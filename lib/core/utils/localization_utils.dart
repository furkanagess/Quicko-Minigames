import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../../l10n/app_localizations.dart';
import 'global_context.dart';

class LocalizationUtils {
  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'blind_sort': 'Blind Sort',
      'blind_sort_description':
          'Sort 10 numbers from 1-50. You lose if the new number doesn\'t fit anywhere!',
      'higher_lower': 'Higher or Lower',
      'higher_lower_description':
          'Guess if the next number will be higher or lower!',
      'color_hunt': 'Color Hunt',
      'color_hunt_description':
          'Find the target color! The text color might trick you!',
      'aim_trainer': 'Aim Trainer',
      'aim_trainer_description':
          'Try to shoot the randomly appearing red targets for 20 seconds. Each hit is 1 point!',
      'number_memory': 'Number Memory',
      'number_memory_description':
          'Memorize the sequence of numbers and enter it correctly using the keypad. How many digits can you remember?',
      'find_difference': 'Find the Difference',
      'find_difference_description':
          'Find the one square with a different color. It gets harder with each round!',
      'rock_paper_scissors': 'Rock-Paper-Scissors',
      'rock_paper_scissors_description':
          'Play against the computer. First to 5 points wins.',
      'twenty_one': '21 (Blackjack)',
      'twenty_one_description':
          'Beat the dealer to 21! Get as close as possible without going over.',
      'loadingFavorites': 'Loading Favorites...',
      'start': 'Start',
      'restart': 'Restart',
      'score': 'Score',
      'game_over': 'Game Over',
      'try_again': 'Try Again',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'close': 'Close',
      'you_won': 'You Won!',
      'congratulations_message':
          'Congratulations! You\'ve completed the challenge!',
      'final_score': 'Final Score',
      'excellent_performance': 'Excellent performance!',
      'play_again': 'Play Again',
      'time_up': 'Time\'s Up',
      'time_up_message': 'You ran out of time!',
      'time_ran_out': 'Time ran out!',
      'last_number': 'Last Number',
      'sort_by': 'Sort By',
      'sort_by_score': 'Sort by Score',
      'sort_by_date': 'Sort by Date',
      'sort_by_game': 'Sort by Game',
      'theme': 'Theme',
      'selectTheme': 'Select Theme',
      'lightTheme': 'Light Theme',
      'darkTheme': 'Dark Theme',
      'systemTheme': 'System Theme',
      'lightThemeDescription': 'Light colored theme',
      'darkThemeDescription': 'Dark colored theme',
      'systemThemeDescription': 'Theme based on system settings',
      'themeChangeInfo':
          'Theme changes will be applied immediately throughout the app.',
      'startGame': 'Start Game',
      'restartGame': 'Restart Game',
      'you': 'You',
      'cpu': 'CPU',
      'dealer': 'Dealer',
      'youWin': 'You Win!',
      'youLose': 'You Lose!',
      'tie': 'Tie!',
      'total': 'Total',
      'red': 'Red',
      'green': 'Green',
      'blue': 'Blue',
      'purple': 'Purple',
      'orange': 'Orange',
      'yellow': 'Yellow',
      'pink': 'Pink',
      'brown': 'Brown',
      'play': 'Play',
      'appSettings': 'App Settings',
      'customizeAppExperience': 'Customize your app experience',
      'settings': 'Settings',
      'hit': 'Hit',
      'stand': 'Stand',
      'reactionTime': 'Reaksiyon Süresi',
      'reactionTimeDescription':
          '1\'den 12\'ye kadar sayıları doğru sırayla mümkün olduğunca hızlı tıklayın. Süreniz ölçülecek (düşük olan daha iyi).',
      'time': 'Süre',
      'wrongSequence': 'Yanlış sıra!',
      'congratulations': 'Tebrikler!',
      'next': 'Sıradaki',
      'reactionTime': 'Reaction Time',
      'reactionTimeDescription':
          'Click the numbers from 1 to 12 in the correct order as fast as you can. Your time will be measured (lower is better).',
      'time': 'Time',
      'wrongSequence': 'Wrong sequence!',
      'congratulations': 'Congratulations!',
      'next': 'Next',
    },
    'tr': {
      'blind_sort': 'Kör Sıralama',
      'blind_sort_description':
          '1-50 arası 10 sayıyı sırala. Yeni sayı hiçbir yere sığmazsa kaybedersin!',
      'higher_lower': 'Yüksek mi Düşük mü',
      'higher_lower_description':
          'Bir sonraki sayının yüksek mi düşük mü olacağını tahmin et!',
      'color_hunt': 'Renk Avı',
      'color_hunt_description':
          'Hedef rengi bul! Metin rengi seni kandırabilir!',
      'aim_trainer': 'Nişan Antrenörü',
      'aim_trainer_description':
          'Rastgele beliren kırmızı hedefleri vurmaya çalış. Her vuruş 1 puan!',
      'number_memory': 'Sayı Hafızası',
      'number_memory_description':
          'Sayı dizisini ezberle ve tuş takımını kullanarak doğru gir. Kaç basamak hatırlayabilirsin?',
      'find_difference': 'Farkı Bul',
      'find_difference_description':
          'Farklı renkteki kareyi bul. Her turda zorlaşır!',
      'rock_paper_scissors': 'Taş-Kağıt-Makas',
      'rock_paper_scissors_description':
          'Bilgisayara karşı oyna. 5 puana ilk ulaşan kazanır.',
      'twenty_one': '21 (Blackjack)',
      'twenty_one_description':
          'Krupiyeyi 21\'de yen! Mümkün olduğunca yaklaş ama geçme.',
      'loadingFavorites': 'Favoriler Yükleniyor...',
      'start': 'Başla',
      'restart': 'Yeniden Başla',
      'score': 'Puan',
      'game_over': 'Oyun Bitti',
      'try_again': 'Tekrar Dene',
      'cancel': 'İptal',
      'confirm': 'Onayla',
      'close': 'Kapat',
      'you_won': 'Kazandın!',
      'congratulations_message': 'Tebrikler! Meydan okumayı tamamladın!',
      'final_score': 'Final Skoru',
      'excellent_performance': 'Mükemmel performans!',
      'play_again': 'Tekrar Oyna',
      'time_up': 'Süre Doldu',
      'time_up_message': 'Süren doldu!',
      'time_ran_out': 'Süre doldu!',
      'last_number': 'Son Sayı',
      'sort_by': 'Sırala',
      'sort_by_score': 'Puana Göre Sırala',
      'sort_by_date': 'Tarihe Göre Sırala',
      'sort_by_game': 'Oyuna Göre Sırala',
      'theme': 'Tema',
      'selectTheme': 'Tema Seç',
      'lightTheme': 'Açık Tema',
      'darkTheme': 'Koyu Tema',
      'systemTheme': 'Sistem Teması',
      'lightThemeDescription': 'Açık renkli tema',
      'darkThemeDescription': 'Koyu renkli tema',
      'systemThemeDescription': 'Sistem ayarlarına göre tema',
      'themeChangeInfo':
          'Tema değişiklikleri uygulama genelinde hemen uygulanacaktır.',
      'startGame': 'Oyunu Başlat',
      'restartGame': 'Oyunu Yeniden Başlat',
      'you': 'Sen',
      'cpu': 'Bilgisayar',
      'dealer': 'Krupiye',
      'youWin': 'Kazandın!',
      'youLose': 'Kaybettin!',
      'tie': 'Berabere!',
      'total': 'Toplam',
      'red': 'Kırmızı',
      'green': 'Yeşil',
      'blue': 'Mavi',
      'purple': 'Mor',
      'orange': 'Turuncu',
      'yellow': 'Sarı',
      'pink': 'Pembe',
      'brown': 'Kahverengi',
      'play': 'Oyna',
      'appSettings': 'Uygulama Ayarları',
      'customizeAppExperience': 'Uygulama deneyiminizi özelleştirin',
      'settings': 'Ayarlar',
      'hit': 'Kart Çek',
      'stand': 'Kal',
      'reactionTime': 'Reaksiyon Süresi',
      'reactionTimeDescription':
          '1\'den 12\'ye kadar sayıları doğru sırayla mümkün olduğunca hızlı tıklayın. Süreniz ölçülecek (düşük olan daha iyi).',
      'time': 'Süre',
      'wrongSequence': 'Yanlış sıra!',
      'congratulations': 'Tebrikler!',
      'next': 'Sıradaki',
    },
  };

  /// Get localized string without context
  static String getString(String key, {String? languageCode}) {
    final lang = languageCode ?? _getCurrentLanguageCode();
    return _localizedStrings[lang]?[key] ?? key;
  }

  /// Get current language code from provider if available
  static String _getCurrentLanguageCode() {
    try {
      final context = GlobalContext.context;
      if (context != null) {
        final languageProvider = Provider.of<LanguageProvider>(
          context,
          listen: false,
        );
        return languageProvider.languageCode;
      }
    } catch (e) {
      // Fallback to default
    }
    return 'en'; // Default fallback
  }

  /// Get localized string with context (preferred method when context is available)
  static String getStringWithContext(BuildContext context, String key) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        // Map the key to the appropriate getter
        switch (key) {
          case 'blind_sort':
            return localizations.blindSort;
          case 'blind_sort_description':
            return localizations.blindSortDescription;
          case 'higher_lower':
            return localizations.higherLower;
          case 'higher_lower_description':
            return localizations.higherLowerDescription;
          case 'color_hunt':
            return localizations.colorHunt;
          case 'color_hunt_description':
            return localizations.colorHuntDescription;
          case 'aim_trainer':
            return localizations.aimTrainer;
          case 'aim_trainer_description':
            return localizations.aimTrainerDescription;
          case 'number_memory':
            return localizations.numberMemory;
          case 'number_memory_description':
            return localizations.numberMemoryDescription;
          case 'find_difference':
            return localizations.findDifference;
          case 'find_difference_description':
            return localizations.findDifferenceDescription;
          case 'rock_paper_scissors':
            return localizations.rockPaperScissors;
          case 'rock_paper_scissors_description':
            return localizations.rockPaperScissorsDescription;
          case 'twenty_one':
            return localizations.twentyOne;
          case 'twenty_one_description':
            return localizations.twentyOneDescription;
          case 'loadingFavorites':
            return localizations.loadingFavorites;
          case 'start':
            return localizations.start;
          case 'restart':
            return localizations.restart;
          case 'score':
            return localizations.score;
          case 'game_over':
            return localizations.gameOver;
          case 'try_again':
            return localizations.tryAgain;
          case 'cancel':
            return localizations.cancel;
          case 'confirm':
            return localizations.confirm;
          case 'close':
            return localizations.close;
          case 'you_won':
            return localizations.youWon;
          case 'congratulations_message':
            return localizations.congratulationsMessage;
          case 'final_score':
            return localizations.finalScore;
          case 'excellent_performance':
            return localizations.excellentPerformance;
          case 'play_again':
            return localizations.playAgain;
          case 'time_up':
            return localizations.timeUp;
          case 'time_up_message':
            return localizations.timeUpMessage;
          case 'time_ran_out':
            return localizations.timeRanOut;
          case 'last_number':
            return localizations.lastNumber;
          case 'sort_by':
            return localizations.sortBy;
          case 'sort_by_score':
            return localizations.sortByScore;
          case 'sort_by_date':
            return localizations.sortByLastPlayed;
          case 'sort_by_game':
            return localizations.sortBy;
          case 'theme':
            return localizations.theme;
          case 'selectTheme':
            return localizations.selectTheme;
          case 'lightTheme':
            return localizations.lightTheme;
          case 'darkTheme':
            return localizations.darkTheme;
          case 'systemTheme':
            return localizations.systemTheme;
          case 'lightThemeDescription':
            return localizations.lightThemeDescription;
          case 'darkThemeDescription':
            return localizations.darkThemeDescription;
          case 'systemThemeDescription':
            return localizations.systemThemeDescription;
          case 'themeChangeInfo':
            return localizations.themeChangeInfo;
          case 'startGame':
            return localizations.startGame;
          case 'restartGame':
            return localizations.restartGame;
          case 'you':
            return localizations.you;
          case 'cpu':
            return localizations.cpu;
          case 'dealer':
            return localizations.dealer;
          case 'youWin':
            return localizations.youWin;
          case 'youLose':
            return localizations.youLose;
          case 'tie':
            return localizations.tie;
          case 'total':
            return localizations.total;
          case 'red':
            return localizations.red;
          case 'green':
            return localizations.green;
          case 'blue':
            return localizations.blue;
          case 'purple':
            return localizations.purple;
          case 'orange':
            return localizations.orange;
          case 'yellow':
            return localizations.yellow;
          case 'pink':
            return localizations.pink;
          case 'brown':
            return localizations.brown;
          case 'play':
            return localizations.play;
          case 'appSettings':
            return localizations.appSettings;
          case 'customizeAppExperience':
            return localizations.customizeAppExperience;
          case 'settings':
            return localizations.settings;
          case 'hit':
            return localizations.hit;
          case 'stand':
            return localizations.stand;
          case 'reactionTime':
            return localizations.reactionTime;
          case 'reactionTimeDescription':
            return localizations.reactionTimeDescription;
          case 'time':
            return localizations.time;
          case 'wrongSequence':
            return localizations.wrongSequence;
          case 'congratulations':
            return localizations.congratulations;
          case 'next':
            return localizations.next;
          case 'betterLuckNextTime':
            return localizations.betterLuckNextTime;
          case 'whyYouLost':
            return localizations.whyYouLost;
          case 'youWonTheGame':
            return localizations.youWonTheGame;
          case 'youSuccessfullySortedAllNumbers':
            return localizations.youSuccessfullySortedAllNumbers;
          case 'youGuessedCorrectly':
            return localizations.youGuessedCorrectly;
          case 'missionFailed':
            return localizations.missionFailed;
          case 'greenTargetHit':
            return localizations.greenTargetHit;
          case 'youHitAllTargets':
            return localizations.youHitAllTargets;
          case 'youFoundAllColors':
            return localizations.youFoundAllColors;
          case 'wrongColorSelection':
            return localizations.wrongColorSelection;
          case 'youRememberedAllNumbers':
            return localizations.youRememberedAllNumbers;
          case 'youReached21':
            return localizations.youReached21;
          case 'youWentOver21':
            return localizations.youWentOver21;
          case 'civilianHit':
            return localizations.civilianHit;
          case 'perfectTime':
            return localizations.perfectTime;
          case 'goodTime':
            return localizations.goodTime;
          case 'averageTime':
            return localizations.averageTime;
          case 'slowTime':
            return localizations.slowTime;
          case 'verySlowTime':
            return localizations.verySlowTime;
          case 'wrongNumber':
            return localizations.wrongNumber;
          case 'gameOver':
            return localizations.gameOver;
          default:
            return getString(key);
        }
      }
    } catch (e) {
      // Fallback to static method
    }
    return getString(key);
  }

  /// Get localized string using global context (for use in providers)
  static String getStringGlobal(String key) {
    final context = GlobalContext.context;
    if (context != null) {
      return getStringWithContext(context, key);
    }
    return getString(key);
  }
}
