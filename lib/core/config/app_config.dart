import 'dart:io';
import 'package:flutter/foundation.dart';

/// App configuration class that manages sensitive data like AdMob IDs
/// This class provides a centralized way to manage configuration values
/// and allows for different configurations based on environment
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // Environment
  static const String _environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'production',
  );

  // Production AdMob IDs
  static const String _androidAppId = String.fromEnvironment(
    'ANDROID_APP_ID',
    defaultValue: 'ca-app-pub-3499593115543692~6841713620',
  );

  static const String _androidRewardedAdId = String.fromEnvironment(
    'ANDROID_REWARDED_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/2111598295',
  );

  static const String _androidBannerAdId = String.fromEnvironment(
    'ANDROID_BANNER_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/8026942404',
  );

  static const String _androidLeaderboardBannerAdId = String.fromEnvironment(
    'ANDROID_LEADERBOARD_BANNER_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/8547130233',
  );

  static const String _iosAppId = String.fromEnvironment(
    'IOS_APP_ID',
    defaultValue: 'ca-app-pub-3499593115543692~4966644738',
  );

  static const String _iosRewardedAdId = String.fromEnvironment(
    'IOS_REWARDED_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/7555496667',
  );

  static const String _iosBannerAdId = String.fromEnvironment(
    'IOS_BANNER_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/9340024074',
  );

  static const String _iosLeaderboardBannerAdId = String.fromEnvironment(
    'IOS_LEADERBOARD_BANNER_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/2173293578',
  );

  static const String _androidInterstitialAdId = String.fromEnvironment(
    'ANDROID_INTERSTITIAL_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/3193434033',
  );

  static const String _iosInterstitialAdId = String.fromEnvironment(
    'IOS_INTERSTITIAL_AD_ID',
    defaultValue: 'ca-app-pub-3499593115543692/1880352367',
  );

  // Test AdMob IDs
  static const String _testAndroidAppId = String.fromEnvironment(
    'TEST_ANDROID_APP_ID',
    defaultValue: 'ca-app-pub-3940256099942544~3347511713',
  );

  static const String _testAndroidRewardedAdId = String.fromEnvironment(
    'TEST_ANDROID_REWARDED_AD_ID',
    defaultValue: 'ca-app-pub-3940256099942544/5224354917',
  );

  static const String _testAndroidBannerAdId = String.fromEnvironment(
    'TEST_ANDROID_BANNER_AD_ID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );

  static const String _testAndroidLeaderboardBannerAdId =
      String.fromEnvironment(
        'TEST_ANDROID_LEADERBOARD_BANNER_AD_ID',
        defaultValue: 'ca-app-pub-3940256099942544/6300978111',
      );

  static const String _testIosAppId = String.fromEnvironment(
    'TEST_IOS_APP_ID',
    defaultValue: 'ca-app-pub-3940256099942544~1458002511',
  );

  static const String _testIosRewardedAdId = String.fromEnvironment(
    'TEST_IOS_REWARDED_AD_ID',
    defaultValue: 'ca-app-pub-3940256099942544/1712485313',
  );

  static const String _testIosBannerAdId = String.fromEnvironment(
    'TEST_IOS_BANNER_AD_ID',
    defaultValue: 'ca-app-pub-3940256099942544/2934735716',
  );

  static const String _testIosLeaderboardBannerAdId = String.fromEnvironment(
    'TEST_IOS_LEADERBOARD_BANNER_AD_ID',
    defaultValue: 'ca-app-pub-3940256099942544/2934735716',
  );

  static const String _testAndroidInterstitialAdId = String.fromEnvironment(
    'TEST_ANDROID_INTERSTITIAL_AD_ID',
    defaultValue: 'ca-app-pub-3940256099942544/1033173712',
  );

  static const String _testIosInterstitialAdId = String.fromEnvironment(
    'TEST_IOS_INTERSTITIAL_AD_ID',
    defaultValue: 'ca-app-pub-3940256099942544/4411468910',
  );

  /// Get current environment
  String get environment => _environment;

  /// Check if running in debug mode
  bool get isDebugMode => kDebugMode;

  /// Check if running in production mode
  bool get isProduction => _environment == 'production';

  /// Check if running in development mode
  bool get isDevelopment => _environment == 'development';

  /// Get AdMob App ID based on platform and environment
  String get adMobAppId {
    if (Platform.isAndroid) {
      return isProduction ? _androidAppId : _testAndroidAppId;
    } else if (Platform.isIOS) {
      return isProduction ? _iosAppId : _testIosAppId;
    }
    throw UnsupportedError('Platform not supported for AdMob');
  }

  /// Get Rewarded Ad Unit ID based on platform and environment
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return isProduction ? _androidRewardedAdId : _testAndroidRewardedAdId;
    } else if (Platform.isIOS) {
      return isProduction ? _iosRewardedAdId : _testIosRewardedAdId;
    }
    throw UnsupportedError('Platform not supported for AdMob');
  }

  /// Get Banner Ad Unit ID based on platform and environment
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return isProduction ? _androidBannerAdId : _testAndroidBannerAdId;
    } else if (Platform.isIOS) {
      return isProduction ? _iosBannerAdId : _testIosBannerAdId;
    }
    throw UnsupportedError('Platform not supported for AdMob');
  }

  /// Get Leaderboard Banner Ad Unit ID based on platform and environment
  String get leaderboardBannerAdUnitId {
    if (Platform.isAndroid) {
      return isProduction
          ? _androidLeaderboardBannerAdId
          : _testAndroidLeaderboardBannerAdId;
    } else if (Platform.isIOS) {
      return isProduction
          ? _iosLeaderboardBannerAdId
          : _testIosLeaderboardBannerAdId;
    }
    throw UnsupportedError('Platform not supported for AdMob');
  }

  /// Get Interstitial Ad Unit ID based on platform and environment
  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return isProduction
          ? _androidInterstitialAdId
          : _testAndroidInterstitialAdId;
    } else if (Platform.isIOS) {
      return isProduction ? _iosInterstitialAdId : _testIosInterstitialAdId;
    }
    throw UnsupportedError('Platform not supported for AdMob');
  }

  /// Get all AdMob configuration for debugging
  Map<String, dynamic> get adMobConfig {
    return {
      'environment': environment,
      'isDebugMode': isDebugMode,
      'isProduction': isProduction,
      'isDevelopment': isDevelopment,
      'adMobAppId': adMobAppId,
      'rewardedAdUnitId': rewardedAdUnitId,
      'bannerAdUnitId': bannerAdUnitId,
      'leaderboardBannerAdUnitId': leaderboardBannerAdUnitId,
      'interstitialAdUnitId': interstitialAdUnitId,
    };
  }

  /// Print configuration for debugging
  void printConfig() {
    if (kDebugMode) {
      print('=== App Configuration ===');
      print('Environment: $environment');
      print('Debug Mode: $isDebugMode');
      print('Production: $isProduction');
      print('Development: $isDevelopment');
      print('AdMob App ID: $adMobAppId');
      print('Rewarded Ad Unit ID: $rewardedAdUnitId');
      print('Banner Ad Unit ID: $bannerAdUnitId');
      print('Leaderboard Banner Ad Unit ID: $leaderboardBannerAdUnitId');
      print('Interstitial Ad Unit ID: $interstitialAdUnitId');
      print('========================');
    }
  }
}
