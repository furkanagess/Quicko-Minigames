import 'package:flutter/material.dart';
import '../services/interstitial_ad_service.dart';

class AppNavigationObserver extends NavigatorObserver {
  final InterstitialAdService _interstitialAdService = InterstitialAdService();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackRouteChange();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _trackRouteChange();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _trackRouteChange();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _trackRouteChange();
  }

  /// Track route change and trigger interstitial ad if conditions are met
  void _trackRouteChange() {
    // Use a microtask to ensure this runs after the navigation is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _interstitialAdService.onRouteChanged();
    });
  }
}
