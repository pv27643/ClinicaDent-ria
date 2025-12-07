import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Use a getter so dotenv is read at runtime (after dotenv.load in main)
  static String get _base {
    try {
      return dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:4000';
    } catch (_) {
      return 'http://10.0.2.2:4000';
    }
  }

  static Uri _uri(String path) => Uri.parse('$_base$path');

  static Future<Map<String, dynamic>> login(String email, String senha) async {
    final res = await http.post(
      _uri('/auth/loginById'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': senha}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Erro ${res.statusCode}: ${res.body}');
  }

}
