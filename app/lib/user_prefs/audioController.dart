import 'package:flame_audio/flame_audio.dart';
import 'package:ramayan/utils/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioController {
  static bool get soundOn => _soundOn;
  static bool get musicOn => _musicOn;
  static bool _soundOn = true;
  static bool _musicOn = true;
  static String? _bgm;
  static init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _soundOn = prefs.getBool('soundOn') ?? true;
    _musicOn = prefs.getBool('musicOn') ?? true;
  }

  static savePrefs() async {
    Log.d("Saving soundOn: $_soundOn, musicOn: $_musicOn");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('soundOn', _soundOn);
    prefs.setBool('musicOn', _musicOn);
  }

  static toggleSound() {
    _soundOn = !_soundOn;
    savePrefs();
    return _soundOn;
  }

  static toggleMusic() {
    _musicOn = !_musicOn;
    savePrefs();
    if (_musicOn && _bgm != null) {
      FlameAudio.bgm.play(_bgm!);
    } else {
      FlameAudio.bgm.pause();
    }
    return _musicOn;
  }

  static playBgm(String bgm) {
    _bgm = bgm + ".m4a";
    if (_musicOn) {
      Log.d("Playing BGM: $_bgm");
      FlameAudio.bgm.play(_bgm!);
    } else
      Log.d("Music is off, not playing BGM: $_bgm");
  }

  static playEffect(String effect) {
    if (_soundOn) {
      FlameAudio.play(effect);
    }
  }
}
