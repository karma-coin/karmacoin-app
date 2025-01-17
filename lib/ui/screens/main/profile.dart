import 'package:karma_coin/common/platform_info.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:karma_coin/services/v2.0/user_info.dart';
import 'package:karma_coin/ui/components/animated_background.dart';
import 'package:karma_coin/ui/components/animated_wave.dart';
import 'package:karma_coin/ui/components/animated_wave_right.dart';
import 'package:karma_coin/ui/helpers/widget_utils.dart';
import 'package:karma_coin/ui/screens/actions/leaderboard.dart';
import 'package:karma_coin/ui/components/traits_scores_wheel.dart';
import 'package:karma_coin/ui/components/traits_viewer.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:status_alert/status_alert.dart';

const smallScreenHeight = 1334;

class ProfileScreen extends StatefulWidget {
  final String userName;
  const ProfileScreen(Key? key, this.userName) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int animationDuration = 1;
  final double coinWidth = 160.0;
  final double coinLabelFontSize = 14.0;
  final double coinNumberFontSize = 60.0;
  final double coinOutlineWidth = 8.0;
  final FontWeight digitFontWeight = FontWeight.w600;
  final FontWeight coinLabelWeight = FontWeight.w600;

  bool apiOffline = false;
  bool userNotFound = false;
  KC2UserInfo? userInfo;

  @override
  void initState() {
    super.initState();

    debugPrint('Profile page init...');

    Future.delayed(Duration.zero, () async {
      bool isConnected = await PlatformInfo.isConnected();
      if (!isConnected) {
        if (context.mounted) {
          StatusAlert.show(context,
              duration: const Duration(seconds: 4),
              title: 'No Internet',
              subtitle: 'Check your connection',
              configuration: const IconConfiguration(
                  icon: CupertinoIcons.exclamationmark_triangle),
              dismissOnBackgroundTap: true,
              maxWidth: statusAlertWidth);
        }
        setState(() {
          apiOffline = true;
        });
        return;
      }

      try {
        KC2UserInfo? info =
            await kc2Service.getUserInfoByUserName(widget.userName);

        setState(() {
          if (info != null) {
            userInfo = info;
            userNotFound = false;
          } else {
            userNotFound = true;
          }
        });
      } catch (e) {
        apiOffline = true;
        if (!mounted) return;
        StatusAlert.show(context,
            duration: const Duration(seconds: 2),
            title: 'Server Error',
            subtitle: 'Please try later',
            configuration: const IconConfiguration(
                icon: CupertinoIcons.exclamationmark_triangle),
            dismissOnBackgroundTap: true,
            maxWidth: statusAlertWidth);
        debugPrint('error getting users: $e');
      }
    });
  }

