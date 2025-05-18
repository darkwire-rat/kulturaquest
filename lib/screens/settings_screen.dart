import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Audio settings
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  bool _muteAll = false;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _musicVolume = prefs.getDouble('musicVolume') ?? 0.7;
      _sfxVolume = prefs.getDouble('sfxVolume') ?? 0.8;
      _muteAll = prefs.getBool('muteAll') ?? false;
      _isLoading = false;
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', _musicVolume);
    await prefs.setDouble('sfxVolume', _sfxVolume);
    await prefs.setBool('muteAll', _muteAll);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Audio settings section
                  const _SectionHeader(title: 'Audio Settings', icon: Icons.volume_up),
                  const SizedBox(height: 16),
                  
                  // Mute all toggle
                  SwitchListTile(
                    title: const Text('Mute All Sounds'),
                    subtitle: const Text('Turn off all audio in the app'),
                    value: _muteAll,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _muteAll = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  // Music volume slider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Background Music Volume', style: TextStyle(fontSize: 16)),
                            Text('${(_musicVolume * 100).round()}%', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _musicVolume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
                          onChanged: _muteAll ? null : (value) {
                            setState(() {
                              _musicVolume = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // SFX volume slider
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sound Effects Volume', style: TextStyle(fontSize: 16)),
                            Text('${(_sfxVolume * 100).round()}%', style: TextStyle(color: Theme.of(context).primaryColor)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _sfxVolume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
                          onChanged: _muteAll ? null : (value) {
                            setState(() {
                              _sfxVolume = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Test sound buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.music_note),
                          label: const Text('Test Music'),
                          onPressed: _muteAll ? null : () {
                            // TODO: Play test music with _musicVolume
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Music player not implemented yet'))
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.volume_up),
                          label: const Text('Test SFX'),
                          onPressed: _muteAll ? null : () {
                            // TODO: Play test SFX with _sfxVolume
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('SFX player not implemented yet'))
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

// Custom section header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
