import 'package:flutter/material.dart';
import '../models/dolibarr_config.dart';
import '../services/storage_service.dart';
import '../services/dolibarr_api_service.dart';

class AuthProvider extends ChangeNotifier {
  DolibarrConfig? _config;
  bool _isLoading = true;
  bool _isConnected = false;
  String? _errorMessage;
  String? _versionInfo;

  DolibarrConfig? get config => _config;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String? get errorMessage => _errorMessage;
  String? get versionInfo => _versionInfo;

  AuthProvider() {
    loadConfig();
  }

  Future<void> loadConfig() async {
    _isLoading = true;
    notifyListeners();

    _config = await StorageService.getConfig();
    if (_config != null && _config!.isValid) {
      await testConnection();
    } else {
      _isConnected = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveAndConnect(String baseUrl, String apiKey) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final newConfig = DolibarrConfig(baseUrl: baseUrl, apiKey: apiKey);
    final apiService = DolibarrApiService(newConfig);

    try {
      final res = await apiService.testConnection();
      _config = newConfig;
      await StorageService.saveConfig(newConfig);
      _isConnected = true;
      _versionInfo = res['version']?.toString() ?? 'Connecté';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isConnected = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> testConnection() async {
    if (_config == null || !_config!.isValid) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final apiService = DolibarrApiService(_config!);
    try {
      final res = await apiService.testConnection();
      _isConnected = true;
      _versionInfo = res['version']?.toString() ?? 'Connecté';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isConnected = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.clearConfig();
    _config = null;
    _isConnected = false;
    _errorMessage = null;
    _versionInfo = null;
    notifyListeners();
  }
}
