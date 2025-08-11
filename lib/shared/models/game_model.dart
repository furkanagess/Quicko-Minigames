import 'package:flutter/material.dart';
import '../../core/utils/localization_utils.dart';

class GameModel {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String route;
  final String icon;
  final String category;
  final int order;

  const GameModel({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.route,
    required this.icon,
    this.category = 'General',
    this.order = 0,
  });

  /// Get localized title using global context (for use in providers)
  String get localizedTitle => LocalizationUtils.getStringGlobal(titleKey);

  /// Get localized description using global context (for use in providers)
  String get localizedDescription =>
      LocalizationUtils.getStringGlobal(descriptionKey);

  /// Get localized title with context (preferred method when context is available)
  String getTitle(BuildContext context) =>
      LocalizationUtils.getStringWithContext(context, titleKey);

  /// Get localized description with context (preferred method when context is available)
  String getDescription(BuildContext context) =>
      LocalizationUtils.getStringWithContext(context, descriptionKey);

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
