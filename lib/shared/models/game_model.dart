class GameModel {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String route;
  final String icon;

  const GameModel({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.route,
    required this.icon,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GameModel(id: $id, titleKey: $titleKey, route: $route)';
  }
}
