import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'doctor_panel/doctor_panel_screen.dart';
import 'hospital_panel/hospital_panel_screen.dart';
import 'dart:async';
import '../services/semptom_service.dart';
import '../services/randevu.dart';
import '../widgets/appointment_booking_modal.dart'; // RandevuAyarlamaModal için import
import '../widgets/custom_time_picker_dialog.dart'; // CustomTimePickerDialog için import

class HomeScreen extends StatefulWidget {
  final int initialTab;
  const HomeScreen({super.key, this.initialTab = 0});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  // globalRandevuList buraya taşındı
  List<Randevu> randevuList = [];

  final List<Widget> _pages = const [
    // RandevuPage() kaldırıldı
    HaritaPage(),
    MesajlarPage(),
    ProfilPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab > 0 ? widget.initialTab -1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sağlık Yönetim Sistemi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Bildirimler sayfası
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.person),
            onSelected: (String result) {
              if (result == 'logout') {
                // Çıkış yap işlemi
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              } else if (result == 'language') {
                // Dil seçeneği işlemi
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dil seçeneği ayarları buraya gelecek.'),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Çıkış Yap'),
              ),
              const PopupMenuItem<String>(
                value: 'language',
                child: Text('Dil Seçeneği'),
              ),
            ],
          ),
        ],
      ),
      // Body içeriği seçili indexe göre güncellendi
      body: _selectedIndex == 0 // Eğer ilk tab (Randevu tabı) seçiliyse
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Randevu',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: HealthApp.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                   Row(
                     children: [
                       Expanded(
                         child: Text(
                           'Yaklaşan randevularınızı görüntüleyin veya yeni bir randevu alın.',
                           style: TextStyle(
                             color: Colors.grey[600],
                             fontSize: 16,
                           ),
                         ),
                       ),
                        ElevatedButton.icon(
                         onPressed: () {
                           Navigator.pushNamed(context, '/semptom-tarama');
                         },
                         icon: Icon(Icons.health_and_safety, color: Colors.white),
                         label: Text(
                           'Semptom Analizi ile Randevu Al',
                           style: TextStyle(
                             color: Colors.white,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         style: ElevatedButton.styleFrom(
                           backgroundColor: HealthApp.primaryColor,
                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(12),
                           ),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 24),

                   // Randevu Ayarlama Modalı
                    RandevuAyarlamaModal(
                      onAppointmentBooked: (appointment) {
                        setState(() {
                          randevuList.add(appointment);
                        });
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                             content: Text('Randevu başarıyla oluşturuldu!'),
                             backgroundColor: Colors.green,
                           ),
                         );
                      },
                    ),

                   const SizedBox(height: 24),
                   Card(
                     child: Padding(
                       padding: const EdgeInsets.all(20),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            Text(
                             'Yaklaşan Randevularınız',
                             style: TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.w600,
                               color: HealthApp.primaryColor,
                             ),
                           ),
                           const SizedBox(height: 16),
                            // Yaklaşan randevular listesi
                            SizedBox(
                              height: 200, // Örnek yükseklik
                              child: ListView.builder(
                                itemCount: randevuList.length,
                                itemBuilder: (context, index) {
                                  final randevu = randevuList[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Icon(Icons.event_available, color: Colors.blue),
                                      title: Text(
                                          '${randevu.department} - ${randevu.doctor}'),
                                      subtitle: Text(
                                        '${randevu.date.day}.${randevu.date.month}.${randevu.date.year} - ${randevu.time}'),
                                       // İsteğe bağlı: Detayları göstermek için onTap ekleyebilirsiniz
                                       onTap: () {
                                         // Randevu detaylarını gösterme
                                       },
                                    ),
                                  );
                                },
                              ),
                            ),
                         ],
                       ),
                     ),
                   ),
                ],
              ),
            )
          : _pages[_selectedIndex + 1], // Randevu sayfası kaldırıldığı için indexi ayarla
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Randevu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Harita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilim',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HaritaPage extends StatefulWidget {
  const HaritaPage({super.key});

  @override
  _HaritaPageState createState() => _HaritaPageState();
}

class _HaritaPageState extends State<HaritaPage> {
  final TextEditingController _searchController = TextEditingController();
  final String _selectedFloor = 'Zemin Kat';
  bool _showDirections = false;
  Map<String, dynamic>? _selectedLocation;
  List<Map<String, dynamic>> _searchResults = [];

