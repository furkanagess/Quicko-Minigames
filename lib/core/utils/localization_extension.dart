import 'package:flutter/material.dart';
import 'localization_utils.dart';

extension LocalizationExtension on String {
  /// Extension method to get localized string (for backward compatibility)
  String tr(BuildContext context) {
    return LocalizationUtils.getStringWithContext(context, this);
  }

  /// Extension method to get localized string without context (for providers)
  String get trGlobal {
    return LocalizationUtils.getStringGlobal(this);
  }
}
