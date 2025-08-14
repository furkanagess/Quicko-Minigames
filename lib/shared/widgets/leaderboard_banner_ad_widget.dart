import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/admob_service.dart';

class LeaderboardBannerAdWidget extends StatefulWidget {
  const LeaderboardBannerAdWidget({super.key});

  @override
  State<LeaderboardBannerAdWidget> createState() =>
      _LeaderboardBannerAdWidgetState();
}

class _LeaderboardBannerAdWidgetState extends State<LeaderboardBannerAdWidget> {
  final AdMobService _adMobService = AdMobService();
  bool _isAdLoaded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    if (kDebugMode) {
      print('LeaderboardBannerAdWidget: Starting to load banner ad');
    }

    try {
      final loaded = await _adMobService.loadLeaderboardBannerAdWithRetry(
        maxRetries: 3,
      );
      if (mounted) {
        setState(() {
          _isAdLoaded = loaded;
          _isLoading = false;
        });
        if (kDebugMode) {
          print('LeaderboardBannerAdWidget: Banner ad load result: $loaded');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          'LeaderboardBannerAdWidget: Exception while loading banner ad: $e',
        );
      }
      if (mounted) {
        setState(() {
          _isAdLoaded = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show anything while loading or if ad failed to load
    if (_isLoading || !_isAdLoaded) {
      return const SizedBox.shrink();
    }

    final bannerWidget = _adMobService.getResponsiveBannerAdWidget();
    if (bannerWidget == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: bannerWidget,
    );
  }
}
