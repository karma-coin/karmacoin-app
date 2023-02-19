import 'package:fixnum/fixnum.dart';
import 'package:karma_coin/common/widget_utils.dart';
import 'package:karma_coin/common_libs.dart';
import 'package:flutter/material.dart';
import 'package:karma_coin/data/personality_traits.dart';
import 'package:karma_coin/logic/app_state.dart';
import 'package:karma_coin/logic/kc_amounts_formatter.dart';
import 'package:karma_coin/ui/widgets/amount_input.dart';
import 'package:karma_coin/ui/widgets/traits_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:status_alert/status_alert.dart';

class AppreciateWidget extends StatefulWidget {
  const AppreciateWidget({super.key});

  @override
  State<AppreciateWidget> createState() => _AppreciateWidgetState();
}

class _AppreciateWidgetState extends State<AppreciateWidget> {
  late PhoneController phoneController;
  TraitsPickerWidget traitsPicker = TraitsPickerWidget(PersonalityTraits);
  bool outlineBorder = false;
  bool mobileOnly = true;
  bool shouldFormat = true;
  bool isCountryChipPersistent = false;
  bool withLabel = true;
  bool useRtl = false;

  // country selector ux
  CountrySelectorNavigator selectorNavigator =
      const CountrySelectorNavigator.draggableBottomSheet();

  final formKey = GlobalKey<FormState>();
  final phoneKey = GlobalKey<FormFieldState<PhoneNumber>>();

  _AppreciateWidgetState();

  @override
  initState() {
    super.initState();
    phoneController = PhoneController(null);
    phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  PhoneNumberInputValidator? _getValidator() {
    List<PhoneNumberInputValidator> validators = [];
    if (mobileOnly) {
      validators.add(PhoneValidator.validMobile());
    } else {
      validators.add(PhoneValidator.valid());
    }
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  static Route<void> _amountInputModelBuilder(
      BuildContext context, Object? arguments) {
    return CupertinoModalPopupRoute<void>(builder: (BuildContext context) {
      return AmountInputWidget();
    });
  }

  // validate input data and show alers if invalid
  bool _validateData() {
    debugPrint('validate data... ${phoneController.value}');
    if (phoneController.value == null ||
        phoneController.value!.countryCode.isEmpty ||
        phoneController.value!.nsn.isEmpty) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: 'Oops...',
        subtitle: 'Please enter receiver\'s mobile phone number',
        configuration: IconConfiguration(icon: CupertinoIcons.exclamationmark),
        maxWidth: 260,
      );
      return false;
    }

    if (appState.kCentsAmount.value == Int64.ZERO) {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: 'Oops...',
        subtitle: 'Please enter a non-zero Karma Coin amount',
        configuration: IconConfiguration(icon: CupertinoIcons.exclamationmark),
        maxWidth: 260,
      );
      return false;
    }

    return true;
  }

  Future<void> _sendAppreciation(BuildContext context) async {
    // todo: validate data and show alerts if invalid

    String number =
        '+${phoneController.value!.countryCode}${phoneController.value!.nsn}';

    // store data in app state - will be handeled in user's home screen dispatcher....
    appState.userProvidedAppreciationData.value = UserProvidedAppreciationData(
        appState.kCentsAmount.value,
        PersonalityTraits[appState.charTraitPickerIndex.value].index,
        -1,
        number,
        '');

    context.pop();
  }

  @override
  build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            stretch: true,
            leading: Container(),
            trailing: adjustNavigationBarButtonPosition(
                CupertinoButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Icon(CupertinoIcons.xmark_circle, size: 24),
                ),
                0,
                -10),
            largeTitle: Text('Appreciate'),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // todo: pick theme from app settings
                  Material(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 36, right: 36, top: 16, bottom: 16),
                      child: PhoneFormField(
                        key: phoneKey,
                        controller: phoneController,
                        shouldFormat: shouldFormat && !useRtl,
                        autofocus: true,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        countrySelectorNavigator: selectorNavigator,
                        defaultCountry: IsoCode.US,
                        validator: _getValidator(),
                        decoration: InputDecoration(
                          label: withLabel ? const Text('Phone') : null,
                          border: outlineBorder
                              ? const OutlineInputBorder()
                              : const UnderlineInputBorder(),
                          hintText: withLabel ? '' : 'Phone',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  traitsPicker,
                  SizedBox(height: 14),
                  Column(
                    children: [
                      Text('Amount to send',
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .pickerTextStyle),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.of(context)
                              .restorablePush(_amountInputModelBuilder);
                        },
                        child: ValueListenableBuilder<Int64>(
                            valueListenable: appState.kCentsAmount,
                            builder: (context, value, child) =>
                                Text(KarmaCoinAmountFormatter.format(value))),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  CupertinoButton.filled(
                    onPressed: () async {
                      if (_validateData()) {
                        await _sendAppreciation(context);
                      }
                    },
                    child: Text('Appreciate'),
                  ),
                  SizedBox(height: 14),
                ]),
          ),
        ],
      ),
    );
  }
}
