import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage audio settings and playback throughout the app
class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Audio settings
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  bool _muteAll = false;
  bool _isInitialized = false;

  // Getters
  double get musicVolume => _muteAll ? 0.0 : _musicVolume;
  double get sfxVolume => _muteAll ? 0.0 : _sfxVolume;
  bool get muteAll => _muteAll;

  // Initialize the service (load saved settings)
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    _musicVolume = prefs.getDouble('musicVolume') ?? 0.7;
    _sfxVolume = prefs.getDouble('sfxVolume') ?? 0.8;
    _muteAll = prefs.getBool('muteAll') ?? false;
    _isInitialized = true;
  }

  // Save current settings
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', _musicVolume);
    await prefs.setDouble('sfxVolume', _sfxVolume);
    await prefs.setBool('muteAll', _muteAll);
  }

  // Update music volume
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    // TODO: Update actual music player volume when implemented
    await saveSettings();
  }

  // Update SFX volume
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    // TODO: Update actual SFX player volume when implemented
    await saveSettings();
  }

  // Toggle mute all
  Future<void> setMuteAll(bool mute) async {
    _muteAll = mute;
    // TODO: Mute/unmute all audio players when implemented
    await saveSettings();
  }

  // Play background music
  void playBackgroundMusic(String musicAsset) {
    if (_muteAll) return;
    // TODO: Implement background music playback with musicVolume
    print('Playing background music: $musicAsset at volume ${musicVolume}');
  }

  // Play sound effect
  void playSfx(String sfxAsset) {
    if (_muteAll) return;
    // TODO: Implement sound effect playback with sfxVolume
    print('Playing SFX: $sfxAsset at volume ${sfxVolume}');
  }
}
