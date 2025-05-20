import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import '../services/semptom_service.dart';
import '../main.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class SemptomTaramaScreen extends StatefulWidget {
  const SemptomTaramaScreen({super.key});

  @override
  _SemptomTaramaScreenState createState() => _SemptomTaramaScreenState();
}

class _SemptomTaramaScreenState extends State<SemptomTaramaScreen> {
  bool isLoading = false;
  Map<String, dynamic>? sonuc;
  final SemptomService _semptomService = SemptomService();

  // Chat benzeri mesajlaşma için değişkenler
  final TextEditingController _semptomController = TextEditingController();
  final List<Map<String, dynamic>> _mesajlar = [];
  final ScrollController _scrollController = ScrollController();

  // Focus ve key değişkenleri
  final FocusNode _textFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Web ve mobil için farklı davranış kontrolü
  bool get _isWebMobile =>
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  // Yaygın semptomlar için hızlı erişim butonları
  final List<String> _yayginSemptomlar = [
    'Ateş',
    'Öksürük',
    'Baş ağrısı',
    'Boğaz ağrısı',
    'Mide bulantısı',
    'İshal',
    'Kas ağrısı',
    'Halsizlik',
    'Nefes darlığı',
  ];

  Map<String, String> diseaseToDepartment = {};
  bool mappingLoaded = false;

  Map<String, String> departmentToDoctor = {
    'Allergy & Immunology': 'Dr. Alice Immuno',
    'Anesthesiology': 'Dr. Andrew Anesth',
    'Colon & Rectal Surgery': 'Dr. Clara Colon',
    'Dermatology': 'Dr. David Derma',
    'Emergency Medicine': 'Dr. Emma Emergency',
    'Family Medicine': 'Dr. Frank Family',
    'Internal Medicine': 'Dr. Irene Internal',
    'Neurological Surgery': 'Dr. Nancy Neuro',
    'Obstetrics & Gynecology': 'Dr. Olivia ObGyn',
    'Ophthalmology': 'Dr. Oscar Ophthal',
    'Orthopaedic Surgery': 'Dr. Oliver Ortho',
    'Otolaryngology': 'Dr. Owen Otolar',
    // ... diğer departmanlar ...
  };

  @override
  void initState() {
    super.initState();
    _loadDiseaseDepartmentMapping();

    // Web uygulaması için API bağlantısını test et
    if (kIsWeb) {
      _testApiConnection();
    }

    // Focus yönetimi
    _textFocusNode.addListener(() {
      if (!_textFocusNode.hasFocus) {
        setState(() {});
      }
    });

    // Başlangıç karşılama mesajını ekle
    _mesajlar.add({
      'isSistem': true,
      'mesaj':
          'Merhaba! Lütfen şikayetlerinizi detaylı şekilde anlatın veya yaygın semptomları seçin.'
    });
  }

