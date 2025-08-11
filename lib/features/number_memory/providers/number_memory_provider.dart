import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quicko_app/l10n/app_localizations.dart';
import '../models/number_memory_game_state.dart';
import '../../../core/utils/sound_utils.dart';
import '../../../core/utils/leaderboard_utils.dart';

class NumberMemoryProvider extends ChangeNotifier {
  NumberMemoryGameState _gameState = const NumberMemoryGameState();
  Timer? _sequenceTimer;
  Timer? _correctMessageTimer;

  NumberMemoryGameState get gameState => _gameState;

  @override
  void dispose() {
    _sequenceTimer?.cancel();
    _correctMessageTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    _gameState = _gameState.copyWith(level: 1, score: 0, isGameActive: true);
    _generateNewSequence();
    notifyListeners();
  }

  void _generateNewSequence() {
    final random = Random();
    final sequence = <int>[];

    for (int i = 0; i < _gameState.level; i++) {
      sequence.add(random.nextInt(9) + 1); // 1-9 digits (no 0)
    }

    _gameState = _gameState.copyWith(
      sequence: sequence,
      userInput: [],
      isShowingSequence: true,
      isWaitingForInput: false,
      showCorrectMessage: false,
      wrongIndices: [],
    );

    // Show sequence for 2 seconds
    _sequenceTimer = Timer(const Duration(seconds: 2), () {
      _gameState = _gameState.copyWith(
        isShowingSequence: false,
        isWaitingForInput: true,
      );
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
      _gameState = _gameState.copyWith(
        showCorrectMessage: false,
        level: _gameState.level + 1,
        score: _gameState.score + 1,
      );
      _generateNewSequence();
      notifyListeners();
    });

    notifyListeners();
  }

  void _handleWrongAnswer(List<int> wrongIndices) async {
    // Play error sound
    SoundUtils.playGameOverSound();

    _gameState = _gameState.copyWith(
      wrongIndices: wrongIndices,
      isWaitingForInput: false,
      showGameOver: true,
    );

    // Update leaderboard
    await LeaderboardUtils.updateHighScore('number_memory', _gameState.score);

    notifyListeners();
  }

  void restartGame() {
    _sequenceTimer?.cancel();
    _correctMessageTimer?.cancel();

    _gameState = const NumberMemoryGameState();
    startGame();
  }

  void resetGame() {
    _sequenceTimer?.cancel();
    _correctMessageTimer?.cancel();

    _gameState = const NumberMemoryGameState();
    notifyListeners();
  }

  /// Hide game over flag to prevent duplicate dialogs
  void hideGameOver() {
    if (_gameState.showGameOver) {
      _gameState = _gameState.copyWith(showGameOver: false);
      notifyListeners();
    }
  }
}
