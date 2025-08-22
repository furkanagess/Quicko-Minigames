import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/in_app_purchase_service.dart';

class TestModeProvider extends ChangeNotifier {
  static final TestModeProvider _instance = TestModeProvider._internal();
  factory TestModeProvider() => _instance;
  TestModeProvider._internal();

  static const String _testAdFreeModeKey = 'test_ad_free_mode';

  bool _testAdFreeMode = false;
  bool get testAdFreeMode => _testAdFreeMode;

  /// Initialize the provider and load saved state
  Future<void> initialize() async {
    await _loadTestModeState();
  }

  /// Load test mode state from SharedPreferences
  Future<void> _loadTestModeState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _testAdFreeMode = prefs.getBool(_testAdFreeModeKey) ?? false;
      notifyListeners();

      if (kDebugMode) {
        print('TestModeProvider: Loaded test mode state: $_testAdFreeMode');
      }
    } catch (e) {
      if (kDebugMode) {
        print('TestModeProvider: Error loading test mode state: $e');
      }
    }
  }

  /// Toggle test ad-free mode
  Future<void> toggleTestAdFreeMode() async {
    _testAdFreeMode = !_testAdFreeMode;
    await _saveTestModeState();
    notifyListeners();

    if (kDebugMode) {
      print('TestModeProvider: Test ad-free mode toggled to: $_testAdFreeMode');
    }
  }

  /// Set test ad-free mode to a specific value
  Future<void> setTestAdFreeMode(bool value) async {
    if (_testAdFreeMode != value) {
      _testAdFreeMode = value;
      await _saveTestModeState();
      notifyListeners();

      if (kDebugMode) {
        print('TestModeProvider: Test ad-free mode set to: $_testAdFreeMode');
      }
    }
  }

  /// Save test mode state to SharedPreferences
  Future<void> _saveTestModeState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_testAdFreeModeKey, _testAdFreeMode);

      if (kDebugMode) {
        print('TestModeProvider: Saved test mode state: $_testAdFreeMode');
      }
    } catch (e) {
      if (kDebugMode) {
        print('TestModeProvider: Error saving test mode state: $e');
      }
    }
  }

  /// Reset test mode to false
  Future<void> resetTestMode() async {
    await setTestAdFreeMode(false);
  }

  /// Check if app should behave as ad-free (combines actual subscription + test mode)
  bool get shouldBehaveAsAdFree {
    final purchaseService = InAppPurchaseService();
    return purchaseService.isAdFree || (kDebugMode && _testAdFreeMode);
  }

  /// Get comprehensive ad-free status for UI display
  bool get isAdFreeForUI {
    final purchaseService = InAppPurchaseService();
    return purchaseService.isAdFree || _testAdFreeMode;
  }

  /// Check if user has real ad-free purchase (not test mode)
  bool get hasRealAdFreePurchase {
    final purchaseService = InAppPurchaseService();
    return purchaseService.isAdFree;
  }

  /// Check if test mode is active
  bool get isTestModeActive => kDebugMode && _testAdFreeMode;
}
