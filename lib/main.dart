import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

// Core
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';

// Features
import 'features/home/views/home_screen.dart';
import 'features/blind_sort/views/blind_sort_screen.dart';
import 'features/higher_lower/views/higher_lower_screen.dart';
import 'features/color_hunt/views/color_hunt_screen.dart';
import 'features/aim_trainer/views/aim_trainer_screen.dart';
import 'features/favorites/views/favorites_screen.dart';
import 'features/favorites/providers/favorites_provider.dart';
import 'features/leaderboard/views/leaderboard_screen.dart';
import 'features/leaderboard/providers/leaderboard_provider.dart';
import 'core/utils/sound_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Easy Localization başlat
  await EasyLocalization.ensureInitialized();

  // Ses sistemini başlat
  await SoundUtils.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      path: 'assets/translations/',
      fallbackLocale: const Locale('tr', 'TR'),
      useOnlyLangCode: true, // Sadece dil kodunu kullan
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Localization
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        // Theme
        theme: AppTheme.getDarkTheme(),
        darkTheme: AppTheme.getDarkTheme(),
        themeMode: ThemeMode.dark,

        // Routes
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/blind-sort': (context) => const BlindSortScreen(),
          '/higher-lower': (context) => const HigherLowerScreen(),
          '/color-hunt': (context) => const ColorHuntScreen(),
          '/aim-trainer': (context) => const AimTrainerScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
        },

        // System UI
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  Theme.of(context).brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
