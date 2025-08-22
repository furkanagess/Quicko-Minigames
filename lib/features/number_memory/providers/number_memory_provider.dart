import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/number_memory_game_state.dart';
import '../../../core/utils/sound_utils.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/services/game_state_service.dart';

class NumberMemoryProvider extends ChangeNotifier {
  NumberMemoryGameState _gameState = const NumberMemoryGameState();
  Timer? _sequenceTimer;
  Timer? _correctMessageTimer;
  bool _hasUsedContinue = false;
  DateTime? _inputStartTime;

  NumberMemoryGameState get gameState => _gameState;

  @override
  void dispose() {
    _sequenceTimer?.cancel();
    _correctMessageTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    _hasUsedContinue = false;
    _inputStartTime = null;
    // Start at a slightly higher level to make early game more engaging
    _gameState = _gameState.copyWith(level: 3, score: 0, isGameActive: true);
    _generateNewSequence();
    notifyListeners();
  }

  void _generateNewSequence({bool isAfterAd = false}) {
    final random = Random();
    final sequence = <int>[];

    for (int i = 0; i < _gameState.level; i++) {
      // Always use digits 1-9 (no zero) as requested
      sequence.add(random.nextInt(9) + 1);
    }

    _gameState = _gameState.copyWith(
      sequence: sequence,
      userInput: [],
      isShowingSequence: true,
      isWaitingForInput: false,
      showCorrectMessage: false,
      wrongIndices: [],
    );

    // Show sequence for different durations based on context
    final displayDurationSeconds =
        isAfterAd ? 4 : 2; // Keep brief to raise challenge
    _sequenceTimer = Timer(Duration(seconds: displayDurationSeconds), () {
      _gameState = _gameState.copyWith(
        isShowingSequence: false,
        isWaitingForInput: true,
      );
      // Start timing user input for potential speed bonus
      _inputStartTime = DateTime.now();
      notifyListeners();
    });

    notifyListeners();
  }

  void onNumberPressed(int number) {
    if (!_gameState.isWaitingForInput ||
        _gameState.userInput.length >= _gameState.level) {
      return;
    }

    // Play sound
    SoundUtils.playTapSound();

    final newUserInput = List<int>.from(_gameState.userInput)..add(number);

    _gameState = _gameState.copyWith(userInput: newUserInput);

    // Check if user has entered all digits
    if (newUserInput.length == _gameState.level) {
      _checkAnswer();
    }

    notifyListeners();
  }

  void onDeletePressed() {
    if (!_gameState.isWaitingForInput || _gameState.userInput.isEmpty) {
      return;
    }

    // Play sound
    SoundUtils.playTapSound();

    final newUserInput = List<int>.from(_gameState.userInput);
    newUserInput.removeLast();

    _gameState = _gameState.copyWith(userInput: newUserInput);
    notifyListeners();
  }

  void _checkAnswer() {
    bool isCorrect = true;
    final wrongIndices = <int>[];

    for (int i = 0; i < _gameState.sequence.length; i++) {
      if (_gameState.userInput[i] != _gameState.sequence[i]) {
        isCorrect = false;
        wrongIndices.add(i);
      }
    }

    if (isCorrect) {
      _handleCorrectAnswer();
    } else {
      _handleWrongAnswer(wrongIndices);
    }
  }

  void _handleCorrectAnswer() {
    // Play success sound
    SoundUtils.playNewLevelSound();

    _gameState = _gameState.copyWith(
      showCorrectMessage: true,
      isWaitingForInput: false,
    );

    // Show correct message briefly
    _correctMessageTimer = Timer(const Duration(milliseconds: 1500), () {
      // Calculate speed bonus: if user finishes under level*800ms, grant +1 bonus
      int bonus = 0;
      if (_inputStartTime != null) {
        final int elapsedMs =
            DateTime.now().difference(_inputStartTime!).inMilliseconds;
        final int thresholdMs = (_gameState.level * 800);
        if (elapsedMs <= thresholdMs) {
          bonus = 1;
          if (kDebugMode) {
            print(
              'NumberMemory: Speed bonus awarded (elapsed ${elapsedMs}ms, threshold ${thresholdMs}ms)',
            );
          }
        }
      }

      _gameState = _gameState.copyWith(
        showCorrectMessage: false,
        level: _gameState.level + 1,
        score: _gameState.score + 1 + bonus,
      );
      _generateNewSequence();
      notifyListeners();
    });

    notifyListeners();
  }

