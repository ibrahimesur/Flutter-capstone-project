import 'package:flutter/material.dart';
import '../../main.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HastaneBilgileriPage(),
    const KatPlanYonetimPage(),
    const PersonelYonetimPage(),
    const SemptomAnalizKontrolPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: HealthApp.primaryColor.withOpacity(0.2),
        selectedItemColor: HealthApp.accentColor,
        unselectedItemColor: Colors.grey[600],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Hastane Bilgileri',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Kat Planı',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Personel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Semptom Analizi',
          ),
        ],
      ),
    );
  }
}

class HastaneBilgileriPage extends StatefulWidget {
  const HastaneBilgileriPage({Key? key}) : super(key: key);

  @override
  _HastaneBilgileriPageState createState() => _HastaneBilgileriPageState();
}

class _HastaneBilgileriPageState extends State<HastaneBilgileriPage> {
  final _formKey = GlobalKey<FormState>();
  final _hastaneAdiController = TextEditingController(text: "Şehir Hastanesi");
  final _adresController =
      TextEditingController(text: "Merkez Mah. Hastane Cad. No:123");
  final _telefonController = TextEditingController(text: "0212 123 45 67");
  final _emailController =
      TextEditingController(text: "info@sehirhastanesi.com");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hastane Bilgileri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HealthApp.accentColor,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hastaneAdiController,
              decoration: const InputDecoration(
                labelText: 'Hastane Adı',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen hastane adını girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _adresController,
              decoration: const InputDecoration(
                labelText: 'Adres',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen adresi girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefonController,
              decoration: const InputDecoration(
                labelText: 'Telefon',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen telefon numarasını girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen e-posta adresini girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bilgiler kaydedildi')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}

class KatPlanYonetimPage extends StatefulWidget {
  const KatPlanYonetimPage({Key? key}) : super(key: key);

  @override
  _KatPlanYonetimPageState createState() => _KatPlanYonetimPageState();
}

class _KatPlanYonetimPageState extends State<KatPlanYonetimPage> {
  final List<Map<String, dynamic>> _katlar = [
    {
      'kat': 'Zemin Kat',
      'bolumler': [
        'Danışma',
        'Acil Servis',
        'Kan Alma',
        'Radyoloji',
        'Kafeterya'
      ],
      'expanded': false,
    },
    {
      'kat': '1. Kat',
      'bolumler': ['Üroloji', 'Kardiyoloji', 'Dahiliye', 'Göz Hastalıkları'],
      'expanded': false,
    },
    {
      'kat': '2. Kat',
      'bolumler': ['Ameliyathane', 'Yoğun Bakım Ünitesi', 'Sterilizasyon'],
      'expanded': false,
    },
  ];

  void _addBolum(int katIndex, String bolum) {
    setState(() {
      _katlar[katIndex]['bolumler'].add(bolum);
    });
  }

  void _removeBolum(int katIndex, int bolumIndex) {
    setState(() {
      _katlar[katIndex]['bolumler'].removeAt(bolumIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kat Planı Yönetimi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _katlar.length,
            itemBuilder: (context, index) {
              final kat = _katlar[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(kat['kat']),
                  subtitle: Text('${kat['bolumler'].length} bölüm'),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      kat['expanded'] = expanded;
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bölümler',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                              kat['bolumler'].length,
                              (bolumIndex) => Chip(
                                label: Text(kat['bolumler'][bolumIndex]),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () =>
                                    _removeBolum(index, bolumIndex),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Yeni Bölüm',
                                    border: OutlineInputBorder(),
                                  ),
                                  onFieldSubmitted: (value) {
                                    if (value.isNotEmpty) {
                                      _addBolum(index, value);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  // Yeni bölüm ekleme
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PersonelYonetimPage extends StatefulWidget {
  const PersonelYonetimPage({Key? key}) : super(key: key);

  @override
  _PersonelYonetimPageState createState() => _PersonelYonetimPageState();
}

class _PersonelYonetimPageState extends State<PersonelYonetimPage> {
  final List<Map<String, dynamic>> _personel = [
    {
      'id': 'DR001',
      'ad': 'Prof. Dr. Burak Buz',
      'unvan': 'Üroloji Uzmanı',
      'bolum': 'Üroloji',
      'telefon': '0532 123 45 67',
      'email': 'burak.buz@hastane.com',
    },
    {
      'id': 'DR002',
      'ad': 'Uzm. Dr. Ayşe Yılmaz',
      'unvan': 'Kardiyoloji Uzmanı',
      'bolum': 'Kardiyoloji',
      'telefon': '0533 234 56 78',
      'email': 'ayse.yilmaz@hastane.com',
    },
    {
      'id': 'NR001',
      'ad': 'Hemşire Zeynep Demir',
      'unvan': 'Baş Hemşire',
      'bolum': 'Acil Servis',
      'telefon': '0534 345 67 89',
      'email': 'zeynep.demir@hastane.com',
    },
  ];

  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredPersonel {
    return _personel.where((personel) {
      return personel['ad']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          personel['bolum']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          personel['id'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personel Yönetimi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HealthApp.accentColor,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Personel Ara',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Yeni Personel'),
                    onPressed: () {
                      // Yeni personel ekleme
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredPersonel.length,
            itemBuilder: (context, index) {
              final personel = _filteredPersonel[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: HealthApp.primaryColor,
                    child: Text(
                      personel['ad'][0],
                      style: const TextStyle(
                        color: HealthApp.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(personel['ad']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${personel['unvan']} - ${personel['bolum']}'),
                      Text('ID: ${personel['id']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Personel düzenleme
                    },
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SemptomAnalizKontrolPage extends StatefulWidget {
  const SemptomAnalizKontrolPage({Key? key}) : super(key: key);

  @override
  _SemptomAnalizKontrolPageState createState() =>
      _SemptomAnalizKontrolPageState();
}

class _SemptomAnalizKontrolPageState extends State<SemptomAnalizKontrolPage> {
  final List<Map<String, dynamic>> _semptomlar = [
    {
      'id': 'SYM001',
      'ad': 'Baş ağrısı',
      'iliskiliHastaliklar': ['Migren', 'Sinüzit', 'Hipertansiyon'],
      'aktif': true,
    },
    {
      'id': 'SYM002',
      'ad': 'Ateş',
      'iliskiliHastaliklar': ['Grip', 'COVID-19', 'Enfeksiyon'],
      'aktif': true,
    },
    {
      'id': 'SYM003',
      'ad': 'Öksürük',
      'iliskiliHastaliklar': ['Soğuk algınlığı', 'Bronşit', 'COVID-19'],
      'aktif': true,
    },
    {
      'id': 'SYM004',
      'ad': 'Mide bulantısı',
      'iliskiliHastaliklar': ['Gıda zehirlenmesi', 'Migren', 'Hamilelik'],
      'aktif': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Semptom Analizi Kontrol',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Semptom Analizi Sistemi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bu modül hastaların şikayetlerine göre ön tanı oluşturulmasına ve doğru bölüme yönlendirilmesine yardımcı olur.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Yeni Semptom'),
                onPressed: () {
                  // Yeni semptom ekleme
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _semptomlar.length,
            itemBuilder: (context, index) {
              final semptom = _semptomlar[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Text(semptom['ad']),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: semptom['aktif']
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          semptom['aktif'] ? 'Aktif' : 'Pasif',
                          style: TextStyle(
                            fontSize: 12,
                            color: semptom['aktif'] ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text('ID: ${semptom['id']}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'İlişkili Hastalıklar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                              semptom['iliskiliHastaliklar'].length,
                              (hastalikIndex) => Chip(
                                label: Text(
                                  semptom['iliskiliHastaliklar'][hastalikIndex],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text('Düzenle'),
                                onPressed: () {
                                  // Semptom düzenleme
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: Icon(
                                  semptom['aktif']
                                      ? Icons.toggle_off
                                      : Icons.toggle_on,
                                  color: semptom['aktif']
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                label: Text(
                                  semptom['aktif']
                                      ? 'Pasife Al'
                                      : 'Aktifleştir',
                                  style: TextStyle(
                                    color: semptom['aktif']
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    semptom['aktif'] = !semptom['aktif'];
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
