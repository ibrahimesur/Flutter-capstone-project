import 'package:flutter/material.dart';
import '../services/randevu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/randevu_service.dart'; // RandevuService import edildi
import 'package:intl/intl.dart'; // Tarih formatlama için

class RandevuAyarlamaModal extends StatefulWidget {
  final String? initialDepartment;
  // Ana ekrandaki listeye yeni randevuyu eklemek için callback fonksiyonu
  final Function(Randevu)? onAppointmentBooked;

  const RandevuAyarlamaModal({Key? key, this.initialDepartment, this.onAppointmentBooked}) : super(key: key);

  @override
  RandevuAyarlamaModalState createState() => RandevuAyarlamaModalState();
}

class RandevuAyarlamaModalState extends State<RandevuAyarlamaModal> {
  final RandevuService _randevuService = RandevuService(); // Service instance

  String? selectedDepartment; // Bölüm adı (string)
  Map<String, dynamic>? selectedDoctor; // Seçilen doktor objesi (backend'den gelen)
  String? selectedDoctorId; // Seçilen doktorun ID'si (string)
  DateTime? selectedDate; // Seçilen tarih (DateTime)
  String? selectedTime; // Seçilen saat (string formatında HH:MM)
  Map<String, dynamic> doctorAvailabilityData = {}; // Backend'den gelen müsaitlik verisi

  bool _isLoading = false; // Genel yüklenme durumu
  bool _isAvailabilityLoading = false; // Müsaitlik yüklenme durumu

  DateTime _currentWeekStartDate = DateTime.now(); // Haftalık takvim için başlangıç tarihi

  // Backend'den çekilecek doktor listesi
  List<Map<String, dynamic>> _allDoctors = [];

  @override
  void initState() {
    super.initState();
    // Haftanın ilk gününü ayarla (genellikle Pazartesi)
    _currentWeekStartDate = _findFirstDayOfWeek(DateTime.now());
    _fetchDoctors(); // Doktorları çek
  }

