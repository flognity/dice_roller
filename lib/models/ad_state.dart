import 'dart:io';

import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  /// iOS test unit IDs can be found here:
  /// https://developers.google.com/admob/ios/test-ads?hl=en-GB
  /// Android test unit IDs can be found here:
  /// https://developers.google.com/admob/android/test-ads?hl=en-GB#enable_test_devices
  String get bannerAdUnitIdDiceScreen => Platform.isAndroid
      ? FlutterConfig.get(
          'ADUNITID_ANDROID_BANNER_DICESCREEN') //Android Banner Test unit ID
      : FlutterConfig.get(
          'ADUNITID_IOS_BANNER_DICESCREEN'); //iOS Banner Test unit ID
  String get bannerAdUnitIdHistoryScreen => Platform.isAndroid
      ? FlutterConfig.get(
          'ADUNITID_ANDROID_BANNER_HISTORYSCREEN') //Android Banner Test unit ID
      : FlutterConfig.get(
          'ADUNITID_IOS_BANNER_HISTORYSCREEN'); //iOS Banner Test unit ID

  BannerAdListener get bannerAdListener => _bannerAdListener;

  final BannerAdListener _bannerAdListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  );

  String get interstitialAdUnitIdSettingsScreen => Platform.isAndroid
      ? FlutterConfig.get(
          'ADUNITID_ANDROID_INTERSTITIAL_SETTINGSSCREEN') //Android Banner Test unit ID
      : FlutterConfig.get(
          'ADUNITID_IOS_BANNER_INTERSTITIAL_SETTINGSSCREEN'); //iOS Banner Test unit ID

}
