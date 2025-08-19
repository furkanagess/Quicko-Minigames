import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quicko_app/core/config/app_initializer.dart';
import 'l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/routes/app_router.dart';
import 'core/utils/global_context.dart';
import 'core/constants/supported_locales.dart';
import 'features/favorites/providers/favorites_provider.dart';
import 'features/leaderboard/providers/leaderboard_provider.dart';
// Removed: handled by AppInitializer
import 'core/routes/navigation_observer.dart';

void main() async {
  // Enable performance optimizations
  if (kDebugMode) {
    debugPrintRebuildDirtyWidgets = false;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null &&
          !message.contains('ImageReader') &&
          !message.contains('FrameEvents')) {
        print(message);
      }
    };
  }

  await AppInitializer.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          // Debug: Check saved values when app starts
          WidgetsBinding.instance.addPostFrameCallback((_) {
            themeProvider.debugCheckSavedTheme();
            languageProvider.debugCheckSavedLanguage();

            // Initialize favorites provider
            final favoritesProvider = Provider.of<FavoritesProvider>(
              context,
              listen: false,
            );
            favoritesProvider.initialize();
          });

          return MaterialApp(
            title: 'Quicko',
            debugShowCheckedModeBanner: false,
            navigatorKey: GlobalContext.navigatorKey,

            // Localization
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: SupportedLocales.locales,
            locale: languageProvider.currentLocale,

            // Theme
            theme: AppTheme.getLightTheme(),
            darkTheme: AppTheme.getDarkTheme(),
            themeMode: _getThemeMode(themeProvider),

            // Routes
            initialRoute: AppRouter.home,
            onGenerateRoute: AppRouter.generateRoute,
            navigatorObservers: [AppNavigationObserver()],

            // Performance
            builder: (context, child) {
              return Directionality(
                textDirection:
                    languageProvider.currentLocale.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                ),
              );
            },
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(ThemeProvider themeProvider) {
    switch (themeProvider.currentThemeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
