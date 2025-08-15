// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Quicko';

  @override
  String get blindSort => 'Kör Sıralama';

  @override
  String get blindSortDescription =>
      '1-50 arası 10 sayıyı sıralayın. Yeni sayı hiçbir yere sığmazsa kaybedersiniz!';

  @override
  String get nextNumber => 'Sonraki Sayı';

  @override
  String get newNumberComing => 'Yeni Sayı Geliyor...';

  @override
  String get start => 'Başla';

  @override
  String get restart => 'Yeniden Başla';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get games => 'Oyunlar';

  @override
  String get score => 'Puan';

  @override
  String get gameOver => 'Oyun Bitti';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get share => 'Paylaş';

  @override
  String get confirm => 'Onayla';

  @override
  String get fullscreen => 'Tam Ekran';

  @override
  String get cancel => 'İptal';

  @override
  String get reset => 'Sıfırla';

  @override
  String get higherLower => 'Yüksek mi Düşük mü';

  @override
  String get higherLowerDescription =>
      'Sonraki sayının yüksek mi yoksa düşük mü olacağını tahmin edin!';

  @override
  String get higher => 'Yüksek';

  @override
  String get lower => 'Düşük';

  @override
  String get lastNumber => 'Son Sayı';

  @override
  String get completedAllTargets => 'Tüm hedefleri tamamladın!';

  @override
  String get targets => 'Hedefler';

  @override
  String get continueGame => 'Oyunu Devam Ettir';

  @override
  String get watchAdToContinue => 'Devam Etmek İçin Reklam İzle';

  @override
  String get adNotAvailable => 'Reklam Mevcut Değil';

  @override
  String get adNotAvailableMessage =>
      'Şu anda reklam mevcut değil. Lütfen daha sonra tekrar deneyin.';

  @override
  String get adFailed => 'Reklam Başarısız';

  @override
  String get adFailedMessage => 'Reklam gösterilemedi. Lütfen tekrar deneyin.';

  @override
  String get ok => 'Tamam';

  @override
  String get exit => 'Çıkış';

  @override
  String get andMore => 've daha fazlası...';

  @override
  String get missionFailed => 'Görev Başarısız!';

  @override
  String get greenTargetHit => 'Yeşil hedef vuruldu!';

  @override
  String get youHitAllTargets => 'Tüm hedefleri vurdun!';

  @override
  String get timeRanOut => 'Süre bitti!';

  @override
  String get targetsHit => 'Vurulan Hedefler';

  @override
  String get mistake => 'Hata';

  @override
  String get civilianHit => 'Sivil Vuruldu';

  @override
  String get youFoundAllColors => 'Tüm renkleri buldun!';

  @override
  String get colorsFound => 'Bulunan Renkler';

  @override
  String get lastMistake => 'Son Hata';

  @override
  String get wrongColor => 'Yanlış Renk';

  @override
  String get currentNumber => 'Mevcut Sayı';

  @override
  String get close => 'Kapat';

  @override
  String get betterLuckNextTime => 'Bir dahaki sefere daha şanslı olacaksın!';

  @override
  String get losingNumbers => 'Kaybetmemize Neden Olan Sayılar';

  @override
  String get losingNumber => 'Kaybetmemize Neden Olan Sayı';

  @override
  String get colorHunt => 'Renk Avı';

  @override
  String get colorHuntDescription =>
      'Hedef rengi bulun! Metnin rengi sizi kandırmaya çalışabilir!';

  @override
  String get target => 'Hedef';

  @override
  String get time => 'Süre';

  @override
  String get wrongColorSelected => 'Yanlış Renk Seçildi';

  @override
  String get wrongColorSelection => 'Yanlış Renk Seçimi';

  @override
  String get favorites => 'Favoriler';

  @override
  String get loadingFavorites => 'Favoriler Yükleniyor...';

  @override
  String get noFavoritesYet => 'Henüz Favori Yok';

  @override
  String get addGamesToFavorites =>
      'Oyunları favorilere ekleyerek hızlı erişim sağlayın';

  @override
  String get browseGames => 'Oyunları Keşfet';

  @override
  String get aimTrainer => 'Nişan Antrenmanı';

  @override
  String get aimTrainerDescription =>
      '20 saniye boyunca rastgele beliren kırmızı hedefleri vurmaya çalışın. Her vuruş 1 puan!';

  @override
  String get numberMemory => 'Sayı Hafızası';

  @override
  String get numberMemoryDescription =>
      'Sayı dizisini ezberleyin ve tuş takımını kullanarak doğru şekilde girin. Kaç basamak hatırlayabilirsiniz?';

  @override
  String get findDifference => 'Farklı Rengi Bul';

  @override
  String get findDifferenceDescription =>
      'Farklı renkte olan tek kareyi bulun. Her turda daha zorlaşır!';

  @override
  String get rockPaperScissors => 'Taş-Kağıt-Makas';

  @override
  String get rockPaperScissorsDescription =>
      'Bilgisayara karşı oyna. 5 puana ilk ulaşan kazanır.';

  @override
  String get twentyOne => '21 (Blackjack)';

  @override
  String get twentyOneDescription =>
      'Krupiyeyi 21\'e kadar yenin! Aşmadan mümkün olduğunca yaklaşın.';

  @override
  String get nowYourTurn => 'Şimdi sıra sizde!';

  @override
  String get correct => 'Doğru!';

  @override
  String get playing => 'Oynanıyor';

  @override
  String youReachedLevel(int level) {
    return 'Seviye $level\'e ulaştınız';
  }

  @override
  String get tapToStartGuessing =>
      'Tahmin etmeye başlamak için Yüksek veya Düşük\'e dokunun! Sayılar 1-50 arasındadır.';

  @override
  String get numbersBetween1And50 => 'Sayılar 1-50 arasındadır';

  @override
  String get leaderboard => 'Liderlik Tablosu';

  @override
  String get noLeaderboardData => 'Liderlik Tablosu Verisi Yok';

  @override
  String get playGamesToSeeScores =>
      'Yüksek skorlarınızı görmek için oyun oynayın!';

  @override
  String get playGames => 'Oyun Oyna';

  @override
  String get swipeToDeleteHint => 'Yüksek skorları silmek için sola kaydırın';

  @override
  String get removeAds => 'Reklamları Kaldır';

  @override
  String get removeAdsDescription =>
      'Aylık abonelik ile reklamsız deneyim yaşayın';

  @override
  String get monthlySubscription => 'Aylık Abonelik';

  @override
  String get subscribeNow => 'Şimdi Abone Ol';

  @override
  String get restorePurchases => 'Satın Alımları Geri Yükle';

  @override
  String get subscriptionActive => 'Abonelik Aktif';

  @override
  String get subscriptionExpired => 'Abonelik Süresi Doldu';

  @override
  String daysRemaining(int days) {
    return '$days gün kaldı';
  }

  @override
  String get purchaseSuccess => 'Satın Alma Başarılı!';

  @override
  String get purchaseError => 'Satın Alma Başarısız';

  @override
  String get restoreSuccess => 'Satın Alımlar Geri Yüklendi!';

  @override
  String get restoreError => 'Geri Yükleme Başarısız';

  @override
  String get totalGames => 'Toplam Oyun';

  @override
  String get highestScore => 'En Yüksek Skor';

  @override
  String get averageScore => 'Ortalama Skor';

  @override
  String highScore(int score) {
    return 'Yüksek Skor: $score';
  }

  @override
  String lastPlayed(String date) {
    return 'Son Oynama: $date';
  }

  @override
  String get sortBy => 'Sırala';

  @override
  String get sortByScore => 'Skora Göre Sırala';

  @override
  String get sortByLastPlayed => 'Son Oynama Tarihine Göre Sırala';

  @override
  String get shareAchievements => 'Başarıları Paylaş';

  @override
  String get previewImage => 'Görseli Önizle';

  @override
  String get shareImage => 'Görseli Paylaş';

  @override
  String get shareNoData =>
      'Henüz paylaşılacak veri yok. Önce biraz oyun oynayın!';

  @override
  String get shareError =>
      'Başarılar paylaşılırken hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get timeUp => 'Süre Doldu';

  @override
  String get timeUpMessage => 'Süreniz bitti!';

  @override
  String get finalScore => 'Final Skor';

  @override
  String get youWon => 'Kazandınız!';

  @override
  String get congratulationsMessage => 'Tebrikler! Görevi tamamladınız!';

  @override
  String get excellentPerformance => 'Mükemmel performans!';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get deleteHighScore => 'Yüksek Skoru Sil';

  @override
  String get deleteHighScoreMessage =>
      'Bu oyun için yüksek skoru silmek istediğinizden emin misiniz?';

  @override
  String get delete => 'Sil';

  @override
  String get language => 'Dil';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get languageChangeInfo =>
      'Dil değişiklikleri hemen uygulanacak. Yeni dil uygulamak için uygulama yeniden başlatılacak.';

  @override
  String get choosePreferredLanguage => 'Tercih ettiğiniz dili seçin';

  @override
  String get sort_by_date => 'Tarihe Göre Sırala';

  @override
  String get sort_by_game => 'Oyuna Göre Sırala';

  @override
  String get theme => 'Tema';

  @override
  String get selectTheme => 'Tema Seçin';

  @override
  String get lightTheme => 'Açık';

  @override
  String get darkTheme => 'Koyu';

  @override
  String get systemTheme => 'Sistem';

  @override
  String get lightThemeDescription => 'Aydınlık ortamlar için açık tema';

  @override
  String get darkThemeDescription => 'Az ışıklı ortamlar için koyu tema';

  @override
  String get systemThemeDescription => 'Cihazınızın tema ayarını takip eder';

  @override
  String get themeChangeInfo =>
      'Tema değişiklikleri uygulama genelinde hemen uygulanacaktır.';

  @override
  String get choosePreferredTheme => 'Tercih ettiğiniz temayı seçin';

  @override
  String get startGame => 'Oyunu Başlat';

  @override
  String get restartGame => 'Oyunu Yeniden Başlat';

  @override
  String get you => 'Sen';

  @override
  String get cpu => 'PC';

  @override
  String get dealer => 'Krupiye';

  @override
  String get youWin => 'Kazandın!';

  @override
  String get youLose => 'Kaybettin!';

  @override
  String get tie => 'Berabere!';

  @override
  String get total => 'Toplam';

  @override
  String get red => 'Kırmızı';

  @override
  String get green => 'Yeşil';

  @override
  String get blue => 'Mavi';

  @override
  String get purple => 'Mor';

  @override
  String get orange => 'Turuncu';

  @override
  String get yellow => 'Sarı';

  @override
  String get pink => 'Pembe';

  @override
  String get brown => 'Kahverengi';

  @override
  String get play => 'Oyna';

  @override
  String get appSettings => 'Uygulama Ayarları';

  @override
  String get customizeAppExperience => 'Uygulama deneyiminizi özelleştirin';

  @override
  String get settings => 'Ayarlar';

  @override
  String get hit => 'Kart Çek';

  @override
  String get stand => 'Kal';

  @override
  String get reactionTime => 'Reaksiyon Süresi';

  @override
  String get reactionTimeDescription =>
      '1\'den 12\'ye kadar sayıları doğru sırayla mümkün olduğunca hızlı tıklayın. Süreniz ölçülecek (düşük olan daha iyi).';

  @override
  String get wrongSequence => 'Yanlış sıra!';

  @override
  String get congratulations => 'Tebrikler!';

  @override
  String get next => 'Sıradaki';

  @override
  String get numbersSorted => 'Sıralanan Sayılar';

  @override
  String get numbersRemembered => 'Hatırlanan Sayılar';

  @override
  String get correctGuesses => 'Doğru Tahminler';

  @override
  String get yourScore => 'Senin Skorun';

  @override
  String get cpuScore => 'PC Skoru';

  @override
  String get result => 'Sonuç';

  @override
  String get bust => 'Patladın!';

  @override
  String get wrongNumber => 'Yanlış Sayı';

  @override
  String get youSuccessfullySortedAllNumbers =>
      'Tüm sayıları başarıyla sıraladın!';

  @override
  String get youRememberedAllNumbers => 'Tüm sayıları hatırladın!';

  @override
  String get youGuessedCorrectly => 'Doğru tahmin ettin!';

  @override
  String get youWonTheGame => 'Oyunu kazandın!';

  @override
  String get youReached21 => '21\'e ulaştın!';

  @override
  String get youWentOver21 => '21\'i aştın!';

  @override
  String get whyYouLost => 'Neden kaybettin';

  @override
  String get sortLeaderboard => 'Liderlik Tablosunu Sırala';

  @override
  String get sortByName => 'İsme Göre Sırala';

  @override
  String get sortByDate => 'Tarihe Göre Sırala';

  @override
  String get perfectTime => 'Mükemmel Süre!';

  @override
  String get goodTime => 'İyi Süre!';

  @override
  String get averageTime => 'Ortalama Süre';

  @override
  String get slowTime => 'Yavaş Süre';

  @override
  String get verySlowTime => 'Çok Yavaş Süre';

  @override
  String get patternMemory => 'Desen Hafızası';

  @override
  String get patternMemoryDescription =>
      'Ekrandaki deseni ezberle ve tekrarla. Desen her seviyede daha karmaşık hale gelir.';

  @override
  String get patternMemoryInstructions =>
      'Ekrandaki deseni ezberle ve tekrarla. Desen her seviyede daha karmaşık hale gelir.';

  @override
  String get wrongPattern => 'Yanlış Desen';

  @override
  String get level => 'Seviye';

  @override
  String get wrong => 'Yanlış';

  @override
  String get row => 'satır';

  @override
  String get column => 'sütun';
}
