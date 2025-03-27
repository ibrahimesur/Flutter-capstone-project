import 'dart:convert';
import 'package:http/http.dart' as http;

class SemptomService {
  static const String baseUrl = 'http://localhost:8000';

  Future<Map<String, dynamic>> hastalikTahmini(List<String> semptomlar) async {
    final response = await http.post(
      Uri.parse('$baseUrl/hastalik-tahmini'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'semptomlar': semptomlar}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Hastalık tahmini yapılamadı');
    }
  }
} 