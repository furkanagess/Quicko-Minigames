import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';
import '../../../core/providers/in_app_purchase_provider.dart';
import '../../../core/routes/app_router.dart';

class AdFreeSubscriptionScreen extends StatefulWidget {
  const AdFreeSubscriptionScreen({super.key});

  @override
  State<AdFreeSubscriptionScreen> createState() =>
      _AdFreeSubscriptionScreenState();
}

class _AdFreeSubscriptionScreenState extends State<AdFreeSubscriptionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Consumer<InAppPurchaseProvider>(
            builder: (context, purchaseProvider, child) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(context),
                      const SizedBox(height: AppConstants.largeSpacing),

                      // Subscription Status
                      if (purchaseProvider.isSubscriptionActive)
                        _buildActiveSubscriptionCard(context, purchaseProvider),

                      // Subscription Options
                      Expanded(
                        child: _buildSubscriptionOptions(
                          context,
                          purchaseProvider,
                        ),
                      ),

                      // Error Message
                      if (purchaseProvider.errorMessage != null)
                        _buildErrorMessage(context, purchaseProvider),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.removeAds,
        style: TextThemeManager.appTitlePrimary(context),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => AppRouter.pop(context),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.largeSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkSuccess.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.block_rounded,
              color: AppTheme.darkSuccess,
              size: 32,
            ),
          ),
          const SizedBox(height: AppConstants.mediumSpacing),

          // Title
          Text(
            AppLocalizations.of(context)!.removeAds,
            style: TextThemeManager.screenTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallSpacing),

          // Description
          Text(
            AppLocalizations.of(context)!.removeAdsDescription,
            style: TextThemeManager.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSubscriptionCard(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.largeSpacing),
      padding: const EdgeInsets.all(AppConstants.largeSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkSuccess.withValues(alpha: 0.1),
            AppTheme.darkSuccess.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.darkSuccess.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkSuccess.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkSuccess.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppTheme.darkSuccess,
              size: 24,
            ),
          ),
          const SizedBox(width: AppConstants.mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.subscriptionActive,
                  style: TextThemeManager.subtitleMedium.copyWith(
                    color: AppTheme.darkSuccess,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.daysRemaining(purchaseProvider.remainingDays),
                  style: TextThemeManager.bodySmall.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOptions(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) {
    return Column(
      children: [
        // Monthly Subscription Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.largeSpacing),
            child: Column(
              children: [
                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$1',
                      style: TextThemeManager.screenTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'USD',
                          style: TextThemeManager.bodySmall.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          '/month',
                          style: TextThemeManager.bodySmall.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.mediumSpacing),

                // Features
                _buildFeatureItem(context, '🚫 No banner ads'),
                _buildFeatureItem(context, '🚫 No interstitial ads'),
                _buildFeatureItem(context, '🚫 No rewarded ads'),
                _buildFeatureItem(
                  context,
                  '✨ Clean, distraction-free experience',
                ),
                _buildFeatureItem(context, '🔄 Cancel anytime'),

                const SizedBox(height: AppConstants.largeSpacing),

                // Subscribe Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        purchaseProvider.isLoading ||
                                purchaseProvider.isSubscriptionActive
                            ? null
                            : () => _handleSubscribe(context, purchaseProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child:
                        purchaseProvider.isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              purchaseProvider.isSubscriptionActive
                                  ? AppLocalizations.of(
                                    context,
                                  )!.subscriptionActive
                                  : AppLocalizations.of(context)!.subscribeNow,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppConstants.largeSpacing),

        // Restore Purchases Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed:
                purchaseProvider.isLoading
                    ? null
                    : () => _handleRestorePurchases(context, purchaseProvider),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                purchaseProvider.isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(
                      AppLocalizations.of(context)!.restorePurchases,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppTheme.darkSuccess,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Expanded(
            child: Text(
              feature,
              style: TextThemeManager.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: AppConstants.mediumSpacing),
      padding: const EdgeInsets.all(AppConstants.mediumSpacing),
      decoration: BoxDecoration(
        color: AppTheme.darkError.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkError.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppTheme.darkError,
            size: 20,
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Expanded(
            child: Text(
              purchaseProvider.errorMessage!,
              style: TextThemeManager.bodySmall.copyWith(
                color: AppTheme.darkError,
              ),
            ),
          ),
          IconButton(
            onPressed: () => purchaseProvider.clearError(),
            icon: Icon(
              Icons.close_rounded,
              color: AppTheme.darkError,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubscribe(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) async {
    final success = await purchaseProvider.purchaseAdFreeSubscription();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.purchaseSuccess),
          backgroundColor: AppTheme.darkSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.purchaseError),
          backgroundColor: AppTheme.darkError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _handleRestorePurchases(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) async {
    final success = await purchaseProvider.restorePurchases();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.restoreSuccess),
          backgroundColor: AppTheme.darkSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.restoreError),
          backgroundColor: AppTheme.darkError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
