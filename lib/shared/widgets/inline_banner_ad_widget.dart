import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_config.dart';
import '../../core/services/admob_service.dart';
import '../../core/providers/in_app_purchase_provider.dart';
import '../../core/providers/test_mode_provider.dart';

/// A self-contained banner ad widget that manages its own BannerAd instance.
///
/// Use this for inline placements where multiple banners may appear in a list
/// or grid. It respects the global ad-free/test mode state via AdMobService.
class InlineBannerAdWidget extends StatefulWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final double fallbackGapHeight;

  const InlineBannerAdWidget({
    super.key,
    this.verticalPadding = 16.0,
    this.horizontalPadding = 0.0,
    this.fallbackGapHeight = 0.0,
  });

  @override
  State<InlineBannerAdWidget> createState() => _InlineBannerAdWidgetState();
}

class _InlineBannerAdWidgetState extends State<InlineBannerAdWidget> {
  final AdMobService _adMobService = AdMobService();
  final AppConfig _config = AppConfig();

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!_adMobService.shouldShowAds) {
      if (kDebugMode) {
        print('InlineBannerAdWidget: Ads disabled (ad-free or test mode).');
      }
      return;
    }

    if (_isLoading || _isLoaded) return;
    _isLoading = true;

    try {
      final adUnitId = _config.bannerAdUnitId;
      if (kDebugMode) {
        print('InlineBannerAdWidget: Loading banner ad: $adUnitId');
      }
      final banner = BannerAd(
        adUnitId: adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _bannerAd = ad as BannerAd;
                _isLoaded = true;
                _isLoading = false;
              });
            }
            if (kDebugMode) {
              print('InlineBannerAdWidget: Banner loaded (${ad.responseInfo})');
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _isLoaded = false;
                _isLoading = false;
              });
            }
            if (kDebugMode) {
              print(
                'InlineBannerAdWidget: Failed to load banner: ${error.message}',
              );
            }
          },
        ),
      );

      await banner.load();
    } catch (e) {
      if (kDebugMode) {
        print('InlineBannerAdWidget: Exception while loading banner: $e');
      }
      if (mounted) {
        setState(() {
          _isLoaded = false;
          _isLoading = false;
        });
      }
    }
  }

  void _disposeBannerIfAny() {
    try {
      _bannerAd?.dispose();
    } catch (_) {}
    _bannerAd = null;
    _isLoaded = false;
    _isLoading = false;
  }

  @override
  void dispose() {
    _disposeBannerIfAny();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<InAppPurchaseProvider, TestModeProvider>(
      builder: (context, iap, test, child) {
        final shouldShow = _adMobService.shouldShowAds;

        if (!shouldShow) {
          if (_bannerAd != null) {
            _disposeBannerIfAny();
          }
          // Use fallback height that matches list spacing when ads are disabled
          return SizedBox(height: _getFallbackHeight());
        }

        if (!_isLoaded && !_isLoading) {
          // Try load if eligible and not yet loading
          _load();
        }

        if (!_isLoaded || _bannerAd == null) {
          // Use fallback height that matches list spacing when ad fails to load
          return SizedBox(height: _getFallbackHeight());
        }

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            bottom: widget.verticalPadding,
            top: widget.verticalPadding,
            left: widget.horizontalPadding,
            right: widget.horizontalPadding,
          ),
          width: double.infinity,
          child: SizedBox(
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        );
      },
    );
  }

  /// Calculate the fallback height when ads are disabled/failed
  /// This should match the typical spacing between list items
  double _getFallbackHeight() {
    // For favorites and home screens (verticalPadding: 8.0), return exactly 16px to match spacing
    // For other screens, use a reasonable default spacing
    if (widget.verticalPadding == 8.0) {
      return 16.0; // Exact match for favorites card spacing and home grid spacing
    }
    return widget.verticalPadding < 12.0 ? 16.0 : 20.0;
  }
}
