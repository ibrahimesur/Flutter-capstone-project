import 'package:flutter/material.dart';
import '../../../main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Appointment {
  final String id;
  final String patientName;
  final String patientAge;
  final String department;
  final String date;
  final String time;
  final String? notes;
  final String? doctorNotes;
  final String? boy;
  final String? kilo;
  final String? kanGrubu;
  final String? kronikHastaliklar;
  final String? alerjiler;
  final bool completed;
  final bool canceled;

  Appointment({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.department,
    required this.date,
    required this.time,
    this.notes,
    this.doctorNotes,
    this.boy,
    this.kilo,
    this.kanGrubu,
    this.kronikHastaliklar,
    this.alerjiler,
    this.completed = false,
    this.canceled = false,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      patientName: json['hasta_adi']?.toString() ?? 'İsimsiz Hasta',
      patientAge: json['hasta_yasi']?.toString() ?? '0',
      department: json['bolum']?.toString() ?? 'Belirtilmemiş',
      date: json['randevu_tarihi']?.toString() ?? '',
      time: json['randevu_saati']?.toString() ?? '',
      notes: json['notlar']?.toString() ?? '',
      doctorNotes: json['doktor_notlari']?.toString() ?? '',
      boy: json['boy']?.toString(),
      kilo: json['kilo']?.toString(),
      kanGrubu: json['kan_grubu']?.toString(),
      kronikHastaliklar: json['kronik_hastaliklar']?.toString(),
      alerjiler: json['alerjiler']?.toString(),
      completed: json['completed'] ?? false,
      canceled: json['canceled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hasta_adi': patientName,
      'hasta_yasi': patientAge,
      'bolum': department,
      'randevu_tarihi': date,
      'randevu_saati': time,
      'notlar': notes,
      'doktor_notlari': doctorNotes,
      'boy': boy,
      'kilo': kilo,
      'kan_grubu': kanGrubu,
      'kronik_hastaliklar': kronikHastaliklar,
      'alerjiler': alerjiler,
      'completed': completed,
      'canceled': canceled,
    };
  }
}

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});

  @override
  State<AppointmentsTab> createState() => _AppointmentsTabState();
}

// Statik ay isimleri
String getMonthName(int month) {
  const monthNames = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık'
  ];
  return monthNames[month - 1];
}

