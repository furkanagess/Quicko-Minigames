import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../../shared/models/higher_lower_game_state.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/utils/sound_utils.dart';

class HigherLowerProvider extends ChangeNotifier {
  HigherLowerGameState _gameState = const HigherLowerGameState();
  Timer? _animationTimer;
  final Random _random = Random();
  bool _hasBrokenRecordThisGame = false;

  HigherLowerGameState get gameState => _gameState;

  /// Rastgele sayı üretir (1-50 arası)
  int _generateRandomNumber() {
    return _random.nextInt(50) + 1;
  }

  /// Oyunu başlat
  void startGame() {
    // Önce animasyonu durdur (eğer çalışıyorsa)
    stopNumberAnimation();
    _hasBrokenRecordThisGame = false;

    _gameState = _gameState.copyWith(
      currentNumber: 0,
      previousNumber: null,
      score: 0,
      status: HigherLowerGameStatus.playing,
      showGameOver: false,
    );
    notifyListeners();

    // Sayı animasyonu başlat
    startNumberAnimation();
  }

  /// Rastgele sayı animasyonu başlat
  void startNumberAnimation() {
    SoundUtils.playSpinnerSound();
    _gameState = _gameState.copyWith(
      isAnimating: true,
      animatedNumber: _generateRandomNumber(),
    );
    notifyListeners();

    _animationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _gameState = _gameState.copyWith(animatedNumber: _generateRandomNumber());
      notifyListeners();
    });

    // 2 saniye sonra animasyonu durdur ve final sayıyı göster
    Timer(const Duration(seconds: 2), () async {
      stopNumberAnimation();
      final finalNumber = _generateRandomNumber();
      _gameState = _gameState.copyWith(
        currentNumber: finalNumber,
        animatedNumber: finalNumber,
        isAnimating: false,
      );
      await SoundUtils.stopSpinnerSound();
      notifyListeners();
    });
  }

  /// Rastgele sayı animasyonunu durdur
  void stopNumberAnimation() {
    _animationTimer?.cancel();
    _animationTimer = null;
  }

  /// Oyunu sıfırla
  void resetGame() {
    _gameState = const HigherLowerGameState();
    _hasBrokenRecordThisGame = false;
    notifyListeners();
  }

  /// Yüksek tahmin
  void guessHigher() {
    if (!_gameState.isGameActive) return;
    SoundUtils.playTapSound();
    _makeGuess(true);
  }

  /// Düşük tahmin
  void guessLower() {
    if (!_gameState.isGameActive) return;
    SoundUtils.playTapSound();
    _makeGuess(false);
  }

  /// Tahmin yap
  void _makeGuess(bool isHigherGuess) {
    final previousNumber = _gameState.currentNumber;
    int newNumber = _generateRandomNumber();

    // Aynı sayı gelirse tekrar üret
    while (newNumber == previousNumber) {
      newNumber = _generateRandomNumber();
    }

    // Tahminin doğru olup olmadığını kontrol et
    final isCorrect =
        isHigherGuess ? newNumber > previousNumber : newNumber < previousNumber;

    if (isCorrect) {
      // Doğru tahmin - skoru artır ve yeni sayıyı göster
      _showNewNumberWithAnimation(
        previousNumber,
        newNumber,
        _gameState.score + 1,
      );
    } else {
      // Yanlış tahmin - oyun biter
      _gameOver(previousNumber, newNumber);
    }
  }

  /// Animasyonlu yeni sayı gösterimi
  void _showNewNumberWithAnimation(
    int previousNumber,
    int newNumber,
    int newScore,
  ) async {
    // Rekor kırıldıysa anında sesi çal (ilk skor hariç, bir kez, oyun aktifken)
    final previousEntry = await LeaderboardUtils.getLeaderboardEntry(
      'higher_lower',
    );
    final previousHighScore = previousEntry?.highScore ?? 0;
    // Oyun bitti flag'i ve aktiflik kontrolü, async gap sonrası tekrar kontrol
    if (!_hasBrokenRecordThisGame &&
        previousEntry != null &&
        newScore > previousHighScore &&
        _gameState.isGameActive) {
      SoundUtils.playNewLevelSound();
      _hasBrokenRecordThisGame = true;
    }
    SoundUtils.playSpinnerSound();
    _gameState = _gameState.copyWith(
      previousNumber: previousNumber,
      isAnimating: true,
      animatedNumber: _generateRandomNumber(),
    );
    notifyListeners();

    // Animasyon timer'ı başlat
    _animationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _gameState = _gameState.copyWith(animatedNumber: _generateRandomNumber());
      notifyListeners();
    });

    // 2 saniye sonra animasyonu durdur ve final sayıyı göster
    Timer(const Duration(seconds: 2), () async {
      stopNumberAnimation();
      _gameState = _gameState.copyWith(
        currentNumber: newNumber,
        score: newScore,
        isAnimating: false,
        animatedNumber: newNumber,
      );
      await SoundUtils.stopSpinnerSound();
      notifyListeners();
    });
  }

  /// Oyun bitti
  void _gameOver(int previousNumber, int newNumber) async {
    // Önce yeni sayıyı animasyonlu göster
    SoundUtils.playSpinnerSound();
    _hasBrokenRecordThisGame = true;
    _gameState = _gameState.copyWith(
      previousNumber: previousNumber,
      isAnimating: true,
      animatedNumber: _generateRandomNumber(),
    );
    notifyListeners();

    // Animasyon timer'ı başlat
    _animationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      _gameState = _gameState.copyWith(animatedNumber: _generateRandomNumber());
      notifyListeners();
    });

    // 2 saniye sonra animasyonu durdur ve oyun biter
    Timer(const Duration(seconds: 2), () async {
      stopNumberAnimation();
      _gameState = _gameState.copyWith(
        currentNumber: newNumber,
        status: HigherLowerGameStatus.gameOver,
        isAnimating: false,
        animatedNumber: newNumber,
        showGameOver: true,
      );
      await SoundUtils.stopSpinnerSound();
      notifyListeners();

      // Yüksek skoru güncelle
      _updateHighScore();
    });
  }

  /// Yüksek skoru güncelle
  void _updateHighScore() async {
    final previousHighScore = await LeaderboardUtils.getHighScore(
      'higher_lower',
    );
    if (_gameState.score > previousHighScore) {
      SoundUtils.playNewLevelSound();
    }
    await LeaderboardUtils.updateHighScore(
      'higher_lower',
      'Higher or Lower',
      _gameState.score,
    );
  }

  /// Game over animasyonunu gizle
  void hideGameOver() {
    _gameState = _gameState.copyWith(showGameOver: false);
    notifyListeners();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }
}
