import 'package:dice_roller/screens/dice_roller_screen.dart';
import 'package:dice_roller/util/google_ads/ad_state.dart';
import 'package:dice_roller/util/google_ads/user_messaging_platform.dart';
import 'package:dice_roller/util/language_provider/language_text_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'globals.dart';
import 'models/dice_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<InitializationStatus> initFuture =
      MobileAds.instance.initialize();
  final adState = AdState(initFuture);

  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => ChangeNotifierProvider(
        create: (context) => DiceModel(),
        child: Consumer<DiceModel>(
          builder: (context, diceModel, child) => UserConsentWrapper(
            child: MaterialApp(
              localizationsDelegates: const [
                LanguageTextProvider.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                for (String langCode in LanguageTextProvider.languages())
                  Locale(langCode, ''),
              ],
              title: Globals.appName,
              theme: Globals.appTheme.getTheme(isDarkTheme: false),
              darkTheme: Globals.appTheme.getTheme(isDarkTheme: true),
              themeMode: diceModel.getThemeMode,
              home: const DiceRollerScreen(),
            ),
          ),
        ),
      ),
    ),
  );
}