class _AppointmentsTabState extends State<AppointmentsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showCalendarView = false;
  bool _showDailyView = false;
  bool _isLoading = false;
  String? _error;

  // Takvim için etkinlikler haritası
  late final ValueNotifier<List<Map<String, dynamic>>> _selectedEvents;
  late Map<DateTime, List<Map<String, dynamic>>> _events;

  // Bugünün tarihi
  final DateTime _today = DateTime.now();

  // Randevuları tutacak listeler
  List<Map<String, dynamic>> _todayAppointments = [];
  List<Map<String, dynamic>> _futureAppointments = [];
  List<Map<String, dynamic>> _archivedAppointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id_value');
      print('DEBUG: Retrieved user_id_value from SharedPreferences: $userId');

      if (userId == null || userId.isEmpty) {
        print('DEBUG: User ID is null or empty in SharedPreferences');
        throw Exception('Doktor ID bulunamadı');
      }

      // Bugünün randevularını getir
      final todayResponse = await http.get(
        Uri.parse('http://localhost:8000/doctor-appointments/$userId/today'),
      );
      print('DEBUG: Today appointments response: ${todayResponse.body}');

      if (todayResponse.statusCode == 200) {
        final List<dynamic> todayData = json.decode(todayResponse.body);
        setState(() {
          _todayAppointments = todayData.map((json) => Appointment.fromJson(json).toJson()).toList();
        });
      } else {
        throw Exception('Bugünün randevuları yüklenirken hata oluştu');
      }

      // Gelecek randevuları getir
      final upcomingResponse = await http.get(
        Uri.parse('http://localhost:8000/doctor-appointments/$userId/future'),
      );

      if (upcomingResponse.statusCode == 200) {
        final List<dynamic> upcomingData = json.decode(upcomingResponse.body);
        setState(() {
          _futureAppointments = upcomingData.map((json) => Appointment.fromJson(json).toJson()).toList();
        });
      } else {
        throw Exception('Gelecek randevular yüklenirken hata oluştu');
      }

      // Arşivlenmiş randevuları getir
      final archivedResponse = await http.get(
        Uri.parse('http://localhost:8000/doctor-appointments/$userId/archived'),
      );

      if (archivedResponse.statusCode == 200) {
        final List<dynamic> archivedData = json.decode(archivedResponse.body);
        setState(() {
          _archivedAppointments = archivedData.map((json) => Appointment.fromJson(json).toJson()).toList();
        });
      } else {
        throw Exception('Arşivlenmiş randevular yüklenirken hata oluştu');
      }

      _updateCalendarEvents();
    } catch (e) {
      print('DEBUG: Randevular yüklenirken hata: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateCalendarEvents() {
    _events = {};

    // Tüm randevuları birleştir
    final allAppointments = [
      ..._todayAppointments,
      ..._futureAppointments,
      ..._archivedAppointments
    ];

    // Randevuları tarihlerine göre grupla
    for (var appointment in allAppointments) {
      String dateStr = appointment['randevu_tarihi']?.toString() ?? '';
      String timeStr = appointment['randevu_saati']?.toString() ?? '00:00';
      DateTime? dateTime;
      try {
        final date = DateTime.parse(dateStr);
        final timeParts = timeStr.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        dateTime = DateTime(date.year, date.month, date.day, hour, minute);
      } catch (_) {
        dateTime = null;
      }
      if (dateTime == null) continue;
      final DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

      // Her randevuya dateTime alanı ekle
      appointment['dateTime'] = dateTime;

      if (_events[dateOnly] != null) {
        _events[dateOnly]!.add(appointment);
      } else {
        _events[dateOnly] = [appointment];
      }
    }

    // Seçilen gün için etkinlikleri güncelle
    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }

  // Belirli bir gün için etkinlikleri al
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildViewToggle(),
          if (_showCalendarView) _buildCalendarView() else _buildListView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HealthApp.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Yeni randevu ekleme işlevi
          _showAddAppointmentDialog();
        },
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: HealthApp.backgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Randevularım',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HealthApp.primaryColor,
            ),
          ),
          const Spacer(),
          ToggleButtons(
            isSelected: [!_showCalendarView, _showCalendarView],
            onPressed: (index) {
              setState(() {
                _showCalendarView = index == 1;
              });
            },
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: HealthApp.primaryColor,
            color: HealthApp.primaryColor,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.view_list),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.calendar_month),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: HealthApp.primaryColor.withOpacity(0.1),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: HealthApp.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: HealthApp.primaryColor,
              tabs: const [
                Tab(text: 'BUGÜNKÜ RANDEVULAR'),
                Tab(text: 'GELECEK RANDEVULAR'),
                Tab(text: 'ARŞİV'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList(_todayAppointments, true),
                _buildAppointmentList(_futureAppointments, false),
                _buildAppointmentList(_archivedAppointments, false,
                    isArchive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _calendarFormat = CalendarFormat.month;
                      _showDailyView = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _calendarFormat == CalendarFormat.month &&
                            !_showDailyView
                        ? HealthApp.primaryColor.withOpacity(0.1)
                        : null,
                    foregroundColor: _calendarFormat == CalendarFormat.month &&
                            !_showDailyView
                        ? HealthApp.primaryColor
                        : Colors.grey,
                    side: BorderSide(
                      color: _calendarFormat == CalendarFormat.month &&
                              !_showDailyView
                          ? HealthApp.primaryColor
                          : Colors.grey,
                    ),
                  ),
                  child: const Text('Aylık'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _calendarFormat = CalendarFormat.week;
                      _showDailyView = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _calendarFormat == CalendarFormat.week &&
                            !_showDailyView
                        ? HealthApp.primaryColor.withOpacity(0.1)
                        : null,
                    foregroundColor: _calendarFormat == CalendarFormat.week &&
                            !_showDailyView
                        ? HealthApp.primaryColor
                        : Colors.grey,
                    side: BorderSide(
                      color: _calendarFormat == CalendarFormat.week &&
                              !_showDailyView
                          ? HealthApp.primaryColor
                          : Colors.grey,
                    ),
                  ),
                  child: const Text('Haftalık'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      // TableCalendar'da günlük görünüm olmadığı için özel bir görünüm kullanıyoruz
                      _showDailyView = true;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _showDailyView
                        ? HealthApp.primaryColor.withOpacity(0.1)
                        : null,
                    foregroundColor:
                        _showDailyView ? HealthApp.primaryColor : Colors.grey,
                    side: BorderSide(
                      color:
                          _showDailyView ? HealthApp.primaryColor : Colors.grey,
                    ),
                  ),
                  child: const Text('Günlük'),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      // Bugüne git butonu
                      _focusedDay = DateTime.now();
                      _selectedDay = DateTime.now();
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HealthApp.primaryColor,
                  ),
                  child: const Text('Bugün'),
                ),
              ],
            ),
          ),
          // Günlük görünüm etkinse takvimi küçült, sadece tarih seçiciyi göster
          if (_showDailyView)
            _buildDailyCalendarCompact()
          else
            TableCalendar<Map<String, dynamic>>(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Ay',
                CalendarFormat.week: 'Hafta',
              },
              selectedDayPredicate: (day) {
                return _selectedDay != null &&
                    day.year == _selectedDay!.year &&
                    day.month == _selectedDay!.month &&
                    day.day == _selectedDay!.day;
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEvents.value = _getEventsForDay(selectedDay);

                  // Debug: Seçilen gün için etkinlikler
                  print('Selected day: $selectedDay');
                  print('Selected events: ${_selectedEvents.value.length}');
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return null;

                  // Tamamlanan ve iptal edilen randevu sayılarını hesapla
                  int completedCount = 0;
                  int canceledCount = 0;
                  int activeCount = 0;

                  for (var event in events) {
                    final appointment = event;
                    if (appointment['completed'] == true) {
                      completedCount++;
                    } else if (appointment['canceled'] == true) {
                      canceledCount++;
                    } else {
                      activeCount++;
                    }
                  }

                  return Positioned(
                    bottom: 1,
                    right: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (activeCount > 0)
                          _buildMarker(activeCount, HealthApp.primaryColor),
                        if (completedCount > 0)
                          _buildMarker(completedCount, Colors.green),
                        if (canceledCount > 0)
                          _buildMarker(canceledCount, Colors.red),
                      ],
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                markersMaxCount: 3,
                todayDecoration: BoxDecoration(
                  color: HealthApp.primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: HealthApp.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: HealthApp.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  _selectedDay != null
                      ? '${_selectedDay!.day} ${getMonthName(_selectedDay!.month)} ${_selectedDay!.year}'
                      : 'Seçilen Gün',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    _colorIndicator(Colors.green, 'Tamamlandı'),
                    const SizedBox(width: 8),
                    _colorIndicator(Colors.red, 'İptal'),
                    const SizedBox(width: 8),
                    _colorIndicator(HealthApp.primaryColor, 'Planlandı'),
                  ],
                ),
              ],
            ),
          ),
          // Günlük görünüm etkinse saat bazlı görünüm göster
          Expanded(
            child: _showDailyView
                ? _buildDailyTimelineView()
                : ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return _buildDayAppointments(value);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Günlük görünüm için küçük takvim widgeti
  Widget _buildDailyCalendarCompact() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              setState(() {
                _selectedDay = _selectedDay!.subtract(const Duration(days: 1));
                _focusedDay = _selectedDay!;
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              });
            },
          ),
          GestureDetector(
            onTap: () async {
              // Tarih seçici dialogu göster
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDay ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(
                        primary: HealthApp.primaryColor,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != _selectedDay) {
                setState(() {
                  _selectedDay = picked;
                  _focusedDay = picked;
                  _selectedEvents.value = _getEventsForDay(_selectedDay!);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: HealthApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: HealthApp.primaryColor),
              ),
              child: Text(
                _selectedDay != null
                    ? '${_selectedDay!.day} ${getMonthName(_selectedDay!.month)} ${_selectedDay!.year}'
                    : 'Tarih Seç',
                style: TextStyle(
                  color: HealthApp.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              setState(() {
                _selectedDay = _selectedDay!.add(const Duration(days: 1));
                _focusedDay = _selectedDay!;
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              });
            },
          ),
        ],
      ),
    );
  }

  // Günlük saat bazlı randevu görünümü
  Widget _buildDailyTimelineView() {
    final events = _selectedEvents.value;
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Bu tarih için randevu yok',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Saatleri sırala (08:00-18:00 arası, 30'ar dakika aralıklarla)
    final List<String> timeSlots = [];
    for (int hour = 8; hour <= 18; hour++) {
      timeSlots.add('${hour.toString().padLeft(2, '0')}:00');
      if (hour != 18) {
        timeSlots.add('${hour.toString().padLeft(2, '0')}:30');
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = timeSlots[index];
        final slotHour = int.parse(timeSlot.split(':')[0]);
        final slotMinute = int.parse(timeSlot.split(':')[1]);

        // Bu saat dilimindeki randevuları bul (saat ve dakika eşleşmesi)
        final slotEvents = events.where((event) {
          DateTime? eventDateTime;
          if (event['dateTime'] is DateTime) {
            eventDateTime = event['dateTime'];
          } else if (event['randevu_tarihi'] != null) {
            eventDateTime = DateTime.tryParse(event['randevu_tarihi'].toString());
          }
          if (eventDateTime == null) return false;
          return eventDateTime.hour == slotHour && eventDateTime.minute == slotMinute;
        }).toList();

        // Slot içindeki randevuları saat sırasına göre sırala
        slotEvents.sort((a, b) {
          final aTime = a['dateTime'] is DateTime
              ? a['dateTime']
              : DateTime.tryParse(a['randevu_tarihi']?.toString() ?? '') ?? DateTime(1970);
          final bTime = b['dateTime'] is DateTime
              ? b['dateTime']
              : DateTime.tryParse(b['randevu_tarihi']?.toString() ?? '') ?? DateTime(1970);
          return aTime.compareTo(bTime);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    timeSlot,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
            if (slotEvents.isNotEmpty)
              ...slotEvents.map((event) => Padding(
                    padding:
                        const EdgeInsets.only(left: 60, top: 8, bottom: 16),
                    child: _buildAppointmentCard(event),
                  ))
            else
              SizedBox(height: 30), // Boş saat dilimlerinde daha az yer kapla
          ],
        );
      },
    );
  }

  Widget _colorIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildDayAppointments(List<Map<String, dynamic>> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Bu tarih için randevu yok',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Zamanlarına göre sırala
    appointments.sort((a, b) {
      final DateTime dateTimeA = a['dateTime'] is DateTime
          ? a['dateTime']
          : DateTime.tryParse(a['randevu_tarihi']?.toString() ?? '') ?? DateTime(1970);
      final DateTime dateTimeB = b['dateTime'] is DateTime
          ? b['dateTime']
          : DateTime.tryParse(b['randevu_tarihi']?.toString() ?? '') ?? DateTime(1970);
      return dateTimeA.compareTo(dateTimeB);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Randevu Ekle'),
        content: const Text('Bu özellik yapım aşamasındadır.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(
      List<Map<String, dynamic>> appointments, bool isToday,
      {bool isArchive = false}) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              isToday
                  ? 'Bugün için randevu yok'
                  : isArchive
                      ? 'Arşivde kayıtlı randevu bulunmuyor'
                      : 'Gelecek randevu bulunmuyor',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final DateTime appointmentDate = DateTime.parse(appointment['randevu_tarihi']?.toString() ?? '1970-01-01');
    final bool isPast = appointmentDate.isBefore(DateTime.now());
    final bool isToday = appointmentDate.year == DateTime.now().year &&
        appointmentDate.month == DateTime.now().month &&
        appointmentDate.day == DateTime.now().day;

    Color statusColor;
    String statusText;
    if (isPast) {
      statusColor = Colors.green;
      statusText = 'Tamamlandı';
    } else if (isToday) {
      statusColor = HealthApp.primaryColor;
      statusText = 'Bugün';
    } else {
      statusColor = Colors.orange;
      statusText = 'Planlandı';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: HealthApp.primaryColor,
          child: Text(
                    (appointment['hasta_adi'] ?? '??').toString().substring(0, 2).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment['hasta_adi']?.toString() ?? 'İsimsiz Hasta',
          style: const TextStyle(
            fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            Text(
                      '${appointment['hasta_yasi']?.toString() ?? '0'} yaş',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
            ),
          ],
        ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
          ),
          child: Text(
                    statusText,
            style: TextStyle(
              color: statusColor,
                      fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
              ],
            ),
            const SizedBox(height: 8),
            // Sağlık profili bilgileri sadece Column içinde, softWrap ve overflow ile
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Boy: ${appointment['boy'] ?? '-'} cm', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Text('Kilo: ${appointment['kilo'] ?? '-'} kg', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Text('Kan Grubu: ${appointment['kan_grubu'] ?? '-'}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                Text('Kronik Hastalıklar: ${appointment['kronik_hastaliklar'] ?? '-'}', style: TextStyle(color: Colors.grey[600], fontSize: 13), softWrap: true, overflow: TextOverflow.visible),
                Text('Alerjiler: ${appointment['alerjiler'] ?? '-'}', style: TextStyle(color: Colors.grey[600], fontSize: 13), softWrap: true, overflow: TextOverflow.visible),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  appointment['randevu_saati']?.toString() ?? '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${appointmentDate.day} ${getMonthName(appointmentDate.month)} ${appointmentDate.year}',
                      style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if ((appointment['notlar']?.toString() ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Notlar: ${appointment['notlar']?.toString() ?? ''}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            if ((appointment['doktor_notlari']?.toString() ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Doktor Notları: ${appointment['doktor_notlari']?.toString() ?? ''}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isPast)
                  TextButton.icon(
                        onPressed: () {
                      _cancelAppointment(appointment['id']?.toString() ?? '');
                    },
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      'İptal Et',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (!isPast)
                  TextButton.icon(
                        onPressed: () {
                      _completeAppointment(appointment['id']?.toString() ?? '');
                        },
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    label: const Text(
                      'Tamamla',
                      style: TextStyle(color: Colors.green),
                      ),
                ),
              ],
          ),
        ],
        ),
      ),
    );
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/cancel-appointment/$appointmentId'),
      );

      if (response.statusCode == 200) {
        // Randevuları yeniden yükle
        await _loadAppointments();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Randevu iptal edildi'),
              backgroundColor: Colors.green,
      ),
    );
  }
      } else {
        throw Exception('Randevu iptal edilemedi');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Randevu iptal edilirken hata oluştu: $e'),
              backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _completeAppointment(String appointmentId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/complete-appointment/$appointmentId'),
      );

      if (response.statusCode == 200) {
        // Randevuları yeniden yükle
        await _loadAppointments();
        if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
              content: Text('Randevu tamamlandı'),
              backgroundColor: Colors.green,
      ),
    );
  }
      } else {
        throw Exception('Randevu tamamlanamadı');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Randevu tamamlanırken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildMarker(int count, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 8,
      height: 8,
    );
  }
}
