import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

// Core
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/providers/app_providers.dart';
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
      providers: AppProviders.providers,
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
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.generateRoute,

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