  Widget _getScreenWidgets(BuildContext context) {
    if (!apiOffline && userInfo == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(width: 20),
              Text('One sec...',
                  style: CupertinoTheme.of(context).textTheme.textStyle),
            ],
          ),
        ],
      );
    }

    if (apiOffline) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text('Karma Coin is down. Please try again later.',
                style: CupertinoTheme.of(context).textTheme.textStyle),
            const TraitsScoresWheel(null, 0),
          ]);
    }

    if (userNotFound) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text('User not found.',
                style: CupertinoTheme.of(context).textTheme.textStyle),
          ]);
    }

    return Padding(
      padding: const EdgeInsets.all(0),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getKarmaScoreWidget(context),
            TraitsViewer(null, userInfo!.getScores(0)),
            _getSocialProfile(context),
          ],
        ),
        _getActionArea(context),
      ]),
    );
  }

  Widget _getSocialProfile(BuildContext context) {
    String? socialUrl = userInfo?.metadata;

    if (socialUrl == null) {
      return Container();
    }

    final String url =
        socialUrl.startsWith('https://') ? socialUrl : 'https://$socialUrl';

    return CupertinoButton(
        child: Text(socialUrl,
            style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                  const TextStyle(color: CupertinoColors.activeBlue),
                )),
        onPressed: () async {
          if (!context.mounted) return;
          await openUrl(url);
        });
  }

  Widget _getActionArea(BuildContext context) {
    if (kc2User.userInfo.value == null) {
      // no signed-in local user
      return CupertinoButton.filled(
          onPressed: () async {
            // store user for appreciation after signup
            appState.sendDestinationUser.value = userInfo;

            if (!context.mounted) return;
            context.go(ScreenPaths.welcome);
          },
          child: const Text('Appreciate Me'));
    }

    if (kc2User.userInfo.value?.userName != widget.userName) {
      return CupertinoButton.filled(
          onPressed: () async {
            // user signup - go to home screen and start appreciating
            appState.sendDestinationUser.value = userInfo;
            if (!context.mounted) return;
            context.go(ScreenPaths.home);
          },
          child: const Text('Appreciate Me'));
    } else {
      // user's viewing his own profile screen
      String uri =
          Uri.encodeFull('https://app.karmaco.in/#/p/${userInfo!.userName}');

      // user viewing his own profile page
      return Column(children: [
        Text("Share your profile anywhere to get appreciated!",
            style: CupertinoTheme.of(context).textTheme.textStyle),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
                child: const Icon(CupertinoIcons.share),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: uri));
                }),
            Text(
              uri,
              style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                    const TextStyle(color: CupertinoColors.activeBlue),
                  ),
            ),
          ],
        ),
      ]);
    }
  }

  Widget _getKarmaScoreWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        debugPrint('Tapped karma score');
        if (!context.mounted) return;

        Navigator.of(context).push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: ((context) => const LeaderboardWidget(communityId: 0)),
          ),
        );
      },
      child: Container(
        height: coinWidth,
        width: coinWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kcPurple,
          border: Border.all(
              width: coinOutlineWidth,
              color: const Color.fromARGB(255, 255, 184, 0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    userInfo!.karmaScore.toString(),
                    style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                          TextStyle(
                              fontSize: coinNumberFontSize,
                              color: const Color.fromARGB(255, 255, 184, 0),
                              fontWeight: digitFontWeight),
                        ),
                  ),
                ),
                Text(
                  'KARMA SCORE',
                  style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                        TextStyle(
                            fontSize: coinLabelFontSize,
                            color: const Color.fromARGB(255, 255, 184, 0),
                            fontWeight: coinLabelWeight),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  build(BuildContext context) {
    Widget titleWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RandomAvatar(widget.userName, height: 40, width: 40),
        const SizedBox(width: 10),
        Text(
          widget.userName,
          style: getNavBarTitleTextStyle(context),
        ),
      ],
    );

    return Title(
      color: CupertinoColors.black, // This is required
      title: 'Karma Coin - ${widget.userName}',
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                border: kcOrangeBorder,
                backgroundColor: kcPurple,
                // backgroundColor: CupertinoColors.activeOrange,
                largeTitle: Center(
                  child: titleWidget,
                ),
              ),
              SliverFillRemaining(
                child: Stack(children: <Widget>[
                  const Positioned(child: AnimatedBackground()),
                  onLeft(const AnimatedWave(
                    height: 180,
                    speed: 1.0,
                  )),
                  onLeft(const AnimatedWave(
                    height: 120,
                    speed: 0.9,
                    offset: pi,
                  )),
                  onLeft(const AnimatedWave(
                    height: 220,
                    speed: 1.2,
                    offset: pi / 2,
                  )),
                  onRight(const AnimatedRightWave(
                    height: 180,
                    speed: 1.0,
                  )),
                  onRight(const AnimatedRightWave(
                    height: 120,
                    speed: 0.9,
                    offset: pi,
                  )),
                  onRight(const AnimatedRightWave(
                    height: 220,
                    speed: 1.2,
                    offset: pi / 2,
                  )),
                  Positioned.fill(
                    child: _getScreenWidgets(context),
                  ),
                ]),
              ),
            ]),
      ),
    );
  }
}
