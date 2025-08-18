class GameIconUtils {
  // Icon mapping for custom PNG icons
  static const Map<String, String> _iconPaths = {
    // Game icons
    'rock-paper-scissors': 'assets/icon/rock-paper-scissors.png',
    'thermostat': 'assets/icon/thermostat.png',
    'color-palette': 'assets/icon/color-palette.png',
    'color-circle': 'assets/icon/color-circle.png',
    'order': 'assets/icon/order.png',
    'target': 'assets/icon/target.png',
    'lottery': 'assets/icon/lottery.png',
    'quick-response': 'assets/icon/quick-response.png',
    'pattern': 'assets/icon/pattern.png',
    'blackjack': 'assets/icon/blackjack.png',

    // Other icons
    'winner': 'assets/icon/winner.png',
    'joystick': 'assets/icon/joystick.png',
    'average': 'assets/icon/average.png',
    'settings': 'assets/icon/settings.png',
  };

  /// Get the asset path for a given icon name
  static String getIconPath(String iconName) {
    return _iconPaths[iconName] ?? 'assets/icon/quicko.png';
  }

  /// Check if an icon exists
  static bool hasIcon(String iconName) {
    return _iconPaths.containsKey(iconName);
  }

  /// Get all available icon names
  static List<String> getAvailableIcons() {
    return _iconPaths.keys.toList();
  }
}
