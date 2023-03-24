import 'package:karma_coin/common/platform_info.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:karma_coin/logic/user_name_availability.dart';
import 'package:karma_coin/services/api/api.pb.dart';
import 'package:karma_coin/ui/helpers/widget_utils.dart';
import 'package:status_alert/status_alert.dart';

enum Operation { signUp, updateUserName }

/// User name input screen part of signup flow, also used to update existing user name
class SetUserNameScreen extends StatefulWidget {
  @required
  final Operation operation;
  @required
  final String title;

  const SetUserNameScreen(
      {super.key, required this.title, required this.operation});

  @override
  State<SetUserNameScreen> createState() => _SetUserNameScreenState();
}

class _SetUserNameScreenState extends State<SetUserNameScreen> {
  String deafaultName = settingsLogic.devMode ? "avive" : "";
  late final _textController = TextEditingController(text: deafaultName);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _postFrameCallback(context));
  }

  void _postFrameCallback(BuildContext context) {
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
        return;
      }

      // check availbility for deafult name
      if (_textController.text.isNotEmpty) {
        await userNameAvailabilityLogic.check(_textController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Text submitButtonText = widget.operation == Operation.signUp
        ? const Text('Next')
        : const Text('Update');

    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(widget.title),
            ),
          ];
        },
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _getTextField(context),
                      const SizedBox(height: 14),
                      _getAvailabilityStatus(context),
                      const SizedBox(height: 14),
                      CupertinoButton.filled(
                        onPressed: () async {
                          await _submitName(context);
                        },
                        child: submitButtonText,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAvailabilityStatus(BuildContext context) {
    if (!mounted) return Container();
    return ChangeNotifierProvider.value(
      value: userNameAvailabilityLogic,
      child: Consumer<UserNameAvailabilityLogic>(
        builder: (context, state, child) {
          switch (state.status) {
            case UserNameAvailabilityStatus.unknown:
              return Container();
            case UserNameAvailabilityStatus.checking:
              return const Text('Checking name availability...');
            case UserNameAvailabilityStatus.available:
              return const Text(
                'Name available',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.activeGreen),
              );
            case UserNameAvailabilityStatus.unavailable:
              return const Text(
                'Name unavailable. Try another one',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.systemRed),
              );
            case UserNameAvailabilityStatus.error:
              return const Text(
                'Server error. Please try again later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.systemRed,
                ),
              );
          }
        },
      ),
    );
  }

  Future<void> _submitName(BuildContext context) async {
    if (!mounted) return;
    if (_textController.text.isEmpty) {
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 2),
        title: 'Ooops',
        subtitle: 'Please enter user name',
        configuration: const IconConfiguration(
            icon: CupertinoIcons.exclamationmark_triangle),
        maxWidth: statusAlertWidth,
      );
      return;
    }

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
      return;
    }

    // check once again for availbility...
    // await userNameAvailabilityLogic.check(_textController.text);

    if (userNameAvailabilityLogic.status ==
        UserNameAvailabilityStatus.available) {
      // store the user's reuqested name in account logic
      await accountLogic.setRequestedUserName(_textController.text);

      switch (widget.operation) {
        case Operation.signUp:
          debugPrint('*** astarting signup flow...');
          await accountSetupController.signUpUser();
          break;
        case Operation.updateUserName:
          debugPrint('starting update user name flow...');
          try {
            SubmitTransactionResponse resp = await accountLogic
                .submitUpdateUserNameTransacation(_textController.text);

            switch (resp.submitTransactionResult) {
              case SubmitTransactionResult.SUBMIT_TRANSACTION_RESULT_SUBMITTED:
                if (context.mounted) {
                  StatusAlert.show(
                    context,
                    duration: const Duration(seconds: 2),
                    title: 'Name updated',
                    configuration:
                        const IconConfiguration(icon: CupertinoIcons.wand_rays),
                    maxWidth: statusAlertWidth,
                  );
                }
                debugPrint(
                    'Update user name transaction submitted and accepted');
                break;
              case SubmitTransactionResult.SUBMIT_TRANSACTION_RESULT_REJECTED:
                if (context.mounted) {
                  StatusAlert.show(
                    context,
                    duration: const Duration(seconds: 2),
                    title: 'Server Error',
                    subtitle: 'Operation failed. Try again later.',
                    configuration: const IconConfiguration(
                        icon: CupertinoIcons.exclamationmark_triangle),
                    maxWidth: statusAlertWidth,
                  );
                }
                break;
            }
          } catch (e) {
            if (context.mounted) {
              StatusAlert.show(
                context,
                duration: const Duration(seconds: 2),
                title: 'Oops',
                subtitle: 'Operation failed. Try again later.',
                configuration: const IconConfiguration(
                    icon: CupertinoIcons.exclamationmark_triangle),
                maxWidth: statusAlertWidth,
              );
            }
          }
          break;
      }
    } else {
      debugPrint('Name not available - show warning');
      if (context.mounted) {
        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          title: 'Name Unavailable',
          subtitle: 'Please try another name.',
          configuration: const IconConfiguration(
              icon: CupertinoIcons.exclamationmark_triangle),
          maxWidth: statusAlertWidth,
        );
      }
    }
  }

  Widget _getTextField(BuildContext context) {
    return Title(
      color: CupertinoColors.black, // This is required
      title: 'Karma Coin - User Name',
      child: CupertinoTextField(
        prefix: const Icon(
          CupertinoIcons.person_solid,
          color: CupertinoColors.lightBackgroundGray,
          size: 28,
        ),
        autofocus: true,
        autocorrect: false,
        clearButtonMode: OverlayVisibilityMode.editing,
        placeholder: 'Requested user name',
        style: CupertinoTheme.of(context).textTheme.textStyle,
        textAlign: TextAlign.center,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0,
              // todo: from theme
              color: CupertinoColors.inactiveGray,
            ),
          ),
        ),
        onChanged: (value) async {
          // check availability on text change
          await userNameAvailabilityLogic.check(value);
        },
        controller: _textController,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }
}