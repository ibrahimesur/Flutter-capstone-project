import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'doctor/doctor_dashboard.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RandevuPage(),
    HaritaPage(),
    SemptomPage(),
    MesajlarPage(),
    AyarlarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sağlık Yönetim Sistemi'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Bildirimler sayfası
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Profil sayfası
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[600],
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Randevu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Harita',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              label: 'Semptom',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Mesajlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class RandevuPage extends StatelessWidget {
  const RandevuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Randevu Al',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5F7C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tercih ettiğiniz bölüm ve doktoru seçin',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 24),
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Randevu Bilgileri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D5F7C),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Bölüm Seçiniz',
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                    items: ['Dahiliye', 'Kardiyoloji', 'Nöroloji', 'Ortopedi', 'Göz Hastalıkları']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Doktor Seçiniz',
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: ['Dr. Ahmet Yılmaz', 'Dr. Ayşe Kaya', 'Dr. Mehmet Demir']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.calendar_today),
                          label: Text('Tarih Seç'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.access_time),
                          label: Text('Saat Seç'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yaklaşan Randevularınız',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D5F7C),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildAppointmentTile(
                    'Dr. Ahmet Yılmaz',
                    'Kardiyoloji',
                    '15 Mart 2024',
                    '14:30',
                  ),
                  Divider(),
                  _buildAppointmentTile(
                    'Dr. Ayşe Kaya',
                    'Nöroloji',
                    '18 Mart 2024',
                    '10:15',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTile(String doctor, String department, String date, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(0xFF2D5F7C),
        child: Icon(Icons.calendar_today, color: Colors.white, size: 20),
      ),
      title: Text(doctor, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$department\n$date'),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xFF2D5F7C).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: Color(0xFF2D5F7C),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      isThreeLine: true,
    );
  }
}

class HaritaPage extends StatefulWidget {
  const HaritaPage({super.key});

  @override
  _HaritaPageState createState() => _HaritaPageState();
}

class _HaritaPageState extends State<HaritaPage> {
  final Map<String, dynamic> islemBilgisi = {
    'islemAdi': 'Kan Alma',
    'kat': '2. Kat',
    'oda': '104',
    'birim': 'Kan Alma Ünitesi',
    'saat': '09:00 - 16:00',
    'not': 'Aç karnına gelmeniz gerekmektedir.',
    'gorevli': 'Hemşire Zeynep Yıldız',
    'siraNo': '45',
    'aktifSira': '43',
    'beklemeListesi': 5,
    'tahminiSure': '~15 dakika',
    'bildirimDurumu': true,
    'bildirimMesafesi': 2,
  };

  Timer? _timer;
  bool _bildirimGonderildi = false;

