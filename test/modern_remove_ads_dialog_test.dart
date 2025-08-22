import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:quicko_app/shared/widgets/dialog/modern_remove_ads_dialog.dart';

void main() {
  group('ModernRemoveAdsDialog UI Tests', () {
    testWidgets('should display modern UI with gradient header', (
      WidgetTester tester,
    ) async {
      // Build the dialog
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ModernRemoveAdsDialog(),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify that the modern UI elements are present
      expect(find.text('Remove Ads'), findsOneWidget);
      expect(find.text('Premium Features'), findsOneWidget);
      expect(
        find.text('Get a clean, ad-free experience with premium features.'),
        findsOneWidget,
      );
      expect(find.text('No Banner Ads'), findsOneWidget);
      expect(find.text('No Interstitial Ads'), findsOneWidget);
      expect(find.text('No Rewarded Ads'), findsOneWidget);
      expect(find.text('Clean Experience'), findsOneWidget);
      expect(find.text('Best Value'), findsOneWidget);
      expect(find.text('Maybe Later'), findsOneWidget);
      expect(find.text('Buy Now'), findsOneWidget);

      // Verify that the dialog has the modern structure
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(LinearGradient), findsWidgets);
    });

    testWidgets('should display Turkish text when locale is Turkish', (
      WidgetTester tester,
    ) async {
      // Build the dialog with Turkish locale
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('tr'),
          home: Scaffold(
            body: Builder(
              builder:
                  (context) => ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ModernRemoveAdsDialog(),
                      );
                    },
                    child: const Text('Show Dialog'),
                  ),
            ),
          ),
        ),
      );

      // Tap to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify that Turkish text is displayed
      expect(find.text('Reklamları Kaldır'), findsOneWidget);
      expect(find.text('Premium Özellikler'), findsOneWidget);
      expect(
        find.text('Premium özelliklerle temiz, reklamsız bir deneyim yaşayın.'),
        findsOneWidget,
      );
      expect(find.text('Banner Reklamları Yok'), findsOneWidget);
      expect(find.text('Geçiş Reklamları Yok'), findsOneWidget);
      expect(find.text('Ödüllü Reklamlar Yok'), findsOneWidget);
      expect(find.text('Temiz Deneyim'), findsOneWidget);
      expect(find.text('En İyi Değer'), findsOneWidget);
      expect(find.text('Belki Daha Sonra'), findsOneWidget);
      expect(find.text('Şimdi Satın Al'), findsOneWidget);
    });
  });
}
