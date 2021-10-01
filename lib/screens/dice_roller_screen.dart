import 'dart:math';
import 'dart:ui';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:dice_roller/models/dice_model.dart';
import 'package:dice_roller/util/google_ads/ad_state.dart';
import 'package:dice_roller/util/language_provider/language_text_provider.dart';
import 'package:dice_roller/util/painter/paint_dice.dart';
import 'package:dice_roller/widgets/about_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import 'change_dice_screen.dart';
import 'dice_history_screen.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({Key? key}) : super(key: key);

  @override
  _DiceRollerScreenState createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((InitializationStatus status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitIdDiceScreen,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: adState.bannerAdListener,
        )..load();
      });
    });
  }

  /// _packageInfo will be set by the async function _initPackageInfo
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  ///On init provide a shake Event Listener and get the app info
  @override
  void initState() {
    //init inherited parent
    super.initState();
    //init accelerometer
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      DiceModel _diceModel = context.read<DiceModel>();
      if (_diceModel.getUseAccelerometer) {
        _diceModel.addAccelerometerListener();
      }
    });
    //init package info
    _initPackageInfo();
  }

  ///Dispose listeners
  @override
  void dispose() {
    //dispose inherited parent
    super.dispose();
    //dispose accelerometer
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      DiceModel _diceModel = context.read<DiceModel>();
      _diceModel.removeAccelerometerListener();
    });
  }

  String getInstructions(bool shake, bool multipleDice) {
    if (shake && !multipleDice) {
      return LanguageTextProvider.of(context)
          .getText('press_button_or_shake_to_roll_die');
    } else if (shake && multipleDice) {
      return LanguageTextProvider.of(context)
          .getText('press_button_or_shake_to_roll_dice');
    } else if (!shake && !multipleDice) {
      return LanguageTextProvider.of(context)
          .getText('press_button_to_roll_die');
    } else {
      return LanguageTextProvider.of(context)
          .getText('press_button_to_roll_dice');
    }
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _diceSpacing = 4.0;

    return Scaffold(
      appBar: AppBar(
        title: Consumer<DiceModel>(
          builder: (context, diceModel, child) => Text(
            LanguageTextProvider.of(context).getText('total') +
                ': ${diceModel.getSum() ?? ''}',
            style: Globals.textStyles.caption,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiceHistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.format_list_numbered),
          ),
          IconButton(
            onPressed: () {
              aboutDialog(context, Globals.appName, _packageInfo.version);
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              child: const ChangeDiceScreen(),
            ),
          );
        },
        child: const Icon(Icons.settings),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Consumer<DiceModel>(
          builder: (context, diceModel, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => diceModel.rollAllDice(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    diceModel.getNumberOfDice < 2
                        ? LanguageTextProvider.of(context).getText('roll_die')
                        : LanguageTextProvider.of(context).getText('roll_dice'),
                    style: Globals.textStyles.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Consumer<DiceModel>(
        builder: (context, diceModel, child) => Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          getInstructions(diceModel.getUseAccelerometer,
                              diceModel.getNumberOfDice > 1),
                          style: Globals.textStyles.paragraph,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ShakeAnimatedWidget(
                        enabled: diceModel.getDiceArray
                            .every((element) => element < 0),
                        duration: Duration(
                            milliseconds:
                                (diceModel.getRollAnimation * 1000).round()),
                        shakeAngle: Rotation.deg(
                          x: Random().nextDouble() * 360,
                          y: Random().nextDouble() * 360,
                          z: Random().nextDouble() * 360,
                        ),
                        curve: Curves.decelerate,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: _diceSpacing,
                          runSpacing: _diceSpacing,
                          children: [
                            for (int i = 0;
                                i < diceModel.getDiceArray.length;
                                i++)
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: ShakeAnimatedWidget(
                                  enabled: diceModel.getDiceArray[i] < 0,
                                  duration: Duration(
                                      milliseconds:
                                          (diceModel.getRollAnimation * 1000)
                                              .round()),
                                  shakeAngle: Rotation.deg(
                                    x: Random().nextDouble() * 180,
                                    y: Random().nextDouble() * 180,
                                    z: Random().nextDouble() * 180,
                                  ),
                                  curve: Curves.decelerate,
                                  child: CustomPaint(
                                    // multiply by 6 to leave enough padding to the side
                                    // even if 3 dice are in one row
                                    size: Size(
                                      diceModel.getDiceWidth(
                                          _screenWidth - _diceSpacing * 6),
                                      diceModel.getDiceWidth(
                                          _screenWidth - _diceSpacing * 6),
                                    ),
                                    painter: PaintDice(
                                      dieNumber: diceModel.getDiceArray[i],
                                      strokeColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fillColor: diceModel.getDiceArray[i] < 0
                                          ? diceModel.getDiceColor
                                              .withOpacity(0.6)
                                          : diceModel.getDiceColor,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  diceModel.rollSingleDie(i);
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (banner == null)
              const SizedBox(height: 50.0)
            else
              Container(
                height: 50.0,
                child: AdWidget(ad: banner!),
              )
          ],
        ),
      ),
    );
  }
}
