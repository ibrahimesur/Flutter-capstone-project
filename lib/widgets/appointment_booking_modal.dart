import 'package:flutter/material.dart';
import '../services/randevu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RandevuAyarlamaModal extends StatefulWidget {
  final String? initialDepartment;
  // Ana ekrandaki listeye yeni randevuyu eklemek için callback fonksiyonu
  final Function(Randevu)? onAppointmentBooked;

  const RandevuAyarlamaModal({Key? key, this.initialDepartment, this.onAppointmentBooked}) : super(key: key);

  @override
  _RandevuAyarlamaModalState createState() => _RandevuAyarlamaModalState();
}

class _RandevuAyarlamaModalState extends State<RandevuAyarlamaModal> {
  String? selectedDepartment;
  String? selectedDoctor;
  DateTime? selectedDate; // Seçilen tarih
  String? selectedTime; // Seçilen saat (string formatında)
  bool _isLoading = false; // Yüklenme durumunu takip etmek için

  DateTime _currentWeekStartDate = DateTime.now(); // Haftalık takvim için başlangıç tarihi

  // Demo: Bölüm ve doktorlar
  final Map<String, List<String>> departmentDoctors = {
    'Psychiatry': ['Dr. Ayşe Yılmaz', 'Dr. Mehmet Demir'],
    'Otolaryngology': ['Dr. Selin Kaya', 'Dr. Barış Aksoy'],
    'Endocrinology': ['Dr. Ece Güneş', 'Dr. Cem Korkmaz'],
    'Urology': ['Dr. Bora Yıldız', 'Dr. Zeynep Şahin'],
    'Internal Medicine': ['Dr. Ahmet Yılmaz', 'Dr. Elif Kılıç'],
    'Pulmonology': ['Dr. Paul Pulmo', 'Dr. Selda Solunum'],
    // ... diğer departmanlar ...
  };

  // Demo: Doktor ve uygun saatler
  // Burada her doktor için hangi gün ve saatlerde müsait olduğu belirtilmeli
  // Örnek olarak: 'Dr. Ahmet Yılmaz': {'2025-05-29': ['09:00', '10:00'], '2025-05-30': ['09:30']} gibi
  final Map<String, Map<String, List<String>>> doctorAvailability = {
    'Dr. Ayşe Yılmaz': {
      '2025-05-29': ['09:00', '10:00', '14:00'],
      '2025-05-30': ['09:00'],
      '2025-06-02': ['09:10', '09:20'],
    },
    'Dr. Mehmet Demir': {
      '2025-05-29': ['09:10', '09:20'],
      '2025-05-30': ['09:10', '09:30'],
      '2025-05-31': ['09:00'],
      '2025-06-02': ['09:30', '09:40'],
    },
    // Diğer doktorlar için müsaitlik bilgileri eklenecek...
    'Dr. Selin Kaya': {'2025-05-29': ['09:30'], '2025-05-30': ['09:20', '09:40']}, // Örnek veri
     'Dr. Barış Aksoy': {'2025-05-29': ['09:40', '09:50'], '2025-05-30': ['09:30', '09:40']}, // Örnek veri
     'Dr. Ece Güneş': {'2025-05-29': ['10:00'], '2025-05-30': ['09:50', '10:00']}, // Örnek veri
     'Dr. Cem Korkmaz': {'2025-05-29': ['10:10', '10:20'], '2025-05-30': ['10:10']}, // Örnek veri
     'Dr. Bora Yıldız': {'2025-05-29': ['10:40'], '2025-05-30': ['10:30', '10:40']}, // Örnek veri
      'Dr. Zeynep Şahin': {'2025-06-02': ['09:50', '10:00']}, // Örnek veri
      'Dr. Elif Kılıç': {'2025-06-02': ['10:10', '10:20']}, // Örnek veri
       'Dr. Paul Pulmo': {'2025-06-02': ['10:30']}, // Örnek veri
        'Dr. Selda Solunum': {'2025-06-02': ['10:40']}, // Örnek veri

  };


  @override
  void initState() {
    super.initState();
    // Eğer initialDepartment belirtildiyse ve geçerliyse seçili hale getir
    if (widget.initialDepartment != null &&
        departmentDoctors.containsKey(widget.initialDepartment)) {
      selectedDepartment = widget.initialDepartment;
    }

    // Haftanın başlangıç tarihini ayarla (genellikle Pazartesi)
    _currentWeekStartDate = _findFirstDayOfWeek(DateTime.now());
  }

