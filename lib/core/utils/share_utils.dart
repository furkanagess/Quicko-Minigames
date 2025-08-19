import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'optimized_screenshot_utils.dart';
import '../../shared/widgets/achievement_image_generator.dart';
import '../../shared/models/leaderboard_entry.dart';

class ShareUtils {
  /// Achievement görüntüsünü paylaş
  static Future<void> shareAchievementImage({
    required List<LeaderboardEntry> entries,
    required int totalGames,
    required int highestScore,
    required double averageScore,
  }) async {
    try {
      // Sadece üst alanı içeren widget'ı oluştur
      final achievementWidget = AchievementImageGenerator(
        entries: entries,
        totalGames: totalGames,
        highestScore: highestScore,
        averageScore: averageScore,
        showTopGames: false, // SADECE ÜST ALAN
      );

      // Optimize edilmiş screenshot al
      final file = await OptimizedScreenshotUtils.saveScreenshot(
        widget: achievementWidget,
        fileName: 'achievement_${DateTime.now().millisecondsSinceEpoch}.png',
        delay: const Duration(milliseconds: 50),
        pixelRatio: 2.0,
      );

      if (file == null) {
        throw Exception('Screenshot alınamadı');
      }

      // Paylaş
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Check out my gaming achievements! 🎮🏆');
    } catch (e) {
      print('Achievement paylaşılırken hata: $e');
      rethrow;
    }
  }

  /// Achievement önizlemesini göster
  static void showAchievementPreview({
    required BuildContext context,
    required List<LeaderboardEntry> entries,
    required int totalGames,
    required int highestScore,
    required double averageScore,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AchievementImageGenerator(
                entries: entries,
                totalGames: totalGames,
                highestScore: highestScore,
                averageScore: averageScore,
                showTopGames: false, // Önizlemede de sadece üst alan
              ),
            ),
          ),
        );
      },
    );
  }
}
