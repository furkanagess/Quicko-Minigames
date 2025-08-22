import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:quicko_app/firebase_options.dart';

import '../config/app_config.dart';
import '../providers/test_mode_provider.dart';
import '../services/admob_service.dart';
import '../services/in_app_purchase_service.dart';
import '../services/interstitial_ad_service.dart';
import '../services/sound_settings_service.dart';
import '../services/connectivity_service.dart';

class AppInitializer {
  AppInitializer._();

  static bool _initialized = false;

  /// Performs one-time application initialization in a well-defined order.
  /// Safe to call multiple times; subsequent calls are no-ops.
  static Future<void> initialize() async {
    if (_initialized) return;

    final Stopwatch stopwatch = Stopwatch()..start();

    // Ensure Flutter engine is ready
    // and set device orientation before any UI builds.
    await _ensureFlutterBindingAndOrientation();

    // Print app configuration early in debug mode
    _printConfigIfDebug();

    // Core services that are required app-wide
    await _initializeCoreServices();

    // Initialize connectivity service
    await ConnectivityService().initialize();

    // Firebase last so platform bindings are already in place
    await _initializeFirebase();

    _initialized = true;

    if (kDebugMode) {
      debugPrint(
        'AppInitializer: completed in ${stopwatch.elapsedMilliseconds}ms',
      );
    }
  }

  static Future<void> _ensureFlutterBindingAndOrientation() async {
    // Widgets binding
    try {
      // ignore: deprecated_member_use_from_same_package
      WidgetsFlutterBinding.ensureInitialized();
    } catch (_) {
      // ignore
    }

    // Orientation
    await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void _printConfigIfDebug() {
    if (!kDebugMode) return;
    final AppConfig config = AppConfig();
    config.printConfig();
  }

  static Future<void> _initializeCoreServices() async {
    // Order matters slightly:
    // - Load persisted user flags first (test mode)
    // - IAP status before ad services
    // - Sound settings for early usage
    await Future.wait(<Future<void>>[
      TestModeProvider().initialize(),
      InAppPurchaseService().initialize(),
      SoundSettingsService.ensureInitialized(),
    ]);

    await AdMobService().initialize();
    await InterstitialAdService().initialize();

    // Reset session upsell flag on app start
    InterstitialAdService().resetSessionUpsellFlag();
  }

  static Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        debugPrint('Firebase: initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase: initialization error: $e');
      }
      rethrow;
    }
  }
}
