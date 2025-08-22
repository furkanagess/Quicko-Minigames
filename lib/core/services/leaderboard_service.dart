import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shared/models/global_leaderboard_entry.dart';
import '../../shared/models/user_ranking_info.dart';

class LeaderboardService {
  LeaderboardService._internal();
  static final LeaderboardService _instance = LeaderboardService._internal();
  factory LeaderboardService() => _instance;

  static const String _collection = 'leaderboards';
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns top N scores for a game, descending by score
  Future<List<GlobalLeaderboardEntry>> fetchTopEntries({
    required String gameId,
    int limit = 10,
  }) async {
    final snapshot =
        await _db
            .collection(_collection)
            .doc(gameId)
            .collection('entries')
            .orderBy('score', descending: true)
            .limit(limit)
            .get();

    return snapshot.docs
        .map((d) => GlobalLeaderboardEntry.fromMap(d.id, d.data()))
        .toList();
  }

  /// Always saves the user's score and returns their rank
  Future<int> saveUserScore({
    required String gameId,
    required String name,
    required String countryCode,
    required int score,
  }) async {
    if (score <= 0) return 0;

    final entriesRef = _db
        .collection(_collection)
        .doc(gameId)
        .collection('entries');

    // Add new entry
    await entriesRef.add({
      'gameId': gameId,
      'name': name,
      'countryCode': countryCode,
      'score': score,
    });

    // Get user's rank
    return await getUserRank(gameId: gameId, score: score);
  }

  /// Get user's rank for a specific score
  Future<int> getUserRank({required String gameId, required int score}) async {
    if (score <= 0) return 0;

    final snapshot =
        await _db
            .collection(_collection)
            .doc(gameId)
            .collection('entries')
            .orderBy('score', descending: true)
            .get();

    final entries =
        snapshot.docs
            .map((d) => GlobalLeaderboardEntry.fromMap(d.id, d.data()))
            .toList();

    int rank = 1;
    for (final entry in entries) {
      if (score >= entry.score) break;
      rank++;
    }

    return rank;
  }

  /// Get user's actual leaderboard score
  Future<int> getUserLeaderboardScore({
    required String gameId,
    required int userScore,
  }) async {
    if (userScore <= 0) return 0;

    final snapshot =
        await _db
            .collection(_collection)
            .doc(gameId)
            .collection('entries')
            .orderBy('score', descending: true)
            .get();

    final entries =
        snapshot.docs
            .map((d) => GlobalLeaderboardEntry.fromMap(d.id, d.data()))
            .toList();

    // Find the user's entry in the leaderboard
    for (final entry in entries) {
      if (entry.score == userScore) {
        return entry.score;
      }
    }

    // If not found, return the user's score (it might not be in leaderboard yet)
    return userScore;
  }

  /// Get ranking range for a user (e.g., "11-50", "51-99", "100-199")
  String getRankingRange(int rank) {
    if (rank <= 10) return rank.toString();

    if (rank <= 50) return '11-50';
    if (rank <= 99) return '51-99';
    if (rank <= 199) return '100-199';
    if (rank <= 299) return '200-299';
    if (rank <= 399) return '300-399';
    if (rank <= 499) return '400-499';
    if (rank <= 999) return '500-999';

    return '1000+';
  }

  /// Get comprehensive user ranking information
  Future<UserRankingInfo> getUserRankingInfo({
    required String gameId,
    required int userScore,
  }) async {
    if (userScore <= 0) {
      return const UserRankingInfo(
        rank: 0,
        rankingRange: 'N/A',
        totalEntries: 0,
        userScore: 0,
        leaderboardScore: 0,
      );
    }

    final rank = await getUserRank(gameId: gameId, score: userScore);
    final totalEntries = await getTotalEntries(gameId);
    final rankingRange = getRankingRange(rank);

    // Get the user's actual leaderboard score
    final leaderboardScore = await getUserLeaderboardScore(
      gameId: gameId,
      userScore: userScore,
    );

    return UserRankingInfo(
      rank: rank,
      rankingRange: rankingRange,
      totalEntries: totalEntries,
      userScore: userScore,
      leaderboardScore: leaderboardScore,
    );
  }

  /// Get total number of entries for a game
  Future<int> getTotalEntries(String gameId) async {
    final snapshot =
        await _db
            .collection(_collection)
            .doc(gameId)
            .collection('entries')
            .count()
            .get();

    return snapshot.count ?? 0;
  }

  /// Returns the rank if this score were inserted now. If rank <= 10, it qualifies.
  /// Rank is 1-based.
  Future<int?> getProvisionalRank({
    required String gameId,
    required int score,
    int maxSize = 10,
  }) async {
    if (score <= 0) return null;
    final top = await fetchTopEntries(gameId: gameId, limit: maxSize);
    // If less than maxSize entries, always qualifies and rank is len+1 position by score
    if (top.isEmpty) return 1;

    int rank = 1;
    for (final e in top) {
      if (score > e.score) break;
      rank++;
    }

    if (top.length < maxSize && rank > top.length) {
      // fits at the end
      return top.length + 1;
    }

    if (rank <= maxSize) {
      return rank;
    }
    return null;
  }

  /// Inserts the score if it qualifies. Keeps only top N entries.
  Future<void> upsertQualifiedEntry({
    required String gameId,
    required String name,
    required String countryCode,
    required int score,
    int maxSize = 10,
  }) async {
    final entriesRef = _db
        .collection(_collection)
        .doc(gameId)
        .collection('entries');

    // Read top to decide qualification
    final topSnap =
        await entriesRef
            .orderBy('score', descending: true)
            .limit(maxSize)
            .get();

    final top =
        topSnap.docs
            .map((d) => GlobalLeaderboardEntry.fromMap(d.id, d.data()))
            .toList();

    bool qualifies = false;
    if (top.length < maxSize) {
      qualifies = true;
    } else if (top.isNotEmpty && score > top.last.score) {
      qualifies = true;
    }

    if (!qualifies) return;

    // Add new entry
    await entriesRef.add({
      'gameId': gameId,
      'name': name,
      'countryCode': countryCode,
      'score': score,
    });

    // Trim if necessary
    final updatedSnap =
        await entriesRef.orderBy('score', descending: true).get();
    if (updatedSnap.docs.length > maxSize) {
      final toDelete = updatedSnap.docs.skip(maxSize);
      final batch = _db.batch();
      for (final d in toDelete) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
  }
}
