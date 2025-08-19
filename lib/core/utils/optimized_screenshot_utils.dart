import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class OptimizedScreenshotUtils {
  static ScreenshotController? _controller;
  static bool _isCapturing = false;

  static ScreenshotController get controller {
    _controller ??= ScreenshotController();
    return _controller!;
  }

  /// Optimized screenshot capture with better buffer management
  static Future<Uint8List?> captureWidget({
    required Widget widget,
    Duration delay = const Duration(milliseconds: 50),
    double pixelRatio = 2.0,
    BuildContext? context,
  }) async {
    if (_isCapturing) {
      return null; // Prevent multiple simultaneous captures
    }

    try {
      _isCapturing = true;

      // Add a small delay to ensure widget is fully rendered
      await Future.delayed(delay);

      final imageBytes = await controller.captureFromWidget(
        widget,
        delay: Duration.zero, // No additional delay since we already waited
        pixelRatio: pixelRatio,
        context: context,
      );

      // Force garbage collection to free up memory
      await _forceGarbageCollection();

      return imageBytes;
    } catch (e) {
      debugPrint('Screenshot capture error: $e');
      return null;
    } finally {
      _isCapturing = false;
    }
  }

  /// Save screenshot to temporary file with optimized settings
  static Future<File?> saveScreenshot({
    required Widget widget,
    required String fileName,
    Duration delay = const Duration(milliseconds: 50),
    double pixelRatio = 2.0,
    BuildContext? context,
  }) async {
    try {
      final imageBytes = await captureWidget(
        widget: widget,
        delay: delay,
        pixelRatio: pixelRatio,
        context: context,
      );

      if (imageBytes == null) {
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      return file;
    } catch (e) {
      debugPrint('Save screenshot error: $e');
      return null;
    }
  }

  /// Force garbage collection to free up memory
  static Future<void> _forceGarbageCollection() async {
    try {
      // Add a small delay to allow system to free up resources
      await Future.delayed(const Duration(milliseconds: 10));

      // Force memory cleanup
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } catch (e) {
      // Ignore errors in garbage collection
    }
  }

  /// Dispose controller to free up resources
  static void dispose() {
    _controller = null;
    _isCapturing = false;
  }
}