  Future<void> _loadDiseaseDepartmentMapping() async {
    try {
      final csvString = await rootBundle.loadString('assets/gpt.csv');
      final rows = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(csvString, eol: '\n');
      for (var i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length > 1) {
          final disease = row[0]?.toString()?.toLowerCase()?.trim();
          final department = row[1]?.toString()?.trim();
          if (disease != null && department != null && disease.isNotEmpty && department.isNotEmpty) {
            diseaseToDepartment[disease] = department;
          }
        }
      }
      setState(() {
        mappingLoaded = true;
      });
    } catch (e) {
      print('Mapping yüklenemedi: $e');
    }
  }

  // API bağlantısını test et
  Future<void> _testApiConnection() async {
    try {
      final isConnected = await _semptomService.checkServerConnection();
      if (isConnected) {
        setState(() {
          _mesajlar.add({
            'isSistem': true,
            'mesaj':
                'API sunucusu ile bağlantı kuruldu. Semptomlarınızı yazabilirsiniz.',
          });
        });
      } else {
        setState(() {
          _mesajlar.add({
            'isSistem': true,
            'mesaj':
                'API sunucusu ile bağlantı kurulamadı. Lütfen backend servisinin çalıştığından emin olun.',
          });
        });
      }
    } catch (e) {
      setState(() {
        _mesajlar.add({
          'isSistem': true,
          'mesaj': 'API bağlantısı kontrol edilirken hata: $e',
        });
      });
    }
  }

  // Semptom gönderme ve analiz
  Future<void> _semptomGonder(String semptomMetni) async {
    // Kullanıcının mesajını ekle
    setState(() {
      _mesajlar.add({
        'isSistem': false,
        'mesaj': semptomMetni,
      });
      _semptomController.clear();
    });

    // Listenin sonuna kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

    // Yükleniyor mesajını ekle
    setState(() {
      _mesajlar.add({
        'isSistem': true,
        'mesaj': 'Analiz yapılıyor...',
        'isLoading': true,
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

    try {
      // Semptom analiz servisini çağır
      final hastalikTahmini =
          await _semptomService.hastalikTahmini([semptomMetni]);

      // Yükleniyor mesajını kaldır
      setState(() {
        _mesajlar.removeWhere((mesaj) => mesaj['isLoading'] == true);
      });

      // Analiz sonucu mesajını ekle
      setState(() {
        _mesajlar.add({
          'isSistem': true,
          'mesaj':
              'Olası Hastalık: ${hastalikTahmini['hastalikAdi']} (${(hastalikTahmini['olasilik'] * 100).toStringAsFixed(2)}%)\nÖneri: ${hastalikTahmini['oneriler']}',
        });
      });

      // Yönlendirme mesajını ekle
      String normalize(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
      String predictedDisease = hastalikTahmini['hastalikAdi']?.toLowerCase()?.trim() ?? '';
      String predictedDiseaseNorm = normalize(predictedDisease);
      String department = '';
      String? matchedDepartment;

      if (mappingLoaded && predictedDisease.isNotEmpty) {
        diseaseToDepartment.forEach((disease, dept) {
          if (predictedDiseaseNorm.contains(normalize(disease))) {
            matchedDepartment = dept;
          }
        });
        if (matchedDepartment != null) {
          department = matchedDepartment!;
          setState(() {
            _mesajlar.add({
              'isSistem': true,
              'mesaj':
                  'Şu bölüme randevu almak üzere yönlendiriliyorsunuz: $department',
              'isRedirection': true,
              'department': department,
            });
          });
        }
      }
    } catch (e) {
      // Hata mesajını ekle
      setState(() {
        _mesajlar.removeWhere((mesaj) => mesaj['isLoading'] == true);
        _mesajlar.add({
          'isSistem': true,
          'mesaj': 'Analiz sırasında bir hata oluştu: $e',
        });
      });
    } finally {
      // Listenin sonuna kaydır
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
    }
  }

  // Chat mesajı widget'ını oluştur
  Widget _buildChatMessage(Map<String, dynamic> mesaj) {
    // Yönlendirme mesajı ise farklı bir widget döndür
    if (mesaj['isRedirection'] == true) {
      return GestureDetector(
        onTap: () {
          // Yönlendirme işlemi
          FocusScope.of(context).unfocus(); // Odaklanmayı kaldır
          Navigator.pushNamed(
            context,
            '/randevu-ayarlama',
            arguments: {
              'department': mesaj['department'],
            },
          );
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: HealthApp.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: HealthApp.primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, color: HealthApp.primaryColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mesaj['mesaj'],
                    style: TextStyle(
                      color: HealthApp.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Normal chat mesajı
    return Align(
      alignment: mesaj['isSistem'] == true
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mesaj['isSistem'] == true ? Colors.grey[200] : Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          mesaj['mesaj'],
          style: TextStyle(
            color: mesaj['isSistem'] == true ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _semptomController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst başlık
          Text(
            'Semptomlarınızı Anlatın',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Şikayetlerinizi detaylı bir şekilde yazın veya yaygın semptomları seçin',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          SizedBox(height: 16),
          // Ana chat alanı
          Expanded(
            child: Column(
              children: [
                // Mesajları gösteren kısım
                Expanded(
                  child: _mesajlar.isEmpty
                      ? Center(
                          child: Text(
                            'Semptomlarınızı yazın veya yaygın semptomlardan seçin.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _mesajlar.length,
                          itemBuilder: (context, index) {
                            final mesaj = _mesajlar[index];
                            return _buildChatMessage(mesaj);
                          },
                        ),
                ),

                // Semptom giriş kısmı
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _semptomController,
                            focusNode: _textFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Semptomlarınızı yazın...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                            ),
                            autofocus: false,
                            textInputAction: TextInputAction.send,
                            keyboardType: TextInputType.text,
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(_textFocusNode);
                            },
                            onFieldSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                _semptomGonder(value);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            if (_semptomController.text.isNotEmpty) {
                              _semptomGonder(_semptomController.text);
                              // Focus'u temizle
                              FocusScope.of(context).unfocus();
                            } else if (kIsWeb) {
                              // Web için giriş dialogunu göster
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Semptomlarınızı girin'),
                                  content: TextField(
                                    controller: _semptomController,
                                    decoration: InputDecoration(
                                      hintText: 'Semptomlarınızı yazın...',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('İptal'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_semptomController
                                            .text.isNotEmpty) {
                                          _semptomGonder(
                                              _semptomController.text);
                                          Navigator.pop(context);
                                          // Focus'u temizle
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                      child: Text('Gönder'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
