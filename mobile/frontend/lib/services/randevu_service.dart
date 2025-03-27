import 'dart:convert';
import 'package:http/http.dart' as http;

class RandevuService {
  static const String baseUrl = 'http://localhost:8000';

  Future<Map<String, dynamic>> randevuOlustur(Map<String, dynamic> randevuData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/randevu'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(randevuData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Randevu oluşturulamadı');
    }
  }
} 