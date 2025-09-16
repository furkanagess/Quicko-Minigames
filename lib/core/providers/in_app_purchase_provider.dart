import 'dart:io';
import '../services/in_app_purchase_service.dart';
import 'package:flutter/foundation.dart';

class InAppPurchaseProvider extends ChangeNotifier {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Listeners for ad services to get real-time updates
  final List<VoidCallback> _adFreeStatusListeners = [];

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
  bool get isIOS => Platform.isIOS;

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
    }

    _isLoading = false;
    notifyListeners();
  }

  /// (removed) test mode toggle

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
        // For iOS, ensure UI is updated after successful purchase
        if (Platform.isIOS) {
          // Small delay to ensure purchase status is properly updated
          await Future.delayed(const Duration(milliseconds: 500));
        }
        // Notify ad services that ad-free status has changed
        _notifyAdFreeStatusListeners();
      } else {
        _errorMessage = 'Failed to purchase subscription';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Purchase error: $e';
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
        // For iOS, ensure UI is updated after successful restoration
        if (Platform.isIOS) {
          // Small delay to ensure purchase status is properly updated
          await Future.delayed(const Duration(milliseconds: 500));
        }
        // Notify ad services that ad-free status has changed
        _notifyAdFreeStatusListeners();
        // Force UI refresh after successful restoration
        notifyListeners();
      } else {
        _errorMessage = 'No previous purchases found to restore';
      }

      return success;
    } catch (e) {
      _errorMessage = 'Restore error: $e';
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

  /// Add listener for ad-free status changes
  void addAdFreeStatusListener(VoidCallback listener) {
    _adFreeStatusListeners.add(listener);
  }

  /// Remove listener for ad-free status changes
  void removeAdFreeStatusListener(VoidCallback listener) {
    _adFreeStatusListeners.remove(listener);
  }

  /// Notify all ad-free status listeners
  void _notifyAdFreeStatusListeners() {
    for (final listener in _adFreeStatusListeners) {
      try {
        listener();
      } catch (e) {
        // Handle listener errors silently
      }
    }
  }

  @override
  void dispose() {
    _adFreeStatusListeners.clear();
    _purchaseService.dispose();
    super.dispose();
  }
}
