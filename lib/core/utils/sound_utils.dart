import 'package:audioplayers/audioplayers.dart';

class SoundUtils {
  static AudioPlayer? _audioPlayer;
  static bool _isInitialized = false;
  static AudioPlayer? _spinnerPlayer;

  /// Ses sistemini başlat
  static Future<void> initialize() async {
    if (_isInitialized) return;

    _audioPlayer = AudioPlayer();
    _isInitialized = true;
  }

  /// Oyun başlama sesi çal
  static Future<void> playGameStartSound() async {
    if (!_isInitialized) await initialize();

    try {
      await _audioPlayer?.play(AssetSource('sounds/game_start.mp3'));
      await _audioPlayer?.setVolume(0.7);
    } catch (e) {
      print('Oyun başlama sesi çalınırken hata: $e');
    }
  }

  /// Laser sesi çal (hedef vurulduğunda)
  static Future<void> playLaserSound() async {
    if (!_isInitialized) await initialize();

    try {
      await _audioPlayer?.play(AssetSource('sounds/laser_sound.mp3'));
      await _audioPlayer?.setVolume(0.7);
    } catch (e) {
      print('Laser sesi çalınırken hata: $e');
    }
  }

  /// Rüzgar sesi çal (hedef yer değiştirdiğinde)
  static Future<void> playWindSound() async {
    if (!_isInitialized) await initialize();

    try {
      await _audioPlayer?.play(AssetSource('sounds/wind_sound.mp3'));
      await _audioPlayer?.setVolume(0.5); // Rüzgar sesi biraz daha düşük
    } catch (e) {
      print('Rüzgar sesi çalınırken hata: $e');
    }
  }

  /// Oyun bitiş sesi çal (alert dialog için)
  static Future<void> playGameOverSound() async {
    if (!_isInitialized) await initialize();

    try {
      await _audioPlayer?.play(AssetSource('sounds/game_over_sound.mp3'));
      await _audioPlayer?.setVolume(0.7);
    } catch (e) {
      print('Oyun bitiş sesi çalınırken hata: $e');
    }
  }

  /// Oyun bitiş sesi çal (eski versiyon - geriye uyumluluk için)
  static Future<void> playGameOverSoundLegacy() async {
    if (!_isInitialized) await initialize();

    try {
      await _audioPlayer?.play(AssetSource('sounds/game_over.mp3'));
      await _audioPlayer?.setVolume(0.7);
    } catch (e) {
      print('Oyun bitiş sesi çalınırken hata: $e');
    }
  }

  /// Doğru renk seçildiğinde blink sesi çal (Color Hunt)
  static Future<void> playBlinkSound() async {
    // Her çağrıda yeni bir player oluştur ki sesler üst üste binebilsin
    final player = AudioPlayer();
    try {
      await player.play(AssetSource('sounds/blink_sound.mp3'));
      await player.setVolume(0.7);
      // Ses bitince player'ı dispose et
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      print('Blink sesi çalınırken hata: $e');
      player.dispose();
    }
  }

  /// Geri sayım sesi çal (son 3 saniye, üst üste çalabilir)
  static Future<void> playCountDownSound() async {
    // Her çağrıda yeni bir player oluştur ki sesler üst üste binebilsin
    final player = AudioPlayer();
    try {
      await player.play(AssetSource('sounds/count_down_sound.mp3'));
      await player.setVolume(0.6);
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      print('Geri sayım sesi çalınırken hata: $e');
      player.dispose();
    }
  }

  /// Spinner sesi çal (animasyon boyunca döngüde)
  static Future<void> playSpinnerSound() async {
    _spinnerPlayer ??= AudioPlayer();
    try {
      await _spinnerPlayer!.setReleaseMode(ReleaseMode.loop);
      await _spinnerPlayer!.play(AssetSource('sounds/spinner_sound.mp3'));
      await _spinnerPlayer!.setVolume(0.5);
    } catch (e) {
      print('Spinner sesi çalınırken hata: $e');
    }
  }

  /// Spinner sesini durdur
  static Future<void> stopSpinnerSound() async {
    try {
      await _spinnerPlayer?.stop();
      await _spinnerPlayer?.dispose();
      _spinnerPlayer = null;
    } catch (e) {
      print('Spinner sesi durdurulurken hata: $e');
    }
  }

  /// Blind Sort'ta sayı yerleştirildiğinde tap sesi çal
  static Future<void> playTapSound() async {
    final player = AudioPlayer();
    try {
      await player.play(AssetSource('sounds/tap_sound.mp3'));
      await player.setVolume(0.7);
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      print('Tap sesi çalınırken hata: $e');
      player.dispose();
    }
  }

  /// Yeni rekor kırıldığında seviye atlama sesi çal
  static Future<void> playNewLevelSound() async {
    final player = AudioPlayer();
    try {
      await player.play(AssetSource('sounds/new_level_sound.mp3'));
      await player.setVolume(0.8);
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      print('New level sesi çalınırken hata: $e');
      player.dispose();
    }
  }

  /// Ses sistemini temizle
  static Future<void> dispose() async {
    await _audioPlayer?.dispose();
    _audioPlayer = null;
    _isInitialized = false;
  }

  /// Ses çalıp çalmadığını kontrol et
  static bool get isPlaying => _audioPlayer?.state == PlayerState.playing;

  /// Ses durumunu kontrol et
  static PlayerState? get playerState => _audioPlayer?.state;
}
