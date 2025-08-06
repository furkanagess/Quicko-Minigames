import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/text_theme_manager.dart';

class GameDescription extends StatelessWidget {
  final String descriptionKey;
  final IconData? icon;

  const GameDescription({super.key, required this.descriptionKey, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Expanded(
            child: Text(
              descriptionKey.tr(),
              style: TextThemeManager.descriptionOnSurface(context),
            ),
          ),
        ],
      ),
    );
  }
}
