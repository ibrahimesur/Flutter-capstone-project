import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'doctor/doctor_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RandevuPage(),
    const HaritaPage(),
    const SemptomPage(),
    const MesajlarPage(),
    const AyarlarPage(),
  ];

  final Map<String, dynamic> islemBilgisi = const {
    'doktor': 'Prof. Dr. Burak Buz',
    'bolum': 'Üroloji',
    'tarih': '15 Haziran 2023',
    'saat': '14:30',
    'durum': 'Onaylandı',
  };

  final List<Map<String, dynamic>> conversations = const [
    {
      'name': 'Prof. Dr. Burak Buz',
      'message':
          'Merhaba, randevu için teşekkürler. Nasıl yardımcı olabilirim?',
      'time': '09:30',
      'unread': 2,
    },
    {
      'name': 'Uzm. Dr. Ayşe Yılmaz',
      'message': 'Test sonuçlarınız hazır. Kontrol etmeniz gerekiyor.',
      'time': '10:15',
      'unread': 1,
    },
    // ... diğer conversation verileri
  ];

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
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Profil sayfası
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
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
          items: const [
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
  const RandevuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Randevu Al',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D5F7C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tercih ettiğiniz bölüm ve doktoru seçin',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Randevu Bilgileri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D5F7C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Bölüm Seçiniz',
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                    items: [
                      'Dahiliye',
                      'Kardiyoloji',
                      'Nöroloji',
                      'Ortopedi',
                      'Göz Hastalıkları'
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Doktor Seçiniz',
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: [
                      'Dr. Ahmet Yılmaz',
                      'Dr. Ayşe Kaya',
                      'Dr. Mehmet Demir'
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Tarih Seç'),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text('Saat Seç'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yaklaşan Randevularınız',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D5F7C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAppointmentTile(
                    'Dr. Ahmet Yılmaz',
                    'Kardiyoloji',
                    '15 Mart 2024',
                    '14:30',
                  ),
                  const Divider(),
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

  Widget _buildAppointmentTile(
      String doctor, String department, String date, String time) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF2D5F7C),
        child: Icon(Icons.calendar_today, color: Colors.white, size: 20),
      ),
      title: Text(doctor, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('$department\n$date'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2D5F7C).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          time,
          style: const TextStyle(
            color: Color(0xFF2D5F7C),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      isThreeLine: true,
    );
  }
}

class HaritaPage extends StatelessWidget {
  final Map<String, dynamic> islemBilgisi = const {
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
  };

  const HaritaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: HealthApp.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.bloodtype,
                          color: HealthApp.accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
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
                              style: const TextStyle(
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
                  const Divider(height: 24),
                  _buildInfoRow(Icons.location_on, 'Konum',
                      '${islemBilgisi['kat']}, ${islemBilgisi['oda']} No\'lu Oda'),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                      Icons.medical_services, 'Birim', islemBilgisi['birim']!),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.access_time, 'Çalışma Saati',
                      islemBilgisi['saat']!),
                  if (islemBilgisi['not'] != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
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
                          const SizedBox(width: 8),
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
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(16),
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
                                  style: const TextStyle(
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
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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
                    padding: const EdgeInsets.all(12),
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
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
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
          const SizedBox(height: 24),
          Text(
            'Hastane Haritası',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map,
                        size: 100, color: HealthApp.primaryColor),
                    const SizedBox(height: 16),
                    const Text(
                      'İnteraktif Hastane Haritası',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HealthApp.accentColor,
                      ),
                    ),
                    const SizedBox(height: 8),
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
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: HealthApp.accentColor),
        const SizedBox(width: 8),
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
              style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          const SizedBox(width: 4),
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
                style: const TextStyle(
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
  const SemptomPage({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 8),
          Text(
            'Yaşadığınız semptomları açıklayın veya listeden seçin',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Semptomlarınızı yazın (örn: baş ağrısı ve ateş)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
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
          const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  _showAnalysisResult();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
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
      margin: const EdgeInsets.only(bottom: 12),
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
                style: const TextStyle(
                  color: accentColor,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Şiddet Seviyesi',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 8),
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
        title: const Text('Semptom Analizi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Seçilen Semptomlar:'),
            const SizedBox(height: 8),
            ...selectedSymptoms.map((symptom) => Text('• $symptom')),
            const SizedBox(height: 16),
            const Text('Olası Durumlar:'),
            const SizedBox(height: 8),
            const Text('Bu semptomlar şunlara işaret edebilir:'),
            const Text('• Üst solunum yolu enfeksiyonu'),
            const Text('• Grip'),
            const Text('• Viral enfeksiyon'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              // Doktor randevusu alma sayfasına yönlendirme
              Navigator.pop(context);
            },
            child: const Text('Randevu Al'),
          ),
        ],
      ),
    );
  }
}

class MesajlarPage extends StatelessWidget {
  final List<Map<String, dynamic>> conversations = const [
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

  const MesajlarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Doktor ara...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              style: const TextStyle(
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
                color: conversation['unread']
                    ? HealthApp.accentColor
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Son ziyaret: ${conversation['lastVisit']}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
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
    Key? key,
    required this.doctorName,
    required this.doctorInfo,
  }) : super(key: key);

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
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      },
      {
        'text':
            'Merhaba, test sonuçlarınızı inceledim. Her şey normal görünüyor.',
        'isPatient': false,
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      },
      {
        'text': 'Teşekkür ederim, kontrol için ne zaman gelmeliyim?',
        'isPatient': true,
        'time': DateTime.now().subtract(const Duration(hours: 1)),
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
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.doctorName),
                Text(
                  widget.doctorInfo['department'],
                  style: const TextStyle(
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
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
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
              padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
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
                  icon: const Icon(
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
                    decoration: const InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
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
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 4),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: const Text('Dosya'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Test Sonuçları'),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doktor Bilgileri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Ad Soyad', widget.doctorName),
            _buildInfoRow('Bölüm', widget.doctorInfo['department']),
            _buildInfoRow('Son Ziyaret', widget.doctorInfo['lastVisit']),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Randevu Al'),
                  onPressed: () {
                    Navigator.pop(context);
                    // Randevu alma sayfasına yönlendirme
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.medical_services),
                  label: const Text('Geçmiş'),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
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
  const AyarlarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.medical_services,
                  color: HealthApp.accentColor),
              title: const Text('Doktor Paneli'),
              subtitle: const Text('Doktor paneline geçiş yapın'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorDashboard(),
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
