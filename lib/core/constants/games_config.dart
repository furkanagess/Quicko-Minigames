import 'package:flutter/material.dart';
import '../../shared/models/game_model.dart';
import '../theme/app_theme.dart';
import 'app_icons.dart';

class GamesConfig {
  // Tüm oyunların merkezi konfigürasyonu
  // Ordered by popularity, user experience, and engagement
  static const List<GameModel> allGames = [
    // Tier 1: Most Popular & Easy Games (Entry Level)
    GameModel(
      id: 'rps',
      titleKey: 'rock_paper_scissors',
      descriptionKey: 'rock_paper_scissors_description',
      route: '/rps',
      icon: 'hand',
      category: 'Reflex',
      order: 0,
    ),
    GameModel(
      id: 'higher_lower',
      titleKey: 'higher_lower',
      descriptionKey: 'higher_lower_description',
      route: '/higher-lower',
      icon: 'trending_up',
      category: 'Numbers',
      order: 1,
    ),
    GameModel(
      id: 'color_hunt',
      titleKey: 'color_hunt',
      descriptionKey: 'color_hunt_description',
      route: '/color-hunt',
      icon: 'palette',
      category: 'Vision',
      order: 2,
    ),

    // Tier 2: Engaging & Medium Difficulty Games
    GameModel(
      id: 'find_difference',
      titleKey: 'find_difference',
      descriptionKey: 'find_difference_description',
      route: '/find-difference',
      icon: 'difference',
      category: 'Vision',
      order: 3,
    ),
    GameModel(
      id: 'blind_sort',
      titleKey: 'blind_sort',
      descriptionKey: 'blind_sort_description',
      route: '/blind-sort',
      icon: 'sort',
      category: 'Logic',
      order: 4,
    ),
    GameModel(
      id: 'aim_trainer',
      titleKey: 'aim_trainer',
      descriptionKey: 'aim_trainer_description',
      route: '/aim-trainer',
      icon: 'gps_fixed',
      category: 'Reflex',
      order: 5,
    ),

    // Tier 3: Advanced & Challenging Games
    GameModel(
      id: 'number_memory',
      titleKey: 'number_memory',
      descriptionKey: 'number_memory_description',
      route: '/number-memory',
      icon: 'memory',
      category: 'Memory',
      order: 6,
    ),
    GameModel(
      id: 'reaction_time',
      titleKey: 'reactionTime',
      descriptionKey: 'reactionTimeDescription',
      route: '/reaction-time',
      icon: 'timer',
      category: 'Reflex',
      order: 7,
    ),
    GameModel(
      id: 'pattern_memory',
      titleKey: 'patternMemory',
      descriptionKey: 'patternMemoryDescription',
      route: '/pattern-memory',
      icon: 'grid_view',
      category: 'Memory',
      order: 8,
    ),
    GameModel(
      id: 'twenty_one',
      titleKey: 'twenty_one',
      descriptionKey: 'twenty_one_description',
      route: '/twenty-one',
      icon: 'casino',
      category: 'Cards',
      order: 9,
    ),
  ];

  // Oyun renkleri
  // Color palette optimized for new game order and user experience
  static const Map<String, Color> gameColors = {
    // Tier 1: Most Popular & Easy Games (Entry Level)
    'rps': AppTheme.darkPrimary, // purple - most popular
    'higher_lower': AppTheme.darkWarning, // yellow - engaging
    'color_hunt': AppTheme.darkSuccess, // green - visual appeal
    // Tier 2: Engaging & Medium Difficulty Games
    'find_difference': AppTheme.darkSecondary, // soft purple - engaging
    'blind_sort': AppTheme.darkPrimary, // purple - logic
    'aim_trainer': AppTheme.darkError, // red - action
    // Tier 3: Advanced & Challenging Games
    'number_memory': AppTheme.vividGreen, // vivid green - memory
    'reaction_time': AppTheme.darkPrimary, // purple - reflex
    'pattern_memory': AppTheme.darkSecondary, // soft purple - advanced memory
    'twenty_one': AppTheme.goldYellow, // gold - casino style
  };

  // Icon mapping
  static const Map<String, IconData> gameIcons = {
    'sort': AppIcons.sort,
    'trending_up': AppIcons.trending,
    'palette': AppIcons.palette,
    'gps_fixed': AppIcons.gpsFixed,
    'memory': AppIcons.memory,
    'difference': AppIcons.gridOn,
    'hand': AppIcons.hand,
    'casino': Icons.casino,
    'timer': AppIcons.timer, // Use AppIcons.timer for consistency
    'grid_view': Icons.grid_view,
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
