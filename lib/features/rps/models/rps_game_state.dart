import 'package:flutter/material.dart';

enum RpsChoice { rock, paper, scissors }

@immutable
class RpsGameState {
  final int youScore;
  final int cpuScore;
  final RpsChoice? playerPick;
  final RpsChoice? cpuPick;
  final String bannerText;
  final bool showBanner;
  final bool isWaiting;
  final bool isCpuAnimating;
  final String cpuAnimEmoji;
  final bool showGameOver;
  final bool youWon;

  const RpsGameState({
    this.youScore = 0,
    this.cpuScore = 0,
    this.playerPick,
    this.cpuPick,
    this.bannerText = '',
    this.showBanner = false,
    this.isWaiting = true,
    this.isCpuAnimating = false,
    this.cpuAnimEmoji = '❓',
    this.showGameOver = false,
    this.youWon = false,
  });

  RpsGameState copyWith({
    int? youScore,
    int? cpuScore,
    RpsChoice? playerPick,
    RpsChoice? cpuPick,
    String? bannerText,
    bool? showBanner,
    bool? isWaiting,
    bool? isCpuAnimating,
    String? cpuAnimEmoji,
    bool? showGameOver,
    bool? youWon,
    bool unsetPlayerPick = false,
    bool unsetCpuPick = false,
  }) {
    return RpsGameState(
      youScore: youScore ?? this.youScore,
      cpuScore: cpuScore ?? this.cpuScore,
      playerPick: unsetPlayerPick ? null : (playerPick ?? this.playerPick),
      cpuPick: unsetCpuPick ? null : (cpuPick ?? this.cpuPick),
      bannerText: bannerText ?? this.bannerText,
      showBanner: showBanner ?? this.showBanner,
      isWaiting: isWaiting ?? this.isWaiting,
      isCpuAnimating: isCpuAnimating ?? this.isCpuAnimating,
      cpuAnimEmoji: cpuAnimEmoji ?? this.cpuAnimEmoji,
      showGameOver: showGameOver ?? this.showGameOver,
      youWon: youWon ?? this.youWon,
    );
  }
}
