import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
    Locale('es'),
    Locale('pt', 'br'),
    Locale('ar'),
    Locale('de'),
    Locale('fr'),
    Locale('id'),
    Locale('hi'),
    Locale('az'),
    Locale('it'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Quicko'**
  String get appName;

  /// Title for the Blind Sort game
  ///
  /// In en, this message translates to:
  /// **'Blind Sort'**
  String get blindSort;

  /// Description for the Blind Sort game
  ///
  /// In en, this message translates to:
  /// **'Sort 10 numbers from 1-50. You lose if the new number doesn\'t fit anywhere!'**
  String get blindSortDescription;

  /// Label for the next number in Blind Sort
  ///
  /// In en, this message translates to:
  /// **'Next Number'**
  String get nextNumber;

  /// Message when a new number is about to appear
  ///
  /// In en, this message translates to:
  /// **'New Number Coming...'**
  String get newNumberComing;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Restart button text
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Games navigation label
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// Score label
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Game over message
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Fullscreen button text
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Title for the Higher or Lower game
  ///
  /// In en, this message translates to:
  /// **'Higher or Lower'**
  String get higherLower;

  /// Description for the Higher or Lower game
  ///
  /// In en, this message translates to:
  /// **'Guess if the next number will be higher or lower!'**
  String get higherLowerDescription;

  /// Higher button text
  ///
  /// In en, this message translates to:
  /// **'Higher'**
  String get higher;

  /// Lower button text
  ///
  /// In en, this message translates to:
  /// **'Lower'**
  String get lower;

  /// Label for the last number
  ///
  /// In en, this message translates to:
  /// **'Last Number'**
  String get lastNumber;

  /// Message when all targets are completed
  ///
  /// In en, this message translates to:
  /// **'Completed all targets!'**
  String get completedAllTargets;

  /// Label for targets
  ///
  /// In en, this message translates to:
  /// **'Targets'**
  String get targets;

  /// Continue game dialog title
  ///
  /// In en, this message translates to:
  /// **'Continue Game'**
  String get continueGame;

  /// Watch ad to continue button text
  ///
  /// In en, this message translates to:
  /// **'Watch Ad to Continue'**
  String get watchAdToContinue;

  /// Ad not available dialog title
  ///
  /// In en, this message translates to:
  /// **'Ad Not Available'**
  String get adNotAvailable;

  /// Ad not available message
  ///
  /// In en, this message translates to:
  /// **'No ads are currently available. Please try again later.'**
  String get adNotAvailableMessage;

  /// Ad failed dialog title
  ///
  /// In en, this message translates to:
  /// **'Ad Failed'**
  String get adFailed;

  /// Ad failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to show ad. Please try again.'**
  String get adFailedMessage;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Exit button text
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Text shown when there are more items to display
  ///
  /// In en, this message translates to:
  /// **'and more...'**
  String get andMore;

  /// Mission failed message
  ///
  /// In en, this message translates to:
  /// **'Mission Failed!'**
  String get missionFailed;

  /// Green target hit message
  ///
  /// In en, this message translates to:
  /// **'Green target hit!'**
  String get greenTargetHit;

  /// All targets hit message
  ///
  /// In en, this message translates to:
  /// **'You hit all targets!'**
  String get youHitAllTargets;

  /// Message indicating time ran out
  ///
  /// In en, this message translates to:
  /// **'Time ran out!'**
  String get timeRanOut;

  /// Targets hit label
  ///
  /// In en, this message translates to:
  /// **'Targets Hit'**
  String get targetsHit;

  /// Mistake label
  ///
  /// In en, this message translates to:
  /// **'Mistake'**
  String get mistake;

  /// Civilian hit message
  ///
  /// In en, this message translates to:
  /// **'Civilian Hit'**
  String get civilianHit;

  /// All colors found message
  ///
  /// In en, this message translates to:
  /// **'You found all colors!'**
  String get youFoundAllColors;

  /// Colors found label
  ///
  /// In en, this message translates to:
  /// **'Colors Found'**
  String get colorsFound;

  /// Last mistake label
  ///
  /// In en, this message translates to:
  /// **'Last Mistake'**
  String get lastMistake;

  /// Wrong color message
  ///
  /// In en, this message translates to:
  /// **'Wrong Color'**
  String get wrongColor;

  /// Label for the current number
  ///
  /// In en, this message translates to:
  /// **'Current Number'**
  String get currentNumber;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Message shown when player loses
  ///
  /// In en, this message translates to:
  /// **'Better luck next time!'**
  String get betterLuckNextTime;

  /// Title for losing numbers section
  ///
  /// In en, this message translates to:
  /// **'Numbers That Caused Loss'**
  String get losingNumbers;

  /// Label for the number that caused loss
  ///
  /// In en, this message translates to:
  /// **'Number That Caused Loss'**
  String get losingNumber;

  /// Title for the Color Hunt game
  ///
  /// In en, this message translates to:
  /// **'Color Hunt'**
  String get colorHunt;

  /// Description for the Color Hunt game
  ///
  /// In en, this message translates to:
  /// **'Find the target color! The text color might trick you!'**
  String get colorHuntDescription;

  /// Target label
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Message when wrong color is selected
  ///
  /// In en, this message translates to:
  /// **'Wrong Color Selected'**
  String get wrongColorSelected;

  /// Message when player loses due to wrong color selection
  ///
  /// In en, this message translates to:
  /// **'Wrong Color Selection'**
  String get wrongColorSelection;

  /// Favorites navigation label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Message when loading favorites
  ///
  /// In en, this message translates to:
  /// **'Loading Favorites...'**
  String get loadingFavorites;

  /// Message when no favorites exist
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavoritesYet;

  /// Instruction to add games to favorites
  ///
  /// In en, this message translates to:
  /// **'Add games to favorites for quick access'**
  String get addGamesToFavorites;

  /// Browse games button text
  ///
  /// In en, this message translates to:
  /// **'Browse Games'**
  String get browseGames;

  /// Title for the Aim Trainer game
  ///
  /// In en, this message translates to:
  /// **'Aim Trainer'**
  String get aimTrainer;

  /// Description for the Aim Trainer game
  ///
  /// In en, this message translates to:
  /// **'Try to shoot the randomly appearing red targets for 20 seconds. Each hit is 1 point!'**
  String get aimTrainerDescription;

  /// Title for the Number Memory game
  ///
  /// In en, this message translates to:
  /// **'Number Memory'**
  String get numberMemory;

  /// Description for the Number Memory game
  ///
  /// In en, this message translates to:
  /// **'Memorize the sequence of numbers and enter it correctly using the keypad. How many digits can you remember?'**
  String get numberMemoryDescription;

  /// Title for the Find the Difference game
  ///
  /// In en, this message translates to:
  /// **'Find the Difference'**
  String get findDifference;

  /// Description for the Find the Difference game
  ///
  /// In en, this message translates to:
  /// **'Find the one square with a different color. It gets harder with each round!'**
  String get findDifferenceDescription;

  /// Title for the Rock-Paper-Scissors game
  ///
  /// In en, this message translates to:
  /// **'Rock-Paper-Scissors'**
  String get rockPaperScissors;

  /// Description for the Rock-Paper-Scissors game
  ///
  /// In en, this message translates to:
  /// **'Play against the computer. First to 5 points wins.'**
  String get rockPaperScissorsDescription;

  /// Title for the 21 (Blackjack) game
  ///
  /// In en, this message translates to:
  /// **'21 (Blackjack)'**
  String get twentyOne;

  /// Description for the 21 (Blackjack) game
  ///
  /// In en, this message translates to:
  /// **'Beat the dealer to 21! Get as close as possible without going over.'**
  String get twentyOneDescription;

  /// Message indicating it's the player's turn
  ///
  /// In en, this message translates to:
  /// **'Now, your turn!'**
  String get nowYourTurn;

  /// Message when answer is correct
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// Playing status label
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playing;

  /// Message when player reaches a new level
  ///
  /// In en, this message translates to:
  /// **'You reached Level {level}'**
  String youReachedLevel(int level);

  /// Instruction to start guessing in Higher or Lower
  ///
  /// In en, this message translates to:
  /// **'Tap Higher or Lower to start guessing! Numbers are between 1-50.'**
  String get tapToStartGuessing;

  /// Information about number range
  ///
  /// In en, this message translates to:
  /// **'Numbers are between 1-50'**
  String get numbersBetween1And50;

  /// Leaderboard navigation label
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// Message when no leaderboard data exists
  ///
  /// In en, this message translates to:
  /// **'No Leaderboard Data'**
  String get noLeaderboardData;

  /// Instruction to play games to see scores
  ///
  /// In en, this message translates to:
  /// **'Play games to see your high scores here!'**
  String get playGamesToSeeScores;

  /// Play games button text
  ///
  /// In en, this message translates to:
  /// **'Play Games'**
  String get playGames;

  /// Total games label
  ///
  /// In en, this message translates to:
  /// **'Total Games'**
  String get totalGames;

  /// Highest score label
  ///
  /// In en, this message translates to:
  /// **'Highest Score'**
  String get highestScore;

  /// Average score label
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get averageScore;

  /// High score display with score value
  ///
  /// In en, this message translates to:
  /// **'High Score: {score}'**
  String highScore(int score);

  /// Last played date display
  ///
  /// In en, this message translates to:
  /// **'Last Played: {date}'**
  String lastPlayed(String date);

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// Sort by score option
  ///
  /// In en, this message translates to:
  /// **'Sort by Score'**
  String get sortByScore;

  /// Sort by last played option
  ///
  /// In en, this message translates to:
  /// **'Sort by Last Played'**
  String get sortByLastPlayed;

  /// Share achievements button text
  ///
  /// In en, this message translates to:
  /// **'Share Achievements'**
  String get shareAchievements;

  /// Preview image button text
  ///
  /// In en, this message translates to:
  /// **'Preview Image'**
  String get previewImage;

  /// Share image button text
  ///
  /// In en, this message translates to:
  /// **'Share Image'**
  String get shareImage;

  /// Message when no data is available to share
  ///
  /// In en, this message translates to:
  /// **'No data to share yet. Play some games first!'**
  String get shareNoData;

  /// Error message when sharing fails
  ///
  /// In en, this message translates to:
  /// **'Error sharing achievements. Please try again.'**
  String get shareError;

  /// Time up message
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up'**
  String get timeUp;

  /// Message when time runs out
  ///
  /// In en, this message translates to:
  /// **'You ran out of time!'**
  String get timeUpMessage;

  /// Label for final score in 21 game
  ///
  /// In en, this message translates to:
  /// **'Final Score'**
  String get finalScore;

  /// You won message
  ///
  /// In en, this message translates to:
  /// **'You Won!'**
  String get youWon;

  /// Congratulations message for winning
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve completed the challenge!'**
  String get congratulationsMessage;

  /// Message for excellent performance
  ///
  /// In en, this message translates to:
  /// **'Excellent performance!'**
  String get excellentPerformance;

  /// Play again button text
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Delete high score dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete High Score'**
  String get deleteHighScore;

  /// Delete high score confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the high score for this game?'**
  String get deleteHighScoreMessage;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Language settings title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language prompt
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Information about language change
  ///
  /// In en, this message translates to:
  /// **'Language changes will be applied immediately. The app will restart to apply the new language.'**
  String get languageChangeInfo;

  /// Text for language selection prompt
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get choosePreferredLanguage;

  /// Sort by date option
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sort_by_date;

  /// Sort by game option
  ///
  /// In en, this message translates to:
  /// **'Sort by Game'**
  String get sort_by_game;

  /// Theme settings title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Select theme prompt
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// Light theme description
  ///
  /// In en, this message translates to:
  /// **'Light theme for bright environments'**
  String get lightThemeDescription;

  /// Dark theme description
  ///
  /// In en, this message translates to:
  /// **'Dark theme for low-light environments'**
  String get darkThemeDescription;

  /// System theme description
  ///
  /// In en, this message translates to:
  /// **'Follows your device theme setting'**
  String get systemThemeDescription;

  /// Information about theme changes
  ///
  /// In en, this message translates to:
  /// **'Theme changes will be applied immediately throughout the app.'**
  String get themeChangeInfo;

  /// Text for theme selection prompt
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get choosePreferredTheme;

  /// Start game button text
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// Restart game button text
  ///
  /// In en, this message translates to:
  /// **'Restart Game'**
  String get restartGame;

  /// Player label
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Computer opponent label
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get cpu;

  /// Dealer label for card games
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get dealer;

  /// Win message
  ///
  /// In en, this message translates to:
  /// **'You Win!'**
  String get youWin;

  /// Lose message
  ///
  /// In en, this message translates to:
  /// **'You Lose!'**
  String get youLose;

  /// Tie message
  ///
  /// In en, this message translates to:
  /// **'Tie!'**
  String get tie;

  /// Total score label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Red color name
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// Green color name
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// Blue color name
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// Purple color name
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// Orange color name
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// Yellow color name
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get yellow;

  /// Pink color name
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// Brown color name
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get brown;

  /// Play button text
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// App settings title
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// App settings description
  ///
  /// In en, this message translates to:
  /// **'Customize your app experience'**
  String get customizeAppExperience;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Hit button text for 21 game
  ///
  /// In en, this message translates to:
  /// **'Hit'**
  String get hit;

  /// Stand button text for 21 game
  ///
  /// In en, this message translates to:
  /// **'Stand'**
  String get stand;

  /// Title for the Reaction Time game
  ///
  /// In en, this message translates to:
  /// **'Reaction Time'**
  String get reactionTime;

  /// Description for the Reaction Time game
  ///
  /// In en, this message translates to:
  /// **'Click the numbers from 1 to 12 in the correct order as fast as you can. Your time will be measured (lower is better).'**
  String get reactionTimeDescription;

  /// Wrong sequence message for reaction time game
  ///
  /// In en, this message translates to:
  /// **'Wrong sequence!'**
  String get wrongSequence;

  /// Congratulations message for winning games
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// Next label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Label for numbers sorted in Blind Sort game
  ///
  /// In en, this message translates to:
  /// **'Numbers Sorted'**
  String get numbersSorted;

  /// Label for numbers remembered in Number Memory game
  ///
  /// In en, this message translates to:
  /// **'Numbers Remembered'**
  String get numbersRemembered;

  /// Label for correct guesses in Higher Lower game
  ///
  /// In en, this message translates to:
  /// **'Correct Guesses'**
  String get correctGuesses;

  /// Label for player score in RPS game
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// Label for CPU score in RPS game
  ///
  /// In en, this message translates to:
  /// **'CPU Score'**
  String get cpuScore;

  /// Label for result in 21 game
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// Message when player goes over 21
  ///
  /// In en, this message translates to:
  /// **'Bust!'**
  String get bust;

  /// Message for wrong number in Number Memory
  ///
  /// In en, this message translates to:
  /// **'Wrong Number'**
  String get wrongNumber;

  /// Success message for Blind Sort game
  ///
  /// In en, this message translates to:
  /// **'You successfully sorted all numbers!'**
  String get youSuccessfullySortedAllNumbers;

  /// Success message for Number Memory game
  ///
  /// In en, this message translates to:
  /// **'You remembered all numbers!'**
  String get youRememberedAllNumbers;

  /// Success message for Higher Lower game
  ///
  /// In en, this message translates to:
  /// **'You guessed correctly!'**
  String get youGuessedCorrectly;

  /// Success message for RPS game
  ///
  /// In en, this message translates to:
  /// **'You won the game!'**
  String get youWonTheGame;

  /// Success message for 21 game
  ///
  /// In en, this message translates to:
  /// **'You reached 21!'**
  String get youReached21;

  /// Failure message for 21 game
  ///
  /// In en, this message translates to:
  /// **'You went over 21!'**
  String get youWentOver21;

  /// Label for loss reason section
  ///
  /// In en, this message translates to:
  /// **'Why you lost'**
  String get whyYouLost;

  /// Title for sort leaderboard dialog
  ///
  /// In en, this message translates to:
  /// **'Sort Leaderboard'**
  String get sortLeaderboard;

  /// Sort by name option
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get sortByName;

  /// Sort by date option
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// Message for perfect completion time
  ///
  /// In en, this message translates to:
  /// **'Perfect Time!'**
  String get perfectTime;

  /// Message for good completion time
  ///
  /// In en, this message translates to:
  /// **'Good Time!'**
  String get goodTime;

  /// Message for average completion time
  ///
  /// In en, this message translates to:
  /// **'Average Time'**
  String get averageTime;

  /// Message for slow completion time
  ///
  /// In en, this message translates to:
  /// **'Slow Time'**
  String get slowTime;

  /// Message for very slow completion time
  ///
  /// In en, this message translates to:
  /// **'Very Slow Time'**
  String get verySlowTime;

  /// Title for the Pattern Memory game
  ///
  /// In en, this message translates to:
  /// **'Pattern Memory'**
  String get patternMemory;

  /// Description for the Pattern Memory game
  ///
  /// In en, this message translates to:
  /// **'Memorize the pattern on the screen and replicate it. The pattern gets more complex with each level.'**
  String get patternMemoryDescription;

  /// Instructions for the Pattern Memory game
  ///
  /// In en, this message translates to:
  /// **'Memorize the pattern on the screen and replicate it. The pattern gets more complex with each level.'**
  String get patternMemoryInstructions;

  /// Message when wrong pattern is selected
  ///
  /// In en, this message translates to:
  /// **'Wrong Pattern'**
  String get wrongPattern;

  /// Level label
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Wrong message
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrong;

  /// Row label for accessibility
  ///
  /// In en, this message translates to:
  /// **'row'**
  String get row;

  /// Column label for accessibility
  ///
  /// In en, this message translates to:
  /// **'column'**
  String get column;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'az',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'az':
      return AppLocalizationsAz();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
