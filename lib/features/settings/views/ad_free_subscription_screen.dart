// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../l10n/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
// import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_theme_manager.dart';
import '../../../core/providers/in_app_purchase_provider.dart';

import '../../../core/services/dialog_service.dart';
import '../../../shared/widgets/app_bars.dart';

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

  // Removed uninstall bottom sheet helpers for cleaner layout

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show iOS not supported message
    if (Platform.isIOS) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  Text(
                    AppLocalizations.of(context)!.comingSoonTitle,
                    style: TextThemeManager.screenTitle.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.smallSpacing),
                  Text(
                    'In-app purchases are not available on iOS devices. Please use an Android device to purchase the ad-free version.',
                    style: TextThemeManager.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Consumer<InAppPurchaseProvider>(
            builder: (context, purchaseProvider, child) {
              final isAdFree = purchaseProvider.isAdFree;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildMainContent(
                          context,
                          purchaseProvider,
                          isAdFree,
                        ),
                      ),
                      // Fixed bottom buttons
                      if (!isAdFree) ...[
                        const SizedBox(height: AppConstants.largeSpacing),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                purchaseProvider.isLoading ||
                                        purchaseProvider.isSubscriptionActive
                                    ? null
                                    : () => _handleSubscribe(
                                      context,
                                      purchaseProvider,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              elevation: 4,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.mediumRadius,
                                ),
                              ),
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
                                          : AppLocalizations.of(
                                            context,
                                          )!.buyNow,
                                      style: TextThemeManager.buttonLarge
                                          .copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                          ),
                        ),
                        // Restore Purchases button - right below Buy Now button
                        const SizedBox(height: AppConstants.mediumSpacing),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed:
                                purchaseProvider.isLoading
                                    ? null
                                    : () => _handleRestore(
                                      context,
                                      purchaseProvider,
                                    ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.mediumRadius,
                                ),
                              ),
                            ),
                            child:
                                purchaseProvider.isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.restorePurchases,
                                      style: TextThemeManager.buttonLarge,
                                    ),
                          ),
                        ),
                      ] else ...[
                        // Restore Purchases button for ad-free users
                        const SizedBox(height: AppConstants.largeSpacing),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed:
                                purchaseProvider.isLoading
                                    ? null
                                    : () => _handleRestore(
                                      context,
                                      purchaseProvider,
                                    ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.mediumRadius,
                                ),
                              ),
                            ),
                            child:
                                purchaseProvider.isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.restorePurchases,
                                      style: TextThemeManager.buttonLarge,
                                    ),
                          ),
                        ),
                      ],
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
    return AppBars.settingsAppBar(
      context: context,
      title: AppLocalizations.of(context)!.removeAds,
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
    bool isAdFree,
  ) {
    return Column(
      children: [
        if (isAdFree) ...[
          _buildAdFreeUnlockedContent(context, purchaseProvider),
        ] else ...[
          _buildPurchaseContent(context, purchaseProvider),
        ],
      ],
    );
  }

  Widget _buildAdFreeUnlockedContent(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) {
    return Column(
      children: [
        // Main Status Card

        // Benefits Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.largeSpacing),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallSpacing),
                  Text(
                    AppLocalizations.of(context)!.unlockedBenefits,
                    style: TextThemeManager.subtitleMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.mediumSpacing),

              // Benefits List
              _buildBenefitItem(
                context,
                Icons.block_rounded,
                AppLocalizations.of(context)!.noBannerAds,
                AppLocalizations.of(context)!.noBannerAdvertisements,
              ),
              _buildBenefitItem(
                context,
                Icons.block_rounded,
                AppLocalizations.of(context)!.noInterstitialAds,
                AppLocalizations.of(context)!.noFullScreenAds,
              ),
              _buildBenefitItem(
                context,
                Icons.block_rounded,
                AppLocalizations.of(context)!.noRewardedAds,
                AppLocalizations.of(context)!.noVideoAds,
              ),
              _buildBenefitItem(
                context,
                Icons.auto_awesome_rounded,
                AppLocalizations.of(context)!.cleanExperience,
                AppLocalizations.of(context)!.distractionFreeGaming,
              ),
              _buildBenefitItem(
                context,
                Icons.all_inclusive_rounded,
                AppLocalizations.of(context)!.lifetimeAccess,
                AppLocalizations.of(context)!.oneTimePaymentForeverAccess,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextThemeManager.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextThemeManager.bodySmall.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseContent(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) {
    return Column(
      children: [
        // Lifetime Purchase Card
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
                // Clean and modern pricing display
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.largeSpacing),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.08),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.03),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.largeRadius,
                        ),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Main price display
                          Text(
                            AppLocalizations.of(context)!.subscriptionPrice,
                            textAlign: TextAlign.center,
                            style: TextThemeManager.screenTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                              shadows: [
                                Shadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.2),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppConstants.smallSpacing),
                          // Badges row
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.smallRadius,
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.payments_rounded,
                                      size: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.oneTimePayment,
                                      style: TextThemeManager.bodySmall
                                          .copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.smallRadius,
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      AppLocalizations.of(context)!.bestValue,
                                      style: TextThemeManager.bodySmall
                                          .copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppConstants.mediumSpacing),

                          // Lifetime access highlight
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(
                                AppConstants.mediumRadius,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.all_inclusive_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  AppLocalizations.of(context)!.lifetimeAccess,
                                  style: TextThemeManager.bodyMedium.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Info button in top right corner
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap:
                              () => _showUninstallWarningBottomSheet(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.mediumSpacing),

                // Features
                _buildFeatureItem(
                  context,
                  AppLocalizations.of(context)!.noBannerAds,
                ),
                _buildFeatureItem(
                  context,
                  AppLocalizations.of(context)!.noInterstitialAds,
                ),
                _buildFeatureItem(
                  context,
                  AppLocalizations.of(context)!.noRewardedAds,
                ),
                _buildFeatureItem(
                  context,
                  AppLocalizations.of(context)!.cleanExperience,
                ),
                _buildFeatureItem(
                  context,
                  AppLocalizations.of(context)!.lifetimeAccess,
                ),
              ],
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
            color: Theme.of(context).colorScheme.tertiary,
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

  // Removed uninstall warning card and inline error widget to avoid extra overlays during purchase flows

  Future<void> _handleSubscribe(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) async {
    await purchaseProvider.purchaseAdFreeSubscription();

    if (!mounted) return;

    // Check if purchase was successful
    if (purchaseProvider.isSubscriptionActive) {
      // Show success dialog
      await DialogService.showAdFreeSuccessDialog(
        context: context,
        onContinue: () {
          // Refresh the UI to show ad-free content
          setState(() {});
        },
      );
    } else if (purchaseProvider.errorMessage != null) {
      // Show error bottom sheet if purchase failed
      _showPurchaseErrorBottomSheet(
        context,
        title: AppLocalizations.of(context)!.purchaseError,
        description: AppLocalizations.of(context)!.purchaseErrorDescription,
      );
    }
  }

  // Cancel subscription flow removed for one-time purchase model

  Future<void> _handleRestore(
    BuildContext context,
    InAppPurchaseProvider purchaseProvider,
  ) async {
    final success = await purchaseProvider.restorePurchases();

    if (!mounted) return;

    if (success) {
      // Check if the user is now ad-free (restoration was successful)
      if (purchaseProvider.isSubscriptionActive) {
        // Show success dialog for restored purchases
        await DialogService.showAdFreeSuccessDialog(
          context: context,
          onContinue: () {
            // Refresh the UI to show ad-free content
            setState(() {});
          },
        );
      } else {
        // Show message that no purchases were found to restore
        _showPurchaseErrorBottomSheet(
          context,
          title: AppLocalizations.of(context)!.noPurchasesFound,
          description:
              AppLocalizations.of(context)!.noPurchasesFoundDescription,
        );
      }
    } else {
      _showPurchaseErrorBottomSheet(
        context,
        title: AppLocalizations.of(context)!.restoreError,
        description: AppLocalizations.of(context)!.restoreErrorDescription,
      );
    }
  }

  void _showPurchaseErrorBottomSheet(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.largeSpacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.largeSpacing),
                  // Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.largeSpacing),
                  // Title
                  Text(
                    title,
                    style: TextThemeManager.sectionTitle.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  // Description
                  Text(
                    description,
                    style: TextThemeManager.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: AppConstants.largeSpacing),
                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.mediumRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.gotIt,
                        style: TextThemeManager.buttonMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUninstallWarningBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.largeSpacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.largeSpacing),
                  // Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.largeSpacing),
                  // Title
                  Text(
                    AppLocalizations.of(context)!.uninstallWarningTitle,
                    style: TextThemeManager.sectionTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.mediumSpacing),
                  // Description
                  Text(
                    AppLocalizations.of(context)!.uninstallWarningMessage,
                    style: TextThemeManager.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: AppConstants.largeSpacing),
                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.mediumRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.gotIt,
                        style: TextThemeManager.buttonMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
