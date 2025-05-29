import 'dart:convert';
import 'package:http/http.dart' as http;

class RandevuService {
  // Android Emülatörü için: 'http://10.0.2.2:8000'
  // Web veya iOS Simülatörü/Gerçek Cihaz için: 'http://localhost:8000' veya sunucu IP'si
  // Web için geliştirme aşamasında 127.0.0.1:8000 çalışır
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Doktorları listelemek için
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final url = Uri.parse('$baseUrl/list-doctors');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> doctorsJson = json.decode(response.body);
        return doctorsJson.cast<Map<String, dynamic>>();
      } else {
        // Hata durumunda boş liste veya hata fırlatılabilir
        print('Doktorlar listelenirken hata oluştu: ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
        return []; // Hata durumunda boş liste döndür
      }
    } catch (e) {
      print('Doktorlar listelenirken bağlantı hatası: $e');
      return []; // Bağlantı hatasında boş liste döndür
    }
  }

  // Belirli bir doktorun belirtilen tarih aralığındaki müsaitliğini getirmek için
  Future<Map<String, dynamic>> fetchDoctorAvailability(String doctorId, DateTime startDate, DateTime endDate) async {
    final startDateStr = startDate.toIso8601String().split('T')[0];
    final endDateStr = endDate.toIso8601String().split('T')[0];
    final url = Uri.parse('$baseUrl/get-doctor-availability/$doctorId?start_date=$startDateStr&end_date=$endDateStr');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Doktor müsaitliği getirilirken hata oluştu: ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
        throw Exception('Doktor müsaitliği getirilemedi');
      }
    } catch (e) {
      print('Doktor müsaitliği getirilirken bağlantı hatası: $e');
      throw Exception('Doktor müsaitliği getirilirken bağlantı hatası');
    }
  }

  // Randevu oluşturmak için
  Future<Map<String, dynamic>> bookAppointment(String hastaId, String doctorId, String tarih, String saat) async {
    // Backend HH:MM formatı bekliyor, sadece saati gönderiyoruz.
    // Tarih YYYY-MM-DD formatı olmalı.
    final url = Uri.parse('$baseUrl/book-appointment');
    print('[RandevuService] Booking appointment to URL: $url');
    print('[RandevuService] Booking data: hasta_id: $hastaId, doctor_id: $doctorId, randevu_tarihi: $tarih, randevu_saati: $saat');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'hasta_id': hastaId,
          'doctor_id': doctorId,
          'randevu_tarihi': tarih,
          'randevu_saati': saat,
          // 'notlar': '...', // İsteğe bağlı olarak eklenebilir
        }),
      );

      print('[RandevuService] Appointment booking response status: ${response.statusCode}');
      print('[RandevuService] Appointment booking response body: ${response.body}');

      final responseBody = json.decode(response.body);

      if (response.statusCode == 201) {
        return responseBody; // Başarılı yanıt
      } else {
        // Hata durumunda backend'den gelen mesajı kullan
        final errorMessage = responseBody['message'] ?? 'Randevu oluşturulurken bir hata oluştu';
        throw Exception('Randevu oluşturulamadı: $errorMessage');
      }
    } catch (e) {
      print('[RandevuService] Appointment booking error: $e');
      throw Exception('Randevu oluşturulurken bağlantı hatası: $e');
    }
  }
} 