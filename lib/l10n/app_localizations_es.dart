// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Quicko';

  @override
  String get blindSort => 'Ordenamiento Ciego';

  @override
  String get blindSortDescription =>
      '¡Ordena 10 números del 1-50. ¡Pierdes si el nuevo número no cabe en ningún lugar!';

  @override
  String get nextNumber => 'Siguiente Número';

  @override
  String get newNumberComing => 'Viene Nuevo Número...';

  @override
  String get start => 'Comenzar';

  @override
  String get restart => 'Reiniciar';

  @override
  String get home => 'Inicio';

  @override
  String get games => 'Juegos';

  @override
  String get score => 'Puntuación';

  @override
  String get gameOver => 'Fin del Juego';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get share => 'Compartir';

  @override
  String get confirm => 'Confirmar';

  @override
  String get fullscreen => 'Pantalla Completa';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get higherLower => 'Mayor o Menor';

  @override
  String get higherLowerDescription =>
      '¡Adivina si el siguiente número será mayor o menor!';

  @override
  String get higher => 'Mayor';

  @override
  String get lower => 'Menor';

  @override
  String get lastNumber => 'Último Número';

  @override
  String get completedAllTargets => '¡Completaste todos los objetivos!';

  @override
  String get targets => 'Objetivos';

  @override
  String get continueGame => 'Continuar Juego';

  @override
  String get watchAdToContinue => 'Ver anuncio para continuar';

  @override
  String get adNotAvailable => 'Anuncio no disponible';

  @override
  String get adNotAvailableMessage =>
      'No hay anuncios disponibles actualmente. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get adFailed => 'Anuncio fallido';

  @override
  String get adFailedMessage =>
      'No se pudo mostrar el anuncio. Por favor, inténtalo de nuevo.';

  @override
  String get ok => 'OK';

  @override
  String get exit => 'Salir';

  @override
  String get andMore => 'y más...';

  @override
  String get missionFailed => '¡Misión Fallida!';

  @override
  String get greenTargetHit => '¡Objetivo verde alcanzado!';

  @override
  String get youHitAllTargets => '¡Alcanzaste todos los objetivos!';

  @override
  String get timeRanOut => '¡Se acabó el tiempo!';

  @override
  String get targetsHit => 'Objetivos Alcanzados';

  @override
  String get mistake => 'Error';

  @override
  String get civilianHit => 'Civil Alcanzado';

  @override
  String get youFoundAllColors => '¡Encontraste todos los colores!';

  @override
  String get colorsFound => 'Colores Encontrados';

  @override
  String get lastMistake => 'Último Error';

  @override
  String get wrongColor => 'Color Incorrecto';

  @override
  String get currentNumber => 'Número Actual';

  @override
  String get close => 'Cerrar';

  @override
  String get betterLuckNextTime => '¡Mejor suerte la próxima vez!';

  @override
  String get losingNumbers => 'Números Que Causaron la Pérdida';

  @override
  String get losingNumber => 'Número Que Causó la Pérdida';

  @override
  String get colorHunt => 'Caza de Colores';

  @override
  String get colorHuntDescription =>
      '¡Encuentra el color objetivo! ¡El color del texto puede engañarte!';

  @override
  String get target => 'Objetivo';

  @override
  String get time => 'Tiempo';

  @override
  String get wrongColorSelected => 'Color Incorrecto Seleccionado';

  @override
  String get wrongColorSelection => 'Selección de Color Incorrecta';

  @override
  String get favorites => 'Favoritos';

  @override
  String get loadingFavorites => 'Cargando Favoritos...';

  @override
  String get noFavoritesYet => 'Aún No Hay Favoritos';

  @override
  String get addGamesToFavorites =>
      'Añade juegos a favoritos para acceso rápido';

  @override
  String get browseGames => 'Explorar Juegos';

  @override
  String get aimTrainer => 'Entrenador de Puntería';

  @override
  String get aimTrainerDescription =>
      '¡Intenta disparar a los objetivos rojos que aparecen aleatoriamente durante 20 segundos. ¡Cada acierto es 1 punto!';

  @override
  String get numberMemory => 'Memoria de Números';

  @override
  String get numberMemoryDescription =>
      'Memoriza la secuencia de números e ingrésala correctamente usando el teclado. ¿Cuántos dígitos puedes recordar?';

  @override
  String get findDifference => 'Encuentra la Diferencia';

  @override
  String get findDifferenceDescription =>
      'Encuentra el cuadrado con un color diferente. ¡Se vuelve más difícil con cada ronda!';

  @override
  String get rockPaperScissors => 'Piedra-Papel-Tijeras';

  @override
  String get rockPaperScissorsDescription =>
      'Juega contra la computadora. El primero en llegar a 5 puntos gana.';

  @override
  String get twentyOne => '21 (Veintiuno)';

  @override
  String get twentyOneDescription =>
      '¡Vence al crupier hasta 21! Acércate lo más posible sin pasarte.';

  @override
  String get nowYourTurn => '¡Ahora es tu turno!';

  @override
  String get correct => '¡Correcto!';

  @override
  String get playing => 'Jugando';

  @override
  String youReachedLevel(int level) {
    return 'Llegaste al Nivel $level';
  }

  @override
  String get tapToStartGuessing =>
      '¡Toca Mayor o Menor para comenzar a adivinar! Los números están entre 1-50.';

  @override
  String get numbersBetween1And50 => 'Los números están entre 1-50';

  @override
  String get leaderboard => 'Tabla de Posiciones';

  @override
  String get noLeaderboardData => 'No Hay Datos de Tabla de Posiciones';

  @override
  String get playGamesToSeeScores =>
      '¡Juega para ver tus puntuaciones más altas aquí!';

  @override
  String get playGames => 'Jugar';

  @override
  String get swipeToDeleteHint =>
      'Desliza hacia la izquierda para eliminar puntuaciones altas';

  @override
  String get removeAds => 'Eliminar Anuncios';

  @override
  String get removeAdsDescription =>
      'Disfruta de una experiencia sin anuncios con suscripción mensual';

  @override
  String get monthlySubscription => 'Suscripción Mensual';

  @override
  String get subscribeNow => 'Suscribirse Ahora';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get subscriptionActive => 'Suscripción Activa';

  @override
  String get subscriptionExpired => 'Suscripción Expirada';

  @override
  String daysRemaining(int days) {
    return '$days días restantes';
  }

  @override
  String get monthlySubscriptionPrice => 'Suscripción mensual - \$2.49';

  @override
  String get uninstallWarning =>
      'Importante: La suscripción se almacena localmente. Si desinstalas la aplicación, tu suscripción se perderá y tendrás que comprar de nuevo.';

  @override
  String get importantNotice => 'Aviso Importante';

  @override
  String get gotIt => 'Entendido';

  @override
  String get purchaseSuccess => '¡Compra Exitosa!';

  @override
  String get purchaseError => 'Error en la Compra';

  @override
  String get restoreSuccess => '¡Compras Restauradas!';

  @override
  String get restoreError => 'Error en la Restauración';

  @override
  String get noBannerAds => 'Sin anuncios de banner';

  @override
  String get noInterstitialAds => 'Sin anuncios intersticiales';

  @override
  String get noRewardedAds => 'Sin anuncios recompensados';

  @override
  String get cleanExperience => 'Experiencia limpia y sin distracciones';

  @override
  String get cancelAnytime => 'Cancela en cualquier momento';

  @override
  String get usdPerMonth => 'USD/mes';

  @override
  String get bestValue => 'MEJOR VALOR';

  @override
  String get fiftyPercentOff => '50% DESCUENTO';

  @override
  String get totalGames => 'Total de Juegos';

  @override
  String get highestScore => 'Puntuación Más Alta';

  @override
  String get averageScore => 'Puntuación Promedio';

  @override
  String highScore(int score) {
    return 'Puntuación Alta: $score';
  }

  @override
  String lastPlayed(String date) {
    return 'Último Juego: $date';
  }

  @override
  String get sortBy => 'Ordenar Por';

  @override
  String get sortByScore => 'Ordenar por Puntuación';

  @override
  String get sortByLastPlayed => 'Ordenar por Último Juego';

  @override
  String get shareAchievements => 'Compartir Logros';

  @override
  String get previewImage => 'Vista Previa';

  @override
  String get shareImage => 'Compartir Imagen';

  @override
  String get shareNoData => 'Aún no hay datos para compartir. ¡Juega primero!';

  @override
  String get shareError => 'Error al compartir logros. Inténtalo de nuevo.';

  @override
  String get timeUp => 'Se Acabó el Tiempo';

  @override
  String get timeUpMessage => '¡Se te acabó el tiempo!';

  @override
  String get finalScore => 'Puntuación Final';

  @override
  String get youWon => '¡Ganaste!';

  @override
  String get congratulationsMessage =>
      '¡Felicitaciones! ¡Has completado el desafío!';

  @override
  String get excellentPerformance => '¡Excelente rendimiento!';

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get deleteHighScore => 'Eliminar Puntuación Alta';

  @override
  String get deleteHighScoreMessage =>
      '¿Estás seguro de que quieres eliminar la puntuación alta de este juego?';

  @override
  String get delete => 'Eliminar';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get languageChangeInfo =>
      'Los cambios de idioma se aplicarán inmediatamente. La aplicación se reiniciará para aplicar el nuevo idioma.';

  @override
  String get choosePreferredLanguage => 'Elige tu idioma preferido';

  @override
  String get sort_by_date => 'Ordenar por Fecha';

  @override
  String get sort_by_game => 'Ordenar por Juego';

  @override
  String get theme => 'Tema';

  @override
  String get selectTheme => 'Seleccionar Tema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get lightThemeDescription => 'Tema claro para entornos brillantes';

  @override
  String get darkThemeDescription => 'Tema oscuro para entornos con poca luz';

  @override
  String get systemThemeDescription =>
      'Sigue la configuración de tema de tu dispositivo';

  @override
  String get themeChangeInfo =>
      'Los cambios de tema se aplicarán inmediatamente en toda la aplicación.';

  @override
  String get choosePreferredTheme => 'Elige tu tema preferido';

  @override
  String get startGame => 'Comenzar Juego';

  @override
  String get restartGame => 'Reiniciar Juego';

  @override
  String get you => 'Tú';

  @override
  String get cpu => 'CPU';

  @override
  String get dealer => 'Crupier';

  @override
  String get youWin => '¡Ganaste!';

  @override
  String get youLose => '¡Perdiste!';

  @override
  String get tie => '¡Empate!';

  @override
  String get total => 'Total';

  @override
  String get red => 'Rojo';

  @override
  String get green => 'Verde';

  @override
  String get blue => 'Azul';

  @override
  String get purple => 'Púrpura';

  @override
  String get orange => 'Naranja';

  @override
  String get yellow => 'Amarillo';

  @override
  String get pink => 'Rosa';

  @override
  String get brown => 'Marrón';

  @override
  String get play => 'Jugar';

  @override
  String get appSettings => 'Configuración de la App';

  @override
  String get customizeAppExperience =>
      'Personaliza tu experiencia en la aplicación';

  @override
  String get settings => 'Configuración';

  @override
  String get hit => 'Pedir';

  @override
  String get stand => 'Plantarse';

  @override
  String get reactionTime => 'Tiempo de Reacción';

  @override
  String get reactionTimeDescription =>
      'Haz clic en los números del 1 al 12 en el orden correcto lo más rápido que puedas. Tu tiempo será medido (menor es mejor).';

  @override
  String get wrongSequence => '¡Secuencia incorrecta!';

  @override
  String get congratulations => '¡Felicitaciones!';

  @override
  String get next => 'Siguiente';

  @override
  String get numbersSorted => 'Números Ordenados';

  @override
  String get numbersRemembered => 'Números Recordados';

  @override
  String get correctGuesses => 'Adivinanzas Correctas';

  @override
  String get yourScore => 'Tu Puntuación';

  @override
  String get cpuScore => 'Puntuación CPU';

  @override
  String get result => 'Resultado';

  @override
  String get bust => '¡Te Pasaste!';

  @override
  String get wrongNumber => 'Número Incorrecto';

  @override
  String get youSuccessfullySortedAllNumbers =>
      '¡Ordenaste exitosamente todos los números!';

  @override
  String get youRememberedAllNumbers => '¡Recordaste todos los números!';

  @override
  String get youGuessedCorrectly => '¡Adivinaste correctamente!';

  @override
  String get youWonTheGame => '¡Ganaste el juego!';

  @override
  String get youReached21 => '¡Llegaste a 21!';

  @override
  String get youWentOver21 => '¡Te pasaste de 21!';

  @override
  String get whyYouLost => 'Por qué perdiste';

  @override
  String get sortLeaderboard => 'Ordenar Tabla de Posiciones';

  @override
  String get sortByName => 'Ordenar por Nombre';

  @override
  String get sortByDate => 'Ordenar por Fecha';

  @override
  String get perfectTime => '¡Tiempo Perfecto!';

  @override
  String get goodTime => '¡Buen Tiempo!';

  @override
  String get averageTime => 'Tiempo Promedio';

  @override
  String get slowTime => 'Tiempo Lento';

  @override
  String get verySlowTime => 'Tiempo Muy Lento';

  @override
  String get patternMemory => 'Memoria de Patrones';

  @override
  String get patternMemoryDescription =>
      'Memoriza el patrón en la pantalla y replícalo. El patrón se vuelve más complejo con cada nivel.';

  @override
  String get patternMemoryInstructions =>
      'Memoriza el patrón en la pantalla y replícalo. El patrón se vuelve más complejo con cada nivel.';

  @override
  String get wrongPattern => 'Patrón Incorrecto';

  @override
  String get level => 'Nivel';

  @override
  String get wrong => 'Incorrecto';

  @override
  String get row => 'fila';

  @override
  String get column => 'columna';

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
  String get soundSettings => 'Ajustes de sonido';

  @override
  String get soundSettingsMenuSubtitle =>
      'Sonidos de la app y nivel de efectos';

  @override
  String get appSounds => 'Sonidos de la aplicación';

  @override
  String get appSoundsDescription =>
      'Activar/desactivar sonidos y ajustar el nivel de efectos';

  @override
  String get sounds => 'Sonidos';

  @override
  String get soundsOn => 'Activado';

  @override
  String get soundsOff => 'Desactivado';

  @override
  String get effectsVolume => 'Volumen de efectos';

  @override
  String get soundTest => 'Prueba de sonido';

  @override
  String get playSampleSound => 'Reproducir sonido de muestra';
}
