import 'package:dice_roller/models/dice_model.dart';
import 'package:dice_roller/util/language_provider/language_text_provider.dart';
import 'package:dice_roller/widgets/elevated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../globals.dart';

class ChangeDiceScreen extends StatefulWidget {
  final String interstitialAdUnitId;
  const ChangeDiceScreen({required this.interstitialAdUnitId, Key? key})
      : super(key: key);

  @override
  State<ChangeDiceScreen> createState() => _ChangeDiceScreenState();
}

class _ChangeDiceScreenState extends State<ChangeDiceScreen> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  static const int _maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd(
      widget.interstitialAdUnitId,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  void _createInterstitialAd(String adUnitId) {
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= _maxFailedLoadAttempts) {
              _createInterstitialAd(adUnitId);
            }
          },
        ));
  }

  void _showInterstitialAd(String adUnitId) {
    if (_interstitialAd == null) {
      //Warning: attempt to show interstitial before loaded.'
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd(adUnitId);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd(adUnitId);
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _diceColors = [
      Theme.of(context).colorScheme.secondary,
      Colors.purple,
      Colors.green,
      Colors.redAccent,
      Colors.blue,
      Colors.orangeAccent,
      Colors.black,
    ];

    return WillPopScope(
      onWillPop: () async {
        // Action to perform on back pressed
        _showInterstitialAd(widget.interstitialAdUnitId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LanguageTextProvider.of(context).getText('settings'),
            style: Globals.textStyles.caption,
          ),
        ),
        body: Consumer<DiceModel>(
          builder: (context, diceModel, child) => Scrollbar(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Text(
                  LanguageTextProvider.of(context).getText('number_of_dice'),
                  style: Globals.textStyles.caption,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        ElevatedIconButton(
                          icon: Icons.remove,
                          onPressed: () {
                            diceModel.removeDie();
                          },
                        ),
                        Text(
                          '${diceModel.getNumberOfDice}',
                          style: Globals.textStyles.caption,
                        ),
                        ElevatedIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            diceModel.addDie();
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => diceModel.resetDie(),
                      child: Text(
                        LanguageTextProvider.of(context).getText('reset'),
                        style: Globals.textStyles.paragraph,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  LanguageTextProvider.of(context).getText('faces_of_the_dice'),
                  style: Globals.textStyles.caption,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        ElevatedIconButton(
                          icon: Icons.remove,
                          onPressed: () => diceModel.removeDieFace(),
                        ),
                        Text(
                          '${diceModel.getDiceFaces}',
                          style: Globals.textStyles.caption,
                        ),
                        ElevatedIconButton(
                          icon: Icons.add,
                          onPressed: () => diceModel.addDieFace(),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => diceModel.resetDiceFaces(),
                      child: Text(
                        LanguageTextProvider.of(context).getText('reset'),
                        style: Globals.textStyles.paragraph,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LanguageTextProvider.of(context)
                            .getText('shake_to_roll') +
                        ':'),
                    Switch(
                      value: diceModel.getUseAccelerometer,
                      onChanged: (bool newValue) =>
                          diceModel.toggleUseAccelerometer(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LanguageTextProvider.of(context)
                            .getText('roll_animation') +
                        ':'),
                    Slider(
                      value: diceModel.getRollAnimation,
                      min: 0.0,
                      max: 3.0,
                      divisions: 6,
                      label: diceModel.getRollAnimation.toString(),
                      onChanged: (double value) {
                        diceModel.setRollAnimation(value);
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        LanguageTextProvider.of(context).getText('dice_color') +
                            ':'),
                    Row(
                      children: [
                        for (Color color in _diceColors)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OutlinedButton(
                                onPressed: () => diceModel.setDiceColor(color),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: color,
                                  elevation: 6,
                                  side: diceModel.getDiceColor.value ==
                                          color.value
                                      ? BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          width: 4.0,
                                        )
                                      : null,
                                ),
                                child: Container(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  LanguageTextProvider.of(context).getText('app_theme') + ':',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ThemeToggle(
                      label: LanguageTextProvider.of(context)
                          .getText('system_default'),
                      themeMode: ThemeMode.system,
                      currentTheme: diceModel.getThemeMode,
                      onPressed: diceModel.setThemeMode,
                    ),
                    ThemeToggle(
                      label: LanguageTextProvider.of(context)
                          .getText('light_mode'),
                      themeMode: ThemeMode.light,
                      currentTheme: diceModel.getThemeMode,
                      onPressed: diceModel.setThemeMode,
                    ),
                    ThemeToggle(
                      label:
                          LanguageTextProvider.of(context).getText('dark_mode'),
                      themeMode: ThemeMode.dark,
                      currentTheme: diceModel.getThemeMode,
                      onPressed: diceModel.setThemeMode,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showInterstitialAd(widget.interstitialAdUnitId);
                    Navigator.pop(context);
                  },
                  child: Text(
                    LanguageTextProvider.of(context).getText('ok'),
                    style: Globals.textStyles.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeToggle extends StatelessWidget {
  final ThemeMode themeMode;
  final ThemeMode currentTheme;
  final String label;
  final void Function(ThemeMode mode) onPressed;
  const ThemeToggle(
      {required this.themeMode,
      required this.onPressed,
      required this.currentTheme,
      required this.label,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          onPressed(themeMode);
        },
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            Radio(
              value: currentTheme == themeMode,
              groupValue: true,
              onChanged: (newValue) {
                onPressed(themeMode);
              },
            )
          ],
        ),
      ),
    );
  }
}
