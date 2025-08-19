import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_config.dart';
import 'in_app_purchase_service.dart';
import '../providers/test_mode_provider.dart';

class InterstitialAdService {
  static final InterstitialAdService _instance =
      InterstitialAdService._internal();
  factory InterstitialAdService() => _instance;
  InterstitialAdService._internal();

  final AppConfig _config = AppConfig();
  final InAppPurchaseService _purchaseService = InAppPurchaseService();
  final TestModeProvider _testModeProvider = TestModeProvider();

  // Interstitial ad management
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  bool _isInterstitialAdLoading = false;

  // Route tracking
  int _routeChangeCount = 0;
  DateTime? _lastInterstitialAdShown;

  // Configuration
  static const int _routeChangeThreshold = 10;
  static const Duration _minimumAdInterval = Duration(minutes: 1);

  /// Get interstitial ad unit ID
  String get _interstitialAdUnitId => _config.interstitialAdUnitId;

  /// Check if ads should be shown (respects ad-free subscription and test mode)
  bool get _shouldShowAds =>
      !_purchaseService.isAdFree && !_testModeProvider.shouldBehaveAsAdFree;

  /// Initialize the service
  Future<void> initialize() async {
    if (kDebugMode) {
      print('InterstitialAdService: Initializing...');
      print(
        'InterstitialAdService: Using Interstitial Ad ID: $_interstitialAdUnitId',
      );
    }

    // Preload the first interstitial ad
    await loadInterstitialAd();
  }

