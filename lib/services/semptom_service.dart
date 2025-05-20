import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:developer' as developer;

class SemptomService {
  // Farklı IP seçeneklerini dene
  static const List<String> baseUrls = [ 
    'http://127.0.0.1:8000'
  ];

  // Windows için ekstra IP adresleri
  static List<String> _dynamicIps = [];

  // Dinamik IP'leri manuel olarak eklemek için (Windows'ta yerel ağ IP'si için)
  static void addLocalNetworkIp(String ip) {
    if (!_dynamicIps.contains('http://$ip:8000')) {
      _dynamicIps.add('http://$ip:8000');
      developer.log('Yeni IP eklendi: http://$ip:8000');
    }
  }

  // Sunucu bağlantı durumunu kontrol et
  Future<bool> checkServerConnection() async {
    for (String baseUrl in [...baseUrls, ..._dynamicIps]) {
      try {
        developer.log('Sunucu bağlantısı denetleniyor: $baseUrl');
        final response = await http.get(
          Uri.parse('$baseUrl/'),
          headers: {'Accept': 'application/json'},
        ).timeout(Duration(seconds: 5));

        if (response.statusCode == 200) {
          developer.log('Sunucu bağlantısı başarılı: $baseUrl');

          // Eğer bir JSON yanıt geldiyse ve server_info varsa IP adreslerini ekle
          try {
            final responseData = json.decode(response.body);
            if (responseData != null &&
                responseData['server_info'] != null &&
                responseData['server_info']['ip_addresses'] != null) {
              final List<dynamic> ipList =
                  responseData['server_info']['ip_addresses'];
              for (var ipInfo in ipList) {
                if (ipInfo is String && ipInfo.contains('Alternatif IP: ')) {
                  final ip = ipInfo.split('Alternatif IP: ')[1].trim();
                  addLocalNetworkIp(ip);
                }
              }
            }
          } catch (e) {
            developer.log('IP bilgileri ayrıştırılamadı: $e');
          }

          return true;
        }
      } catch (e) {
        developer.log('$baseUrl URL için bağlantı hatası: $e');
      }
    }
    return false;
  }

  Future<Map<String, dynamic>> hastalikTahmini(List<String> semptomlar) async {
    // Önce bağlantı durumunu kontrol et
    final isConnected = await checkServerConnection();
    if (!isConnected) {
      developer.log('Hiçbir sunucu URL\'si çalışmıyor!');
    }

    // Detaylı loglama ekle
    developer.log('Hastalık tahmini için istek gönderiliyor');
    developer.log('Semptomlar: $semptomlar');

    // Manuel olarak Windows için yerel ağ IP'sini ekle (test için)
    // Bu kısmı kendi yerel IP'nizi kullanarak güncelleyin
    // Örnek: addLocalNetworkIp('192.168.1.100');

    // Tüm IP'ler üzerinde dön
    List<String> allUrls = [...baseUrls, ..._dynamicIps];
    developer.log('Denenen URL\'ler: $allUrls');

    // Tüm olası URL'leri dene
    for (String baseUrl in allUrls) {
      try {
        developer.log('İstek gönderiliyor: $baseUrl/hastalik-tahmini');

        // HTTP POST isteği
        final response = await http
            .post(
              Uri.parse('$baseUrl/hastalik-tahmini'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode({'semptomlar': semptomlar}),
            )
            .timeout(Duration(seconds: 20));

        developer.log('Yanıt alındı: ${response.statusCode}');
        developer.log('Yanıt gövdesi: ${response.body}');

        if (response.statusCode == 200) {
          final decodedJson = json.decode(response.body);
          developer.log('Yanıt başarıyla ayrıştırıldı: $decodedJson');
          return decodedJson;
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          developer
              .log('İstek hatası: ${response.statusCode} ${response.body}');
          continue; // Diğer URL'yi dene
        } else {
          developer
              .log('Sunucu hatası: ${response.statusCode} ${response.body}');
          continue; // Diğer URL'yi dene
        }
      } on TimeoutException catch (e) {
        developer.log('$baseUrl URL için zaman aşımı: $e');
        continue; // Diğer URL'yi dene
      } catch (e) {
        developer.log('$baseUrl URL için hata: $e');
        continue; // Diğer URL'yi dene
      }
    }

    // Hiçbir URL çalışmadıysa
    developer.log('Tüm URL\'ler başarısız oldu!');
    return {
      "hastalikAdi": "Bağlantı Hatası",
      "olasilik": 0.0,
      "oneriler":
          "API sunucusuna bağlanılamadı. Lütfen backend uygulamasının çalıştığından emin olun ve firewall ayarlarını kontrol edin."
    };
  }
}
