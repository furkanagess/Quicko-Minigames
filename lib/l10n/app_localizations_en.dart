// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Quicko';

  @override
  String get blindSort => 'Blind Sort';

  @override
  String get blindSortDescription =>
      'Sort 10 numbers from 1-50. You lose if the new number doesn\'t fit anywhere!';

  @override
  String get nextNumber => 'Next Number';

  @override
  String get newNumberComing => 'New Number Coming...';

  @override
  String get start => 'Start';

  @override
  String get restart => 'Restart';

  @override
  String get home => 'Home';

  @override
  String get games => 'Games';

  @override
  String get score => 'Score';

  @override
  String get gameOver => 'Game Over';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get share => 'Share';

  @override
  String get confirm => 'Confirm';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get higherLower => 'Higher or Lower';

  @override
  String get higherLowerDescription =>
      'Guess if the next number will be higher or lower!';

  @override
  String get higher => 'Higher';

  @override
  String get lower => 'Lower';

  @override
  String get lastNumber => 'Last Number';

  @override
  String get completedAllTargets => 'Completed all targets!';

  @override
  String get targets => 'Targets';

  @override
  String get continueGame => 'Continue Game';

  @override
  String get watchAdToContinue => 'Watch Ad to Continue';

  @override
  String get adNotAvailable => 'Ad Not Available';

  @override
  String get adNotAvailableMessage =>
      'No ads are currently available. Please try again later.';

  @override
  String get adFailed => 'Ad Failed';

  @override
  String get adFailedMessage => 'Failed to show ad. Please try again.';

  @override
  String get ok => 'OK';

  @override
  String get exit => 'Exit';

  @override
  String get andMore => 'and more...';

  @override
  String get missionFailed => 'Mission Failed!';

  @override
  String get greenTargetHit => 'Green target hit!';

  @override
  String get youHitAllTargets => 'You hit all targets!';

  @override
  String get timeRanOut => 'Time ran out!';

  @override
  String get targetsHit => 'Targets Hit';

  @override
  String get mistake => 'Mistake';

  @override
  String get civilianHit => 'Civilian Hit';

  @override
  String get youFoundAllColors => 'You found all colors!';

  @override
  String get colorsFound => 'Colors Found';

  @override
  String get lastMistake => 'Last Mistake';

  @override
  String get wrongColor => 'Wrong Color';

  @override
  String get currentNumber => 'Current Number';

  @override
  String get close => 'Close';

  @override
  String get betterLuckNextTime => 'Better luck next time!';

  @override
  String get losingNumbers => 'Numbers That Caused Loss';

  @override
  String get losingNumber => 'Number That Caused Loss';

  @override
  String get colorHunt => 'Color Hunt';

  @override
  String get colorHuntDescription =>
      'Find the target color! The text color might trick you!';

  @override
  String get target => 'Target';

  @override
  String get time => 'Time';

  @override
  String get wrongColorSelected => 'Wrong Color Selected';

  @override
  String get wrongColorSelection => 'Wrong Color Selection';

  @override
  String get favorites => 'Favorites';

  @override
  String get loadingFavorites => 'Loading Favorites...';

  @override
  String get noFavoritesYet => 'No Favorites Yet';

  @override
  String get addGamesToFavorites => 'Add games to favorites for quick access';

  @override
  String get browseGames => 'Browse Games';

  @override
  String get aimTrainer => 'Aim Trainer';

  @override
  String get aimTrainerDescription =>
      'Try to shoot the randomly appearing red targets for 20 seconds. Each hit is 1 point!';

  @override
  String get numberMemory => 'Number Memory';

  @override
  String get numberMemoryDescription =>
      'Memorize the sequence of numbers and enter it correctly using the keypad. How many digits can you remember?';

  @override
  String get findDifference => 'Find the Difference';

  @override
  String get findDifferenceDescription =>
      'Find the one square with a different color. It gets harder with each round!';

  @override
  String get rockPaperScissors => 'Rock-Paper-Scissors';

  @override
  String get rockPaperScissorsDescription =>
      'Play against the computer. First to 5 points wins.';

  @override
  String get twentyOne => '21 (Blackjack)';

  @override
  String get twentyOneDescription =>
      'Beat the dealer to 21! Get as close as possible without going over.';

  @override
  String get nowYourTurn => 'Now, your turn!';

  @override
  String get correct => 'Correct!';

  @override
  String get playing => 'Playing';

  @override
  String youReachedLevel(int level) {
    return 'You reached Level $level';
  }

  @override
  String get tapToStartGuessing =>
      'Tap Higher or Lower to start guessing! Numbers are between 1-50.';

  @override
  String get numbersBetween1And50 => 'Numbers are between 1-50';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get noLeaderboardData => 'No Leaderboard Data';

  @override
  String get playGamesToSeeScores => 'Play games to see your high scores here!';

  @override
  String get playGames => 'Play Games';

  @override
  String get swipeToDeleteHint => 'Swipe left to delete high scores';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get removeAdsDescription =>
      'Enjoy an ad-free experience with monthly subscription';

  @override
  String get monthlySubscription => 'Monthly Subscription';

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get subscriptionActive => 'Subscription Active';

  @override
  String get subscriptionExpired => 'Subscription Expired';

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get purchaseSuccess => 'Purchase Successful!';

  @override
  String get purchaseError => 'Purchase Failed';

  @override
  String get restoreSuccess => 'Purchases Restored!';

  @override
  String get restoreError => 'Restore Failed';

  @override
  String get totalGames => 'Total Games';

  @override
  String get highestScore => 'Highest Score';

  @override
  String get averageScore => 'Average Score';

  @override
  String highScore(int score) {
    return 'High Score: $score';
  }

  @override
  String lastPlayed(String date) {
    return 'Last Played: $date';
  }

  @override
  String get sortBy => 'Sort By';

  @override
  String get sortByScore => 'Sort by Score';

  @override
  String get sortByLastPlayed => 'Sort by Last Played';

  @override
  String get shareAchievements => 'Share Achievements';

  @override
  String get previewImage => 'Preview Image';

  @override
  String get shareImage => 'Share Image';

  @override
  String get shareNoData => 'No data to share yet. Play some games first!';

  @override
  String get shareError => 'Error sharing achievements. Please try again.';

  @override
  String get timeUp => 'Time\'s Up';

  @override
  String get timeUpMessage => 'You ran out of time!';

  @override
  String get finalScore => 'Final Score';

  @override
  String get youWon => 'You Won!';

  @override
  String get congratulationsMessage =>
      'Congratulations! You\'ve completed the challenge!';

  @override
  String get excellentPerformance => 'Excellent performance!';

  @override
  String get playAgain => 'Play Again';

  @override
  String get deleteHighScore => 'Delete High Score';

  @override
  String get deleteHighScoreMessage =>
      'Are you sure you want to delete the high score for this game?';

  @override
  String get delete => 'Delete';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChangeInfo =>
      'Language changes will be applied immediately. The app will restart to apply the new language.';

  @override
  String get choosePreferredLanguage => 'Choose your preferred language';

  @override
  String get sort_by_date => 'Sort by Date';

  @override
  String get sort_by_game => 'Sort by Game';

  @override
  String get theme => 'Theme';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get lightThemeDescription => 'Light theme for bright environments';

  @override
  String get darkThemeDescription => 'Dark theme for low-light environments';

  @override
  String get systemThemeDescription => 'Follows your device theme setting';

  @override
  String get themeChangeInfo =>
      'Theme changes will be applied immediately throughout the app.';

  @override
  String get choosePreferredTheme => 'Choose your preferred theme';

  @override
  String get startGame => 'Start Game';

  @override
  String get restartGame => 'Restart Game';

  @override
  String get you => 'You';

  @override
  String get cpu => 'CPU';

  @override
  String get dealer => 'Dealer';

  @override
  String get youWin => 'You Win!';

  @override
  String get youLose => 'You Lose!';

  @override
  String get tie => 'Tie!';

  @override
  String get total => 'Total';

  @override
  String get red => 'Red';

  @override
  String get green => 'Green';

  @override
  String get blue => 'Blue';

  @override
  String get purple => 'Purple';

  @override
  String get orange => 'Orange';

  @override
  String get yellow => 'Yellow';

  @override
  String get pink => 'Pink';

  @override
  String get brown => 'Brown';

  @override
  String get play => 'Play';

  @override
  String get appSettings => 'App Settings';

  @override
  String get customizeAppExperience => 'Customize your app experience';

  @override
  String get settings => 'Settings';

  @override
  String get hit => 'Hit';

  @override
  String get stand => 'Stand';

  @override
  String get reactionTime => 'Reaction Time';

  @override
  String get reactionTimeDescription =>
      'Click the numbers from 1 to 12 in the correct order as fast as you can. Your time will be measured (lower is better).';

  @override
  String get wrongSequence => 'Wrong sequence!';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get next => 'Next';

  @override
  String get numbersSorted => 'Numbers Sorted';

  @override
  String get numbersRemembered => 'Numbers Remembered';

  @override
  String get correctGuesses => 'Correct Guesses';

  @override
  String get yourScore => 'Your Score';

  @override
  String get cpuScore => 'CPU Score';

  @override
  String get result => 'Result';

  @override
  String get bust => 'Bust!';

  @override
  String get wrongNumber => 'Wrong Number';

  @override
  String get youSuccessfullySortedAllNumbers =>
      'You successfully sorted all numbers!';

  @override
  String get youRememberedAllNumbers => 'You remembered all numbers!';

  @override
  String get youGuessedCorrectly => 'You guessed correctly!';

  @override
  String get youWonTheGame => 'You won the game!';

  @override
  String get youReached21 => 'You reached 21!';

  @override
  String get youWentOver21 => 'You went over 21!';

  @override
  String get whyYouLost => 'Why you lost';

  @override
  String get sortLeaderboard => 'Sort Leaderboard';

  @override
  String get sortByName => 'Sort by Name';

  @override
  String get sortByDate => 'Sort by Date';

  @override
  String get perfectTime => 'Perfect Time!';

  @override
  String get goodTime => 'Good Time!';

  @override
  String get averageTime => 'Average Time';

  @override
  String get slowTime => 'Slow Time';

  @override
  String get verySlowTime => 'Very Slow Time';

  @override
  String get patternMemory => 'Pattern Memory';

  @override
  String get patternMemoryDescription =>
      'Memorize the pattern on the screen and replicate it. The pattern gets more complex with each level.';

  @override
  String get patternMemoryInstructions =>
      'Memorize the pattern on the screen and replicate it. The pattern gets more complex with each level.';

  @override
  String get wrongPattern => 'Wrong Pattern';

  @override
  String get level => 'Level';

  @override
  String get wrong => 'Wrong';

  @override
  String get row => 'row';

  @override
  String get column => 'column';
}
