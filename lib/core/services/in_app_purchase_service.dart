import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  static const String _adFreeSubscriptionId = 'one_time_payment';
  static const String _isAdFreeKey = 'is_ad_free';
  static const String _subscriptionExpiryKey = 'subscription_expiry';
  static const String _subscriptionStartKey = 'subscription_start';
  static const String _lastPaymentDateKey = 'last_payment_date';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAdFree = false;
  DateTime? _subscriptionExpiry;
  DateTime? _subscriptionStart;
  DateTime? _lastPaymentDate;
  bool _isInitialized = false;

  bool get isAdFree => _isAdFree;
  DateTime? get subscriptionExpiry => _subscriptionExpiry;
  DateTime? get subscriptionStart => _subscriptionStart;
  DateTime? get lastPaymentDate => _lastPaymentDate;
  bool get isInitialized => _isInitialized;

  /// Initialize the in-app purchase service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load saved subscription status
      await _loadSubscriptionStatus();

      // Listen to purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription?.cancel(),
        onError: (error) {
          if (kDebugMode) {
            print('InAppPurchase: Purchase stream error: $error');
          }
        },
      );

      _isInitialized = true;
      if (kDebugMode) {
        print('InAppPurchase: Service initialized successfully');
        print('InAppPurchase: Ad-free status: $_isAdFree');
        print('InAppPurchase: Subscription expiry: $_subscriptionExpiry');
      }
    } catch (e) {
      if (kDebugMode) {
        print('InAppPurchase: Error initializing service: $e');
      }
    }
  }

  /// Load subscription status from SharedPreferences
  Future<void> _loadSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAdFree = prefs.getBool(_isAdFreeKey) ?? false;

      final expiryTimestamp = prefs.getInt(_subscriptionExpiryKey);
      if (expiryTimestamp != null) {
        _subscriptionExpiry = DateTime.fromMillisecondsSinceEpoch(
          expiryTimestamp,
        );
      }

      final startTimestamp = prefs.getInt(_subscriptionStartKey);
      if (startTimestamp != null) {
        _subscriptionStart = DateTime.fromMillisecondsSinceEpoch(
          startTimestamp,
        );
      }

      final lastPaymentTimestamp = prefs.getInt(_lastPaymentDateKey);
      if (lastPaymentTimestamp != null) {
        _lastPaymentDate = DateTime.fromMillisecondsSinceEpoch(
          lastPaymentTimestamp,
        );
      }

      // Check if subscription has expired
      if (_isAdFree &&
          _subscriptionExpiry != null &&
          _subscriptionExpiry!.isBefore(DateTime.now())) {
        _isAdFree = false;
        await _saveSubscriptionStatus();
      }
    } catch (e) {
      if (kDebugMode) {
        print('InAppPurchase: Error loading subscription status: $e');
      }
    }
  }

  /// Save subscription status to SharedPreferences
  Future<void> _saveSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isAdFreeKey, _isAdFree);

      if (_subscriptionExpiry != null) {
        await prefs.setInt(
          _subscriptionExpiryKey,
          _subscriptionExpiry!.millisecondsSinceEpoch,
        );
      } else {
        await prefs.remove(_subscriptionExpiryKey);
      }

      if (_subscriptionStart != null) {
        await prefs.setInt(
          _subscriptionStartKey,
          _subscriptionStart!.millisecondsSinceEpoch,
        );
      } else {
        await prefs.remove(_subscriptionStartKey);
      }

      if (_lastPaymentDate != null) {
        await prefs.setInt(
          _lastPaymentDateKey,
          _lastPaymentDate!.millisecondsSinceEpoch,
        );
      } else {
        await prefs.remove(_lastPaymentDateKey);
      }
    } catch (e) {
      if (kDebugMode) {
        print('InAppPurchase: Error saving subscription status: $e');
      }
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (kDebugMode) {
        print('InAppPurchase: Purchase update: ${purchaseDetails.productID}');
        print('InAppPurchase: Purchase status: ${purchaseDetails.status}');
      }

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending purchase
        if (kDebugMode) {
          print('InAppPurchase: Purchase pending');
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Handle successful purchase
        _handleSuccessfulPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle purchase error
        if (kDebugMode) {
          print('InAppPurchase: Purchase error: ${purchaseDetails.error}');
        }
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        // Handle canceled purchase
        if (kDebugMode) {
          print('InAppPurchase: Purchase canceled');
        }
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// Handle successful purchase
  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == _adFreeSubscriptionId) {
      final now = DateTime.now();

      _isAdFree = true;
      _lastPaymentDate = now;
      _subscriptionStart = now;

      // For one-time payment, no expiry date (lifetime)
      _subscriptionExpiry = null;

      await _saveSubscriptionStatus();

      if (kDebugMode) {
        print('InAppPurchase: Lifetime ad-free access activated');
        print('InAppPurchase: Purchased on: $_lastPaymentDate');
        print('InAppPurchase: No expiry date (lifetime access)');
      }
    }
  }

  /// Purchase ad-free subscription
  Future<bool> purchaseAdFreeSubscription() async {
    try {
      if (kDebugMode) {
        print('InAppPurchase: Starting ad-free subscription purchase');
      }

      // Check if already subscribed
      if (_isAdFree) {
        if (kDebugMode) {
          print('InAppPurchase: Already subscribed to ad-free');
        }
        return true;
      }

      // Get product details
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails({_adFreeSubscriptionId});

      if (response.error != null) {
        if (kDebugMode) {
          print('InAppPurchase: Error querying products: ${response.error}');
        }
        return false;
      }

      if (response.productDetails.isEmpty) {
        if (kDebugMode) {
          print('InAppPurchase: No products found');
        }
        return false;
      }

      // Create purchase params
      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      // Start purchase (one-time payment)
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (kDebugMode) {
        print('InAppPurchase: Purchase initiated: $success');
      }

      return success;
    } catch (e) {
      if (kDebugMode) {
        print('InAppPurchase: Error purchasing subscription: $e');
      }
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      if (kDebugMode) {
        print('InAppPurchase: Restoring purchases');
      }

      await _inAppPurchase.restorePurchases();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('InAppPurchase: Error restoring purchases: $e');
      }
      return false;
    }
  }

  /// Cancel subscription (clear ad-free status)
  Future<bool> cancelSubscription() async {
    try {
      if (kDebugMode) {
        print('InAppPurchase: Canceling subscription');
      }

      // Clear ad-free status
      _isAdFree = false;
      _subscriptionExpiry = null;
      _subscriptionStart = null;
      _lastPaymentDate = null;

      // Save the updated status
      await _saveSubscriptionStatus();

      if (kDebugMode) {
        print('InAppPurchase: Subscription canceled successfully');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('InAppPurchase: Error canceling subscription: $e');
      }
      return false;
    }
  }

  /// Check if subscription is active (for lifetime access, always true if purchased)
  bool isSubscriptionActive() {
    return _isAdFree;
  }

  /// Get remaining subscription days (for lifetime access, returns -1)
  int getRemainingDays() {
    if (!_isAdFree) return 0;
    return -1; // -1 indicates lifetime access
  }

  /// Check if it's time for next payment (not applicable for lifetime access)
  bool get isPaymentDueSoon {
    return false; // No payment due for lifetime access
  }

  /// Get subscription duration in days
  int getSubscriptionDuration() {
    if (_subscriptionStart == null || _subscriptionExpiry == null) return 0;
    return _subscriptionExpiry!.difference(_subscriptionStart!).inDays;
  }

  /// Get subscription status text
  String getSubscriptionStatusText() {
    if (!_isAdFree) return 'Not purchased';
    return 'Lifetime access';
  }

  /// Dispose the service
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
