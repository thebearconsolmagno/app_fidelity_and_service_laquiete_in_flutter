
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_models.dart';
import '../services/api_service.dart';

class AppProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  
  String? _token;
  User? _user;
  AppTheme? _theme;
  bool _isLoading = true;
  String? _error;

  String? get token => _token;
  User? get user => _user;
  AppTheme? get theme => _theme;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    
    String? userData = prefs.getString('user_data');
    if (userData != null) _user = User.fromJson(jsonDecode(userData));
    
    String? themeData = prefs.getString('app_theme');
    if (themeData != null) _theme = AppTheme.fromJson(jsonDecode(themeData));

    await refreshTheme();
  }

  Future<void> refreshTheme() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _theme = await _api.getPublicTheme();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_theme', jsonEncode(_theme!.toJson()));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final data = await _api.login(email, password);
    _token = data['token'];
    _user = User.fromJson(data['user']);
    _theme = AppTheme.fromJson(data['theme']);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('user_data', jsonEncode(data['user']));
    await prefs.setString('app_theme', jsonEncode(_theme!.toJson()));

    notifyListeners();
  }

  Future<void> register(Map<String, dynamic> data) async {
    final response = await _api.register(data);
    _token = response['token'];
    _user = User.fromJson(response['user']);
    _theme = AppTheme.fromJson(response['theme']);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('user_data', jsonEncode(response['user']));
    await prefs.setString('app_theme', jsonEncode(_theme!.toJson()));

    notifyListeners();
  }

  void logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    notifyListeners();
  }
}
