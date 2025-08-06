class LeaderboardEntry {
  final String gameId;
  final String gameTitle;
  final int highScore;
  final DateTime? lastPlayed;

  const LeaderboardEntry({
    required this.gameId,
    required this.gameTitle,
    required this.highScore,
    this.lastPlayed,
  });

  LeaderboardEntry copyWith({
    String? gameId,
    String? gameTitle,
    int? highScore,
    DateTime? lastPlayed,
  }) {
    return LeaderboardEntry(
      gameId: gameId ?? this.gameId,
      gameTitle: gameTitle ?? this.gameTitle,
      highScore: highScore ?? this.highScore,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'gameTitle': gameTitle,
      'highScore': highScore,
      'lastPlayed': lastPlayed?.toIso8601String(),
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      gameId: json['gameId'] as String,
      gameTitle: json['gameTitle'] as String,
      highScore: json['highScore'] as int,
      lastPlayed:
          json['lastPlayed'] != null
              ? DateTime.parse(json['lastPlayed'] as String)
              : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardEntry &&
        other.gameId == gameId &&
        other.gameTitle == gameTitle &&
        other.highScore == highScore &&
        other.lastPlayed == lastPlayed;
  }

  @override
  int get hashCode {
    return Object.hash(gameId, gameTitle, highScore, lastPlayed);
  }

  @override
  String toString() {
    return 'LeaderboardEntry(gameId: $gameId, gameTitle: $gameTitle, highScore: $highScore, lastPlayed: $lastPlayed)';
  }
}