  void _handleWrongAnswer(List<int> wrongIndices) async {
    // Play error sound
    SoundUtils.playGameOverSound();

    if (kDebugMode) {
      print('NumberMemory: Wrong answer detected, showing continue dialog');
    }

    _gameState = _gameState.copyWith(
      wrongIndices: wrongIndices,
      isWaitingForInput: false,
      showGameOver: false, // Don't show game over dialog
      showContinueDialog: true, // Show continue game dialog
    );

    // Update leaderboard
    await LeaderboardUtils.updateHighScore('number_memory', _gameState.score);

    notifyListeners();

    // Save state for rewarded-continue
    await _saveGameState();

    if (kDebugMode) {
      print(
        'NumberMemory: Game state saved, continue dialog should be visible',
      );
    }
  }

  void restartGame() {
    _sequenceTimer?.cancel();
    _correctMessageTimer?.cancel();

    _gameState = const NumberMemoryGameState();
    _inputStartTime = null;
    startGame();
  }

  void resetGame() {
    _sequenceTimer?.cancel();
    _correctMessageTimer?.cancel();

    _gameState = const NumberMemoryGameState();
    _hasUsedContinue = false;
    _inputStartTime = null;
    notifyListeners();
  }

  Future<void> _saveGameState() async {
    final state = {
      'level': _gameState.level,
      'score': _gameState.score,
      'sequence': _gameState.sequence,
    };
    await GameStateService().saveGameState('number_memory', state);
    await GameStateService().saveGameScore('number_memory', _gameState.score);
  }

  Future<bool> continueGame() async {
    if (kDebugMode) {
      print('NumberMemory: Continue game requested');
    }

    final saved = await GameStateService().loadGameState('number_memory');
    if (saved == null) {
      if (kDebugMode) {
        print('NumberMemory: No saved state found');
      }
      return false;
    }

    try {
      // When continuing after watching ad, advance to next level
      // but keep the current score
      final currentLevel = (saved['level'] as int?) ?? 1;
      final currentScore = (saved['score'] as int?) ?? 0;

      if (kDebugMode) {
        print(
          'NumberMemory: Restoring game state - Level: $currentLevel -> ${currentLevel + 1}, Score: $currentScore',
        );
      }

      // Clear the saved state after successful restore
      await clearSavedGameState();

      // Mark that continue has been used
      _hasUsedContinue = true;

      // Set the new level and score first
      _gameState = _gameState.copyWith(
        level: currentLevel + 1, // Continue from next level
        score: currentScore, // Keep current score
        isGameActive: true,
        showGameOver: false,
        showContinueDialog: false,
      );

      // Generate new sequence for the next level and show it
      _generateNewSequence(isAfterAd: true);

      if (kDebugMode) {
        print(
          'NumberMemory: Game continued successfully to level ${currentLevel + 1}',
        );
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('NumberMemory: Error continuing game: $e');
      }
      return false;
    }
  }

  Future<bool> canContinueGame() async {
    if (_hasUsedContinue) return false;
    final canContinue = await GameStateService().hasGameState('number_memory');
    if (kDebugMode) {
      print(
        'NumberMemory: Can continue game: $canContinue, hasUsedContinue: $_hasUsedContinue',
      );
    }
    return canContinue;
  }

  Future<void> clearSavedGameState() async {
    await GameStateService().clearGameState('number_memory');
  }

  /// Hide game over flag to prevent duplicate dialogs
  void hideGameOver() {
    if (_gameState.showGameOver) {
      _gameState = _gameState.copyWith(showGameOver: false);
      notifyListeners();
    }
  }

  /// Hide continue dialog
  void hideContinueDialog() {
    if (_gameState.showContinueDialog) {
      if (kDebugMode) {
        print('NumberMemory: Hiding continue dialog');
      }
      _gameState = _gameState.copyWith(showContinueDialog: false);
      notifyListeners();
    }
  }

  /// Pause the game (no timer to pause for this game)
  void pauseGame() {
    // This game doesn't have a timer, so nothing to pause
  }

  /// Resume the game (no timer to resume for this game)
  void resumeGame() {
    // This game doesn't have a timer, so nothing to resume
  }
}
