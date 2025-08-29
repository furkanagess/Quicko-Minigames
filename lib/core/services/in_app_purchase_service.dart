import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InAppPurchaseService {
  static final InAppPurchaseService _instance =
      InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  // Platform-specific product IDs
  static const String _adFreeSubscriptionIdIOS = 'one_time_payment_ads_remove';
  static const String _adFreeSubscriptionIdAndroid = 'one_time_payment';

  // Get the appropriate product ID based on platform
  String get _adFreeSubscriptionId {
    if (Platform.isIOS) {
      return _adFreeSubscriptionIdIOS;
    } else if (Platform.isAndroid) {
      return _adFreeSubscriptionIdAndroid;
    } else {
      // Default to iOS ID for other platforms
      return _adFreeSubscriptionIdIOS;
    }
  }

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

  /// Get the current platform's product ID (for debugging/logging)
  String get currentProductId => _adFreeSubscriptionId;

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
          // Handle error silently in production
        },
      );

      _isInitialized = true;
    } catch (e) {
      // Handle error silently in production
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
      // Handle error silently in production
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
      // Handle error silently in production
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending purchase
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Handle successful purchase
        _handleSuccessfulPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle purchase error
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        // Handle canceled purchase
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// Handle successful purchase
  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    // Check for both iOS and Android product IDs
    if (purchaseDetails.productID == _adFreeSubscriptionIdIOS ||
        purchaseDetails.productID == _adFreeSubscriptionIdAndroid) {
      final now = DateTime.now();

      _isAdFree = true;
      _lastPaymentDate = now;
      _subscriptionStart = now;

      // For one-time payment, no expiry date (lifetime)
      _subscriptionExpiry = null;

      await _saveSubscriptionStatus();
    }
  }

  /// Purchase ad-free subscription
  Future<bool> purchaseAdFreeSubscription() async {
    try {
      // Check if already subscribed
      if (_isAdFree) {
        return true;
      }

      // Get product details
      final ProductDetailsResponse response = await _inAppPurchase
          .queryProductDetails({_adFreeSubscriptionId});

      if (response.error != null) {
        return false;
      }

      if (response.productDetails.isEmpty) {
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

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      // Check if already ad-free (no need to restore if already active)
      if (_isAdFree) {
        return true;
      }

      // Call the platform's restore purchases method
      await _inAppPurchase.restorePurchases();

      // The actual restoration will be handled by _onPurchaseUpdate
      // when the restored purchases come through the purchase stream

      // Wait a bit for the purchase stream to process the restored purchases
      await Future.delayed(const Duration(seconds: 2));

      // Check if restoration was successful by checking if we're now ad-free
      return _isAdFree;
    } catch (e) {
      // Handle error silently in production
      return false;
    }
  }

  /// Cancel subscription (clear ad-free status)
  Future<bool> cancelSubscription() async {
    try {
      // Clear ad-free status
      _isAdFree = false;
      _subscriptionExpiry = null;
      _subscriptionStart = null;
      _lastPaymentDate = null;

      // Save the updated status
      await _saveSubscriptionStatus();

      return true;
    } catch (e) {
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