  // Tüm doktorları backend'den çeken fonksiyon
  Future<void> _fetchDoctors() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });
    try {
      _allDoctors = await _randevuService.fetchDoctors();
      if (!mounted) return;
      // Eğer initialDepartment belirtildiyse, ilgili doktorları filtrele ve ilkini seç
      if (widget.initialDepartment != null && _allDoctors.isNotEmpty) {
        final filteredDoctors = _allDoctors.where((doc) => doc['department'] == widget.initialDepartment).toList();
        if (filteredDoctors.isNotEmpty) {
          setState(() {
            selectedDepartment = widget.initialDepartment;
            // İlk doktoru otomatik seç ve müsaitliği çek
            selectedDoctor = filteredDoctors.first;
            selectedDoctorId = selectedDoctor!['doctor_id'].toString();
          });
          _fetchDoctorAvailability();
        } else {
          // Belirtilen departmanda doktor yoksa uyar
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Belirtilen bölümde doktor bulunamadı.')),
          );
        }
      }
    } catch (e) {
      print('Doktorlar çekilirken hata: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doktor listesi yüklenemedi: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;
      setState(() { _isLoading = false; });
    }
  }

  // Seçili doktorun müsaitliğini backend'den çeken fonksiyon
  Future<void> _fetchDoctorAvailability() async {
    if (selectedDoctorId == null || !mounted) return;

    try {
      // Backend'den müsaitlik verisini çek
      final availabilityData = await _randevuService.fetchDoctorAvailability(
        selectedDoctorId!,
        DateTime.now(),
        DateTime.now().add(const Duration(days: 30)),
      );

      if (!mounted) return;
      setState(() {
        doctorAvailabilityData = availabilityData;
      });
    } catch (e) {
      print('Müsaitlik verisi çekilirken hata: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Müsaitlik verisi çekilirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Form alanlarını temizleme metodu
  void resetForm() {
    setState(() {
      selectedDepartment = null;
      selectedDoctor = null;
      selectedDoctorId = null;
      selectedDate = null;
      selectedTime = null;
      doctorAvailabilityData = {};
      _currentWeekStartDate = _findFirstDayOfWeek(DateTime.now()); // Takvimi sıfırla
    });
    _fetchDoctors(); // Doktor listesini yeniden çek
  }

  // Haftanın ilk gününü bulan yardımcı fonksiyon (Pazartesi)
  DateTime _findFirstDayOfWeek(DateTime date) {
    // DateTime.weekday Pazartesi için 1, Pazar için 7 döner
    // Hedefimiz Pazartesi (1). Eğer şu an Pazartesi değilse aradaki farkı çıkar.
    int daysToSubtract = date.weekday - 1;
    // Eğer tarih Pazar ise (weekday 7), 6 gün çıkarmamız gerekir (7-1=6)
    if (date.weekday == 7) daysToSubtract = 6;
    return date.subtract(Duration(days: daysToSubtract));
  }

  // Sonraki haftaya git
  void _goToNextWeek() {
    setState(() {
      _currentWeekStartDate = _currentWeekStartDate.add(Duration(days: 7));
      // Yeni hafta seçildiğinde seçili tarih ve saati sıfırla
      selectedDate = null;
      selectedTime = null;
      doctorAvailabilityData = {}; // Önceki müsaitlik verisini temizle
    });
    _fetchDoctorAvailability(); // Yeni hafta için müsaitliği çek
  }

  // Önceki haftaya git
  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStartDate = _currentWeekStartDate.subtract(Duration(days: 7));
      // Yeni hafta seçildiğinde seçili tarih ve saati sıfırla
      selectedDate = null;
      selectedTime = null;
      doctorAvailabilityData = {}; // Önceki müsaitlik verisini temizle
    });
    _fetchDoctorAvailability(); // Yeni hafta için müsaitliği çek
  }

  // Backend'den gelen veriye göre belirli bir gün ve saat için slot bilgisini bul
  Map<String, dynamic>? _getSlotInfo(DateTime date, String time) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date); // YYYY-MM-DD formatı

    if (doctorAvailabilityData.containsKey('availability')) {
      // İlgili güne ait müsaitlik verisini bul
      final dayAvailability = (doctorAvailabilityData['availability'] as List)
          .firstWhere(
              (dayData) => dayData['date'] == dateStr,
              orElse: () => null, // Gün bulunamazsa null döndür
          );

      if (dayAvailability != null && dayAvailability.containsKey('time_slots')) {
        // İlgili saate ait slot bilgisini bul
        final slot = (dayAvailability['time_slots'] as List)
            .firstWhere(
                (slotData) => slotData['time'] == time,
                orElse: () => null, // Saat bulunamazsa null döndür
            );
        return slot; // Slot bulunduysa slot bilgisini döndür (id, time, durum)
      }
    }
    return null; // Veri yapısı uygun değilse veya slot bulunamazsa null döndür
  }

  // Backend'e randevu alma isteği gönderen fonksiyon
  Future<void> _bookAppointment() async {
    if (selectedDoctorId == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doldurun'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Hasta ID'sini SharedPreferences'dan al
      final prefs = await SharedPreferences.getInstance();
      final hastaId = prefs.getString('hasta_id');

      if (hastaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Randevu almak için lütfen giriş yapın'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Randevu oluştur
      final result = await _randevuService.bookAppointment(
        hastaId,
        selectedDoctorId!,
        selectedDate!.toIso8601String().split('T')[0],
        selectedTime!,
      );

      // Başarılı mesajı göster
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Randevu başarıyla oluşturuldu'),
            backgroundColor: Colors.green,
          ),
        );

        // Callback'i çağır
        if (widget.onAppointmentBooked != null) {
          widget.onAppointmentBooked!(Randevu(
            id: result['randevu_id'],
            hastaId: hastaId,
            department: selectedDoctor!['department'],
            doctor: selectedDoctor!['name'],
            date: selectedDate!,
            time: selectedTime!,
          ));
        }
      }

      // Modalı kapat
      Navigator.of(context).pop();
    } catch (e) {
      print('Randevu oluşturulurken hata: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Randevu oluşturulurken hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Haftanın günlerini oluştur
    final List<DateTime> weekDays = List.generate(7, (index) => _currentWeekStartDate.add(Duration(days: index)));

    // Backend'den gelen müsaitlik verisindeki tüm benzersiz saatleri topla ve sırala
    final List<String> allAvailableTimes = [];
    if (doctorAvailabilityData.containsKey('availability')) {
      for (var dayData in doctorAvailabilityData['availability']) {
        if (dayData.containsKey('time_slots')) {
          for (var slotData in dayData['time_slots']) {
            if (!allAvailableTimes.contains(slotData['time'])) {
              allAvailableTimes.add(slotData['time']);
            }
          }
        }
      }
    }
    allAvailableTimes.sort();

    // Tüm doktorları departmana göre grupla
    final Map<String, List<Map<String, dynamic>>> doctorsByDepartment = {};
    for (var doctor in _allDoctors) {
       final department = doctor['department'] ?? 'Diğer';
       if (!doctorsByDepartment.containsKey(department)) {
          doctorsByDepartment[department] = [];
       }
       doctorsByDepartment[department]!.add(doctor);
    }
     // Departmanları alfabetik sırala
    final List<String> sortedDepartments = doctorsByDepartment.keys.toList()..sort();


    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _isLoading // Genel yüklenme durumu kontrolü
          ? Center(child: CircularProgressIndicator()) // Yükleniyorsa spinner göster
          : SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Randevu Bilgileri',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), // Font boyutu büyütüldü
              ),
            ),
            SizedBox(height: 24), // Boşluk arttırıldı
            // Bölüm seçimi
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              decoration: InputDecoration(
                labelText: 'Bölüm Seçiniz',
                prefixIcon: Icon(Icons.local_hospital), // İkon eklendi
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), // Kenarlık stili
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16), // Padding ayarı
              ),
              items: sortedDepartments
                  .map((dep) => DropdownMenuItem(
                        value: dep,
                        child: Text(dep),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedDepartment = val;
                  selectedDoctor = null;
                  selectedDoctorId = null;
                  selectedDate = null;
                  selectedTime = null;
                  doctorAvailabilityData = {}; // Bölüm değişince müsaitlik verisini temizle
                });
              },
            ),
            SizedBox(height: 20), // Boşluk
            // Doktor seçimi
            DropdownButtonFormField<String?>(
              value: selectedDoctorId,
              decoration: InputDecoration(
                labelText: 'Doktor Seçiniz',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: (selectedDepartment != null && doctorsByDepartment.containsKey(selectedDepartment!))
                  ? doctorsByDepartment[selectedDepartment]!
                      .map<DropdownMenuItem<String?>>((doc) => DropdownMenuItem<String?>(
                            value: doc['doctor_id'].toString(),
                            child: Text(doc['name']!),
                          ))
                      .toList()
                  : [],
              onChanged: (String? val) {
                setState(() {
                  selectedDoctorId = val;
                  // ID'ye göre doktor objesini bul ve selectedDoctor'a ata
                  selectedDoctor = _allDoctors.firstWhere(
                      (doc) => doc['doctor_id'].toString() == val,
                      orElse: () => {}, // Bulunamazsa boş map döndür (null yerine daha güvenli)
                  );
                  selectedDate = null;
                  selectedTime = null;
                  doctorAvailabilityData = {}; // Doktor değişince müsaitlik verisini temizle
                });
                if (selectedDoctorId != null) { // ID null değilse müsaitliği çek
                  _fetchDoctorAvailability();
                }
              },
               // Dropdown menüde doktor adı gösterilirken, değer olarak tüm doktor objesi tutuluyor.
               // displayItem: (doc) => Text(doc['name']), // Bu özellik DropdownButtonFormField'de yok, Text widget'ı child olarak kullanılıyor
            ),
            SizedBox(height: 20), // Boşluk

            // Haftalık Takvim Başlığı ve Navigasyon
            if (selectedDoctor != null) ...[ // Doktor seçildiyse takvimi göster
              Row( // Haftalık takvim başlığı ve navigasyon
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 18), // İkon boyutu ayarlandı
                    onPressed: _isAvailabilityLoading ? null : _goToPreviousWeek, // Yüklenirken pasif yap
                  ),
                  Text(
                    '${DateFormat('dd.MM.yyyy').format(_currentWeekStartDate)} - ${DateFormat('dd.MM.yyyy').format(_currentWeekStartDate.add(Duration(days: 6)))}', // Tarih formatı düzeltildi
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Font boyutu
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 18), // İkon boyutu ayarlandı
                    onPressed: _isAvailabilityLoading ? null : _goToNextWeek, // Yüklenirken pasif yap
                  ),
                ],
              ),
              SizedBox(height: 16), // Boşluk
              // Takvim Tablosu veya Yüklenme Göstergesi
              _isAvailabilityLoading
                  ? Center(child: CircularProgressIndicator()) // Müsaitlik yükleniyorsa spinner göster
                  : SingleChildScrollView( // Yatay kaydırma için
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 12.0, // Sütunlar arası boşluk
                         dataRowHeight: 50, // Satır yüksekliği
                         headingRowHeight: 60, // Başlık satırı yüksekliği
                        columns: [ // Gün başlıkları
                          DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.bold))), // Saat sütunu için boş başlık
                          ...
                          weekDays.map((date) => DataColumn(label: Text(
                                  '${_getDayName(date.weekday)}\n${date.day}.${date.month}', // Gün adı ve tarih
                                  textAlign: TextAlign.center, // Ortala
                                   style: TextStyle(fontWeight: FontWeight.bold) // Kalın yap
                                ))).toList(),
                        ],
                        rows: [ // Saat satırları
                           ...allAvailableTimes.map((time) { // Her saat için bir satır
                             return DataRow(cells: [
                               DataCell(Text(time, style: TextStyle(fontWeight: FontWeight.bold))), // Saat hücresi kalın yapıldı
                               ...
                               weekDays.map((date) { // Her gün için bir hücre
                                  // Belirli gün ve saat için slot bilgisini backend verisinden al
                                  final slotInfo = _getSlotInfo(date, time);
                                  final bool isAvailable = slotInfo == null || slotInfo['durum'] == 'müsait'; // Backend'de yoksa veya müsaitse available sayılır
                                  final bool isSelected = selectedDate != null &&
                                      DateFormat('yyyy-MM-dd').format(selectedDate!) == DateFormat('yyyy-MM-dd').format(date) && // Tarih formatı karşılaştırması
                                      selectedTime == time;

                                  // Sadece hafta içi ve çalışma saatleri (backend zaten kurala uyanları döndürüyor ama UI'da emin olalım)
                                   final int dayOfWeekInt = date.weekday; // Pazartesi 1, Pazar 7
                                   bool isWorkingDayAndTime = (dayOfWeekInt >= 1 && dayOfWeekInt <= 5); // Haftaiçi

                                   if (isWorkingDayAndTime) { // Sadece hafta içi günleri işle
                                     // Burada backend'den gelen time_slots zaten kurala uygun saatleri içeriyor.
                                     // O yüzden ayrıca 09:00-12:30 ve 14:00-17:00 kontrolüne gerek yok.

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
                                                         color: isSelected ? Colors.white : Colors.green[900], // Seçiliyse beyaz, değilse yeşil
                                                         fontWeight: FontWeight.bold,
                                                          fontSize: 12 // Yazı boyutu ayarlandı
                                                       ), // Kalın yap
                                                     ), // Müsait yazısı
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
                                                       color: Colors.red[900], // Kırmızı
                                                       fontWeight: FontWeight.bold,
                                                        fontSize: 12 // Yazı boyutu ayarlandı
                                                     ), // Kalın yap
                                                   ), // Dolu yazısı
                                                 ),
                                         ),
                                       );
                                   } else { // Haftasonu veya çalışma saatleri dışı
                                       return DataCell(Container()); // Boş hücre döndür
                                   }

                               }).toList(),
                             ]);
                           }).toList(),
                        ],
                      ),
                    ),
            ],

            SizedBox(height: 32), // Boşluk
            // Randevu Al butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedDoctorId != null && // Doktor ID seçili olmalı
                        selectedDate != null &&
                        selectedTime != null &&
                        !_isLoading) // Yüklenmiyor olmalı
                    ? _bookAppointment
                    : null, // Eğer şartlar sağlanmazsa buton pasif
                style: ElevatedButton.styleFrom(
                   backgroundColor: Theme.of(context).colorScheme.secondary, // Buton rengi tema secondary color
                  foregroundColor: Colors.white, // Yazı rengi beyaz
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)), // Kenarlık yuvarlatma
                  padding: EdgeInsets.symmetric(vertical: 20), // Padding
                ),
                child: _isLoading // Buton yükleniyorsa spinner göster
                    ? SizedBox(
                         width: 24,
                         height: 24,
                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5,)
                      )
                    : Text('Randevu Al',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Yazı stili
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