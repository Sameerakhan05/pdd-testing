import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Plays the emergency buzzer.
/// Needs an asset:  assets/alarm.mp3  (any loud alarm/siren clip).
/// Declare it under `assets:` in pubspec.yaml.
class AlarmService {
  static final AudioPlayer _player = AudioPlayer();
  static bool isPlaying = false;

  static Future<void> start() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(1.0);
      await _player.play(AssetSource('alarm.mp3'));
      isPlaying = true;
      HapticFeedback.heavyImpact();
    } catch (_) {
      // If the asset is missing it just fails silently in dev.
    }
  }

  static Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    isPlaying = false;
  }
}
