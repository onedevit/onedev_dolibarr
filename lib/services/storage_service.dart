import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dolibarr_config.dart';

class StorageService {
  static const String _keyConfig = 'dolibarr_config';

  static Future<void> saveConfig(DolibarrConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyConfig, jsonEncode(config.toJson()));
  }

  static Future<DolibarrConfig?> getConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyConfig);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return DolibarrConfig.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyConfig);
  }
}
