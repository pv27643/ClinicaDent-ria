import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Use a getter so dotenv is read at runtime (after dotenv.load in main)
  static String get _base {
    try {
      return dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:3001';
    } catch (_) {
      // dotenv not initialized yet (hot-reload or other). Use localhost emulator default.
      return 'http://10.0.2.2:3001';
    }
  }

  static Uri _uri(String path) => Uri.parse('$_base$path');

  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final res = await http.post(
      _uri('/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': senha}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Erro ${res.statusCode}: ${res.body}');
  }

  static Future<DateTime> pgTest() async {
    final res = await http.get(_uri('/pg/test'));
    if (res.statusCode == 200) {
      final obj = jsonDecode(res.body);
      return DateTime.parse(obj['now'] as String);
    }
    throw Exception('PG test failed: ${res.statusCode}');
  }

  static Future<List<dynamic>> getUsuarios() async {
    final res = await http.get(_uri('/pg/usuarios'));
    if (res.statusCode == 200) return jsonDecode(res.body) as List<dynamic>;
    throw Exception('Erro ao obter usuarios: ${res.statusCode}');
  }
}
