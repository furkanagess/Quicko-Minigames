import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/text_theme_manager.dart';
import '../../core/utils/localization_utils.dart';

class GameDescription extends StatelessWidget {
  final String descriptionKey;
  final IconData? icon;

  const GameDescription({super.key, required this.descriptionKey, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon with modern styling
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon ?? Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppConstants.mediumSpacing),
        // Description text
        Expanded(
          child: Text(
            LocalizationUtils.getStringWithContext(context, descriptionKey),
            style: TextThemeManager.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
