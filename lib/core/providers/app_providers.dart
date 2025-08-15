import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Features
import '../../features/favorites/providers/favorites_provider.dart';
import '../../features/leaderboard/providers/leaderboard_provider.dart';

// Core
import 'language_provider.dart';
import 'theme_provider.dart';
import 'in_app_purchase_provider.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider<FavoritesProvider>(
      create: (_) => FavoritesProvider(),
    ),
    ChangeNotifierProvider<LeaderboardProvider>(
      create: (_) => LeaderboardProvider(),
    ),
    ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
    ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
    ChangeNotifierProvider<InAppPurchaseProvider>(
      create: (_) => InAppPurchaseProvider(),
    ),
  ];

  // Helper method to get provider instance
  static T getProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  // Helper method to watch provider changes
  static T watchProvider<T>(BuildContext context) {
    return Provider.of<T>(context, listen: true);
  }

  // Helper method to select specific data from provider
  static R selectProvider<T, R>(
    BuildContext context,
    R Function(T provider) selector,
  ) {
    return Provider.of<T>(context, listen: true).let(selector);
  }
}

// Extension to make the let function available
extension ObjectExtension<T> on T {
  R let<R>(R Function(T value) operation) => operation(this);
}
