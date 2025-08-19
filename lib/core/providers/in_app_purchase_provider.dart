import 'package:flutter/foundation.dart';
import '../services/in_app_purchase_service.dart';

class InAppPurchaseProvider extends ChangeNotifier {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  bool get isAdFree => _purchaseService.isAdFree;
  bool get isSubscriptionActive => _purchaseService.isSubscriptionActive();
  DateTime? get subscriptionExpiry => _purchaseService.subscriptionExpiry;
  DateTime? get subscriptionStart => _purchaseService.subscriptionStart;
  DateTime? get lastPaymentDate => _purchaseService.lastPaymentDate;
  int get remainingDays => _purchaseService.getRemainingDays();
  bool get isPaymentDueSoon => _purchaseService.isPaymentDueSoon;
  int get subscriptionDuration => _purchaseService.getSubscriptionDuration();
  String get subscriptionStatusText =>
      _purchaseService.getSubscriptionStatusText();
  String? get errorMessage => _errorMessage;

  InAppPurchaseProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _purchaseService.initialize();
      _isInitialized = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to initialize purchase service: $e';
      if (kDebugMode) {
        print('InAppPurchaseProvider: Error initializing: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Purchase ad-free subscription
  Future<bool> purchaseAdFreeSubscription() async {
    if (!_isInitialized) {
      _errorMessage = 'Purchase service not initialized';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _purchaseService.purchaseAdFreeSubscription();

      if (success) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to purchase subscription';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Purchase error: $e';
      if (kDebugMode) {
        print('InAppPurchaseProvider: Purchase error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    if (!_isInitialized) {
      _errorMessage = 'Purchase service not initialized';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _purchaseService.restorePurchases();

      if (success) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to restore purchases';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Restore error: $e';
      if (kDebugMode) {
        print('InAppPurchaseProvider: Restore error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cancel subscription
  Future<bool> cancelSubscription() async {
    if (!_isInitialized) {
      _errorMessage = 'Purchase service not initialized';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _purchaseService.cancelSubscription();

      if (success) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to cancel subscription';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Cancel subscription error: $e';
      if (kDebugMode) {
        print('InAppPurchaseProvider: Cancel subscription error: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh subscription status
  void refreshStatus() {
    notifyListeners();
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }
}
