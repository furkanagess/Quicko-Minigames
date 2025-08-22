import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import 'package:quicko_app/shared/widgets/dialog/game_in_progress_dialog.dart';

void main() {
  group('GameInProgressDialog UI Tests', () {
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
                            (context) => const GameInProgressDialog(
                              onStayInGame: _dummyStayInGame,
                              onExitGame: _dummyExitGame,
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
      expect(find.text('Game In Progress'), findsOneWidget);
      expect(find.text('You have an active game session'), findsOneWidget);
      expect(find.text('Game Session Active'), findsOneWidget);
      expect(
        find.text(
          'You have an active game session. Do you want to continue with the current game or start a new one?',
        ),
        findsOneWidget,
      );
      expect(find.text('Exit'), findsOneWidget);
      expect(find.text('Stay'), findsOneWidget);

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
                            (context) => const GameInProgressDialog(
                              onStayInGame: _dummyStayInGame,
                              onExitGame: _dummyExitGame,
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
      expect(find.text('Oyun Devam Ediyor'), findsOneWidget);
      expect(find.text('Aktif bir oyun oturumunuz var'), findsOneWidget);
      expect(find.text('Oyun Oturumu Aktif'), findsOneWidget);
      expect(
        find.text(
          'Aktif bir oyun oturumunuz var. Mevcut oyuna devam etmek mi yoksa yeni bir oyun başlatmak mı istiyorsunuz?',
        ),
        findsOneWidget,
      );
      expect(find.text('Çıkış'), findsOneWidget);
      expect(find.text('Kal'), findsOneWidget);
    });
  });
}

void _dummyStayInGame() {}
void _dummyExitGame() {}
