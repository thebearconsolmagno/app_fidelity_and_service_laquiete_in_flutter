
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/app_models.dart';

class ApiService {
  final String _baseUrl = AppConfig.apiBaseUrl;

  String? get _systemAuth {
    if (AppConfig.systemUser.isEmpty || AppConfig.systemPass.isEmpty) {
      return null;
    }
    String credentials = "${AppConfig.systemUser}:${AppConfig.systemPass}";
    return "Basic ${base64Encode(utf8.encode(credentials))}";
  }

  Map<String, String> _headers([String? userToken]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final systemAuth = _systemAuth;
    if (systemAuth != null) headers['Authorization'] = systemAuth;
    if (userToken != null) {
      headers['X-User-Token'] = userToken;
    }
    return headers;
  }

  String resolveUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    if (path.contains('logo.png')) return "$_baseUrl/static/img/LOGO_QUIETE_QRCODE-1.png";
    if (path.startsWith('static/') || path.startsWith('/static/')) return "$_baseUrl/$path";
    if (path.startsWith('/')) return "$_baseUrl$path";
    return "$_baseUrl/static/uploads/products/$path";
  }

  Future<AppTheme> getPublicTheme() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/api/theme/public"),
        headers: _headers(),
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        return AppTheme.fromJson(jsonDecode(response.body));
      } else {
        throw "Status: ${response.statusCode}";
      }
    } on SocketException {
      throw "OFFLINE: Impossibile contattare il server local $_baseUrl";
    } catch (e) {
      throw "ERRORE: $e";
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/login"),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw error['msg'] ?? 'Credenziali non valide';
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/register"),
      headers: _headers(),
      body: jsonEncode({
        ...data,
        'phone_ddi': data['phoneDDI'],
        'phone_number': data['phoneNumber'],
        'restaurant_code': data['restaurantCode'],
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw error['msg'] ?? 'Errore registrazione';
    }
  }

  Future<String> recoverPassword(String email) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/recover-password"),
      headers: _headers(),
      body: jsonEncode({'email': email}),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['msg'] ?? 'Email di recupero inviata';
    } else {
      final error = jsonDecode(response.body);
      throw error['msg'] ?? 'Email non trovata';
    }
  }

  Future<String> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/reset-password"),
      headers: _headers(),
      body: jsonEncode({'token': token, 'newPassword': newPassword}),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['msg'] ?? 'Password modificata con successo';
    } else {
      final error = jsonDecode(response.body);
      throw error['msg'] ?? 'Token non valido o scaduto';
    }
  }

  Future<List<Product>> getProducts(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/api/menu"),
      headers: { ..._headers(), 'Authorization': 'Bearer $token' },
    );

    if (response.statusCode == 200) {
      List l = jsonDecode(response.body);
      return l.map((item) => Product.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<String>> getMenuCategories(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/api/menu/categories"),
      headers: { ..._headers(), 'Authorization': 'Bearer $token' },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<String>((item) {
          if (item is String) return item;
          if (item is Map) {
            return (item['name'] ?? item['title'] ?? item['label'] ?? '').toString();
          }
          return '';
        }).where((e) => e.trim().isNotEmpty).toList();
      }
    }
    return [];
  }

  Future<List<FidelityHistory>> getFidelity(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/api/fidelity"),
      headers: { ..._headers(), 'Authorization': 'Bearer $token' },
    );

    if (response.statusCode == 200) {
      List l = jsonDecode(response.body);
      return l.map((item) => FidelityHistory.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> createReservation(String token, Map<String, dynamic> res) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/api/reservations"),
      headers: { ..._headers(), 'Authorization': 'Bearer $token' },
      body: jsonEncode(res),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw "Errore prenotazione";
    }
  }

  Future<List<Reservation>> getReservations(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/api/reservations"),
      headers: { ..._headers(), 'Authorization': 'Bearer $token' },
    );

    if (response.statusCode == 200) {
      List l = jsonDecode(response.body);
      return l.map((item) => Reservation.fromJson(item)).toList();
    }
    return [];
  }
}
