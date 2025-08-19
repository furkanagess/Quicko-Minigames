import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/color_hunt_game_state.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/utils/sound_utils.dart';
import '../../../core/services/game_state_service.dart';

class ColorHuntProvider extends ChangeNotifier {
  ColorHuntGameState _gameState = const ColorHuntGameState();
  Timer? _timer;
  final Random _random = Random();
  bool _hasBrokenRecordThisGame = false;
  bool _hasUsedContinue = false;

  ColorHuntGameState get gameState => _gameState;

  // Enhanced color keys with more distinct and easily differentiable colors
  final Map<String, Color> _colorMap = {
    'red': const Color(0xFFE53E3E), // Bright red
    'green': const Color(0xFF38A169), // Bright green
    'blue': const Color(0xFF3182CE), // Bright blue
    'purple': const Color(0xFF805AD5), // Bright purple
    'orange': const Color(0xFFFF6B35), // Vibrant orange
    'yellow': const Color(0xFFFFD700), // Gold yellow
    'pink': const Color(0xFFE91E63), // Hot pink
    'brown': const Color(0xFF8B4513), // Saddle brown
    'cyan': const Color(0xFF00BCD4), // Bright cyan
    'lime': const Color(0xFF4CAF50), // Material green
    'magenta': const Color(0xFF9C27B0), // Purple magenta
    'teal': const Color(0xFF009688), // Material teal
    'indigo': const Color(0xFF3F51B5), // Indigo
    'amber': const Color(0xFFFF9800), // Material amber
    'deep_purple': const Color(0xFF673AB7), // Deep purple
    'light_blue': const Color(0xFF03A9F4), // Light blue
  };

  // Enhanced available colors list with more distinct options
  final List<Color> _availableColors = [
    const Color(0xFFE53E3E), // Bright red
    const Color(0xFF38A169), // Bright green
    const Color(0xFF3182CE), // Bright blue
    const Color(0xFF805AD5), // Bright purple
    const Color(0xFFFF6B35), // Vibrant orange
    const Color(0xFFFFD700), // Gold yellow
    const Color(0xFFE91E63), // Hot pink
    const Color(0xFF8B4513), // Saddle brown
    const Color(0xFF00BCD4), // Bright cyan
    const Color(0xFF4CAF50), // Material green
    const Color(0xFF9C27B0), // Purple magenta
    const Color(0xFF009688), // Material teal
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFFFF9800), // Material amber
    const Color(0xFF673AB7), // Deep purple
    const Color(0xFF03A9F4), // Light blue
  ];

  /// Oyunu başlat
  void startGame() {
    _hasBrokenRecordThisGame = false;
    _hasUsedContinue = false;
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

    // Create more interesting text color combinations
    // Sometimes use the same color as target (creates confusion), sometimes different
    Color textColor;
    final useSameColor = _random.nextBool(); // 50% chance to use same color

    if (useSameColor) {
      // Use the same color as target (creates visual confusion)
      textColor = targetColor;
    } else {
      // Use a different color (traditional approach)
      do {
        textColor = _availableColors[_random.nextInt(_availableColors.length)];
      } while (textColor == targetColor);
    }

    // Ensure target color is always in the available options
    final availableColorsForDisplay = <Color>[];

    // First, add the target color
    availableColorsForDisplay.add(targetColor);

    // Then add 3 other distinct colors (excluding target color and similar colors)
    final otherColors =
        _availableColors.where((color) => color != targetColor).toList();
    otherColors.shuffle();

    // Add 3 distinct colors, avoiding colors that are too similar
    for (int i = 0; i < 3 && i < otherColors.length; i++) {
      final candidateColor = otherColors[i];

      // Check if this color is too similar to any already selected color
      bool isTooSimilar = false;
      for (final selectedColor in availableColorsForDisplay) {
        if (_isColorTooSimilar(candidateColor, selectedColor)) {
          isTooSimilar = true;
          break;
        }
      }

      if (!isTooSimilar) {
        availableColorsForDisplay.add(candidateColor);
      } else {
        // Try to find a more distinct color
        for (int j = i + 1; j < otherColors.length; j++) {
          final alternativeColor = otherColors[j];
          bool isAlternativeTooSimilar = false;

          for (final selectedColor in availableColorsForDisplay) {
            if (_isColorTooSimilar(alternativeColor, selectedColor)) {
              isAlternativeTooSimilar = true;
              break;
            }
          }

          if (!isAlternativeTooSimilar) {
            availableColorsForDisplay.add(alternativeColor);
            break;
          }
        }

        // If we still don't have enough colors, just add the original
        if (availableColorsForDisplay.length < 4) {
          availableColorsForDisplay.add(candidateColor);
        }
      }
    }

    // Shuffle the final list to randomize positions
    availableColorsForDisplay.shuffle();

    debugPrint(
      'Color Hunt: New target generated - Available colors: $availableColorsForDisplay, Text color: $textColor, Same color: $useSameColor',
    );

    _gameState = _gameState.copyWith(
      targetColorKey: targetColorKey,
      targetColor: targetColor,
      textColor: textColor,
      availableColors: availableColorsForDisplay,
    );
  }

  /// Check if two colors are too similar to each other
  bool _isColorTooSimilar(Color color1, Color color2) {
    // Convert colors to HSV for better similarity comparison
    final hsv1 = HSVColor.fromColor(color1);
    final hsv2 = HSVColor.fromColor(color2);

    // Calculate hue difference (considering circular nature of hue)
    double hueDiff = (hsv1.hue - hsv2.hue).abs();
    if (hueDiff > 180) hueDiff = 360 - hueDiff;

    // Calculate saturation and value differences
    final satDiff = (hsv1.saturation - hsv2.saturation).abs();
    final valDiff = (hsv1.value - hsv2.value).abs();

    // Colors are too similar if:
    // - Hue difference is less than 30 degrees AND
    // - Saturation difference is less than 0.3 AND
    // - Value difference is less than 0.3
    return hueDiff < 30 && satDiff < 0.3 && valDiff < 0.3;
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
    _hasUsedContinue = false;
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
      final savedTimeLeft = (saved['timeLeft'] as int?) ?? 30;

      debugPrint(
        'Color Hunt: Continuing game - Score: $savedScore, Time: $savedTimeLeft',
      );

      // Restore game state with both score and time from where user left off
      _gameState = _gameState.copyWith(
        score: savedScore,
        timeLeft: savedTimeLeft, // Restore the actual time left
        status: ColorHuntGameStatus.playing,
        showGameOver: false,
        wrongTapIndex: null,
      );

      debugPrint('Color Hunt: Basic state restored, generating new target...');

      // Generate a new target as if user never made a mistake
      _generateNewTarget();

      debugPrint(
        'Color Hunt: New target generated, restarting timer with saved time: $savedTimeLeft...',
      );

      // Restart the timer with the saved time (not reset to 30)
      _startTimer();

      // Clear the saved state after successful restore
      await clearSavedGameState();

      // Mark that continue has been used
      _hasUsedContinue = true;

      debugPrint(
        'Color Hunt: Game continued with new target and restored time successfully',
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error continuing Color Hunt game: $e');
      return false;
    }
  }

  Future<bool> canContinueGame() async {
    if (_hasUsedContinue) return false;
    final hasState = await GameStateService().hasGameState('color_hunt');
    debugPrint(
      'Color Hunt: canContinueGame check - Has state: $hasState, hasUsedContinue: $_hasUsedContinue',
    );
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
