import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/color_hunt_game_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/utils/sound_utils.dart';
import '../../../core/utils/localization_utils.dart';

class ColorHuntProvider extends ChangeNotifier {
  ColorHuntGameState _gameState = const ColorHuntGameState();
  Timer? _timer;
  final Random _random = Random();
  bool _hasBrokenRecordThisGame = false;

  ColorHuntGameState get gameState => _gameState;

  // Color keys and their corresponding colors
  final Map<String, Color> _colorMap = {
    'red': AppTheme.darkError,
    'green': Colors.green,
    'blue': Colors.blue,
    'purple': Colors.purple,
    'orange': Colors.orange,
    'yellow': Colors.yellow,
    'pink': Colors.pink,
    'brown': Colors.brown,
  };

  final List<Color> _availableColors = [
    AppTheme.darkError,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.yellow,
    Colors.pink,
    Colors.brown,
  ];

  /// Oyunu başlat
  void startGame() {
    _hasBrokenRecordThisGame = false;
    _gameState = _gameState.copyWith(
      score: 0,
      timeLeft: 30,
      status: ColorHuntGameStatus.playing,
      showGameOver: false,
      wrongTapIndex: null,
    );

    _generateNewTarget();
    _startTimer();
    notifyListeners();
  }

  /// Timer'ı başlat
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameState.timeLeft > 0) {
        _gameState = _gameState.copyWith(timeLeft: _gameState.timeLeft - 1);

        // Son 4 saniyede geri sayım sesi çal
        if (_gameState.timeLeft <= 3 && _gameState.timeLeft > 0) {
          SoundUtils.playCountDownSound();
        }

        notifyListeners();
      } else {
        _gameOver();
      }
    });
  }

  /// Timer'ı durdur
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Yeni hedef oluştur
  void _generateNewTarget() {
    final colorKeys = _colorMap.keys.toList();
    final targetColorKey = colorKeys[_random.nextInt(colorKeys.length)];
    final targetColor = _colorMap[targetColorKey]!;

    // Get localized color name
    final targetColorName = LocalizationUtils.getStringGlobal(targetColorKey);

    // Misleading text color (different from target color)
    Color textColor;
    do {
      textColor = _availableColors[_random.nextInt(_availableColors.length)];
    } while (textColor == targetColor);

    // Ensure target color is always in the available options
    final availableColorsForDisplay = <Color>[];

    // First, add the target color
    availableColorsForDisplay.add(targetColor);

    // Then add 3 other random colors (excluding target color)
    final otherColors =
        _availableColors.where((color) => color != targetColor).toList();
    otherColors.shuffle();

    // Add 3 random colors from the remaining colors
    for (int i = 0; i < 3 && i < otherColors.length; i++) {
      availableColorsForDisplay.add(otherColors[i]);
    }

    // Shuffle the final list to randomize positions
    availableColorsForDisplay.shuffle();

    _gameState = _gameState.copyWith(
      targetColorName: targetColorName,
      targetColor: targetColor,
      textColor: textColor,
      availableColors: availableColorsForDisplay,
    );
  }

  /// Renk kutusuna tıklandığında
  void onColorTap(int index) {
    if (!_gameState.isGameActive) return;

    final tappedColor = _gameState.availableColors[index];

    if (tappedColor == _gameState.targetColor) {
      // Doğru renk seçildi
      _correctAnswer();
    } else {
      // Yanlış renk seçildi
      _wrongAnswer(index);
    }
  }

  /// Doğru cevap
  void _correctAnswer() async {
    // Rekor kırıldıysa anında sesi çal (ilk skor hariç, bir kez, oyun aktifken)
    final previousEntry = await LeaderboardUtils.getLeaderboardEntry(
      'color_hunt',
    );
    final previousHighScore = previousEntry?.highScore ?? 0;
    final newScore = _gameState.score + 1;
    // Oyun bitti flag'i ve aktiflik kontrolü, async gap sonrası tekrar kontrol
    if (!_hasBrokenRecordThisGame &&
        previousEntry != null &&
        newScore > previousHighScore &&
        _gameState.isGameActive) {
      SoundUtils.playNewLevelSound();
      _hasBrokenRecordThisGame = true;
    }
    // Blink sesi çal (asenkron, await yok)
    SoundUtils.playBlinkSound();

    _gameState = _gameState.copyWith(score: newScore, wrongTapIndex: null);

    _generateNewTarget();
    notifyListeners();
  }

  /// Yanlış cevap
  void _wrongAnswer(int wrongIndex) {
    _stopTimer();
    _hasBrokenRecordThisGame = true;

    // Ensure we capture the final score before setting game over
    final finalScore = _gameState.score;

    _gameState = _gameState.copyWith(
      wrongTapIndex: wrongIndex,
      status: ColorHuntGameStatus.gameOver,
      showGameOver: true,
      score: finalScore, // Explicitly set the final score
    );

    notifyListeners();

    // Yüksek skoru güncelle
    _updateHighScore();
  }

  /// Oyun bitti
  void _gameOver() async {
    _stopTimer();
    _hasBrokenRecordThisGame = true;

    // Ensure we capture the final score before setting game over
    final finalScore = _gameState.score;

    _gameState = _gameState.copyWith(
      status: ColorHuntGameStatus.gameOver,
      showGameOver: true,
      score: finalScore, // Explicitly set the final score
    );

    // Yüksek skoru güncelle
    _updateHighScore();
    notifyListeners();
  }

  /// Yüksek skoru güncelle
  void _updateHighScore() async {
    final previousHighScore = await LeaderboardUtils.getHighScore('color_hunt');
    if (_gameState.score > previousHighScore) {
      SoundUtils.playNewLevelSound();
    }
    await LeaderboardUtils.updateHighScore('color_hunt', _gameState.score);
  }

  /// Oyunu sıfırla
  void resetGame() {
    _stopTimer();
    _gameState = const ColorHuntGameState();
    _hasBrokenRecordThisGame = false;
    notifyListeners();
  }

  /// Game over animasyonunu gizle
  void hideGameOver() {
    _gameState = _gameState.copyWith(showGameOver: false);
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
