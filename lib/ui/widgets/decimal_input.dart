import 'package:intl/intl.dart';
import 'package:karma_coin/common_libs.dart';

class DecimalAmountInputWidget extends StatefulWidget {
  const DecimalAmountInputWidget({super.key});

  @override
  State<DecimalAmountInputWidget> createState() =>
      _DecimalAmountInputWidgetState();
}

const double _kItemExtent = 32.0;

var _deicmalFormat = NumberFormat("###.##");

class _DecimalAmountInputWidgetState extends State<DecimalAmountInputWidget> {
  // this is the picker's currently selected amount
  double _kAmountCoins = 1;

  // this is the exchange rate - needs to come from the api for real time estimate
  double _kToUsdExchangeRate = 0.02;

  /// 0...10,0000
  List<int> _kcMajorDecimalDigits = Iterable<int>.generate(100000).toList();

  /// 0...9
  List<int> _kcDecimalDigits = Iterable<int>.generate(10).toList();

  FixedExtentScrollController? _kcMajorUnitsScrollController;
  FixedExtentScrollController? _kcCentiUnitsScrollController;
  FixedExtentScrollController? _kcDeciUnitsScrollController;

  @override
  void dispose() {
    _kcMajorUnitsScrollController?.dispose();
    _kcCentiUnitsScrollController?.dispose();
    _kcDeciUnitsScrollController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _kcMajorUnitsScrollController = FixedExtentScrollController(initialItem: 1);
    _kcDeciUnitsScrollController = FixedExtentScrollController();
    _kcCentiUnitsScrollController = FixedExtentScrollController();
  }

  void _pickerHandler() {
    int majorIndex = _kcMajorUnitsScrollController?.selectedItem ?? 0;

    int deciIndex = _kcDeciUnitsScrollController?.selectedItem ?? 0;
    int centiIndex = _kcCentiUnitsScrollController?.selectedItem ?? 0;

    if (majorIndex < 0) {
      majorIndex = _kcMajorDecimalDigits.length + majorIndex;
    }

    if (deciIndex < 0) {
      deciIndex = _kcDecimalDigits.length + deciIndex;
    }

    if (centiIndex < 0) {
      centiIndex = _kcDecimalDigits.length + centiIndex;
    }

    double kAmountCoins = majorIndex.toDouble() +
        deciIndex.toDouble() * 0.1 +
        centiIndex.toDouble() * 0.01;

    setState(() => _kAmountCoins = kAmountCoins);
  }

  _DecimalAmountInputWidgetState();

  @override
  build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
            '${_deicmalFormat.format(_kAmountCoins)} Karma Coins (${NumberFormat.currency().format(_kAmountCoins * _kToUsdExchangeRate)})',
            style: CupertinoTheme.of(context).textTheme.pickerTextStyle),
        Container(
          height: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: CupertinoPicker(
                    magnification: 1.2,
                    squeeze: 1,
                    useMagnifier: true,
                    itemExtent: _kItemExtent,
                    onSelectedItemChanged: (int index) {
                      debugPrint(
                          'left picker changed to $index. Selected item: ${_kcMajorUnitsScrollController?.selectedItem}');

                      _pickerHandler();
                    },
                    looping: true,
                    scrollController: _kcMajorUnitsScrollController,
                    children: List<Widget>.generate(
                      _kcMajorDecimalDigits.length,
                      (int index) {
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 14),
                                  Text(
                                    '${_kcMajorDecimalDigits[index]}',
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Text(
                '.',
                style: CupertinoTheme.of(context).textTheme.textStyle.merge(
                      TextStyle(fontSize: 32),
                    ),
              ),
              Expanded(
                child: Center(
                  child: CupertinoPicker(
                    magnification: 1.2,
                    squeeze: 1.0,
                    useMagnifier: false,
                    itemExtent: _kItemExtent,
                    onSelectedItemChanged: (int index) {
                      _pickerHandler();
                    },
                    looping: true,
                    scrollController: _kcDeciUnitsScrollController,
                    children: List<Widget>.generate(_kcDecimalDigits.length,
                        (int index) {
                      return Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 14),
                                Text(
                                  '${_kcDecimalDigits[index]}',
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: CupertinoPicker(
                    magnification: 1.2,
                    squeeze: 1.0,
                    useMagnifier: false,
                    itemExtent: _kItemExtent,
                    onSelectedItemChanged: (int index) {
                      _pickerHandler();
                    },
                    looping: true,
                    scrollController: _kcCentiUnitsScrollController,
                    children: List<Widget>.generate(
                      _kcDecimalDigits.length,
                      (int index) {
                        return Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 14),
                                  Text(
                                    '${_kcDecimalDigits[index]}',
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
            '1 Karma Coin is about ${NumberFormat.currency().format(_kToUsdExchangeRate)}'),
      ],
    );
  }
}