  @override
  void initState() {
    super.initState();
    _startSiraTimer();
    _checkSiraAndNotify();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSiraTimer() {
    // Her 30 saniyede bir sıra kontrolü yap
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _checkSiraAndNotify();
    });
  }

  void _checkSiraAndNotify() {
    int aktifSira = int.parse(islemBilgisi['aktifSira']);
    int benimSiram = int.parse(islemBilgisi['siraNo']);
    int bildirimMesafesi = islemBilgisi['bildirimMesafesi'];

    if (islemBilgisi['bildirimDurumu'] && !_bildirimGonderildi) {
      if (benimSiram - aktifSira <= bildirimMesafesi) {
        _showNotification(
          'Sıranız Yaklaşıyor!',
          'Şu an $aktifSira numaralı hasta işlemde. Sıranıza ${benimSiram - aktifSira} kişi kaldı.',
        );
        setState(() {
          _bildirimGonderildi = true;
        });
      }
    }
  }

  void _showNotification(String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.orange),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body),
            SizedBox(height: 16),
            Text(
              'Lütfen bekleme alanında hazır bulununuz.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showAutoQueueDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.queue, color: HealthApp.accentColor),
            SizedBox(width: 8),
            Text('Otomatik Sıra Al'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kan alma işlemi için otomatik sıra almak ister misiniz?'),
            SizedBox(height: 8),
            Text(
              'Tahmini bekleme süresi: 45 dakika',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sıranız geldiğinde bildirim alacaksınız.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _getAutoQueue();
            },
            child: Text('Sıra Al'),
          ),
        ],
      ),
    );
  }

  void _getAutoQueue() {
    // Simüle edilmiş sıra alma
    setState(() {
      islemBilgisi['siraNo'] = '48';
      islemBilgisi['beklemeListesi'] = 8;
      islemBilgisi['tahminiSure'] = '~45 dakika';
    });

    // Sıra alma bildirimi
    _showNotification(
      'Sıra Alındı',
      'Sıra numaranız: 48\nŞu an işlemde olan numara: ${islemBilgisi['aktifSira']}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: HealthApp.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.bloodtype,
                          color: HealthApp.accentColor,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yapılacak İşlem',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              islemBilgisi['islemAdi']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: HealthApp.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24),
                  _buildInfoRow(Icons.location_on, 'Konum',
                      '${islemBilgisi['kat']}, ${islemBilgisi['oda']} No\'lu Oda'),
                  SizedBox(height: 8),
                  _buildInfoRow(
                      Icons.medical_services, 'Birim', islemBilgisi['birim']!),
                  SizedBox(height: 8),
                  _buildInfoRow(
                      Icons.access_time, 'Çalışma Saati', islemBilgisi['saat']!),
                  if (islemBilgisi['not'] != null) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange[100]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.orange[800], size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              islemBilgisi['not']!,
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: HealthApp.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: HealthApp.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sıra Numaranız',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  islemBilgisi['siraNo'],
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: HealthApp.accentColor,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Aktif Sıra',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  islemBilgisi['aktifSira'],
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(
                              Icons.people_outline,
                              'Bekleyen',
                              '${islemBilgisi['beklemeListesi']} kişi',
                            ),
                            _buildInfoChip(
                              Icons.timer_outlined,
                              'Tahmini Süre',
                              islemBilgisi['tahminiSure'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue[100]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Icon(Icons.person, color: Colors.blue),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Size Yardımcı Olacak',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                islemBilgisi['gorevli'],
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Hastane Haritası',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 100, color: HealthApp.primaryColor),
                    SizedBox(height: 16),
                    Text(
                      'İnteraktif Hastane Haritası',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HealthApp.accentColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Yakında hizmetinizde olacak',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _showAutoQueueDialog,
              icon: Icon(Icons.queue),
              label: Text('Otomatik Sıra Al'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HealthApp.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text('Sıra Bildirimleri'),
              subtitle: Text('Sıranız yaklaştığında bildirim alın'),
              value: islemBilgisi['bildirimDurumu'],
              onChanged: (value) {
                setState(() {
                  islemBilgisi['bildirimDurumu'] = value;
                });
              },
              activeColor: HealthApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: HealthApp.accentColor),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: HealthApp.accentColor),
          SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HealthApp.accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
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
  List<String> selectedSymptoms = [];
  String searchText = '';

  static const primaryColor = Color(0xFFE0D3F5);
  static const secondaryColor = Color(0xFFF0E6FF);
  static const backgroundColor = Color(0xFFFAF8FF);
  static const accentColor = Color(0xFF9B8BB4);

  final List<Map<String, dynamic>> allSymptoms = [
    {
      'title': 'Ateş',
      'icon': Icons.thermostat,
      'description': '38°C ve üzeri ateş',
      'severity': ['Hafif (37.5-38°C)', 'Orta (38-39°C)', 'Yüksek (39°C+)'],
      'keywords': ['ateş', 'yüksek ateş', 'vücut ısısı', 'hararet'],
      'relatedSymptoms': ['Titreme', 'Terleme', 'Halsizlik']
    },
    {
      'title': 'Öksürük',
      'icon': Icons.healing,
      'description': 'Kuru veya balgamlı öksürük',
      'severity': ['Aralıklı', 'Sürekli', 'Şiddetli'],
      'keywords': ['öksürük', 'kuru öksürük', 'balgam', 'boğaz'],
      'relatedSymptoms': ['Boğaz ağrısı', 'Nefes darlığı']
    },
    {
      'title': 'Baş Ağrısı',
      'icon': Icons.sick,
      'description': 'Zonklama veya basınç hissi',
      'severity': ['Hafif', 'Orta', 'Şiddetli'],
      'keywords': ['baş ağrısı', 'migren', 'zonklama', 'başım ağrıyor'],
      'relatedSymptoms': ['Baş dönmesi', 'Mide bulantısı']
    },
    {
      'title': 'Yorgunluk',
      'icon': Icons.battery_alert,
      'description': 'Genel halsizlik ve bitkinlik',
      'severity': ['Hafif', 'Belirgin', 'Şiddetli'],
      'keywords': ['yorgunluk', 'halsizlik', 'bitkinlik', 'güçsüzlük'],
      'relatedSymptoms': ['Kas ağrısı', 'Uyku hali']
    },
    {
      'title': 'Mide Bulantısı',
      'icon': Icons.sick_outlined,
      'description': 'Bulantı ve kusma hissi',
      'severity': ['Hafif', 'Orta', 'Şiddetli'],
      'keywords': ['mide bulantısı', 'kusma', 'bulantı'],
      'relatedSymptoms': ['Karın ağrısı', 'İştahsızlık']
    },
  ];

  List<Map<String, dynamic>> get filteredSymptoms {
    if (searchText.isEmpty) return allSymptoms;
    return allSymptoms.where((symptom) {
      final keywords = symptom['keywords'] as List<String>;
      return keywords.any((keyword) => 
        keyword.toLowerCase().contains(searchText.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semptom Analizi',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: accentColor,
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
          if (selectedSymptoms.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  _showAnalysisResult();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Analizi Başlat',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandableSymptomCard(Map<String, dynamic> symptom) {
    final isSelected = selectedSymptoms.contains(symptom['title']);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          symptom['icon'] as IconData,
          color: isSelected ? accentColor : Colors.black87,
          size: 28,
        ),
        title: Text(
          symptom['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isSelected ? accentColor : Colors.black87,
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
                  color: accentColor,
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
                    color: accentColor,
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

  void _showAnalysisResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Semptom Analizi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seçilen Semptomlar:'),
            SizedBox(height: 8),
            ...selectedSymptoms.map((symptom) => Text('• $symptom')),
            SizedBox(height: 16),
            Text('Olası Durumlar:'),
            SizedBox(height: 8),
            Text('Bu semptomlar şunlara işaret edebilir:'),
            Text('• Üst solunum yolu enfeksiyonu'),
            Text('• Grip'),
            Text('• Viral enfeksiyon'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              // Doktor randevusu alma sayfasına yönlendirme
              Navigator.pop(context);
            },
            child: Text('Randevu Al'),
          ),
        ],
      ),
    );
  }
}

class MesajlarPage extends StatelessWidget {
  final List<Map<String, dynamic>> conversations = [
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
              color: HealthApp.accentColor,
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

  Widget _buildConversationCard(BuildContext context, Map<String, dynamic> conversation) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: conversation['unread'] ? HealthApp.primaryColor : Colors.grey[300],
              child: Text(
                conversation['doctorName'].toString().split(' ')[1][0],
                style: TextStyle(
                  color: conversation['unread'] ? Colors.white : Colors.grey[600],
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
            fontWeight: conversation['unread'] ? FontWeight.bold : FontWeight.normal,
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
                color: HealthApp.accentColor,
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
                color: conversation['unread'] ? HealthApp.accentColor : Colors.grey,
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

  const PatientChatScreen({super.key, 
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
        'text': 'Merhaba, test sonuçlarınızı inceledim. Her şey normal görünüyor.',
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
                    color: HealthApp.accentColor,
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
                    color: HealthApp.accentColor,
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
              color: HealthApp.accentColor,
            ),
          ),
          SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(Icons.medical_services, color: HealthApp.accentColor),
              title: Text('Doktor Paneli'),
              subtitle: Text('Doktor paneline geçiş yapın'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDashboard(),
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