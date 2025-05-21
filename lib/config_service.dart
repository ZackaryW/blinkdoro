import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const String _prefix = 'blinkdoro_';
  static final Map<String, String> _defaultConfig = {
    'workDuration': '${90 * 60}',
    'shortBreak': '${25 * 60}',
    'longBreak': '${60 * 60}',
    'sessionsUntilLongBreak': '4',
    'minBlinkInterval': '${5 * 60}',
    'maxBlinkInterval': '${10 * 60}',
    'blinkDuration': '10',
  };

  static Future<Map<String, int>> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final config = <String, int>{};

    for (final key in _defaultConfig.keys) {
      final value = prefs.getString('$_prefix$key') ?? _defaultConfig[key]!;
      config[key] = int.parse(value);
    }

    return config;
  }

  static Future<void> saveConfig(Map<String, int> config) async {
    final prefs = await SharedPreferences.getInstance();
    
    for (final entry in config.entries) {
      await prefs.setString('$_prefix${entry.key}', entry.value.toString());
    }
  }
} 