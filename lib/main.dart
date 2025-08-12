import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/text_theme_manager.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/routes/app_router.dart';
import 'core/utils/global_context.dart';
import 'features/favorites/providers/favorites_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
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
            supportedLocales: const [
              Locale('en'), // English
              Locale('tr'), // Turkish
            ],
            locale: languageProvider.currentLocale,

            // Theme
            theme: AppTheme.getLightTheme(),
            darkTheme: AppTheme.getDarkTheme(),
            themeMode: _getThemeMode(themeProvider),

            // Routes
            initialRoute: AppRouter.home,
            onGenerateRoute: AppRouter.generateRoute,

            // Performance
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
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