  final List<String> _floors = [
    'Zemin Kat',
    '1. Kat',
    '2. Kat',
    '3. Kat',
    '4. Kat',
  ];

  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Kan Alma Ünitesi',
      'floor': '2. Kat',
      'room': '207',
      'description': 'Kan testleri ve laboratuvar işlemleri',
      'category': 'Laboratuvar',
      'icon': Icons.bloodtype,
    },
    {
      'name': 'Radyoloji',
      'floor': '1. Kat',
      'room': '105',
      'description': 'Röntgen, MR ve tomografi işlemleri',
      'category': 'Görüntüleme',
      'icon': Icons.medical_services,
    },
    {
      'name': 'Poliklinik',
      'floor': '3. Kat',
      'room': '301-310',
      'description': 'Doktor muayene odaları',
      'category': 'Muayene',
      'icon': Icons.local_hospital,
    },
    {
      'name': 'Acil Servis',
      'floor': 'Zemin Kat',
      'room': '001',
      'description': 'Acil durumlar için giriş',
      'category': 'Acil',
      'icon': Icons.emergency,
    },
    {
      'name': 'Eczane',
      'floor': 'Zemin Kat',
      'room': '002',
      'description': 'Reçeteli ilaçlar ve medikal ürünler',
      'category': 'Eczane',
      'icon': Icons.local_pharmacy,
    },
  ];

  final List<Map<String, dynamic>> _patientTasks = [
    {
      'id': '1',
      'name': 'Ödeme İşlemi',
      'status': 'Beklemede',
      'priority': 'Yüksek',
      'location': 'Danışma',
      'floor': 'Zemin Kat',
      'room': '003',
      'instructions': 'Kimliğinizi yanınızda bulundurunuz.',
      'doctor': 'Danışma',
      'date': '15 Mart 2024',
      'time': '09:00',
      'completed': false,
      'isBlocking': true,
      'personnel': {
        'name': 'Ayşe Yılmaz',
        'title': 'Danışma Görevlisi',
        'contact': 'Dahili: 1001',
        'workingHours': '08:00 - 17:00',
        'photo': null,
      },
    },
    {
      'id': '2',
      'name': 'Kan Tahlili',
      'status': 'Beklemede',
      'priority': 'Yüksek',
      'location': 'Kan Alma Ünitesi',
      'floor': '2. Kat',
      'room': '207',
      'instructions': 'Aç karnına gelmeniz gerekmektedir.',
      'doctor': 'Dr. Ahmet Yılmaz',
      'date': '15 Mart 2024',
      'time': '09:30',
      'completed': false,
      'isBlocking': false,
      'requiredTaskId': '1',
      'personnel': {
        'name': 'Mehmet Demir',
        'title': 'Laboratuvar Teknisyeni',
        'contact': 'Dahili: 2071',
        'workingHours': '07:30 - 16:30',
        'photo': null,
      },
    },
    {
      'id': '3',
      'name': 'Röntgen Çekimi',
      'status': 'Beklemede',
      'priority': 'Orta',
      'location': 'Radyoloji',
      'floor': '1. Kat',
      'room': '105',
      'instructions': 'Metal eşya ve takılarınızı çıkarmanız gerekmektedir.',
      'doctor': 'Dr. Ayşe Kaya',
      'date': '15 Mart 2024',
      'time': '10:30',
      'completed': false,
      'isBlocking': false,
      'requiredTaskId': '1',
      'personnel': {
        'name': 'Zeynep Kaya',
        'title': 'Radyoloji Teknisyeni',
        'contact': 'Dahili: 1051',
        'workingHours': '08:00 - 16:00',
        'photo': null,
      },
    },
  ];

  final List<Map<String, dynamic>> _facilities = [
    {
      'name': 'WC (Kadın)',
      'floor': 'Zemin Kat',
      'room': '004',
      'description': 'Ana girişin sol tarafında',
      'category': 'WC',
      'icon': Icons.wc,
      'gender': 'Kadın',
    },
    {
      'name': 'WC (Erkek)',
      'floor': 'Zemin Kat',
      'room': '005',
      'description': 'Ana girişin sol tarafında',
      'category': 'WC',
      'icon': Icons.wc,
      'gender': 'Erkek',
    },
    {
      'name': 'WC (Kadın)',
      'floor': '1. Kat',
      'room': '106',
      'description': 'Asansörlerin karşısında',
      'category': 'WC',
      'icon': Icons.wc,
      'gender': 'Kadın',
    },
    {
      'name': 'WC (Erkek)',
      'floor': '1. Kat',
      'room': '107',
      'description': 'Asansörlerin karşısında',
      'category': 'WC',
      'icon': Icons.wc,
      'gender': 'Erkek',
    },
    {
      'name': 'WC (Engelli)',
      'floor': 'Zemin Kat',
      'room': '006',
      'description': 'Ana girişin sağ tarafında',
      'category': 'WC',
      'icon': Icons.accessible,
      'gender': 'Engelli',
    },
  ];

  void _searchLocations(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showDirections = false;
      });
      return;
    }

    setState(() {
      _searchResults = _locations.where((location) {
        return location['name'].toLowerCase().contains(query.toLowerCase()) ||
            location['room'].toLowerCase().contains(query.toLowerCase()) ||
            location['category'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _showLocationDetails(Map<String, dynamic> location) {
    setState(() {
      _selectedLocation = location;
      _showDirections = true;
      _currentFloor = location['floor']; // Bulunduğumuz katı güncelle
    });
  }

  Widget _buildSearchBar() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText:
                    'Gitmek istediğiniz yeri yazın (örn: Kan Alma, Radyoloji)',
                prefixIcon: Icon(Icons.search, color: HealthApp.primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchResults = [];
                            _showDirections = false;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: HealthApp.primaryColor),
                ),
              ),
              onChanged: _searchLocations,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Arama sonucu bulunamadı',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final location = _searchResults[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: HealthApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                location['icon'] as IconData,
                color: HealthApp.primaryColor,
              ),
            ),
            title: Text(
              location['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HealthApp.primaryColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${location['floor']}, ${location['room']}'),
                Text(
                  location['description'],
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, color: HealthApp.primaryColor),
            onTap: () => _showLocationDetails(location),
          ),
        );
      },
    );
  }

  Widget _buildDirections() {
    if (_selectedLocation == null) return SizedBox.shrink();

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Yol Tarifi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: HealthApp.primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _showDirections = false;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HealthApp.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _selectedLocation!['icon'] as IconData,
                    color: HealthApp.primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedLocation!['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_selectedLocation!['floor']}, ${_selectedLocation!['room']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Yol Tarifi:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HealthApp.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            _buildDirectionStep('1', 'Ana girişten içeri girin'),
            _buildDirectionStep('2', 'Asansörlere doğru ilerleyin'),
            _buildDirectionStep('3', '${_selectedLocation!['floor']} çıkın'),
            _buildDirectionStep(
                '4', '${_selectedLocation!['room']} numaralı odaya gidin'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HealthApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: HealthApp.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: HealthApp.primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Randevunuzdan 15 dakika önce hastanede olmanız önerilir.',
                      style: TextStyle(
                        color: HealthApp.primaryColor,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionStep(String number, String instruction) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: HealthApp.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(instruction),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTasks() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Yapılacak İşlemler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: HealthApp.primaryColor,
                  ),
                ),
                Text(
                  '${_patientTasks.where((task) => !task['completed']).length} işlem kaldı',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ..._patientTasks.map((task) => _buildTaskCard(task)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final bool isBlocked = task['requiredTaskId'] != null &&
        !_patientTasks
            .firstWhere((t) => t['id'] == task['requiredTaskId'])['completed'];

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isBlocked
                ? Colors.grey.withOpacity(0.1)
                : _getPriorityColor(task['priority']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTaskIcon(task['name']),
            color:
                isBlocked ? Colors.grey : _getPriorityColor(task['priority']),
          ),
        ),
        title: Text(
          task['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isBlocked
                ? Colors.grey
                : task['completed']
                    ? Colors.grey
                    : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${task['date']} - ${task['time']}'),
            if (isBlocked)
              Text(
                'Önce ödeme işlemini tamamlamalısınız',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              )
            else if (task['completed'])
              Text(
                'Tamamlandı',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: isBlocked
            ? Icon(Icons.lock, color: Colors.grey)
            : Icon(
                task['completed']
                    ? Icons.check_circle
                    : Icons.arrow_forward_ios,
                color:
                    task['completed'] ? Colors.green : HealthApp.primaryColor,
              ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskDetailRow('Doktor', task['doctor']),
                _buildTaskDetailRow(
                    'Konum', '${task['floor']}, ${task['room']}'),
                _buildTaskDetailRow('Öncelik', task['priority']),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isBlocked ? Colors.grey[100] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: isBlocked ? Colors.grey : Colors.blue[800],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isBlocked
                              ? 'Bu işlemi yapabilmek için önce ödeme işlemini tamamlamalısınız.'
                              : task['instructions'],
                          style: TextStyle(
                            color: isBlocked ? Colors.grey : Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'İlgili Personel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HealthApp.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                HealthApp.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              color: HealthApp.primaryColor,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['personnel']['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  task['personnel']['title'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Çalışma Saatleri: ${task['personnel']['workingHours']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: HealthApp.primaryColor,
                            ),
                            onPressed: () {
                              // Telefon arama işlemi
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!task['completed'] && !isBlocked) ...[
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.directions),
                        label: Text('Yol Tarifi'),
                        onPressed: () {
                          _showLocationDetails({
                            'name': task['location'],
                            'floor': task['floor'],
                            'room': task['room'],
                            'description': task['instructions'],
                            'category': 'İşlem',
                            'icon': _getTaskIcon(task['name']),
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HealthApp.primaryColor,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.check),
                        label: Text('Tamamlandı'),
                        onPressed: () {
                          setState(() {
                            task['completed'] = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Yüksek':
        return Colors.red;
      case 'Orta':
        return Colors.orange;
      case 'Düşük':
        return Colors.green;
      default:
        return HealthApp.primaryColor;
    }
  }

  IconData _getTaskIcon(String taskName) {
    switch (taskName) {
      case 'Kan Tahlili':
        return Icons.bloodtype;
      case 'Röntgen Çekimi':
        return Icons.medical_services;
      case 'Ödeme İşlemi':
        return Icons.payment;
      default:
        return Icons.medical_services;
    }
  }

  Widget _buildQuickAccessButtons() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hızlı Erişim',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HealthApp.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.wc),
                  label: Text('WC'),
                  onPressed: () {
                    _showWcOptions();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HealthApp.primaryColor,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.local_cafe),
                  label: Text('Kafeterya'),
                  onPressed: () {
                    _showLocationDetails({
                      'name': 'Kafeterya',
                      'floor': 'Zemin Kat',
                      'room': '007',
                      'description': 'Ana girişin arka tarafında',
                      'category': 'Kafeterya',
                      'icon': Icons.local_cafe,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HealthApp.primaryColor,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.local_pharmacy),
                  label: Text('Eczane'),
                  onPressed: () {
                    _showLocationDetails({
                      'name': 'Eczane',
                      'floor': 'Zemin Kat',
                      'room': '002',
                      'description': 'Ana girişin sağ tarafında',
                      'category': 'Eczane',
                      'icon': Icons.local_pharmacy,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HealthApp.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWcOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('WC Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.wc),
              title: Text('Kadın WC'),
              onTap: () {
                Navigator.pop(context);
                _showNearestWc('Kadın');
              },
            ),
            ListTile(
              leading: Icon(Icons.wc),
              title: Text('Erkek WC'),
              onTap: () {
                Navigator.pop(context);
                _showNearestWc('Erkek');
              },
            ),
            ListTile(
              leading: Icon(Icons.accessible),
              title: Text('Engelli WC'),
              onTap: () {
                Navigator.pop(context);
                _showNearestWc('Engelli');
              },
            ),
          ],
        ),
      ),
    );
  }

  String _currentFloor =
      'Zemin Kat'; // Varsayılan olarak zemin katta olduğunu varsayalım

  void _showNearestWc(String gender) {
    // Önce aynı kattaki WC'yi kontrol et
    var wc = _facilities.firstWhere(
      (facility) =>
          facility['category'] == 'WC' &&
          facility['gender'] == gender &&
          facility['floor'] == _currentFloor,
      orElse: () => _facilities.firstWhere(
        (facility) =>
            facility['category'] == 'WC' && facility['gender'] == gender,
      ),
    );

    // Eğer aynı katta WC yoksa, en yakın WC'yi bul
    if (wc['floor'] != _currentFloor) {
      wc = _facilities.firstWhere(
        (facility) =>
            facility['category'] == 'WC' && facility['gender'] == gender,
      );
    }

    _showLocationDetails(wc);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildQuickAccessButtons(),
        if (_showDirections)
          _buildDirections()
        else
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPatientTasks(),
                  if (_searchResults.isNotEmpty) _buildSearchResults(),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class SemptomPage extends StatefulWidget {
  const SemptomPage({super.key});

  @override
  _SemptomPageState createState() => _SemptomPageState();
}

class _SemptomPageState extends State<SemptomPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _symptomDescriptionController =
      TextEditingController();
  List<String> selectedSymptoms = [];
  String searchText = '';

  final List<Map<String, dynamic>> allSymptoms = [
    {
      'title': 'Ateş',
      'icon': Icons.thermostat,
      'description': '38°C ve üzeri ateş',
      'severity': ['Hafif (37.5-38°C)', 'Orta (38-39°C)', 'Yüksek (39°C+)'],
      'keywords': ['ateş', 'yüksek ateş', 'vücut ısısı', 'hararet', 'sıcaklık'],
      'relatedSymptoms': [
        'Titreme',
        'Terleme',
        'Halsizlik',
        'Üşüme',
        'Kas Ağrısı'
      ]
    },
    {
      'title': 'Öksürük',
      'icon': Icons.healing,
      'description': 'Kuru veya balgamlı öksürük',
      'severity': ['Aralıklı', 'Sürekli', 'Şiddetli', 'Gece Artan'],
      'keywords': [
        'öksürük',
        'kuru öksürük',
        'balgam',
        'boğaz',
        'öksürme',
        'boğulma hissi'
      ],
      'relatedSymptoms': [
        'Boğaz ağrısı',
        'Nefes darlığı',
        'Göğüs ağrısı',
        'Hırıltı'
      ]
    },
    {
      'title': 'Baş Ağrısı',
      'icon': Icons.sick,
      'description': 'Zonklama veya basınç hissi',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Migren'],
      'keywords': [
        'baş ağrısı',
        'migren',
        'zonklama',
        'başım ağrıyor',
        'şiddetli ağrı',
        'temporal ağrı'
      ],
      'relatedSymptoms': [
        'Baş dönmesi',
        'Mide bulantısı',
        'Işığa hassasiyet',
        'Sese hassasiyet'
      ]
    },
    {
      'title': 'Yorgunluk',
      'icon': Icons.battery_alert,
      'description': 'Genel halsizlik ve bitkinlik',
      'severity': ['Hafif', 'Belirgin', 'Şiddetli', 'Kronik'],
      'keywords': [
        'yorgunluk',
        'halsizlik',
        'bitkinlik',
        'güçsüzlük',
        'enerji düşüklüğü',
        'uyku hali'
      ],
      'relatedSymptoms': [
        'Kas ağrısı',
        'Uyku hali',
        'Konsantrasyon güçlüğü',
        'İştahsızlık'
      ]
    },
    {
      'title': 'Mide Bulantısı',
      'icon': Icons.sick_outlined,
      'description': 'Bulantı ve kusma hissi',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Sürekli'],
      'keywords': [
        'mide bulantısı',
        'kusma',
        'bulantı',
        'mide rahatsızlığı',
        'hazımsızlık'
      ],
      'relatedSymptoms': [
        'Karın ağrısı',
        'İştahsızlık',
        'Baş dönmesi',
        'Terleme'
      ]
    },
    {
      'title': 'Nefes Darlığı',
      'icon': Icons.air,
      'description': 'Solunum güçlüğü ve nefes alma zorluğu',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Acil'],
      'keywords': [
        'nefes darlığı',
        'solunum güçlüğü',
        'nefes alamama',
        'göğüs sıkışması',
        'boğulma hissi'
      ],
      'relatedSymptoms': ['Öksürük', 'Göğüs ağrısı', 'Hırıltı', 'Baş dönmesi']
    },
    {
      'title': 'Göğüs Ağrısı',
      'icon': Icons.favorite,
      'description': 'Göğüs bölgesinde ağrı veya rahatsızlık',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Acil'],
      'keywords': [
        'göğüs ağrısı',
        'kalp ağrısı',
        'göğüs sıkışması',
        'yanma hissi',
        'basınç hissi'
      ],
      'relatedSymptoms': [
        'Nefes darlığı',
        'Terleme',
        'Baş dönmesi',
        'Mide bulantısı'
      ]
    },
    {
      'title': 'Karın Ağrısı',
      'icon': Icons.sick_outlined,
      'description': 'Karın bölgesinde ağrı veya rahatsızlık',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': ['karın ağrısı', 'mide ağrısı', 'kramp', 'şişkinlik', 'gaz'],
      'relatedSymptoms': ['Mide bulantısı', 'İshal', 'Kabızlık', 'İştahsızlık']
    },
    {
      'title': 'İshal',
      'icon': Icons.sick_outlined,
      'description': 'Sık ve sulu dışkı',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': [
        'ishal',
        'sulu dışkı',
        'sık tuvalet',
        'bağırsak rahatsızlığı'
      ],
      'relatedSymptoms': [
        'Karın ağrısı',
        'Mide bulantısı',
        'Halsizlik',
        'Susuzluk'
      ]
    },
    {
      'title': 'Kabızlık',
      'icon': Icons.sick_outlined,
      'description': 'Seyrek ve zor dışkılama',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': [
        'kabızlık',
        'dışkı yapamama',
        'bağırsak tembelliği',
        'şişkinlik'
      ],
      'relatedSymptoms': ['Karın ağrısı', 'Şişkinlik', 'Gaz', 'İştahsızlık']
    },
    {
      'title': 'Eklem Ağrısı',
      'icon': Icons.sick_outlined,
      'description': 'Eklemlerde ağrı ve hareket kısıtlılığı',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': [
        'eklem ağrısı',
        'romatizma',
        'kireçlenme',
        'hareket kısıtlılığı'
      ],
      'relatedSymptoms': [
        'Şişlik',
        'Kızarıklık',
        'Hareket zorluğu',
        'Sabah tutukluğu'
      ]
    },
    {
      'title': 'Kas Ağrısı',
      'icon': Icons.sick_outlined,
      'description': 'Kaslarda ağrı ve gerginlik',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': ['kas ağrısı', 'kas tutulması', 'gerginlik', 'spazm'],
      'relatedSymptoms': ['Yorgunluk', 'Hareket zorluğu', 'Kramp', 'Titreme']
    },
    {
      'title': 'Baş Dönmesi',
      'icon': Icons.sick_outlined,
      'description': 'Denge kaybı ve sersemlik hissi',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Sürekli'],
      'keywords': ['baş dönmesi', 'sersemlik', 'dengesizlik', 'vertigo'],
      'relatedSymptoms': [
        'Mide bulantısı',
        'Terleme',
        'Görme bulanıklığı',
        'Kulak çınlaması'
      ]
    },
    {
      'title': 'Uyku Bozukluğu',
      'icon': Icons.bedtime,
      'description': 'Uykuya dalmada güçlük veya kalitesiz uyku',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': ['uykusuzluk', 'uyku bozukluğu', 'uyuyamama', 'erken uyanma'],
      'relatedSymptoms': [
        'Yorgunluk',
        'Sinirlilik',
        'Konsantrasyon güçlüğü',
        'Baş ağrısı'
      ]
    },
    {
      'title': 'Cilt Döküntüsü',
      'icon': Icons.sick_outlined,
      'description': 'Ciltte kızarıklık, kaşıntı veya döküntü',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Yaygın'],
      'keywords': ['döküntü', 'kaşıntı', 'kızarıklık', 'kurdeşen', 'egzama'],
      'relatedSymptoms': ['Kaşıntı', 'Yanma', 'Şişlik', 'Ağrı']
    },
    {
      'title': 'Göz Problemleri',
      'icon': Icons.remove_red_eye,
      'description': 'Görme bozukluğu veya göz rahatsızlığı',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Acil'],
      'keywords': [
        'göz ağrısı',
        'görme bulanıklığı',
        'kızarıklık',
        'kaşıntı',
        'yanma'
      ],
      'relatedSymptoms': [
        'Baş ağrısı',
        'Işığa hassasiyet',
        'Göz yaşarması',
        'Göz kapağı şişmesi'
      ]
    },
    {
      'title': 'Kulak Ağrısı',
      'icon': Icons.hearing,
      'description': 'Kulakta ağrı veya rahatsızlık',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Acil'],
      'keywords': [
        'kulak ağrısı',
        'kulak tıkanıklığı',
        'çınlama',
        'işitme kaybı'
      ],
      'relatedSymptoms': ['Baş ağrısı', 'Baş dönmesi', 'Ateş', 'İşitme azlığı']
    },
    {
      'title': 'Burun Tıkanıklığı',
      'icon': Icons.sick_outlined,
      'description': 'Burun solunumunda güçlük',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': [
        'burun tıkanıklığı',
        'nezle',
        'sinüzit',
        'akıntı',
        'hapşırma'
      ],
      'relatedSymptoms': [
        'Baş ağrısı',
        'Boğaz ağrısı',
        'Öksürük',
        'Koku alamama'
      ]
    },
    {
      'title': 'Boğaz Ağrısı',
      'icon': Icons.sick_outlined,
      'description': 'Boğazda ağrı ve rahatsızlık',
      'severity': ['Hafif', 'Orta', 'Şiddetli', 'Kronik'],
      'keywords': ['boğaz ağrısı', 'yutkunma zorluğu', 'yanma', 'kaşıntı'],
      'relatedSymptoms': [
        'Öksürük',
        'Burun tıkanıklığı',
        'Ateş',
        'Ses kısıklığı'
      ]
    }
  ];

  List<Map<String, dynamic>> get filteredSymptoms {
    if (searchText.isEmpty) return allSymptoms;
    return allSymptoms.where((symptom) {
      final keywords = symptom['keywords'] as List<String>;
      return keywords.any((keyword) =>
          keyword.toLowerCase().contains(searchText.toLowerCase()));
    }).toList();
  }

  Widget _buildExpandableSymptomCard(Map<String, dynamic> symptom) {
    final isSelected = selectedSymptoms.contains(symptom['title']);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          symptom['icon'] as IconData,
          color: isSelected ? HealthApp.primaryColor : Colors.black87,
          size: 28,
        ),
        title: Text(
          symptom['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected ? HealthApp.primaryColor : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              symptom['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            if (isSelected)
              Text(
                'İlişkili semptomlar: ${(symptom['relatedSymptoms'] as List).join(", ")}',
                style: TextStyle(
                  color: HealthApp.primaryColor,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Şiddet Seviyesi',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: HealthApp.primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (symptom['severity'] as List).map((severity) {
                    return ChoiceChip(
                      label: Text(severity),
                      selected: false,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            if (!selectedSymptoms.contains(symptom['title'])) {
                              selectedSymptoms.add(symptom['title']);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semptom Analizi'),
        backgroundColor: HealthApp.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semptomlarınızı Seçin',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: HealthApp.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Yaşadığınız semptomları açıklayın veya listeden seçin',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _symptomDescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Semptomlarınızı detaylı olarak anlatın (örn: Başım ağrıyor, ateşim var, boğazım yanıyor...)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Semptomlarınızı yazın (örn: baş ağrısı ve ateş)',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchText = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            SizedBox(height: 16),
            if (selectedSymptoms.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                children: selectedSymptoms.map((symptom) {
                  return Chip(
                    label: Text(symptom),
                    onDeleted: () {
                      setState(() {
                        selectedSymptoms.remove(symptom);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: filteredSymptoms.length,
                itemBuilder: (context, index) {
                  return _buildExpandableSymptomCard(filteredSymptoms[index]);
                },
              ),
            ),
            if (selectedSymptoms.isNotEmpty ||
                _symptomDescriptionController.text.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SemptomAnalizSonucu(
                          selectedSymptoms: selectedSymptoms,
                          symptomDescription:
                              _symptomDescriptionController.text,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HealthApp.primaryColor,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Analizi Başlat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SemptomAnalizSonucu extends StatelessWidget {
  final List<String> selectedSymptoms;
  final String symptomDescription;

  const SemptomAnalizSonucu({
    super.key,
    required this.selectedSymptoms,
    required this.symptomDescription,
  });

  void _createAppointment(BuildContext context) {
    // Semptomlara göre uygun bölüm ve doktor seçimi
    String department = 'Dahiliye';
    String doctor = 'Dr. Ahmet Yılmaz';

    if (selectedSymptoms.contains('Göğüs Ağrısı') ||
        selectedSymptoms.contains('Nefes Darlığı')) {
      department = 'Kardiyoloji';
      doctor = 'Dr. Mehmet Demir';
    } else if (selectedSymptoms.contains('Baş Ağrısı') ||
        selectedSymptoms.contains('Baş Dönmesi')) {
      department = 'Nöroloji';
      doctor = 'Dr. Ayşe Kaya';
    } else if (selectedSymptoms.contains('Eklem Ağrısı') ||
        selectedSymptoms.contains('Kas Ağrısı')) {
      department = 'Ortopedi';
      doctor = 'Dr. Ali Yıldız';
    }

    // Varsayılan randevu tarihi ve saati
    DateTime selectedDate = DateTime.now().add(Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.calendar_today, color: HealthApp.primaryColor),
              SizedBox(width: 8),
              Text('Randevu Oluştur'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Randevu detaylarınız:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HealthApp.primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                _buildAppointmentDetailRow('Doktor', doctor),
                _buildAppointmentDetailRow('Bölüm', department),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.calendar_today, color: Colors.white),
                        label: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 30)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: HealthApp.primaryColor,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HealthApp.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.access_time, color: Colors.white),
                        label: Text(
                          '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CustomTimePickerDialog(
                                  initialTime: selectedTime,
                                  onTimeSelected: (TimeOfDay time) {
                                    setState(() {
                                      selectedTime = time;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HealthApp.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: HealthApp.secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: HealthApp.primaryColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Randevunuzdan 15 dakika önce hastanede olmanız önerilir.',
                          style: TextStyle(color: HealthApp.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: HealthApp.primaryColor,
              ),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAppointmentConfirmation(
                    context, doctor, department, selectedDate, selectedTime);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HealthApp.primaryColor,
              ),
              child: Text('Devam Et'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentConfirmation(
    BuildContext context,
    String doctor,
    String department,
    DateTime date,
    TimeOfDay time,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: HealthApp.primaryColor),
            SizedBox(width: 8),
            Text('Randevu Onayı'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aşağıdaki randevuyu onaylıyor musunuz?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HealthApp.primaryColor,
              ),
            ),
            SizedBox(height: 16),
            _buildAppointmentDetailRow('Doktor', doctor),
            _buildAppointmentDetailRow('Bölüm', department),
            _buildAppointmentDetailRow(
              'Tarih',
              '${date.day}/${date.month}/${date.year}',
            ),
            _buildAppointmentDetailRow(
              'Saat',
              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
            ),
            if (selectedSymptoms.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Semptomlar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HealthApp.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: selectedSymptoms
                    .map((symptom) => Chip(
                          label: Text(symptom),
                          backgroundColor:
                              HealthApp.primaryColor.withOpacity(0.1),
                        ))
                    .toList(),
              ),
            ],
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HealthApp.secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: HealthApp.primaryColor),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Randevunuzdan 15 dakika önce hastanede olmanız önerilir.',
                      style: TextStyle(color: HealthApp.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _createAppointment(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: HealthApp.primaryColor,
            ),
            child: Text('Düzenle'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Randevunuz başarıyla oluşturuldu'),
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                    label: 'Detaylar',
                    textColor: Colors.white,
                    onPressed: () {
                      _showAppointmentDetails(
                          context, doctor, department, date, time);
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HealthApp.primaryColor,
            ),
            child: Text('Onayla'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _showAppointmentDetails(
    BuildContext context,
    String doctor,
    String department,
    DateTime date,
    TimeOfDay time,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Randevu Detayları',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: HealthApp.primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(),
            _buildAppointmentDetailRow('Doktor', doctor),
            _buildAppointmentDetailRow('Bölüm', department),
            _buildAppointmentDetailRow(
              'Tarih',
              '${date.day}/${date.month}/${date.year}',
            ),
            _buildAppointmentDetailRow(
              'Saat',
              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
            ),
            if (selectedSymptoms.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Semptomlar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HealthApp.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: selectedSymptoms
                    .map((symptom) => Chip(
                          label: Text(symptom),
                          backgroundColor:
                              HealthApp.primaryColor.withOpacity(0.1),
                        ))
                    .toList(),
              ),
            ],
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.qr_code),
              label: Text('QR Kod Oluştur'),
              onPressed: () {
                // QR kod oluşturma işlemi
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HealthApp.primaryColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analiz Sonucu'),
        backgroundColor: HealthApp.primaryColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: selectedSymptoms.isNotEmpty
            ? SemptomService().hastalikTahmini(selectedSymptoms)
            : Future.value({
                'hastalikAdi': 'Belirlenemedi',
                'olasilik': 0.0,
                'oneriler': 'Daha fazla semptom belirtiniz.'
              }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Hastalık tahmini yapılırken bir hata oluştu: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final hastalikTahmini = snapshot.data ??
              {
                'hastalikAdi': 'Belirlenemedi',
                'olasilik': 0.0,
                'oneriler': 'Daha fazla semptom belirtiniz.'
              };

          // Analiz sonucuna göre otomatik yönlendirme
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).unfocus();
            String department, doctor;
            if (selectedSymptoms.contains('Göğüs Ağrısı') ||
                selectedSymptoms.contains('Nefes Darlığı')) {
              department = 'Kardiyoloji';
              doctor = 'Dr. Mehmet Demir';
            } else if (selectedSymptoms.contains('Baş Ağrısı') ||
                selectedSymptoms.contains('Baş Dönmesi')) {
              department = 'Nöroloji';
              doctor = 'Dr. Ayşe Kaya';
            } else if (selectedSymptoms.contains('Eklem Ağrısı') ||
                selectedSymptoms.contains('Kas Ağrısı')) {
              department = 'Ortopedi';
              doctor = 'Dr. Ali Yıldız';
            } else {
              department = 'Dahiliye';
              doctor = 'Dr. Ahmet Yılmaz';
            }
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
              arguments: {
                'selectedDepartment': department,
                'selectedDoctor': doctor,
                'initialTab': 0,
              },
            );
          });

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Girdiğiniz Semptomlar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: HealthApp.primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        if (symptomDescription.isNotEmpty) ...[
                          Text(
                            'Açıklamanız:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(symptomDescription),
                          SizedBox(height: 16),
                        ],
                        if (selectedSymptoms.isNotEmpty) ...[
                          Text(
                            'Seçtiğiniz Semptomlar:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: selectedSymptoms
                                .map((symptom) => Chip(
                                      label: Text(symptom),
                                      backgroundColor: HealthApp.primaryColor
                                          .withOpacity(0.1),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olası Hastalık Tahmini',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: HealthApp.primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildConditionCard(
                          hastalikTahmini['hastalikAdi'] ?? 'Belirlenemedi',
                          'Olasılık: ${((hastalikTahmini['olasilik'] ?? 0.0) * 100).toStringAsFixed(2)}%',
                          Icons.medical_services,
                          Colors.blue,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Not: Bu analiz sadece bir ön değerlendirmedir ve kesin tanı yerine geçmez.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Öneriler',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: HealthApp.primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildRecommendationItem(
                          hastalikTahmini['oneriler'] ?? 'Bol sıvı tüketin',
                          Icons.local_drink,
                        ),
                        _buildRecommendationItem(
                          'Dinlenmeye özen gösterin',
                          Icons.bedtime,
                        ),
                        _buildRecommendationItem(
                          'Doktor kontrolüne gidin',
                          Icons.medical_services,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                // Randevuya Git butonu
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Randevuya Git'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HealthApp.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    minimumSize: Size(double.infinity, 56),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    String department, doctor;
                    if (selectedSymptoms.contains('Göğüs Ağrısı') ||
                        selectedSymptoms.contains('Nefes Darlığı')) {
                      department = 'Kardiyoloji';
                      doctor = 'Dr. Mehmet Demir';
                    } else if (selectedSymptoms.contains('Baş Ağrısı') ||
                        selectedSymptoms.contains('Baş Dönmesi')) {
                      department = 'Nöroloji';
                      doctor = 'Dr. Ayşe Kaya';
                    } else if (selectedSymptoms.contains('Eklem Ağrısı') ||
                        selectedSymptoms.contains('Kas Ağrısı')) {
                      department = 'Ortopedi';
                      doctor = 'Dr. Ali Yıldız';
                    } else {
                      department = 'Dahiliye';
                      doctor = 'Dr. Ahmet Yılmaz';
                    }
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                      arguments: {
                        'selectedDepartment': department,
                        'selectedDoctor': doctor,
                        'initialTab': 0,
                      },
                    );
                  },
                ),
                // Chat balonu şeklinde yönlendirme mesajı
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    String department, doctor;
                    if (selectedSymptoms.contains('Göğüs Ağrısı') ||
                        selectedSymptoms.contains('Nefes Darlığı')) {
                      department = 'Kardiyoloji';
                      doctor = 'Dr. Mehmet Demir';
                    } else if (selectedSymptoms.contains('Baş Ağrısı') ||
                        selectedSymptoms.contains('Baş Dönmesi')) {
                      department = 'Nöroloji';
                      doctor = 'Dr. Ayşe Kaya';
                    } else if (selectedSymptoms.contains('Eklem Ağrısı') ||
                        selectedSymptoms.contains('Kas Ağrısı')) {
                      department = 'Ortopedi';
                      doctor = 'Dr. Ali Yıldız';
                    } else {
                      department = 'Dahiliye';
                      doctor = 'Dr. Ahmet Yılmaz';
                    }
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                      arguments: {
                        'selectedDepartment': department,
                        'selectedDoctor': doctor,
                        'initialTab': 0,
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: HealthApp.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: HealthApp.primaryColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_forward,
                            color: HealthApp.primaryColor),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Şu doktora yönlendiriliyorsunuz: ' +
                                (selectedSymptoms.contains('Göğüs Ağrısı') ||
                                        selectedSymptoms
                                            .contains('Nefes Darlığı')
                                    ? 'Dr. Mehmet Demir (Kardiyoloji)'
                                    : selectedSymptoms.contains('Baş Ağrısı') ||
                                            selectedSymptoms
                                                .contains('Baş Dönmesi')
                                        ? 'Dr. Ayşe Kaya (Nöroloji)'
                                        : selectedSymptoms
                                                    .contains('Eklem Ağrısı') ||
                                                selectedSymptoms
                                                    .contains('Kas Ağrısı')
                                            ? 'Dr. Ali Yıldız (Ortopedi)'
                                            : 'Dr. Ahmet Yılmaz (Dahiliye)') +
                                '\nRandevuya gitmek için buraya tıklayın.',
                            style: TextStyle(
                              color: HealthApp.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConditionCard(
      String title, String description, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: HealthApp.primaryColor),
          SizedBox(width: 16),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class MesajlarPage extends StatelessWidget {
  static final List<Map<String, dynamic>> conversations = [
    {
      'doctorName': 'Dr. Ahmet Yılmaz',
      'department': 'Kardiyoloji',
      'lastMessage': 'Test sonuçlarınız normal görünüyor.',
      'time': '14:30',
      'unread': true,
      'profileImage': null,
      'lastVisit': '10 Mart 2024',
      'status': 'Aktif Doktor',
    },
    {
      'doctorName': 'Dr. Ayşe Kaya',
      'department': 'Nöroloji',
      'lastMessage': 'Randevunuz onaylandı.',
      'time': 'Dün',
      'unread': false,
      'profileImage': null,
      'lastVisit': '5 Mart 2024',
      'status': 'Takip Eden Doktor',
    },
  ];

  const MesajlarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Mesajlar',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: HealthApp.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Doktor ara...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _buildConversationCard(context, conversation);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationCard(
      BuildContext context, Map<String, dynamic> conversation) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: conversation['unread']
                  ? HealthApp.primaryColor
                  : Colors.grey[300],
              child: Text(
                conversation['doctorName'].toString().split(' ')[1][0],
                style: TextStyle(
                  color:
                      conversation['unread'] ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
            if (conversation['unread'])
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          conversation['doctorName'],
          style: TextStyle(
            fontWeight:
                conversation['unread'] ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conversation['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              conversation['department'],
              style: TextStyle(
                color: HealthApp.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              conversation['time'],
              style: TextStyle(
                color: conversation['unread']
                    ? HealthApp.primaryColor
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Son ziyaret: ${conversation['lastVisit']}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientChatScreen(
                doctorName: conversation['doctorName'],
                doctorInfo: conversation,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PatientChatScreen extends StatefulWidget {
  final String doctorName;
  final Map<String, dynamic> doctorInfo;

  const PatientChatScreen({
    super.key,
    required this.doctorName,
    required this.doctorInfo,
  });

  @override
  _PatientChatScreenState createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // Örnek mesajları yükle
    _messages = [
      {
        'text': 'Merhaba doktor bey, test sonuçlarım geldi.',
        'isPatient': true,
        'time': DateTime.now().subtract(Duration(days: 1, hours: 2)),
      },
      {
        'text':
            'Merhaba, test sonuçlarınızı inceledim. Her şey normal görünüyor.',
        'isPatient': false,
        'time': DateTime.now().subtract(Duration(days: 1, hours: 1)),
      },
      {
        'text': 'Teşekkür ederim, kontrol için ne zaman gelmeliyim?',
        'isPatient': true,
        'time': DateTime.now().subtract(Duration(hours: 1)),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: HealthApp.primaryColor.withOpacity(0.2),
              child: Text(widget.doctorName.split(' ')[1][0]),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctorName),
                Text(
                  widget.doctorInfo['department'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions();
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showDoctorInfo();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(
                  message['text'],
                  message['isPatient'],
                  message['time'],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: HealthApp.primaryColor,
                  ),
                  onPressed: () {
                    _showAttachmentOptions();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: HealthApp.primaryColor,
                  ),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'isPatient': true,
        'time': DateTime.now(),
      });
      _messageController.clear();
    });
  }

  Widget _buildMessageBubble(String message, bool isPatient, DateTime time) {
    return Align(
      alignment: isPatient ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPatient ? HealthApp.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isPatient ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isPatient ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${time.hour}:${time.minute}',
              style: TextStyle(
                fontSize: 12,
                color: isPatient ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.file_present),
              title: Text('Dosya'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_services),
              title: Text('Test Sonuçları'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDoctorInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doktor Bilgileri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Ad Soyad', widget.doctorName),
            _buildInfoRow('Bölüm', widget.doctorInfo['department']),
            _buildInfoRow('Son Ziyaret', widget.doctorInfo['lastVisit']),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.calendar_today),
                  label: Text('Randevu Al'),
                  onPressed: () {
                    Navigator.pop(context);
                    // Randevu alma sayfasına yönlendirme
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.medical_services),
                  label: Text('Geçmiş'),
                  onPressed: () {
                    Navigator.pop(context);
                    // Muayene geçmişi sayfasına yönlendirme
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class AyarlarPage extends StatelessWidget {
  const AyarlarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ayarlar',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: HealthApp.primaryColor,
            ),
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading:
                  Icon(Icons.medical_services, color: HealthApp.primaryColor),
              title: Text('Doktor Paneli'),
              subtitle: Text('Doktor paneline geçiş yapın'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorPanelScreen(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading:
                  Icon(Icons.local_hospital, color: HealthApp.primaryColor),
              title: Text('Hastane Yönetim Paneli'),
              subtitle: Text('Hastane yönetim paneline geçiş yapın'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HospitalPanelScreen(),
                  ),
                );
              },
            ),
          ),
          // Diğer ayarlar buraya eklenebilir
        ],
      ),
    );
  }
}

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedBloodType = 'A+';
  final List<String> _chronicDiseases = [];
  final List<String> _allergies = [];
  String _searchText = '';

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    '0+',
    '0-'
  ];
  final List<String> _commonDiseases = [
    'Diyabet',
    'Hipertansiyon',
    'Astım',
    'Kalp Hastalığı',
    'Kolesterol',
    'Tiroit',
  ];
  final List<String> _commonAllergies = [
    'Pollen',
    'Toz',
    'Kedi/Köpek',
    'Fıstık',
    'Süt',
    'Yumurta',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sağlık Profilim',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: HealthApp.primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Ad Soyad',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen adınızı girin';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Yaş',
                        prefixIcon: Icon(Icons.cake),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen yaşınızı girin';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            decoration: InputDecoration(
                              labelText: 'Boy (cm)',
                              prefixIcon: Icon(Icons.height),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            decoration: InputDecoration(
                              labelText: 'Kilo (kg)',
                              prefixIcon: Icon(Icons.monitor_weight),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBloodType,
                      decoration: InputDecoration(
                        labelText: 'Kan Grubu',
                        prefixIcon: Icon(Icons.bloodtype),
                      ),
                      items: _bloodTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBloodType = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Kronik Hastalıklar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Hastalık ara...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _commonDiseases.map((disease) {
                        final isSelected = _chronicDiseases.contains(disease);
                        return FilterChip(
                          label: Text(disease),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _chronicDiseases.add(disease);
                              } else {
                                _chronicDiseases.remove(disease);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Alerjiler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _commonAllergies.map((allergy) {
                        final isSelected = _allergies.contains(allergy);
                        return FilterChip(
                          label: Text(allergy),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _allergies.add(allergy);
                              } else {
                                _allergies.remove(allergy);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Profil bilgilerini kaydet
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Profil bilgileriniz kaydedildi'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HealthApp.primaryColor,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Kaydet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
