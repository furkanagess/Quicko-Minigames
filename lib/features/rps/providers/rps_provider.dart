import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/rps_game_state.dart';
import '../../../core/utils/leaderboard_utils.dart';
import '../../../core/utils/sound_utils.dart';
import '../../../core/utils/localization_utils.dart';

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
    if (_state.showGameOver || _state.isWaiting) return;

    SoundUtils.playTapSound();
    _state = _state.copyWith(playerPick: pick, cpuPick: null);
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
      _state = _state.copyWith(isCpuAnimating: false, cpuPick: cpu);

      final res = _roundResult(pick, cpu);
      if (res > 0) {
        _state = _state.copyWith(
          bannerText: LocalizationUtils.getStringGlobal('youWin'),
          youScore: _state.youScore + 1,
        );
        SoundUtils.playNewLevelSound();
      } else if (res < 0) {
        _state = _state.copyWith(
          bannerText: LocalizationUtils.getStringGlobal('youLose'),
          cpuScore: _state.cpuScore + 1,
        );
        SoundUtils.playLaserSound();
      } else {
        _state = _state.copyWith(
          bannerText: LocalizationUtils.getStringGlobal('tie'),
        );
      }
      _state = _state.copyWith(showBanner: true);
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 900));
      _state = _state.copyWith(showBanner: false);
      notifyListeners();

      if (_state.youScore >= 5 || _state.cpuScore >= 5) {
        final youWon = _state.youScore >= 5;
        _state = _state.copyWith(showGameOver: true, youWon: youWon);
        notifyListeners();
        await LeaderboardUtils.updateHighScore('rps', _state.youScore);
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
}
