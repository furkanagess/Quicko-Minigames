// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Quicko';

  @override
  String get blindSort => 'Blindes Sortieren';

  @override
  String get blindSortDescription =>
      'Sortiere 10 Zahlen von 1-50. Du verlierst, wenn die neue Zahl nirgendwo passt!';

  @override
  String get nextNumber => 'Nächste Zahl';

  @override
  String get newNumberComing => 'Neue Zahl kommt...';

  @override
  String get start => 'Start';

  @override
  String get restart => 'Neustart';

  @override
  String get home => 'Startseite';

  @override
  String get games => 'Spiele';

  @override
  String get score => 'Punktzahl';

  @override
  String get gameOver => 'Spiel Beendet';

  @override
  String get tryAgain => 'Nochmal Versuchen';

  @override
  String get share => 'Teilen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get fullscreen => 'Vollbild';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get higherLower => 'Höher oder Niedriger';

  @override
  String get higherLowerDescription =>
      'Rate, ob die nächste Zahl höher oder niedriger sein wird!';

  @override
  String get higher => 'Höher';

  @override
  String get lower => 'Niedriger';

  @override
  String get lastNumber => 'Letzte Zahl';

  @override
  String get completedAllTargets => 'Alle Ziele abgeschlossen!';

  @override
  String get targets => 'Ziele';

  @override
  String get continueGame => 'Spiel Fortsetzen';

  @override
  String get watchAdToContinue => 'Werbung ansehen um fortzufahren';

  @override
  String get adNotAvailable => 'Werbung nicht verfügbar';

  @override
  String get adNotAvailableMessage =>
      'Derzeit sind keine Werbungen verfügbar. Bitte versuchen Sie es später erneut.';

  @override
  String get adFailed => 'Werbung fehlgeschlagen';

  @override
  String get adFailedMessage =>
      'Werbung konnte nicht angezeigt werden. Bitte versuchen Sie es erneut.';

  @override
  String get ok => 'OK';

  @override
  String get exit => 'Beenden';

  @override
  String get andMore => 'und mehr...';

  @override
  String get missionFailed => 'Mission Fehlgeschlagen!';

  @override
  String get greenTargetHit => 'Grünes Ziel getroffen!';

  @override
  String get youHitAllTargets => 'Du hast alle Ziele getroffen!';

  @override
  String get timeRanOut => 'Zeit ist abgelaufen!';

  @override
  String get targetsHit => 'Getroffene Ziele';

  @override
  String get mistake => 'Fehler';

  @override
  String get civilianHit => 'Zivilist Getroffen';

  @override
  String get youFoundAllColors => 'Du hast alle Farben gefunden!';

  @override
  String get colorsFound => 'Gefundene Farben';

  @override
  String get lastMistake => 'Letzter Fehler';

  @override
  String get wrongColor => 'Falsche Farbe';

  @override
  String get currentNumber => 'Aktuelle Zahl';

  @override
  String get close => 'Schließen';

  @override
  String get betterLuckNextTime => 'Viel Glück beim nächsten Mal!';

  @override
  String get losingNumbers => 'Zahlen die zum Verlust führten';

  @override
  String get losingNumber => 'Zahl die zum Verlust führte';

  @override
  String get colorHunt => 'Farbenjagd';

  @override
  String get colorHuntDescription =>
      'Finde die Zielfarbe! Die Textfarbe könnte dich täuschen!';

  @override
  String get target => 'Ziel';

  @override
  String get time => 'Zeit';

  @override
  String get wrongColorSelected => 'Falsche Farbe Ausgewählt';

  @override
  String get wrongColorSelection => 'Falsche Farbauswahl';

  @override
  String get favorites => 'Favoriten';

  @override
  String get loadingFavorites => 'Favoriten werden geladen...';

  @override
  String get noFavoritesYet => 'Noch Keine Favoriten';

  @override
  String get addGamesToFavorites =>
      'Füge Spiele zu Favoriten hinzu für schnellen Zugriff';

  @override
  String get browseGames => 'Spiele Durchsuchen';

  @override
  String get aimTrainer => 'Ziel-Trainer';

  @override
  String get aimTrainerDescription =>
      'Versuche die roten Ziele zu treffen, die zufällig für 20 Sekunden erscheinen. Jeder Treffer ist 1 Punkt!';

  @override
  String get numberMemory => 'Zahlen-Gedächtnis';

  @override
  String get numberMemoryDescription =>
      'Merke dir die Zahlenfolge und gib sie korrekt mit der Tastatur ein. Wie viele Ziffern kannst du dir merken?';

  @override
  String get findDifference => 'Finde den Unterschied';

  @override
  String get findDifferenceDescription =>
      'Finde das Quadrat mit einer anderen Farbe. Wird schwieriger in jeder Runde!';

  @override
  String get rockPaperScissors => 'Schere-Stein-Papier';

  @override
  String get rockPaperScissorsDescription =>
      'Spiele gegen den Computer. Der erste der 5 Punkte erreicht gewinnt.';

  @override
  String get twentyOne => '21 (Blackjack)';

  @override
  String get twentyOneDescription =>
      'Besiege den Dealer bis 21! Komme so nah wie möglich ohne zu überschreiten.';

  @override
  String get nowYourTurn => 'Jetzt bist du dran!';

  @override
  String get correct => 'Richtig!';

  @override
  String get playing => 'Spielt';

  @override
  String youReachedLevel(int level) {
    return 'Du hast Level $level erreicht';
  }

  @override
  String get tapToStartGuessing =>
      'Tippe auf Höher oder Niedriger um mit dem Raten zu beginnen! Die Zahlen sind zwischen 1-50.';

  @override
  String get numbersBetween1And50 => 'Die Zahlen sind zwischen 1-50';

  @override
  String get leaderboard => 'Bestenliste';

  @override
  String get noLeaderboardData => 'Keine Bestenlisten-Daten';

  @override
  String get playGamesToSeeScores =>
      'Spiele um deine höchsten Punktzahlen hier zu sehen!';

  @override
  String get playGames => 'Spielen';

  @override
  String get totalGames => 'Gesamte Spiele';

  @override
  String get highestScore => 'Höchste Punktzahl';

  @override
  String get averageScore => 'Durchschnittliche Punktzahl';

  @override
  String highScore(int score) {
    return 'Höchste Punktzahl: $score';
  }

  @override
  String lastPlayed(String date) {
    return 'Zuletzt gespielt: $date';
  }

  @override
  String get sortBy => 'Sortieren Nach';

  @override
  String get sortByScore => 'Nach Punktzahl Sortieren';

  @override
  String get sortByLastPlayed => 'Nach Zuletzt Gespielt Sortieren';

  @override
  String get shareAchievements => 'Erfolge Teilen';

  @override
  String get previewImage => 'Vorschau';

  @override
  String get shareImage => 'Bild Teilen';

  @override
  String get shareNoData => 'Noch keine Daten zum Teilen. Spiele zuerst!';

  @override
  String get shareError =>
      'Fehler beim Teilen der Erfolge. Versuche es erneut.';

  @override
  String get timeUp => 'Zeit ist Um';

  @override
  String get timeUpMessage => 'Deine Zeit ist abgelaufen!';

  @override
  String get finalScore => 'Endpunktzahl';

  @override
  String get youWon => 'Du hast Gewonnen!';

  @override
  String get congratulationsMessage =>
      'Glückwunsch! Du hast die Herausforderung abgeschlossen!';

  @override
  String get excellentPerformance => 'Ausgezeichnete Leistung!';

  @override
  String get playAgain => 'Nochmal Spielen';

  @override
  String get deleteHighScore => 'Höchste Punktzahl Löschen';

  @override
  String get deleteHighScoreMessage =>
      'Bist du sicher, dass du die höchste Punktzahl für dieses Spiel löschen möchtest?';

  @override
  String get delete => 'Löschen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache Auswählen';

  @override
  String get languageChangeInfo =>
      'Sprachänderungen werden sofort angewendet. Die App wird neu gestartet, um die neue Sprache zu übernehmen.';

  @override
  String get choosePreferredLanguage => 'Wähle deine bevorzugte Sprache';

  @override
  String get sort_by_date => 'Nach Datum Sortieren';

  @override
  String get sort_by_game => 'Nach Spiel Sortieren';

  @override
  String get theme => 'Design';

  @override
  String get selectTheme => 'Design Auswählen';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get systemTheme => 'System';

  @override
  String get lightThemeDescription => 'Helles Design für helle Umgebungen';

  @override
  String get darkThemeDescription =>
      'Dunkles Design für Umgebungen mit wenig Licht';

  @override
  String get systemThemeDescription =>
      'Folgt der Design-Einstellung deines Geräts';

  @override
  String get themeChangeInfo =>
      'Design-Änderungen werden sofort in der gesamten App angewendet.';

  @override
  String get choosePreferredTheme => 'Wähle dein bevorzugtes Design';

  @override
  String get startGame => 'Spiel Starten';

  @override
  String get restartGame => 'Spiel Neustarten';

  @override
  String get you => 'Du';

  @override
  String get cpu => 'CPU';

  @override
  String get dealer => 'Dealer';

  @override
  String get youWin => 'Du Gewinnst!';

  @override
  String get youLose => 'Du Verlierst!';

  @override
  String get tie => 'Unentschieden!';

  @override
  String get total => 'Gesamt';

  @override
  String get red => 'Rot';

  @override
  String get green => 'Grün';

  @override
  String get blue => 'Blau';

  @override
  String get purple => 'Lila';

  @override
  String get orange => 'Orange';

  @override
  String get yellow => 'Gelb';

  @override
  String get pink => 'Rosa';

  @override
  String get brown => 'Braun';

  @override
  String get play => 'Spielen';

  @override
  String get appSettings => 'App-Einstellungen';

  @override
  String get customizeAppExperience => 'Passe deine App-Erfahrung an';

  @override
  String get settings => 'Einstellungen';

  @override
  String get hit => 'Ziehen';

  @override
  String get stand => 'Stehen';

  @override
  String get reactionTime => 'Reaktionszeit';

  @override
  String get reactionTimeDescription =>
      'Klicke auf die Zahlen von 1 bis 12 in der richtigen Reihenfolge so schnell wie möglich. Deine Zeit wird gemessen (niedriger ist besser).';

  @override
  String get wrongSequence => 'Falsche Reihenfolge!';

  @override
  String get congratulations => 'Glückwunsch!';

  @override
  String get next => 'Nächste';

  @override
  String get numbersSorted => 'Sortierte Zahlen';

  @override
  String get numbersRemembered => 'Gemerkte Zahlen';

  @override
  String get correctGuesses => 'Richtige Schätzungen';

  @override
  String get yourScore => 'Deine Punktzahl';

  @override
  String get cpuScore => 'CPU Punktzahl';

  @override
  String get result => 'Ergebnis';

  @override
  String get bust => 'Überkauft!';

  @override
  String get wrongNumber => 'Falsche Zahl';

  @override
  String get youSuccessfullySortedAllNumbers =>
      'Du hast alle Zahlen erfolgreich sortiert!';

  @override
  String get youRememberedAllNumbers => 'Du hast alle Zahlen gemerkt!';

  @override
  String get youGuessedCorrectly => 'Du hast richtig geraten!';

  @override
  String get youWonTheGame => 'Du hast das Spiel gewonnen!';

  @override
  String get youReached21 => 'Du hast 21 erreicht!';

  @override
  String get youWentOver21 => 'Du hast 21 überschritten!';

  @override
  String get whyYouLost => 'Warum du verloren hast';

  @override
  String get sortLeaderboard => 'Bestenliste Sortieren';

  @override
  String get sortByName => 'Nach Name Sortieren';

  @override
  String get sortByDate => 'Nach Datum Sortieren';

  @override
  String get perfectTime => 'Perfekte Zeit!';

  @override
  String get goodTime => 'Gute Zeit!';

  @override
  String get averageTime => 'Durchschnittliche Zeit';

  @override
  String get slowTime => 'Langsame Zeit';

  @override
  String get verySlowTime => 'Sehr Langsame Zeit';

  @override
  String get patternMemory => 'Muster-Gedächtnis';

  @override
  String get patternMemoryDescription =>
      'Merke dir das Muster auf dem Bildschirm und wiederhole es. Das Muster wird mit jedem Level komplexer.';

  @override
  String get patternMemoryInstructions =>
      'Merke dir das Muster auf dem Bildschirm und wiederhole es. Das Muster wird mit jedem Level komplexer.';

  @override
  String get wrongPattern => 'Falsches Muster';

  @override
  String get level => 'Level';

  @override
  String get wrong => 'Falsch';

  @override
  String get row => 'Zeile';

  @override
  String get column => 'Spalte';
}
