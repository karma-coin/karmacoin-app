import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:karma_coin/data/genesis_config.dart';
import 'package:karma_coin/data/payment_tx_data.dart';
import 'package:karma_coin/services/v2.0/nomination_pools/interfaces.dart';
import 'package:karma_coin/services/v2.0/user_info.dart';
import 'package:karma_coin/ui/screens/actions/appreciate.dart';
import 'package:karma_coin/ui/helpers/widget_utils.dart';
import 'package:karma_coin/ui/components/animated_background.dart';
import 'package:karma_coin/ui/components/animated_wave.dart';
import 'package:karma_coin/ui/components/animated_wave_right.dart';
import 'package:karma_coin/ui/components/traits_scores_wheel.dart';
import 'package:karma_coin/ui/screens/intros/appreciation_intro.dart';
import 'package:karma_coin/ui/screens/actions/appreciation_progress.dart';
import 'package:karma_coin/ui/screens/intros/intro.dart';
import 'package:karma_coin/ui/screens/actions/leaderboard.dart';
import 'package:karma_coin/ui/screens/intros/staking_intro.dart';

const smallScreenHeight = 1334;

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final NumberFormat _deicmalFormat = NumberFormat("#,###.#");

  final int animationDuration = 1;
  double coinWidth = 160.0;
  double coinLabelFontSize = 14.0;
  double coinNumberFontSize = 60.0;
  double coinOutlineWidth = 8.0;
  final FontWeight digitFontWeight = FontWeight.w600;
  final FontWeight coinLabelWeight = FontWeight.w600;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _postFrameCallback(context));
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();

    Size size = View.of(context).physicalSize;
    double height = size.height;
    if (height <= smallScreenHeight && !kIsWeb) {
      coinWidth = 120.0;
      coinLabelFontSize = 8.0;
      coinNumberFontSize = 32.0;
      coinOutlineWidth = 4.0;
    }
  }

  void _postFrameCallback(BuildContext context) {
    // handle appreciate from a profile page after local user signup
    if (appState.sendDestinationUser.value != null) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: ((context) => const AppreciateWidget(communityId: 0)),
        ),
      );
      return;
    }

    Future.delayed(Duration.zero, () async {
      if (kIsWeb || !Platform.isIOS) {
        if (appState.signedUpInCurentSession.value && mounted) {
          appState.signedUpInCurentSession.value = false;
          Navigator.of(context).push(
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: ((context) => const IntroScreen()),
            ),
          );
        }
      }
      // register for push notes but don't wait on it - may show dialog
      // disabled in this release migrating to Twillio
      // todo: fix me
      // settingsLogic.registerPushNotifications();
    });
  }

  Widget _getAppreciationListener(BuildContext context) {
    return ValueListenableBuilder<PaymentTransactionData?>(
        valueListenable: appState.paymentTransactionData,
        builder: (context, value, child) {
          // we only care about non-community appreciations here
          if (value == null || value.communityId != 0) {
            return Container();
          }

          // todo: customize the progress screen for just coin sending...

          Future.delayed(const Duration(milliseconds: 200), () async {
            if (!context.mounted) return;

            Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: ((context) => AppreciationProgress(data: value)),
              ),
            );

            // clear the user tx data
            debugPrint("clearing local new tx data...");
            appState.paymentTransactionData.value = null;
          });

          return Container();
        });
  }

  Future<void> onAppreciateButtonPressed(BuildContext context) async {
    if (!context.mounted) return;

    if (appState.appreciateIntroDisplayed.value) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: ((context) => const AppreciateWidget(communityId: 0)),
        ),
      );
      return;
    }

    appState.appreciateIntroDisplayed.value = true;

    Navigator.of(context)
        .push(CupertinoPageRoute(
            fullscreenDialog: true,
            builder: ((context) =>
                // push intro screen here
                const AppreciationIntro())))
        .then((completion) {
      Future.delayed(const Duration(milliseconds: 250), () async {
        if (!context.mounted) return;
        Navigator.of(context).push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: ((context) => const AppreciateWidget(communityId: 0)),
          ),
        );
      });
    });
  }

  Widget _getWidgetForUser(BuildContext context) {
    return ValueListenableBuilder<KC2UserInfo?>(
        // todo: how to make this not assert when karmaCoinUser is null?
        valueListenable: kc2User.userInfo,
        builder: (context, value, child) {
          if (value == null) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      _getKarmaScoreWidget(context),
                      const TraitsScoresWheel(null, 0),
                      _getKarmaCoinWidget(context),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    onPressed: () => onAppreciateButtonPressed(context),
                    child: const Text('Appreciate'),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      await _earnButtonHandler(context);
                    },
                    child: Text(
                      'Earn Karma Coins',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .actionTextStyle
                          .merge(
                            const TextStyle(fontSize: 15),
                          ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      await openUrl(configLogic.learnYoutubePlaylistUrl);
                    },
                    child: Text(
                      'Learn more',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .actionTextStyle
                          .merge(
                            const TextStyle(fontSize: 15),
                          ),
                    ),
                  ),
                  _getAppreciationListener(context),
                ]),
          );
        });
  }

  Future<void> _earnButtonHandler(BuildContext context) async {
    if (!context.mounted) return;

    Navigator.of(context)
        .push(CupertinoPageRoute(
            fullscreenDialog: true,
            builder: ((context) =>
                // push intro screen here
                const StakingIntro())))
        .then((completion) async {
      if (kc2User.poolMembership.value != null) {
        Pool? pool = await (kc2Service as KC2NominationPoolsInterface)
            .getPool(poolId: kc2User.poolMembership.value!.id);
        if (pool != null) {
          if (context.mounted) {
            // local user is member of a pool - show pool details screen
            context.pushNamed(ScreenNames.pool,
                params: {'poolId': pool.id.toString()}, extra: pool);
          }
        } else {
          // pool not found
          // TODO: figure out how to handle this case
        }
      } else {
        if (context.mounted) {
          // local user is not a member of a pool - push pool selection screen
          context.push(ScreenPaths.pools);
        }
      }
    });
  }

  Widget _getKarmaScoreWidget(BuildContext context) {
    int? score = kc2User.userInfo.value?.karmaScore;
    if (score == null) {
      return Container();
    }

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
                    score.toString(),
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

  Widget _getKarmaCoinWidget(BuildContext context) {
    BigInt? balance = kc2User.userInfo.value?.balance;
    if (balance == null) {
      return Container();
    }

    // kcents value
    // todo: properly handle a very large balance
    double dispValue = balance.toDouble();
    String labelText = 'KARMA CENTS';
    if (balance >= GenesisConfig.kCentsPerCoinBigInt) {
      dispValue /= 1000000.0;
      labelText = 'KARMA COINS';
    }

    return GestureDetector(
      onTap: () async {
        debugPrint('Tapped karma coin');
        if (!context.mounted) return;
        context.pushNamed(ScreenNames.account, params: {
          'accountId': kc2User.identity.accountId,
        });
      },
      child: Container(
        height: coinWidth,
        width: coinWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kcPurple,
          border: Border.all(width: coinOutlineWidth, color: kcOrange),
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
                    _deicmalFormat.format(dispValue),
                    style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                          TextStyle(
                              fontSize: coinNumberFontSize,
                              color: const Color.fromARGB(255, 255, 184, 0),
                              fontWeight: digitFontWeight),
                        ),
                  ),
                ),
                Text(
                  labelText,
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

  /*
  Widget _getCommunitiesPullDownMenuItems(BuildContext context) {
    return ValueListenableBuilder<List<CommunityMembership>>(
        valueListenable: accountLogic.karmaCoinUser.value!.communities,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return adjustNavigationBarButtonPosition(
                CupertinoButton(
                  onPressed: () async {
                    await openUrl(settingsLogic.learnYoutubePlaylistUrl);
                  },
                  child: const Icon(CupertinoIcons.question_circle, size: 24),
                ),
                0,
                0);
          }

          List<PullDownMenuEntry> items = [
            const PullDownMenuTitle(
              title: Text('Your Communities'),
            ),
          ];

          for (CommunityMembership membership in value) {
            Community? community =
                GenesisConfig.communities[membership.communityId];
            if (community == null) {
              continue;
            }

            String title = '${community.emoji} ${community.name}';

            if (membership.isAdmin) {
              title += ' 👑';
            }

            items.add(
              PullDownMenuItem(
                title: title,
                onTap: () => context.push(
                    GenesisConfig.communityHomeScreenPaths[community.id]!),
              ),
            );
            items.add(const PullDownMenuDivider());
          }

          return PullDownButton(
            itemBuilder: (context) => items,
            position: PullDownMenuPosition.under,
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: const Icon(CupertinoIcons.person_3, size: 38),
            ),
          );
        });
  }*/

  @override
  build(BuildContext context) {
    return Title(
      color: CupertinoColors.black, // This is required
      title: 'Karma Coin - Home',
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: true,
        child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                border: kcOrangeBorder,
                backgroundColor: kcPurple,
                // backgroundColor: CupertinoColors.activeOrange,
                leading:
                    Container(), //_getCommunitiesPullDownMenuItems(context),
                trailing: adjustNavigationBarButtonPosition(
                    CupertinoButton(
                      onPressed: () => context.push(ScreenPaths.actions),
                      child:
                          const Icon(CupertinoIcons.ellipsis_circle, size: 24),
                    ),
                    0,
                    0),
                largeTitle: Center(
                  child: Text(
                    '☥ KARMA COIN',
                    style: getNavBarTitleTextStyle(context),
                  ),
                ),
                padding: EdgeInsetsDirectional.zero,
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
                    child: _getWidgetForUser(context),
                  ),
                ]),
              ),
            ]),
      ),
    );
  }
}
