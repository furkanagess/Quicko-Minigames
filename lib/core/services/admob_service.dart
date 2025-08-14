import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // Production AdMob IDs
  static String get _rewardedAdUnitId =>
      Platform.isAndroid
          ? 'ca-app-pub-3499593115543692/2111598295' // Android production rewarded ad ID
          : 'ca-app-pub-3499593115543692/7555496667'; // iOS production rewarded ad ID

  static String get _bannerAdUnitId =>
      Platform.isAndroid
          ? 'ca-app-pub-3499593115543692/5725525775' // Android production banner ad ID
          : 'ca-app-pub-3499593115543692/9584879730'; // iOS production banner ad ID

  static String get _leaderboardBannerAdUnitId =>
      Platform.isAndroid
          ? 'ca-app-pub-3499593115543692/8547130233' // Android leaderboard banner ad ID
          : 'ca-app-pub-3499593115543692/2173293578'; // iOS leaderboard banner ad ID

  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;
  bool _isBannerAdLoaded = false;

  /// Initialize AdMob
  Future<void> initialize() async {
    if (kDebugMode) {
      print('AdMob: Initializing...');
    }

    await MobileAds.instance.initialize();

    if (kDebugMode) {
      print('AdMob: Initialized successfully');
    }
  }

  /// Load rewarded ad
  Future<bool> loadRewardedAd() async {
    if (_isAdLoading || _isAdLoaded) return _isAdLoaded;

    _isAdLoading = true;

    try {
      await RewardedAd.load(
        adUnitId: _rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isAdLoaded = true;
            _isAdLoading = false;

            if (kDebugMode) {
              print('AdMob: Rewarded ad loaded successfully');
            }

            // Set up ad event listeners
            _setupAdEventListeners();
          },
          onAdFailedToLoad: (error) {
            _isAdLoaded = false;
            _isAdLoading = false;

            if (kDebugMode) {
              print('AdMob: Failed to load rewarded ad: ${error.message}');
            }
          },
        ),
      );
    } catch (e) {
      _isAdLoaded = false;
      _isAdLoading = false;

      if (kDebugMode) {
        print('AdMob: Exception while loading rewarded ad: $e');
      }
    }

    return _isAdLoaded;
  }

  /// Setup ad event listeners
  void _setupAdEventListeners() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isAdLoaded = false;
        _rewardedAd = null;

        if (kDebugMode) {
          print('AdMob: Rewarded ad dismissed');
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isAdLoaded = false;
        _rewardedAd = null;

        if (kDebugMode) {
          print('AdMob: Failed to show rewarded ad: ${error.message}');
        }
      },
      onAdShowedFullScreenContent: (ad) {
        if (kDebugMode) {
          print('AdMob: Rewarded ad showed full screen content');
        }
      },
    );
  }

  /// Show rewarded ad
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    required Function() onAdClosed,
    required Function(String error) onAdFailed,
  }) async {
    if (!_isAdLoaded || _rewardedAd == null) {
      final loaded = await loadRewardedAd();
      if (!loaded) {
        onAdFailed('Ad not available');
        return false;
      }
    }

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          if (kDebugMode) {
            print('AdMob: User earned reward: ${reward.amount} ${reward.type}');
          }
          onRewarded();
        },
      );

      onAdClosed();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('AdMob: Exception while showing rewarded ad: $e');
      }
      onAdFailed(e.toString());
      return false;
    }
  }

  /// Load banner ad
  Future<bool> loadBannerAd() async {
    if (_isBannerAdLoaded) {
      if (kDebugMode) {
        print('AdMob: Banner ad already loaded');
      }
      return true;
    }

    if (kDebugMode) {
      print('AdMob: Loading banner ad with ID: $_bannerAdUnitId');
    }

    try {
      _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _isBannerAdLoaded = true;
            if (kDebugMode) {
              print('AdMob: Banner ad loaded successfully');
              if (ad is BannerAd) {
                print(
                  'AdMob: Banner ad size: ${ad.size.width}x${ad.size.height}',
                );
              }
            }
          },
          onAdFailedToLoad: (ad, error) {
            _isBannerAdLoaded = false;
            if (kDebugMode) {
              print('AdMob: Failed to load banner ad: ${error.message}');
              print('AdMob: Error code: ${error.code}');
            }
          },
          onAdOpened: (ad) {
            if (kDebugMode) {
              print('AdMob: Banner ad opened');
            }
          },
          onAdClosed: (ad) {
            if (kDebugMode) {
              print('AdMob: Banner ad closed');
            }
          },
        ),
      );

      await _bannerAd!.load();

      if (kDebugMode) {
        print('AdMob: Banner ad load completed. Success: $_isBannerAdLoaded');
      }

      return _isBannerAdLoaded;
    } catch (e) {
      _isBannerAdLoaded = false;
      if (kDebugMode) {
        print('AdMob: Exception while loading banner ad: $e');
      }
      return false;
    }
  }

  /// Load banner ad with retry mechanism
  Future<bool> loadBannerAdWithRetry({int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      if (kDebugMode) {
        print('AdMob: Banner ad load attempt $attempt of $maxRetries');
      }

      final success = await loadBannerAd();
      if (success) {
        return true;
      }

      if (attempt < maxRetries) {
        if (kDebugMode) {
          print('AdMob: Banner ad load failed, retrying in 2 seconds...');
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (kDebugMode) {
      print('AdMob: Banner ad load failed after $maxRetries attempts');
    }
    return false;
  }

  /// Load leaderboard banner ad
  Future<bool> loadLeaderboardBannerAd() async {
    if (kDebugMode) {
      print(
        'AdMob: Loading leaderboard banner ad with ID: $_leaderboardBannerAdUnitId',
      );
    }

    try {
      _bannerAd = BannerAd(
        adUnitId: _leaderboardBannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _isBannerAdLoaded = true;
            if (kDebugMode) {
              print('AdMob: Leaderboard banner ad loaded successfully');
              if (ad is BannerAd) {
                print(
                  'AdMob: Leaderboard banner ad size: ${ad.size.width}x${ad.size.height}',
                );
              }
            }
          },
          onAdFailedToLoad: (ad, error) {
            _isBannerAdLoaded = false;
            if (kDebugMode) {
              print(
                'AdMob: Failed to load leaderboard banner ad: ${error.message}',
              );
              print('AdMob: Error code: ${error.code}');
            }
          },
          onAdOpened: (ad) {
            if (kDebugMode) {
              print('AdMob: Leaderboard banner ad opened');
            }
          },
          onAdClosed: (ad) {
            if (kDebugMode) {
              print('AdMob: Leaderboard banner ad closed');
            }
          },
        ),
      );

      await _bannerAd!.load();

      if (kDebugMode) {
        print(
          'AdMob: Leaderboard banner ad load completed. Success: $_isBannerAdLoaded',
        );
      }

      return _isBannerAdLoaded;
    } catch (e) {
      _isBannerAdLoaded = false;
      if (kDebugMode) {
        print('AdMob: Exception while loading leaderboard banner ad: $e');
      }
      return false;
    }
  }

  /// Load leaderboard banner ad with retry mechanism
  Future<bool> loadLeaderboardBannerAdWithRetry({int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      if (kDebugMode) {
        print(
          'AdMob: Leaderboard banner ad load attempt $attempt of $maxRetries',
        );
      }

      final success = await loadLeaderboardBannerAd();
      if (success) {
        return true;
      }

      if (attempt < maxRetries) {
        if (kDebugMode) {
          print(
            'AdMob: Leaderboard banner ad load failed, retrying in 2 seconds...',
          );
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (kDebugMode) {
      print(
        'AdMob: Leaderboard banner ad load failed after $maxRetries attempts',
      );
    }
    return false;
  }

  /// Get banner ad widget
  Widget? getBannerAdWidget() {
    if (_isBannerAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return null;
  }

  /// Get banner ad widget with responsive sizing
  Widget? getResponsiveBannerAdWidget() {
    if (_isBannerAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return null;
  }

  /// Check if ad is available
  bool get isAdAvailable => _isAdLoaded && _rewardedAd != null;

  /// Check if banner ad is available
  bool get isBannerAdAvailable => _isBannerAdLoaded && _bannerAd != null;

  /// Dispose ad
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;
    _isAdLoading = false;
    _isBannerAdLoaded = false;
  }
}
