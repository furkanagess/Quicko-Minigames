import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../../shared/models/aim_trainer_game_state.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/utils/sound_utils.dart';

class AimTrainerProvider extends ChangeNotifier {
  AimTrainerGameState _gameState = const AimTrainerGameState();
  Timer? _timer;
  final Random _random = Random();
  Size? _gameAreaSize;
  bool _hasBrokenRecordThisGame = false;

  AimTrainerGameState get gameState => _gameState;

  /// Set the game area size for target positioning
  void setGameAreaSize(Size size) {
    _gameAreaSize = size;
    if (_gameState.isGameActive) {
      _generateNewTarget();
    }
  }

  /// Start the game
  void startGame() async {
    _hasBrokenRecordThisGame = false;
    _gameState = _gameState.copyWith(
      score: 0,
      timeLeft: 20,
      status: AimTrainerGameStatus.playing,
      showGameOver: false,
    );

    _generateNewTarget();
    _startTimer();

    // Oyun başlama sesi çal
    await SoundUtils.playGameStartSound();

    notifyListeners();
  }

  /// Start the timer
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

  /// Stop the timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Generate a new target at a random position
  void _generateNewTarget() {
    if (_gameAreaSize == null) return;

    // Target radius is 24px, so we need to account for that in positioning
    const targetRadius = 24.0;
    final maxX = _gameAreaSize!.width - targetRadius;
    final maxY = _gameAreaSize!.height - targetRadius;
    final minX = targetRadius;
    final minY = targetRadius;

    final newX = minX + _random.nextDouble() * (maxX - minX);
    final newY = minY + _random.nextDouble() * (maxY - minY);

    _gameState = _gameState.copyWith(targetPosition: Offset(newX, newY));
  }

  /// Handle target tap
  void onTargetTap() async {
    if (!_gameState.isGameActive) return;

    final newScore = _gameState.score + 1;
    // Rekor kırıldıysa anında sesi çal (ilk skor hariç, bir kez, oyun aktifken)
    final previousEntry = await LeaderboardUtils.getLeaderboardEntry(
      'aim_trainer',
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
    _gameState = _gameState.copyWith(score: newScore);

    // Laser sesi çal (asenkron, await yok)
    SoundUtils.playLaserSound();

    _generateNewTarget();
    notifyListeners();
  }

  /// Game over
  void _gameOver() async {
    _stopTimer();
    _hasBrokenRecordThisGame = true;

    // Ensure we capture the final score before setting game over
    final finalScore = _gameState.score;

    _gameState = _gameState.copyWith(
      status: AimTrainerGameStatus.gameOver,
      showGameOver: true,
      score: finalScore, // Explicitly set the final score
    );

    // Oyun bitiş sesi çal
    await SoundUtils.playGameOverSound();

    // Update high score
    _updateHighScore();
    notifyListeners();
  }

  /// Update high score
  void _updateHighScore() async {
    final previousHighScore = await LeaderboardUtils.getHighScore(
      'aim_trainer',
    );
    if (_gameState.score > previousHighScore) {
      SoundUtils.playNewLevelSound();
    }
    await LeaderboardUtils.updateHighScore(
      'aim_trainer',
      'Aim Trainer',
      _gameState.score,
    );
  }

  /// Reset the game
  void resetGame() {
    _stopTimer();
    _gameState = const AimTrainerGameState();
    _hasBrokenRecordThisGame = false;
    notifyListeners();
  }

  /// Hide game over animation
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