  /// Load interstitial ad
  Future<bool> loadInterstitialAd() async {
    // Don't load interstitial ads if user has ad-free subscription or test mode is enabled
    if (!_shouldShowAds) {
      if (kDebugMode) {
        print(
          'InterstitialAdService: Skipping interstitial ad load - user has ad-free subscription or test mode enabled',
        );
      }
      return false;
    }

    if (_isInterstitialAdLoading || _isInterstitialAdLoaded) {
      return _isInterstitialAdLoaded;
    }

    _isInterstitialAdLoading = true;

    try {
      await InterstitialAd.load(
        adUnitId: _interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialAdLoaded = true;
            _isInterstitialAdLoading = false;

            if (kDebugMode) {
              print(
                'InterstitialAdService: Interstitial ad loaded successfully',
              );
            }

            // Set up ad event listeners
            _setupInterstitialAdEventListeners();
          },
          onAdFailedToLoad: (error) {
            _isInterstitialAdLoaded = false;
            _isInterstitialAdLoading = false;

            if (kDebugMode) {
              print(
                'InterstitialAdService: Failed to load interstitial ad: ${error.message}',
              );
            }
          },
        ),
      );
    } catch (e) {
      _isInterstitialAdLoaded = false;
      _isInterstitialAdLoading = false;

      if (kDebugMode) {
        print(
          'InterstitialAdService: Exception while loading interstitial ad: $e',
        );
      }
    }

    return _isInterstitialAdLoaded;
  }

  /// Setup interstitial ad event listeners
  void _setupInterstitialAdEventListeners() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isInterstitialAdLoaded = false;
        _interstitialAd = null;
        _lastInterstitialAdShown = DateTime.now();

        if (kDebugMode) {
          print('InterstitialAdService: Interstitial ad dismissed');
        }

        // Load the next interstitial ad
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isInterstitialAdLoaded = false;
        _interstitialAd = null;

        if (kDebugMode) {
          print(
            'InterstitialAdService: Failed to show interstitial ad: ${error.message}',
          );
        }

        // Try to load another ad
        loadInterstitialAd();
      },
      onAdShowedFullScreenContent: (ad) {
        if (kDebugMode) {
          print(
            'InterstitialAdService: Interstitial ad showed full screen content',
          );
        }
      },
    );
  }

  /// Track route change and show ad if conditions are met
  Future<void> onRouteChanged() async {
    if (_shouldShowAds) {
      _routeChangeCount++;

      if (kDebugMode) {
        print('InterstitialAdService: Route change count: $_routeChangeCount');
      }

      if (_shouldShowInterstitialAd()) {
        await showInterstitialAd();
      }
    }
  }

  /// Check if interstitial ad should be shown
  bool _shouldShowInterstitialAd() {
    // Check if we have enough route changes
    if (_routeChangeCount < _routeChangeThreshold) {
      return false;
    }

    // Check if enough time has passed since last ad
    if (_lastInterstitialAdShown != null) {
      final timeSinceLastAd = DateTime.now().difference(
        _lastInterstitialAdShown!,
      );
      if (timeSinceLastAd < _minimumAdInterval) {
        if (kDebugMode) {
          print(
            'InterstitialAdService: Not enough time passed since last ad. '
            'Time since last ad: ${timeSinceLastAd.inSeconds} seconds',
          );
        }
        return false;
      }
    }

    // Check if ad is loaded
    if (!_isInterstitialAdLoaded || _interstitialAd == null) {
      if (kDebugMode) {
        print('InterstitialAdService: Interstitial ad not loaded');
      }
      return false;
    }

    return true;
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd() async {
    // Don't show interstitial ads if user has ad-free subscription or test mode is enabled
    if (!_shouldShowAds) {
      if (kDebugMode) {
        print(
          'InterstitialAdService: Skipping interstitial ad show - user has ad-free subscription or test mode enabled',
        );
      }
      return false;
    }

    if (!_isInterstitialAdLoaded || _interstitialAd == null) {
      if (kDebugMode) {
        print(
          'InterstitialAdService: Interstitial ad not available, trying to load...',
        );
      }
      final loaded = await loadInterstitialAd();
      if (!loaded) {
        if (kDebugMode) {
          print('InterstitialAdService: Failed to load interstitial ad');
        }
        return false;
      }
    }

    try {
      await _interstitialAd!.show();

      // Reset route change count after showing ad
      _routeChangeCount = 0;

      if (kDebugMode) {
        print('InterstitialAdService: Interstitial ad shown successfully');
        print('InterstitialAdService: Route change count reset to 0');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
          'InterstitialAdService: Exception while showing interstitial ad: $e',
        );
      }
      return false;
    }
  }

  /// Force show interstitial ad (for testing or manual triggers)
  Future<bool> forceShowInterstitialAd() async {
    if (_purchaseService.isAdFree) {
      if (kDebugMode) {
        print(
          'InterstitialAdService: User has ad-free subscription, skipping ad',
        );
      }
      return false;
    }

    return await showInterstitialAd();
  }

  /// Test method to manually trigger interstitial ad (for debugging)
  Future<bool> testInterstitialAd() async {
    if (kDebugMode) {
      print('InterstitialAdService: Testing interstitial ad...');
      print('InterstitialAdService: Route change count: $_routeChangeCount');
      print(
        'InterstitialAdService: Time since last ad: ${timeSinceLastAd?.inSeconds ?? 0} seconds',
      );
      print('InterstitialAdService: Ad loaded: $_isInterstitialAdLoaded');
      print(
        'InterstitialAdService: Should show ads: $shouldShowInterstitialAds',
      );
    }

    return await forceShowInterstitialAd();
  }

  /// Get current route change count
  int get routeChangeCount => _routeChangeCount;

  /// Get route change threshold
  int get routeChangeThreshold => _routeChangeThreshold;

  /// Get time since last ad was shown
  Duration? get timeSinceLastAd {
    if (_lastInterstitialAdShown == null) return null;
    return DateTime.now().difference(_lastInterstitialAdShown!);
  }

  /// Check if interstitial ad is available
  bool get isInterstitialAdAvailable =>
      _isInterstitialAdLoaded && _interstitialAd != null;

  /// Check if interstitial ads should be shown (respects ad-free subscription)
  bool get shouldShowInterstitialAds => _shouldShowAds;

  /// Reset route change count (useful for testing)
  void resetRouteChangeCount() {
    _routeChangeCount = 0;
    if (kDebugMode) {
      print('InterstitialAdService: Route change count reset to 0');
    }
  }

  /// Dispose interstitial ad
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded = false;
    _isInterstitialAdLoading = false;
  }
}
