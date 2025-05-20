import 'package:flutter/material.dart';
import '../../../main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

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

  // Takvim için etkinlikler haritası
  late final ValueNotifier<List<Map<String, dynamic>>> _selectedEvents;
  late Map<DateTime, List<Map<String, dynamic>>> _events;

  // Bugünün tarihi
  final DateTime _today = DateTime.now();

  // Örnek veriler - bugünkü randevular
  late final List<Map<String, dynamic>> _todayAppointments = [
    {
      'patientName': 'Ahmet Yılmaz',
      'patientAge': 45,
      'time': '09:30',
      'date': '${_today.day} ${getMonthName(_today.month)} ${_today.year}',
      'type': 'Kontrol',
      'status': 'Onaylandı',
      'notes': 'Kan tahlil sonuçları kontrolü',
      'avatar': 'AY',
      'department': 'Kardiyoloji',
      'reason': 'Rutin kontrol',
      'completed': false,
      'canceled': false,
      'dateTime': DateTime(_today.year, _today.month, _today.day, 9, 30),
    },
    {
      'patientName': 'Ayşe Kaya',
      'patientAge': 32,
      'time': '10:15',
      'date': '${_today.day} ${getMonthName(_today.month)} ${_today.year}',
      'type': 'İlk Muayene',
      'status': 'Beklemede',
      'notes': 'Baş ağrısı şikayeti',
      'avatar': 'AK',
      'department': 'Kardiyoloji',
      'reason': 'Baş ağrısı şikayeti',
      'completed': false,
      'canceled': false,
      'dateTime': DateTime(_today.year, _today.month, _today.day, 10, 15),
    },
    {
      'patientName': 'Mehmet Demir',
      'patientAge': 58,
      'time': '11:30',
      'date': '${_today.day} ${getMonthName(_today.month)} ${_today.year}',
      'type': 'Acil',
      'status': 'Onaylandı',
      'notes': 'Göğüs ağrısı ve tansiyon kontrolü',
      'avatar': 'MD',
      'department': 'Kardiyoloji',
      'reason': 'Göğüs ağrısı',
      'completed': true,
      'canceled': false,
      'dateTime': DateTime(_today.year, _today.month, _today.day, 11, 30),
    },
  ];

  // Gelecekteki randevular için tarihleri önceden hesapla
  final DateTime _dayPlus2 = DateTime.now().add(const Duration(days: 2));
  final DateTime _dayPlus3 = DateTime.now().add(const Duration(days: 3));
  final DateTime _dayPlus5 = DateTime.now().add(const Duration(days: 5));
  final DateTime _dayMinus1 = DateTime.now().subtract(const Duration(days: 1));
  final DateTime _dayMinus2 = DateTime.now().subtract(const Duration(days: 2));

  // Örnek veriler - gelecek randevular
  late final List<Map<String, dynamic>> _futureAppointments = [
    {
      'patientName': 'Zeynep Yıldız',
      'patientAge': 28,
      'time': '14:00',
      'date':
          '${_dayPlus2.day} ${getMonthName(_dayPlus2.month)} ${_dayPlus2.year}',
      'type': 'Kontrol',
      'status': 'Onaylandı',
      'notes': 'İlaç sonrası değerlendirme',
      'avatar': 'ZY',
      'department': 'Kardiyoloji',
      'reason': 'İlaç değerlendirmesi',
      'completed': false,
      'canceled': false,
      'dateTime':
          DateTime(_dayPlus2.year, _dayPlus2.month, _dayPlus2.day, 14, 0),
    },
    {
      'patientName': 'Ali Öztürk',
      'patientAge': 41,
      'time': '15:30',
      'date':
          '${_dayPlus3.day} ${getMonthName(_dayPlus3.month)} ${_dayPlus3.year}',
      'type': 'İlk Muayene',
      'status': 'Beklemede',
      'notes': 'Sırt ağrısı şikayeti',
      'avatar': 'AÖ',
      'department': 'Kardiyoloji',
      'reason': 'Sırt ağrısı',
      'completed': false,
      'canceled': true,
      'dateTime':
          DateTime(_dayPlus3.year, _dayPlus3.month, _dayPlus3.day, 15, 30),
    },
    {
      'patientName': 'Hakan Aydın',
      'patientAge': 52,
      'time': '09:00',
      'date':
          '${_dayPlus5.day} ${getMonthName(_dayPlus5.month)} ${_dayPlus5.year}',
      'type': 'Takip',
      'status': 'Onaylandı',
      'notes': 'Kalp ritim bozukluğu takibi',
      'avatar': 'HA',
      'department': 'Kardiyoloji',
      'reason': 'Ritim bozukluğu takibi',
      'completed': false,
      'canceled': false,
      'dateTime':
          DateTime(_dayPlus5.year, _dayPlus5.month, _dayPlus5.day, 9, 0),
    },
    {
      'patientName': 'Fatma Şen',
      'patientAge': 65,
      'time': '11:15',
      'date':
          '${_dayMinus2.day} ${getMonthName(_dayMinus2.month)} ${_dayMinus2.year}',
      'type': 'Kontrol',
      'status': 'Tamamlandı',
      'notes': 'Düzenli kontrol muayenesi',
      'avatar': 'FŞ',
      'department': 'Kardiyoloji',
      'reason': 'Düzenli kontrol',
      'completed': true,
      'canceled': false,
      'dateTime':
          DateTime(_dayMinus2.year, _dayMinus2.month, _dayMinus2.day, 11, 15),
    },
    {
      'patientName': 'Kemal Yılmaz',
      'patientAge': 48,
      'time': '16:00',
      'date':
          '${_dayMinus1.day} ${getMonthName(_dayMinus1.month)} ${_dayMinus1.year}',
      'type': 'Acil',
      'status': 'İptal',
      'notes': 'Hasta gelmedi',
      'avatar': 'KY',
      'department': 'Kardiyoloji',
      'reason': 'Kalp çarpıntısı',
      'completed': false,
      'canceled': true,
      'dateTime':
          DateTime(_dayMinus1.year, _dayMinus1.month, _dayMinus1.day, 16, 0),
    },
  ];

  // Örnek veriler - geçmiş randevular arşivi
  final List<Map<String, dynamic>> _archivedAppointments = [
    {
      'patientName': 'Hüseyin Kara',
      'patientAge': 37,
      'time': '13:45',
      'date': '5 Mayıs 2024',
      'type': 'Kontrol',
      'status': 'Tamamlandı',
      'notes': 'Tansiyon değerleri normale dönmüş, ilaç dozunu azaltıyoruz.',
      'doctorNotes':
          'Hastaya sağlıklı beslenme ve egzersiz önerildi. 3 ay sonra kontrol.',
      'avatar': 'HK',
      'department': 'Kardiyoloji',
      'reason': 'Tansiyon kontrolü',
      'completed': true,
      'canceled': false,
      'dateTime': DateTime.now().subtract(const Duration(days: 20)),
    },
    {
      'patientName': 'Aylin Yıldırım',
      'patientAge': 42,
      'time': '10:30',
      'date': '12 Nisan 2024',
      'type': 'Takip',
      'status': 'Tamamlandı',
      'notes': 'EKG sonuçları normal, ritim düzenli.',
      'doctorNotes':
          'İlaç tedavisine devam, stres faktörlerinin azaltılması önerildi.',
      'avatar': 'AY',
      'department': 'Kardiyoloji',
      'reason': 'Ritim bozukluğu takibi',
      'completed': true,
      'canceled': false,
      'dateTime': DateTime.now().subtract(const Duration(days: 45)),
    },
    {
      'patientName': 'Murat Öztürk',
      'patientAge': 65,
      'time': '09:15',
      'date': '28 Mart 2024',
      'type': 'Acil',
      'status': 'Tamamlandı',
      'notes': 'Göğüs ağrısı şikayetiyle acil başvuru.',
      'doctorNotes':
          'Akut MI şüphesi, acil kateter ünitesine sevk edildi. Takipte MI doğrulanmadı.',
      'avatar': 'MÖ',
      'department': 'Kardiyoloji',
      'reason': 'Göğüs ağrısı',
      'completed': true,
      'canceled': false,
      'dateTime': DateTime.now().subtract(const Duration(days: 60)),
    },
  ];

  // Tüm randevuları birleştir
  List<Map<String, dynamic>> get _allAppointments {
    return [
      ..._todayAppointments,
      ..._futureAppointments,
      ..._archivedAppointments
    ];
  }

  // Seçilen güne ait randevuları getir
  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return _allAppointments.where((appointment) {
      final appointmentDate = appointment['dateTime'] as DateTime;
      return appointmentDate.year == day.year &&
          appointmentDate.month == day.month &&
          appointmentDate.day == day.day;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // 3 sekme: bugün, gelecek, arşiv

    // Takvimi bugünün tarihine odakla
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;

    // Debug: Randevu sayılarını kontrol et
    print('Today appointments: ${_todayAppointments.length}');
    print('Future appointments: ${_futureAppointments.length}');
    print('Archived appointments: ${_archivedAppointments.length}');
    print('All appointments: ${_allAppointments.length}');

    // Randevuları tarihlerine göre ayır
    _loadAppointments();
  }

  void _loadAppointments() {
    // Etkinlikleri yükle
    _events = {};

    // Tüm randevuları döngüyle işle
    for (var appointment in _allAppointments) {
      final DateTime dateTime = appointment['dateTime'] as DateTime;
      // Tarihi normalize et (saat, dakika, saniye bilgilerini kaldır)
      final DateTime date =
          DateTime(dateTime.year, dateTime.month, dateTime.day);

      // Debug: Randevu detaylarını yazdır
      print('Appointment: ${appointment['patientName']} on ${date.toString()}');

      if (_events[date] != null) {
        _events[date]!.add(appointment);
      } else {
        _events[date] = [appointment];
      }
    }

    // Debug: Oluşturulan etkinlik sayısını kontrol et
    print('Event dates count: ${_events.length}');
    _events.forEach((date, events) {
      print('Date: $date, Events: ${events.length}');
    });

    // Seçilen gün için etkinlikleri güncelle
    if (_selectedDay != null) {
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    } else {
      _selectedEvents = ValueNotifier([]);
    }
  }

  // Belirli bir gün için etkinlikleri al
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    // Tarihi normalize et
    final DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    // Debug: Belirli gün için etkinlik arama
    print('Getting events for: $normalizedDay');
    final events = _events[normalizedDay] ?? [];
    print('Found ${events.length} events');

    return events;
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

    // Saatleri sırala (08:00-18:00 arası)
    final List<String> timeSlots = List.generate(11, (index) {
      final hour = index + 8;
      return '${hour.toString().padLeft(2, '0')}:00';
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = timeSlots[index];
        final hour = int.parse(timeSlot.split(':')[0]);

        // Bu saat dilimindeki randevuları bul
        final slotEvents = events.where((event) {
          final eventDateTime = event['dateTime'] as DateTime;
          return eventDateTime.hour == hour;
        }).toList();

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
      final DateTime dateTimeA = a['dateTime'] as DateTime;
      final DateTime dateTimeB = b['dateTime'] as DateTime;
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
    final String status = appointment['status']?.toString() ?? 'Beklemede';
    final bool isCompleted = appointment['completed'] ?? false;
    final bool isCanceled = appointment['canceled'] ?? false;
    final String doctorNotes = appointment['doctorNotes']?.toString() ?? '';

    // Duruma göre renk belirleme
    final Color statusColor = isCompleted
        ? Colors.green
        : isCanceled
            ? Colors.red
            : HealthApp.primaryColor;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: statusColor,
          radius: 24,
          child: Text(
            appointment['avatar']?.toString().substring(0, 1) ?? 'X',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          appointment['patientName']?.toString() ?? 'İsimsiz Hasta',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${appointment['patientAge']?.toString() ?? '?'} yaş',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(
              appointment['dateTime'] != null
                  ? '${_formatDate(appointment['dateTime'])}, ${_formatTime(appointment['dateTime'])}'
                  : appointment['date']?.toString() ?? 'Tarih belirtilmemiş',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            isCompleted
                ? 'Tamamlandı'
                : isCanceled
                    ? 'İptal Edildi'
                    : status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    'Bölüm', appointment['department'] ?? 'Belirtilmemiş'),
                const SizedBox(height: 8),
                _buildInfoRow('Tür', appointment['type'] ?? 'Belirtilmemiş'),
                const SizedBox(height: 8),
                _buildInfoRow(
                    'Sebep', appointment['reason'] ?? 'Belirtilmemiş'),
                const SizedBox(height: 8),
                _buildInfoRow('Not', appointment['notes'] ?? 'Not yok'),
                const SizedBox(height: 8),
                // Doktor notları
                const Text(
                  'Doktor Notları:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    _showDoctorNotesEditor(appointment);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!)),
                    width: double.infinity,
                    child: Text(
                      doctorNotes.isEmpty
                          ? 'Henüz not eklenmemiş. Eklemek için tıklayın.'
                          : doctorNotes,
                      style: TextStyle(
                        color: doctorNotes.isEmpty
                            ? Colors.grey[600]
                            : Colors.black87,
                        fontStyle: doctorNotes.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isCompleted && !isCanceled) ...[
                      OutlinedButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text('İptal Et'),
                        onPressed: () {
                          _showCancelConfirmation(appointment);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.email),
                        label: const Text('Mesaj'),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Tamamlandı'),
                        onPressed: () {
                          _showCompleteConfirmation(appointment);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ] else if (isCompleted && !isCanceled) ...[
                      OutlinedButton.icon(
                        icon: const Icon(Icons.note_add),
                        label: const Text('Not Ekle'),
                        onPressed: () {
                          _showDoctorNotesEditor(appointment);
                        },
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.restore),
                        label: const Text('Yeniden Planla'),
                        onPressed: () {
                          _showRescheduleConfirmation(appointment);
                        },
                      ),
                    ] else ...[
                      OutlinedButton.icon(
                        icon: const Icon(Icons.restore),
                        label: const Text('Yeniden Planla'),
                        onPressed: () {
                          _showRescheduleConfirmation(appointment);
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day} ${getMonthName(dateTime.month)} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showCompleteConfirmation(Map<String, dynamic> appointment) {
    final String patientName =
        appointment['patientName']?.toString() ?? 'İsimsiz Hasta';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Randevuyu Tamamla'),
        content: Text(
            '$patientName için randevuyu tamamlandı olarak işaretlemek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                appointment['completed'] = true;
                appointment['status'] = 'Tamamlandı';
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Tamamlandı'),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(Map<String, dynamic> appointment) {
    final String patientName =
        appointment['patientName']?.toString() ?? 'İsimsiz Hasta';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Randevuyu İptal Et'),
        content: Text(
            '$patientName için randevuyu iptal etmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                appointment['canceled'] = true;
                appointment['status'] = 'İptal';
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleConfirmation(Map<String, dynamic> appointment) {
    final String patientName =
        appointment['patientName']?.toString() ?? 'İsimsiz Hasta';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Randevuyu Yeniden Planla'),
        content: Text(
            '$patientName için randevuyu yeniden planlamak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                appointment['completed'] = false;
                appointment['canceled'] = false;
                appointment['status'] = 'Beklemede';
              });
              Navigator.pop(context);

              // Yeni tarih seçme diyaloğu burada açılabilir
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Yeniden planlama özelliği yakında eklenecektir'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HealthApp.primaryColor,
            ),
            child: const Text('Yeniden Planla'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value?.toString() ?? '-',
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
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

  // Doktor notları düzenleme dialogu
  void _showDoctorNotesEditor(Map<String, dynamic> appointment) {
    final TextEditingController notesController = TextEditingController();
    notesController.text = appointment['doctorNotes']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Doktor Notları'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${appointment['patientName']} - ${_formatDate(appointment['dateTime'])}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                hintText: 'Randevu ile ilgili notlarınızı giriniz...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                appointment['doctorNotes'] = notesController.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HealthApp.primaryColor,
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
