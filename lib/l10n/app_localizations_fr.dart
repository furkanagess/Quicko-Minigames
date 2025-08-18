// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Quicko';

  @override
  String get blindSort => 'Tri Aveugle';

  @override
  String get blindSortDescription =>
      'Triez 10 nombres de 1-50. Vous perdez si le nouveau nombre ne s\'intègre nulle part !';

  @override
  String get nextNumber => 'Nombre Suivant';

  @override
  String get newNumberComing => 'Nouveau Nombre Arrive...';

  @override
  String get start => 'Commencer';

  @override
  String get restart => 'Redémarrer';

  @override
  String get home => 'Accueil';

  @override
  String get games => 'Jeux';

  @override
  String get score => 'Score';

  @override
  String get gameOver => 'Partie Terminée';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get share => 'Partager';

  @override
  String get confirm => 'Confirmer';

  @override
  String get fullscreen => 'Plein Écran';

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get higherLower => 'Plus ou Moins';

  @override
  String get higherLowerDescription =>
      'Devinez si le prochain nombre sera plus élevé ou plus bas !';

  @override
  String get higher => 'Plus';

  @override
  String get lower => 'Moins';

  @override
  String get lastNumber => 'Dernier Nombre';

  @override
  String get completedAllTargets => 'Toutes les cibles terminées !';

  @override
  String get targets => 'Cibles';

  @override
  String get continueGame => 'Continuer le Jeu';

  @override
  String get watchAdToContinue => 'Regarder une publicité pour continuer';

  @override
  String get adNotAvailable => 'Publicité non disponible';

  @override
  String get adNotAvailableMessage =>
      'Aucune publicité n\'est actuellement disponible. Veuillez réessayer plus tard.';

  @override
  String get adFailed => 'Publicité échouée';

  @override
  String get adFailedMessage =>
      'Impossible d\'afficher la publicité. Veuillez réessayer.';

  @override
  String get ok => 'OK';

  @override
  String get exit => 'Quitter';

  @override
  String get andMore => 'et plus...';

  @override
  String get missionFailed => 'Mission Échouée !';

  @override
  String get greenTargetHit => 'Cible verte touchée !';

  @override
  String get youHitAllTargets => 'Vous avez touché toutes les cibles !';

  @override
  String get timeRanOut => 'Le temps est écoulé !';

  @override
  String get targetsHit => 'Cibles Touchées';

  @override
  String get mistake => 'Erreur';

  @override
  String get civilianHit => 'Civil Touché';

  @override
  String get youFoundAllColors => 'Vous avez trouvé toutes les couleurs !';

  @override
  String get colorsFound => 'Couleurs Trouvées';

  @override
  String get lastMistake => 'Dernière Erreur';

  @override
  String get wrongColor => 'Mauvaise Couleur';

  @override
  String get currentNumber => 'Nombre Actuel';

  @override
  String get close => 'Fermer';

  @override
  String get betterLuckNextTime => 'Bonne chance la prochaine fois !';

  @override
  String get losingNumbers => 'Nombres qui ont causé la perte';

  @override
  String get losingNumber => 'Nombre qui a causé la perte';

  @override
  String get colorHunt => 'Chasse aux Couleurs';

  @override
  String get colorHuntDescription =>
      'Trouvez la couleur cible ! La couleur du texte peut vous tromper !';

  @override
  String get target => 'Cible';

  @override
  String get time => 'Temps';

  @override
  String get wrongColorSelected => 'Mauvaise Couleur Sélectionnée';

  @override
  String get wrongColorSelection => 'Sélection de Couleur Incorrecte';

  @override
  String get favorites => 'Favoris';

  @override
  String get loadingFavorites => 'Chargement des favoris...';

  @override
  String get noFavoritesYet => 'Pas Encore de Favoris';

  @override
  String get addGamesToFavorites =>
      'Ajoutez des jeux aux favoris pour un accès rapide';

  @override
  String get browseGames => 'Parcourir les Jeux';

  @override
  String get aimTrainer => 'Entraîneur de Visée';

  @override
  String get aimTrainerDescription =>
      'Essayez de toucher les cibles rouges qui apparaissent aléatoirement pendant 20 secondes. Chaque touche vaut 1 point !';

  @override
  String get numberMemory => 'Mémoire des Nombres';

  @override
  String get numberMemoryDescription =>
      'Mémorisez la séquence de nombres et saisissez-la correctement en utilisant le clavier. Combien de chiffres pouvez-vous retenir ?';

  @override
  String get findDifference => 'Trouvez la Différence';

  @override
  String get findDifferenceDescription =>
      'Trouvez le carré avec une couleur différente. Devient plus difficile à chaque tour !';

  @override
  String get rockPaperScissors => 'Pierre-Papier-Ciseaux';

  @override
  String get rockPaperScissorsDescription =>
      'Jouez contre l\'ordinateur. Le premier à atteindre 5 points gagne.';

  @override
  String get twentyOne => '21 (Vingt-et-Un)';

  @override
  String get twentyOneDescription =>
      'Battez le croupier jusqu\'à 21 ! Approchez-vous le plus possible sans dépasser.';

  @override
  String get nowYourTurn => 'C\'est maintenant votre tour !';

  @override
  String get correct => 'Correct !';

  @override
  String get playing => 'En Cours';

  @override
  String youReachedLevel(int level) {
    return 'Vous avez atteint le Niveau $level';
  }

  @override
  String get tapToStartGuessing =>
      'Appuyez sur Plus ou Moins pour commencer à deviner ! Les nombres sont entre 1-50.';

  @override
  String get numbersBetween1And50 => 'Les nombres sont entre 1-50';

  @override
  String get leaderboard => 'Classement';

  @override
  String get noLeaderboardData => 'Aucune Donnée de Classement';

  @override
  String get playGamesToSeeScores =>
      'Jouez pour voir vos scores les plus élevés ici !';

  @override
  String get playGames => 'Jouer';

  @override
  String get swipeToDeleteHint =>
      'Glissez vers la gauche pour supprimer les scores élevés';

  @override
  String get removeAds => 'Supprimer les Publicités';

  @override
  String get removeAdsDescription =>
      'Profitez d\'une expérience sans publicité avec un abonnement mensuel';

  @override
  String get monthlySubscription => 'Abonnement Mensuel';

  @override
  String get subscribeNow => 'S\'abonner Maintenant';

  @override
  String get restorePurchases => 'Restaurer les Achats';

  @override
  String get subscriptionActive => 'Abonnement Actif';

  @override
  String get subscriptionExpired => 'Abonnement Expiré';

  @override
  String daysRemaining(int days) {
    return '$days jours restants';
  }

  @override
  String get monthlySubscriptionPrice => 'Abonnement mensuel - \$2.49';

  @override
  String get uninstallWarning =>
      'Important : L\'abonnement est stocké localement. Si vous désinstallez l\'application, votre abonnement sera perdu et vous devrez l\'acheter à nouveau.';

  @override
  String get importantNotice => 'Avis Important';

  @override
  String get gotIt => 'Compris';

  @override
  String get purchaseSuccess => 'Achat Réussi !';

  @override
  String get purchaseError => 'Échec de l\'Achat';

  @override
  String get restoreSuccess => 'Achats Restaurés !';

  @override
  String get restoreError => 'Échec de la Restauration';

  @override
  String get noBannerAds => 'Pas de publicités de bannière';

  @override
  String get noInterstitialAds => 'Pas de publicités interstitielles';

  @override
  String get noRewardedAds => 'Pas de publicités récompensées';

  @override
  String get cleanExperience => 'Expérience propre et sans distraction';

  @override
  String get cancelAnytime => 'Annulez à tout moment';

  @override
  String get usdPerMonth => 'USD/mois';

  @override
  String get bestValue => 'MEILLEUR RAPPORT';

  @override
  String get fiftyPercentOff => '50% DE RÉDUCTION';

  @override
  String get totalGames => 'Total des Jeux';

  @override
  String get highestScore => 'Score le Plus Élevé';

  @override
  String get averageScore => 'Score Moyen';

  @override
  String highScore(int score) {
    return 'Score Élevé : $score';
  }

  @override
  String lastPlayed(String date) {
    return 'Dernier Jeu : $date';
  }

  @override
  String get sortBy => 'Trier Par';

  @override
  String get sortByScore => 'Trier par Score';

  @override
  String get sortByLastPlayed => 'Trier par Dernier Jeu';

  @override
  String get shareAchievements => 'Partager les Réussites';

  @override
  String get previewImage => 'Aperçu';

  @override
  String get shareImage => 'Partager l\'Image';

  @override
  String get shareNoData =>
      'Aucune donnée à partager pour le moment. Jouez d\'abord !';

  @override
  String get shareError => 'Erreur lors du partage des réussites. Réessayez.';

  @override
  String get timeUp => 'Temps Écoulé';

  @override
  String get timeUpMessage => 'Votre temps est écoulé !';

  @override
  String get finalScore => 'Score Final';

  @override
  String get youWon => 'Vous avez Gagné !';

  @override
  String get congratulationsMessage =>
      'Félicitations ! Vous avez terminé le défi !';

  @override
  String get excellentPerformance => 'Performance Excellente !';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get deleteHighScore => 'Supprimer le Score Élevé';

  @override
  String get deleteHighScoreMessage =>
      'Êtes-vous sûr de vouloir supprimer le score élevé pour ce jeu ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get languageChangeInfo =>
      'Les changements de langue seront appliqués immédiatement. L\'application sera redémarrée pour appliquer la nouvelle langue.';

  @override
  String get choosePreferredLanguage => 'Choisissez votre langue préférée';

  @override
  String get sort_by_date => 'Trier par Date';

  @override
  String get sort_by_game => 'Trier par Jeu';

  @override
  String get theme => 'Thème';

  @override
  String get selectTheme => 'Sélectionner le Thème';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Système';

  @override
  String get lightThemeDescription =>
      'Thème clair pour les environnements lumineux';

  @override
  String get darkThemeDescription =>
      'Thème sombre pour les environnements peu éclairés';

  @override
  String get systemThemeDescription =>
      'Suit les paramètres de thème de votre appareil';

  @override
  String get themeChangeInfo =>
      'Les changements de thème seront appliqués immédiatement dans toute l\'application.';

  @override
  String get choosePreferredTheme => 'Choisissez votre thème préféré';

  @override
  String get startGame => 'Commencer le Jeu';

  @override
  String get restartGame => 'Redémarrer le Jeu';

  @override
  String get you => 'Vous';

  @override
  String get cpu => 'CPU';

  @override
  String get dealer => 'Croupier';

  @override
  String get youWin => 'Vous Gagnez !';

  @override
  String get youLose => 'Vous Perdez !';

  @override
  String get tie => 'Égalité !';

  @override
  String get total => 'Total';

  @override
  String get red => 'Rouge';

  @override
  String get green => 'Vert';

  @override
  String get blue => 'Bleu';

  @override
  String get purple => 'Violet';

  @override
  String get orange => 'Orange';

  @override
  String get yellow => 'Jaune';

  @override
  String get pink => 'Rose';

  @override
  String get brown => 'Marron';

  @override
  String get play => 'Jouer';

  @override
  String get appSettings => 'Paramètres de l\'App';

  @override
  String get customizeAppExperience =>
      'Personnalisez votre expérience dans l\'application';

  @override
  String get settings => 'Paramètres';

  @override
  String get hit => 'Tirer';

  @override
  String get stand => 'Rester';

  @override
  String get reactionTime => 'Temps de Réaction';

  @override
  String get reactionTimeDescription =>
      'Cliquez sur les nombres de 1 à 12 dans le bon ordre aussi rapidement que possible. Votre temps sera mesuré (plus bas est mieux).';

  @override
  String get wrongSequence => 'Séquence Incorrecte !';

  @override
  String get congratulations => 'Félicitations !';

  @override
  String get next => 'Suivant';

  @override
  String get numbersSorted => 'Nombres Triés';

  @override
  String get numbersRemembered => 'Nombres Mémorisés';

  @override
  String get correctGuesses => 'Devinettes Correctes';

  @override
  String get yourScore => 'Votre Score';

  @override
  String get cpuScore => 'Score CPU';

  @override
  String get result => 'Résultat';

  @override
  String get bust => 'Dépassé !';

  @override
  String get wrongNumber => 'Mauvais Nombre';

  @override
  String get youSuccessfullySortedAllNumbers =>
      'Vous avez trié tous les nombres avec succès !';

  @override
  String get youRememberedAllNumbers => 'Vous avez mémorisé tous les nombres !';

  @override
  String get youGuessedCorrectly => 'Vous avez deviné correctement !';

  @override
  String get youWonTheGame => 'Vous avez gagné le jeu !';

  @override
  String get youReached21 => 'Vous avez atteint 21 !';

  @override
  String get youWentOver21 => 'Vous avez dépassé 21 !';

  @override
  String get whyYouLost => 'Pourquoi vous avez perdu';

  @override
  String get sortLeaderboard => 'Trier le Classement';

  @override
  String get sortByName => 'Trier par Nom';

  @override
  String get sortByDate => 'Trier par Date';

  @override
  String get perfectTime => 'Temps Parfait !';

  @override
  String get goodTime => 'Bon Temps !';

  @override
  String get averageTime => 'Temps Moyen';

  @override
  String get slowTime => 'Temps Lent';

  @override
  String get verySlowTime => 'Temps Très Lent';

  @override
  String get patternMemory => 'Mémoire des Motifs';

  @override
  String get patternMemoryDescription =>
      'Mémorisez le motif à l\'écran et reproduisez-le. Le motif devient plus complexe à chaque niveau.';

  @override
  String get patternMemoryInstructions =>
      'Mémorisez le motif à l\'écran et reproduisez-le. Le motif devient plus complexe à chaque niveau.';

  @override
  String get wrongPattern => 'Mauvais Motif';

  @override
  String get level => 'Niveau';

  @override
  String get wrong => 'Incorrect';

  @override
  String get row => 'ligne';

  @override
  String get column => 'colonne';

  @override
  String get gameInProgress => 'Game in Progress';

  @override
  String get gameInProgressMessage =>
      'A game is currently in progress. Are you sure you want to exit? Your progress will be lost.';

  @override
  String get stayInGame => 'Stay in Game';

  @override
  String get exitGame => 'Exit Game';

  @override
  String get soundSettings => 'Paramètres du son';

  @override
  String get soundSettingsMenuSubtitle =>
      'Sons de l\'application et niveau des effets';

  @override
  String get appSounds => 'Sons de l\'application';

  @override
  String get appSoundsDescription =>
      'Activer/désactiver les sons et régler le niveau des effets';

  @override
  String get sounds => 'Sons';

  @override
  String get soundsOn => 'Activé';

  @override
  String get soundsOff => 'Désactivé';

  @override
  String get effectsVolume => 'Volume des effets';

  @override
  String get soundTest => 'Test du son';

  @override
  String get playSampleSound => 'Lire un son d\'exemple';

  @override
  String get purchaseErrorDescription =>
      'Votre achat n’a pas pu être finalisé. Veuillez réessayer ou vérifier votre moyen de paiement.';

  @override
  String get restoreErrorDescription =>
      'Nous n’avons pas pu restaurer vos achats. Veuillez réessayer.';
}
