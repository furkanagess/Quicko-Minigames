import 'package:flutter/material.dart';

enum AimTrainerGameStatus { waiting, playing, gameOver }

class AimTrainerGameState {
  final int score;
  final int timeLeft;
  final Offset targetPosition;
  final AimTrainerGameStatus status;
  final bool showGameOver;

  const AimTrainerGameState({
    this.score = 0,
    this.timeLeft = 20,
    this.targetPosition = const Offset(0, 0),
    this.status = AimTrainerGameStatus.waiting,
    this.showGameOver = false,
  });

  AimTrainerGameState copyWith({
    int? score,
    int? timeLeft,
    Offset? targetPosition,
    AimTrainerGameStatus? status,
    bool? showGameOver,
  }) {
    return AimTrainerGameState(
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      targetPosition: targetPosition ?? this.targetPosition,
      status: status ?? this.status,
      showGameOver: showGameOver ?? this.showGameOver,
    );
  }

  bool get isGameActive => status == AimTrainerGameStatus.playing;
  bool get isWaiting => status == AimTrainerGameStatus.waiting;
  bool get isGameOver => status == AimTrainerGameStatus.gameOver;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AimTrainerGameState &&
        other.score == score &&
        other.timeLeft == timeLeft &&
        other.targetPosition == targetPosition &&
        other.status == status &&
        other.showGameOver == showGameOver;
  }

  @override
  int get hashCode {
    return Object.hash(score, timeLeft, targetPosition, status, showGameOver);
  }
}
