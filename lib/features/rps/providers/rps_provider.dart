import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/rps_game_state.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/utils/sound_utils.dart';
import '../../../core/services/game_state_service.dart';

class RpsProvider extends ChangeNotifier {
  final Random _rng = Random();
  Timer? _cpuAnimTimer;
  RpsGameState _state = const RpsGameState();

  RpsGameState get state => _state;

  void start() {
    _state = _state.copyWith(isWaiting: false);
    notifyListeners();
  }

  void reset() {
    _cpuAnimTimer?.cancel();
    _state = const RpsGameState();
    notifyListeners();
  }

  void hideDialog() {
    _state = _state.copyWith(showGameOver: false);
    notifyListeners();
  }

  void onPick(RpsChoice pick) {
    if (_state.showGameOver ||
        _state.isWaiting ||
        _state.isPlayerSelectionLocked)
      return;

    SoundUtils.playTapSound();
    _state = _state.copyWith(
      playerPick: pick,
      cpuPick: null,
      isPlayerSelectionLocked: true,
    );
    notifyListeners();

    // start cpu animation
    const emojis = ['✊', '✋', '✌️'];
    int idx = 0;
    _cpuAnimTimer?.cancel();
    SoundUtils.playSpinnerSound();
    _state = _state.copyWith(isCpuAnimating: true);
    notifyListeners();

    _cpuAnimTimer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      _state = _state.copyWith(cpuAnimEmoji: emojis[idx % emojis.length]);
      idx++;
      notifyListeners();
    });

    Future.delayed(const Duration(milliseconds: 650), () async {
      _cpuAnimTimer?.cancel();
      await SoundUtils.stopSpinnerSound();
      final cpu = RpsChoice.values[_rng.nextInt(3)];
      _state = _state.copyWith(
        isCpuAnimating: false,
        cpuPick: cpu,
        isPlayerSelectionLocked: false,
      );

      final res = _roundResult(pick, cpu);
      if (res > 0) {
        _state = _state.copyWith(
          bannerTextKey: 'youWin',
          youScore: _state.youScore + 1,
        );
        SoundUtils.playNewLevelSound();
      } else if (res < 0) {
        _state = _state.copyWith(
          bannerTextKey: 'youLose',
          cpuScore: _state.cpuScore + 1,
        );
        SoundUtils.playLaserSound();
      } else {
        _state = _state.copyWith(bannerTextKey: 'tie');
      }
      _state = _state.copyWith(showBanner: true);
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 900));
      _state = _state.copyWith(
        showBanner: false,
        isPlayerSelectionLocked: false,
      );
      notifyListeners();

      if (_state.youScore >= 5 || _state.cpuScore >= 5) {
        final youWon = _state.youScore >= 5;
        _state = _state.copyWith(showGameOver: true, youWon: youWon);
        notifyListeners();
        await LeaderboardUtils.updateHighScore('rps', _state.youScore);
        // Save state for rewarded-continue
        await _saveGameState();
      }
    });
  }

  int _roundResult(RpsChoice a, RpsChoice b) {
    if (a == b) return 0;
    if ((a == RpsChoice.rock && b == RpsChoice.scissors) ||
        (a == RpsChoice.paper && b == RpsChoice.rock) ||
        (a == RpsChoice.scissors && b == RpsChoice.paper)) {
      return 1;
    }
    return -1;
  }

  Future<void> _saveGameState() async {
    final state = {'youScore': _state.youScore, 'cpuScore': _state.cpuScore};
    await GameStateService().saveGameState('rps', state);
    await GameStateService().saveGameScore('rps', _state.youScore);
  }

  Future<bool> continueGame() async {
    final saved = await GameStateService().loadGameState('rps');
    if (saved == null) return false;
    try {
      // Reduce CPU score by 1 as a reward for watching the ad
      final savedCpuScore = (saved['cpuScore'] as int?) ?? 0;
      final reducedCpuScore = savedCpuScore > 0 ? savedCpuScore - 1 : 0;

      _state = _state.copyWith(
        youScore: (saved['youScore'] as int?) ?? 0,
        cpuScore: reducedCpuScore,
        showGameOver: false,
        isCpuAnimating: false,
        cpuPick: null,
        playerPick: null,
        isPlayerSelectionLocked: false,
      );

      // Clear the saved state after successful restore
      await clearSavedGameState();

      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> canContinueGame() async {
    return await GameStateService().hasGameState('rps');
  }

  Future<void> clearSavedGameState() async {
    await GameStateService().clearGameState('rps');
  }
}
