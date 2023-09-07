import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karma_coin/services/v2.0/kc2_service_interface.dart';
import 'package:karma_coin/services/v2.0/user_info.dart';
import 'package:karma_coin/ui/helpers/widget_utils.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:random_avatar/random_avatar.dart';
// import 'package:random_avatar/random_avatar.dart';
import 'package:status_alert/status_alert.dart';

const _aboutPoolsUrl = 'https://karmaco.in/pools/';

class PoolsScreen extends StatefulWidget {
  const PoolsScreen({super.key});

  @override
  State<PoolsScreen> createState() => _PoolsScreenState();
}

class _PoolsScreenState extends State<PoolsScreen> {
  bool apiOffline = false;
  List<Pool>? entries;

  @override
  initState() {
    super.initState();
    apiOffline = false;

    Future.delayed(Duration.zero, () async {
      try {
        debugPrint('getting open pools...');
        List<Pool> pools = await (kc2Service as KC2NominationPoolsInterface)
            .getPools(state: PoolState.open);
        debugPrint('got ${pools.length} entries');

        // Populate user infos for all pools roles
        for (final Pool pool in pools) {
          await pool.populateUsers();
        }

        setState(() {
          entries = pools;
        });
      } catch (e) {
        setState(() {
          apiOffline = true;
        });
        if (!mounted) return;
        StatusAlert.show(context,
            duration: const Duration(seconds: 2),
            title: 'Server Error',
            subtitle: 'Please try later',
            configuration: const IconConfiguration(
                icon: CupertinoIcons.exclamationmark_triangle),
            dismissOnBackgroundTap: true,
            maxWidth: statusAlertWidth);
        debugPrint('error getting pools: $e');
      }
    });
  }

  Widget _getBodyContent(BuildContext context) {
    if (apiOffline) {
      return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Center(
          child: Text(
              'The Karma Coin Server is down.\n\nPlease try again later.',
              textAlign: TextAlign.center,
              style: CupertinoTheme.of(context).textTheme.pickerTextStyle),
        ),
      );
    }

    if (entries == null) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    }

    List<Widget> widgets = [];

    if (entries != null) {
      if (entries!.isNotEmpty) {
        widgets.add(_getPoolsWidget(context));
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 64, bottom: 36),
            child: Center(
              child: Text('😞 No open pools available.',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context).textTheme.pickerTextStyle),
            ),
          ),
        );
      }

      widgets.add(CupertinoButton(
          child: const Text('Learn more...'),
          onPressed: () {
            openUrl(_aboutPoolsUrl);
          }));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 24),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets),
    );
  }

  Widget _getPoolsWidget(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 24),
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
            indent: 0,
          );
        },
        itemCount: entries!.length,
        itemBuilder: (context, index) {
          return _getPoolWidget(context, entries![index], index);
        },
      ),
    );
  }

  Widget _getPoolWidget(BuildContext context, Pool pool, int index) {
    List<CupertinoListTile> tiles = [];
    if (pool.socialUrl != null) {
      String url = pool.socialUrl!.startsWith("https://")
          ? pool.socialUrl!
          : "https://${pool.socialUrl!}";

      tiles.add(CupertinoListTile.notched(
        title: Text('Web Profile',
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        leading: const Icon(CupertinoIcons.globe, size: 28),
        subtitle: Text(
          pool.socialUrl!,
          style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                const TextStyle(color: CupertinoColors.activeBlue),
              ),
        ),
        trailing: const CupertinoListTileChevron(),
        onTap: () async {
          await openUrl(url);
        },
      ));
    }

    tiles.add(CupertinoListTile.notched(
      title: const Text('Points'),
      leading: const FaIcon(FontAwesomeIcons.coins, size: 24),
      trailing: Text(
        // todo: format it properly
        pool.points.toString(),
      ),
    ));

    tiles.add(CupertinoListTile.notched(
      title: const Text('Members'),
      leading: const FaIcon(FontAwesomeIcons.peopleGroup, size: 24),
      trailing: Text(
        // todo: format this properly
        pool.memberCounter.toString(),
      ),
    ));

    KC2UserInfo creator = pool.depositor!;

    tiles.add(CupertinoListTile.notched(
      title: const Text('Creator'),
      leading: RandomAvatar(creator.userName, height: 50, width: 50),
      subtitle: Text(
          // todo: format this properly
          creator.userName),
      trailing: const CupertinoListTileChevron(),
    ));

    KC2UserInfo? nominator = pool.nominator;
    if (nominator != null) {
      tiles.add(CupertinoListTile.notched(
        title: const Text('Nominator'),
        leading: RandomAvatar(nominator.userName, height: 50, width: 50),
        subtitle: Text(
            // todo: format this properly
            nominator.userName),
        trailing: const CupertinoListTileChevron(),
      ));
    }

    KC2UserInfo? bouncer = pool.bouncer;
    if (bouncer != null) {
      tiles.add(CupertinoListTile.notched(
        title: const Text('Nominator'),
        leading: RandomAvatar(bouncer.userName, height: 50, width: 50),
        subtitle: Text(
            // todo: format this properly
            bouncer.userName),
        trailing: const CupertinoListTileChevron(),
      ));
    }

    tiles.add(CupertinoListTile.notched(
        title: CupertinoButton(
      onPressed: () {
        // TODO:: push join pool screen
      },
      child: const Text('Join'),
    )));

    return CupertinoListSection.insetGrouped(
        key: Key(index.toString()),
        header: Text(
          pool.id.toString(),
          style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                const TextStyle(
                    fontSize: 14, color: CupertinoColors.inactiveGray),
              ),
        ),
        children: tiles);
  }

  @override
  build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            backgroundColor: kcPurple,
            border: kcOrangeBorder,
            largeTitle: Center(
              child:
                  Text('MINING POOLS', style: getNavBarTitleTextStyle(context)),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: _getBodyContent(context),
          ),
        ],
      ),
    );
  }
}
