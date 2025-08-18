import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/color_hunt_game_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/utils/sound_utils.dart';
import '../../../core/services/game_state_service.dart';

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

  /// Pause the game (stop timer)
  void pauseGame() {
    if (_gameState.isGameActive) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Resume the game (restart timer)
  void resumeGame() {
    if (_gameState.isGameActive) {
      _startTimer();
    }
  }

  /// Clean up game state when exiting
  void cleanupGame() {
    _stopTimer();
    _gameState = const ColorHuntGameState();
    _hasBrokenRecordThisGame = false;
    notifyListeners();
  }

  /// Yeni hedef oluştur
  void _generateNewTarget() {
    final colorKeys = _colorMap.keys.toList();
    final targetColorKey = colorKeys[_random.nextInt(colorKeys.length)];
    final targetColor = _colorMap[targetColorKey]!;

    debugPrint(
      'Color Hunt: Generating new target - Key: $targetColorKey, Color: $targetColor',
    );

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

    debugPrint(
      'Color Hunt: New target generated - Available colors: $availableColorsForDisplay, Text color: $textColor',
    );

    _gameState = _gameState.copyWith(
      targetColorKey: targetColorKey,
      targetColor: targetColor,
      textColor: textColor,
      availableColors: availableColorsForDisplay,
    );
  }

  /// Renk kutusuna tıklandığında
  void onColorTap(int index) {
    if (!_gameState.isGameActive) return;

    final tappedColor = _gameState.availableColors[index];
    final targetColor = _gameState.targetColor;

    debugPrint(
      'Color Hunt: Color tapped - Index: $index, Tapped: $tappedColor, Target: $targetColor, Match: ${tappedColor == targetColor}',
    );

    if (tappedColor == targetColor) {
      // Doğru renk seçildi
      debugPrint('Color Hunt: Correct color selected');
      _correctAnswer();
    } else {
      // Yanlış renk seçildi
      debugPrint('Color Hunt: Wrong color selected');
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

    // Clear any saved state since user is continuing successfully
    await clearSavedGameState();

    notifyListeners();
  }

  /// Yanlış cevap
  void _wrongAnswer(int wrongIndex) async {
    _stopTimer();
    _hasBrokenRecordThisGame = true;

    // Ensure we capture the final score before setting game over
    final finalScore = _gameState.score;

    debugPrint('Color Hunt: Wrong answer - Final score: $finalScore');

    // Save state BEFORE setting game over status
    await _saveGameState();

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

    debugPrint('Color Hunt: Game over - Final score: $finalScore');

    // Save state BEFORE setting game over status
    await _saveGameState();

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

  Future<void> _saveGameState() async {
    debugPrint(
      'Color Hunt: Saving game state - Score: ${_gameState.score}, Time: ${_gameState.timeLeft}',
    );

    final state = {'score': _gameState.score, 'timeLeft': _gameState.timeLeft};

    await GameStateService().saveGameState('color_hunt', state);
    await GameStateService().saveGameScore('color_hunt', _gameState.score);

    debugPrint('Color Hunt: Game state saved successfully');
  }

  Future<bool> continueGame() async {
    debugPrint('Color Hunt: Attempting to continue game...');

    final saved = await GameStateService().loadGameState('color_hunt');
    if (saved == null) {
      debugPrint('Color Hunt: No saved state found');
      return false;
    }

    try {
      final savedScore = (saved['score'] as int?) ?? 0;

      debugPrint(
        'Color Hunt: Continuing game - Score: $savedScore, Restarting timer from beginning',
      );

      // Restore game state with score but reset timer to initial value (30 seconds)
      _gameState = _gameState.copyWith(
        score: savedScore,
        timeLeft: 30, // Reset timer to initial value
        status: ColorHuntGameStatus.playing,
        showGameOver: false,
        wrongTapIndex: null,
      );

      debugPrint('Color Hunt: Basic state restored, generating new target...');

      // Generate a new target as if user never made a mistake
      _generateNewTarget();

      debugPrint(
        'Color Hunt: New target generated, restarting timer from beginning...',
      );

      // Restart the timer with the initial time (30 seconds)
      _startTimer();

      // Clear the saved state after successful restore
      await clearSavedGameState();

      debugPrint(
        'Color Hunt: Game continued with new target and fresh timer successfully',
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error continuing Color Hunt game: $e');
      return false;
    }
  }

  Future<bool> canContinueGame() async {
    final hasState = await GameStateService().hasGameState('color_hunt');
    debugPrint('Color Hunt: canContinueGame check - Has state: $hasState');
    return hasState;
  }

  Future<void> clearSavedGameState() async {
    debugPrint('Color Hunt: Clearing saved game state');
    await GameStateService().clearGameState('color_hunt');
    debugPrint('Color Hunt: Saved game state cleared');
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
