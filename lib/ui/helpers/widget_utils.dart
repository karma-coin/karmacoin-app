import 'package:flutter/material.dart';
import 'package:karma_coin/common/platform_info.dart';
import 'package:status_alert/status_alert.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:url_launcher/url_launcher.dart';

// common widget helper functions

const statusAlertWidth = 300.0;

const Color kcPurple = Color.fromARGB(255, 88, 40, 138);
const Color kcOrange = Color.fromARGB(255, 255, 184, 0);
const Border kcOrangeBorder = Border(
  bottom: BorderSide(color: kcOrange, width: 2),
);

Text standardTextWidget(String text, BuildContext context) {
  return Text(text, style: CupertinoTheme.of(context).textTheme.textStyle);
}

CupertinoSliverNavigationBar kcNavBar(context, String title,
    {bool enableBackButton = true}) {
  return CupertinoSliverNavigationBar(
    largeTitle: Text(
      title,
      style: getNavBarTitleTextStyle(context),
      textAlign: TextAlign.left,
    ),
    backgroundColor: kcPurple,
    border: kcOrangeBorder,
    leading: enableBackButton
        ? CupertinoNavigationBarBackButton(
            color: CupertinoTheme.of(context).primaryColor,
            // must be added as default implementation throws assert
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            })
        : Container(),
    trailing: adjustNavigationBarButtonPosition(
        CupertinoButton(
          onPressed: () async {
            await openUrl(configLogic.learnYoutubePlaylistUrl);
          },
          child: const Icon(CupertinoIcons.question_circle, size: 24),
        ),
        16,
        -6),
  );
}

CupertinoSliverNavigationBar kcNavBarWidget(context, Widget titleWidget) {
  return CupertinoSliverNavigationBar(
    largeTitle: titleWidget,
    backgroundColor: kcPurple,
    border: kcOrangeBorder,
    trailing: adjustNavigationBarButtonPosition(
        CupertinoButton(
          onPressed: () async {
            await openUrl(configLogic.learnYoutubePlaylistUrl);
          },
          child: const Icon(CupertinoIcons.question_circle, size: 24),
        ),
        16,
        0),
  );
}

TextStyle getNavBarTitleTextStyle(BuildContext context, {int communityId = 0}) {
  if (communityId == 0) {
    return CupertinoTheme.of(context)
        .textTheme
        .navLargeTitleTextStyle
        .merge(const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w400,
        ));
  } else {
    return CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle;
  }
}

showNoConnectionAlert(BuildContext context) {
  StatusAlert.show(context,
      duration: const Duration(seconds: 4),
      title: 'No Internet',
      subtitle: 'Check your connection',
      configuration: const IconConfiguration(
          icon: CupertinoIcons.exclamationmark_triangle),
      dismissOnBackgroundTap: true,
      maxWidth: statusAlertWidth);
}

onLeft(Widget child) => Positioned.fill(
      child: Align(
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );

onRight(Widget child) => Positioned.fill(
      child: Align(
        alignment: Alignment.centerRight,
        child: child,
      ),
    );

Future<bool> openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  return await launchUrl(uri);

  /*
  if (!await launchUrl(url0) && context.mounted) {
    StatusAlert.show(context,
        duration: const Duration(seconds: 4),
        title: 'Failed to open url',
        configuration: const IconConfiguration(
            icon: CupertinoIcons.exclamationmark_triangle),
        dismissOnBackgroundTap: true,
        maxWidth: statusAlertWidth);
  }*/
}

Widget adjustNavigationBarButtonPosition(Widget button, double x, double y) {
  return Container(
    transform: Matrix4.translationValues(x, y, 0),
    child: button,
  );
}

/// Check for Internet connection and display alert if not connected
Future<bool> checkInternetConnection(BuildContext context) async {
  bool isConnected = await PlatformInfo.isConnected();

  if (!isConnected && context.mounted) {
    StatusAlert.show(context,
        duration: const Duration(seconds: 4),
        title: 'No Internet',
        subtitle: 'Check your connection',
        configuration: const IconConfiguration(
            icon: CupertinoIcons.exclamationmark_triangle),
        dismissOnBackgroundTap: true,
        maxWidth: statusAlertWidth);
  }

  return isConnected;
}
