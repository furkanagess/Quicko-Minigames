import 'package:flutter/material.dart';
import '../../shared/models/game_model.dart';
import '../theme/app_theme.dart';

class GamesConfig {
  // Tüm oyunların merkezi konfigürasyonu
  static const List<GameModel> allGames = [
    GameModel(
      id: 'blind_sort',
      titleKey: 'blind_sort',
      descriptionKey: 'blind_sort_description',
      route: '/blind-sort',
      icon: 'sort',
    ),
    GameModel(
      id: 'higher_lower',
      titleKey: 'higher_lower',
      descriptionKey: 'higher_lower_description',
      route: '/higher-lower',
      icon: 'trending_up',
    ),
    GameModel(
      id: 'color_hunt',
      titleKey: 'color_hunt',
      descriptionKey: 'color_hunt_description',
      route: '/color-hunt',
      icon: 'palette',
    ),
    GameModel(
      id: 'aim_trainer',
      titleKey: 'aim_trainer',
      descriptionKey: 'aim_trainer_description',
      route: '/aim-trainer',
      icon: 'gps_fixed',
    ),
  ];

  // Oyun renkleri
  static const Map<String, Color> gameColors = {
    'blind_sort': AppTheme.darkPrimary,
    'higher_lower': AppTheme.darkSecondary,
    'color_hunt': AppTheme.darkSuccess,
    'aim_trainer': AppTheme.darkWarning,
  };

  // Icon mapping
  static const Map<String, IconData> gameIcons = {
    'sort': Icons.sort_rounded,
    'trending_up': Icons.trending_up_rounded,
    'palette': Icons.palette_rounded,
    'gps_fixed': Icons.gps_fixed_rounded,
  };

  /// Belirli bir oyunu ID'ye göre bul
  static GameModel? getGameById(String gameId) {
    try {
      return allGames.firstWhere((game) => game.id == gameId);
    } catch (e) {
      return null;
    }
  }

  /// Oyunun rengini al
  static Color getGameColor(String gameId) {
    return gameColors[gameId] ?? AppTheme.darkPrimary;
  }

  /// Oyunun icon'unu al
  static IconData getGameIcon(String iconName) {
    return gameIcons[iconName] ?? Icons.games_rounded;
  }

  /// Tüm oyun ID'lerini al
  static List<String> getAllGameIds() {
    return allGames.map((game) => game.id).toList();
  }
}
