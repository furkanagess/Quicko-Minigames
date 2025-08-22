import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'in_app_purchase_provider.dart';
import 'language_provider.dart';
import 'sound_settings_provider.dart';
import 'test_mode_provider.dart';
import 'theme_provider.dart';
import 'connectivity_provider.dart';
import 'onboarding_provider.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import '../../features/leaderboard/providers/leaderboard_provider.dart';
import '../../features/feedback/providers/feedback_provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InAppPurchaseProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SoundSettingsProvider()),
        ChangeNotifierProvider(create: (_) => TestModeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        // Feature providers
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
      ],
      child: child,
    );
  }
}
