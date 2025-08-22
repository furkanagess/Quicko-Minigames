import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:quicko_app/shared/widgets/dialog/congrats_dialog.dart';

void main() {
  group('CongratsDialog UI Tests', () {
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
                        builder:
                            (context) => const CongratsDialog(
                              gameId: 'test_game',
                              gameTitle: 'Test Game',
                              currentScore: 100,
                              onRestart: _dummyRestart,
                              onExit: _dummyExit,
                            ),
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
      expect(find.text('Congratulations'), findsOneWidget);
      expect(find.text('Test Game - Score 100'), findsOneWidget);
      expect(find.text('Game Completed!'), findsOneWidget);
      expect(
        find.text(
          'Congratulations on completing the game! You can restart to play again or exit to return to the main menu.',
        ),
        findsOneWidget,
      );
      expect(find.text('Restart'), findsOneWidget);
      expect(find.text('Exit'), findsOneWidget);

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
                        builder:
                            (context) => const CongratsDialog(
                              gameId: 'test_game',
                              gameTitle: 'Test Game',
                              currentScore: 100,
                              onRestart: _dummyRestart,
                              onExit: _dummyExit,
                            ),
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
      expect(find.text('Tebrikler'), findsOneWidget);
      expect(find.text('Test Game - Skor 100'), findsOneWidget);
      expect(find.text('Oyun Tamamlandı!'), findsOneWidget);
      expect(
        find.text(
          'Oyunu tamamladığınız için tebrikler! Tekrar oynamak için yeniden başlatabilir veya ana menüye dönmek için çıkabilirsiniz.',
        ),
        findsOneWidget,
      );
      expect(find.text('Yeniden Başlat'), findsOneWidget);
      expect(find.text('Çıkış'), findsOneWidget);
    });
  });
}

void _dummyRestart() {}
void _dummyExit() {}