  // Haftanın ilk gününü bulan yardımcı fonksiyon
  DateTime _findFirstDayOfWeek(DateTime date) {
    // DateTime.weekday Pazartesi için 1, Pazar için 7 döner
    return date.subtract(Duration(days: date.weekday - 1));
  }

  // Sonraki haftaya git
  void _goToNextWeek() {
    setState(() {
      _currentWeekStartDate = _currentWeekStartDate.add(Duration(days: 7));
      // Yeni hafta seçildiğinde seçili tarih ve saati sıfırla
      selectedDate = null;
      selectedTime = null;
    });
  }

  // Önceki haftaya git
  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStartDate = _currentWeekStartDate.subtract(Duration(days: 7));
       // Yeni hafta seçildiğinde seçili tarih ve saati sıfırla
      selectedDate = null;
      selectedTime = null;
    });
  }

  // Belirli bir gün için müsait saatleri getir
  List<String> _getAvailableTimesForDay(DateTime date) {
    if (selectedDoctor == null) return [];
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return doctorAvailability[selectedDoctor]?[dateKey] ?? [];
  }

  // Backend'e randevu alma isteği gönderen fonksiyon
  Future<void> _bookAppointment() async {
    print('[_bookAppointment] Fonksiyon başladı.');
    // Aktif olan herhangi bir input elementinin odağını kaldır (Web için faydalı olabilir)
    FocusManager.instance.primaryFocus?.unfocus();
    print('[_bookAppointment] Odak kaldırıldı.');

    if (selectedDepartment == null || selectedDoctor == null || selectedDate == null || selectedTime == null) {
      print('[_bookAppointment] Zorunlu alanlar eksik.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }
    print('[_bookAppointment] Zorunlu alanlar dolu.');

    setState(() {
      _isLoading = true;
    });
    print('[_bookAppointment] Yükleniyor durumu true yapıldı.');

    // Hasta ID'sini SharedPreferences'dan al
    final prefs = await SharedPreferences.getInstance();
    final hastaId = prefs.getString('hasta_id');
    print('[_bookAppointment] Hasta ID alındı: $hastaId');


    if (hastaId == null) {
       print('[_bookAppointment] Hasta ID null. Kullanıcı giriş yapmamış.');
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Randevu almak için lütfen giriş yapın.')),
       );
       setState(() { _isLoading = false; });
       // İsteğe bağlı: Modalı kapat veya giriş sayfasına yönlendir
       // Navigator.pop(context);
       return;
    }


    // Backend URL'si - Web için 127.0.0.1 kullanıyoruz
    // Eğer Android emülatöründe çalışıyorsanız 10.0.2.2 kullanmalısınız.
    final url = Uri.parse('http://127.0.0.1:8000/book-appointment');
    print('[_bookAppointment] Hedef URL: $url');

    try {
      // Tarih ve saati backend'in beklediği formata çevir
      final formattedDate = selectedDate!.toIso8601String().split('T')[0]; // YYYY-MM-DD
      final formattedTime = selectedTime! + ":00"; // HH:MI:SS
      print('[_bookAppointment] Formatlanmış Tarih: $formattedDate, Saat: $formattedTime');

      print('[_bookAppointment] HTTP POST isteği gönderiliyor...');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Authorization header'ı token kaldırıldığı için artık yok
        },
        body: jsonEncode({
          'hasta_id': hastaId,
          'department': selectedDepartment,
          'doctor': selectedDoctor,
          'date': formattedDate,
          'time': formattedTime,
        }),
      );
       print('[_bookAppointment] HTTP yanıtı alındı. Status kod: ${response.statusCode}');


      if (response.statusCode == 201) {
        // Başarılı
        final responseBody = jsonDecode(response.body);
        print('[_bookAppointment] Randevu başarıyla oluşturuldu: ${response.body}');

        final newAppointment = Randevu(
          id: responseBody['appointment_id'],
          hastaId: responseBody['hasta_id'],
          doctor: selectedDoctor!,
          department: selectedDepartment!,
          date: selectedDate!,
          time: selectedTime!,
        );

        if (widget.onAppointmentBooked != null) {
          widget.onAppointmentBooked!(newAppointment);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Randevunuz başarıyla oluşturuldu'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pop(context);
      } else {
        // Hata durumu
        final errorBody = jsonDecode(response.body);
        print('[_bookAppointment] Backend hata döndürdü: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorBody['message'] ?? 'Randevu oluşturulurken bir hata oluştu'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('[_bookAppointment] Hata oluştu: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bağlantı hatası: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      print('[_bookAppointment] Yükleniyor durumu false yapıldı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Haftanın günlerini oluştur
    final List<DateTime> weekDays = List.generate(7, (index) => _currentWeekStartDate.add(Duration(days: index)));

    // Tüm müsait saatlerin listesini oluştur (takvim satırları için)
    final List<String> allAvailableTimes = selectedDoctor != null
        ? (doctorAvailability[selectedDoctor]?.values.expand((times) => times).toSet().toList() ?? [])
        : [];

    // Oluşturulan listeyi sırala
    allAvailableTimes.sort();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Randevu Bilgileri',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24),
            // Bölüm seçimi
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              decoration: InputDecoration(
                labelText: 'Bölüm Seçiniz',
                prefixIcon: Icon(Icons.local_hospital),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: departmentDoctors.keys
                  .map((dep) => DropdownMenuItem(
                        value: dep,
                        child: Text(dep),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedDepartment = val;
                  selectedDoctor = null;
                   selectedDate = null;
                  selectedTime = null;
                });
              },
            ),
            SizedBox(height: 20),
            // Doktor seçimi
            DropdownButtonFormField<String>(
              value: selectedDoctor,
              decoration: InputDecoration(
                labelText: 'Doktor Seçiniz',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: (selectedDepartment != null)
                  ? departmentDoctors[selectedDepartment]!
                      .map((doc) => DropdownMenuItem(
                            value: doc,
                            child: Text(doc),
                          ))
                      .toList()
                  : [],
              onChanged: (val) {
                setState(() {
                  selectedDoctor = val;
                  selectedDate = null;
                  selectedTime = null;
                });
              },
            ),
            SizedBox(height: 20),

            // Haftalık Takvim Başlığı ve Navigasyon
            if (selectedDoctor != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: _goToPreviousWeek,
                  ),
                  Text(
                    '${_currentWeekStartDate.day}.${_currentWeekStartDate.month}.${_currentWeekStartDate.year} - ${_currentWeekStartDate.add(Duration(days: 6)).day}.${_currentWeekStartDate.add(Duration(days: 6)).month}.${_currentWeekStartDate.add(Duration(days: 6)).year}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: _goToNextWeek,
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Takvim Tablosu
              SingleChildScrollView( // Yatay kaydırma için
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 12.0, // Sütunlar arası boşluk
                  columns: [ // Gün başlıkları
                    DataColumn(label: Text('')), // Saat sütunu için boş başlık
                    ...
                    weekDays.map((date) => DataColumn(label: Text('${_getDayName(date.weekday)}\n${date.day}.${date.month}'))).toList(),
                  ],
                  rows: [ // Saat satırları
                     ...allAvailableTimes.map((time) => DataRow(cells: [ // Her saat için bir satır
                       DataCell(Text(time)), // Saat hücresi
                       ...
                       weekDays.map((date) { // Her gün için bir hücre
                          final availableTimes = _getAvailableTimesForDay(date);
                          final isAvailable = availableTimes.contains(time);
                          final isSelected = selectedDate != null &&
                              selectedDate!.year == date.year &&
                              selectedDate!.month == date.month &&
                              selectedDate!.day == date.day &&
                              selectedTime == time;

                          return DataCell(
                            Center(
                              child: isAvailable
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDate = date;
                                          selectedTime = time;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(context).colorScheme.secondary
                                              : Colors.green.withOpacity(0.2), // Müsait saatler yeşil
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          'Müsait',
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.green[900],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container( // Müsait olmayan saatler
                                      padding: EdgeInsets.all(8.0),
                                       decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2), // Müsait olmayan saatler kırmızı
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      child: Text(
                                        'Dolu',
                                        style: TextStyle(
                                          color: Colors.red[900],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                       }).toList(),
                     ])).toList(),
                  ],
                ),
              ),
            ],

            SizedBox(height: 32),
            // Randevu Al butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedDepartment != null &&
                        selectedDoctor != null &&
                        selectedDate != null &&
                        selectedTime != null)
                    ? _bookAppointment
                    : null,
                style: ElevatedButton.styleFrom(
                   backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text('Randevu Al',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gün adını döndüren yardımcı fonksiyon
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Pzt';
      case 2: return 'Sal';
      case 3: return 'Çar';
      case 4: return 'Per';
      case 5: return 'Cum';
      case 6: return 'Cmt';
      case 7: return 'Paz';
      default: return '';
    }
  }
} 