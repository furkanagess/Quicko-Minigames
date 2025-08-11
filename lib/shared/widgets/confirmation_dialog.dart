import 'package:flutter/material.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/text_theme_manager.dart';
import 'base_dialog.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor =
        isDestructive
            ? AppTheme.darkError
            : Theme.of(context).colorScheme.primary;
    final defaultIcon =
        isDestructive ? Icons.warning_rounded : Icons.help_outline_rounded;

    return BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          BaseDialogHeader(
            icon: Icon(icon ?? defaultIcon),
            title: title,
            backgroundColor: accentColor.withValues(alpha: 0.1),
            iconColor: accentColor,
            titleColor: accentColor,
          ),

          // Content
          BaseDialogContent(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Text(
                message,
                style: TextThemeManager.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Actions
          BaseDialogActions(
            children: [
              BaseDialogButton(
                text: cancelText ?? AppLocalizations.of(context)!.cancel,
                onPressed: onCancel ?? () => Navigator.of(context).pop(false),
                width: 110,
                icon: Icons.close_rounded,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              BaseDialogButton(
                text: confirmText ?? AppLocalizations.of(context)!.confirm,
                onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
                isPrimary: !isDestructive,
                isDestructive: isDestructive,
                width: 110,
                icon:
                    isDestructive
                        ? Icons.delete_forever_rounded
                        : Icons.check_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SortDialog extends StatelessWidget {
  final String currentSortBy;
  final Function(String) onSortChanged;

  const SortDialog({
    super.key,
    required this.currentSortBy,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          BaseDialogHeader(
            icon: const Icon(Icons.sort_rounded),
            title: AppLocalizations.of(context)!.sortBy,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            iconColor: Theme.of(context).colorScheme.primary,
            titleColor: Theme.of(context).colorScheme.primary,
          ),

          // Content
          BaseDialogContent(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSortOption(
                  context,
                  'score',
                  AppLocalizations.of(context)!.sortByScore,
                  Icons.emoji_events_rounded,
                ),
                _buildSortOption(
                  context,
                  'date',
                  AppLocalizations.of(context)!.sort_by_date,
                  Icons.calendar_today_rounded,
                ),
                _buildSortOption(
                  context,
                  'game',
                  AppLocalizations.of(context)!.sort_by_game,
                  Icons.games_rounded,
                ),
              ],
            ),
          ),

          // Actions
          BaseDialogActions(
            children: [
              BaseDialogButton(
                text: AppLocalizations.of(context)!.close,
                onPressed: () => Navigator.of(context).pop(),
                width: 120,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String value,
    String title,
    IconData icon,
  ) {
    final isSelected = currentSortBy == value;
    final accentColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onSortChanged(value);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? accentColor.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected
                        ? accentColor.withValues(alpha: 0.3)
                        : Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color:
                      isSelected
                          ? accentColor
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextThemeManager.bodyMedium.copyWith(
                      color:
                          isSelected
                              ? accentColor
                              : Theme.of(context).colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: accentColor,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
