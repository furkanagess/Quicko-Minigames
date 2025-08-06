import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// Features
import '../../features/home/views/home_screen.dart';
import '../../features/blind_sort/views/blind_sort_screen.dart';
import '../../features/higher_lower/views/higher_lower_screen.dart';
import '../../features/color_hunt/views/color_hunt_screen.dart';
import '../../features/aim_trainer/views/aim_trainer_screen.dart';
import '../../features/favorites/views/favorites_screen.dart';
import '../../features/leaderboard/views/leaderboard_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String blindSort = '/blind-sort';
  static const String higherLower = '/higher-lower';
  static const String colorHunt = '/color-hunt';
  static const String aimTrainer = '/aim-trainer';
  static const String favorites = '/favorites';
  static const String leaderboard = '/leaderboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(settings, const HomeScreen());

      case blindSort:
        return _buildRoute(settings, const BlindSortScreen());

      case higherLower:
        return _buildRoute(settings, const HigherLowerScreen());

      case colorHunt:
        return _buildRoute(settings, const ColorHuntScreen());

      case aimTrainer:
        return _buildRoute(settings, const AimTrainerScreen());

      case favorites:
        return _buildRoute(settings, const FavoritesScreen());

      case leaderboard:
        return _buildRoute(settings, const LeaderboardScreen());

      default:
        return _buildRoute(
          settings,
          Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }

  static PageRoute<dynamic> _buildRoute(RouteSettings settings, Widget child) {
    return MaterialPageRoute(settings: settings, builder: (context) => child);
  }

  // Navigation helper methods
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.of(context).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }
}
