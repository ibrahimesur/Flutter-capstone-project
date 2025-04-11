import 'package:flutter/material.dart';
import '../../main.dart';

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({Key? key}) : super(key: key);

  @override
  _TestResultsScreenState createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Örnek laboratuvar testi verileri
  final List<Map<String, dynamic>> _labTests = [
    {
      'id': 'LAB001',
      'name': 'Tam Kan Sayımı (CBC)',
      'date': '22.03.2024',
      'doctor': 'Dr. Mehmet Yılmaz',
      'department': 'Dahiliye',
      'status': 'Tamamlandı',
      'results': [
        {
          'name': 'WBC',
          'value': '7.5',
          'unit': '10^3/µL',
          'range': '4.5-11.0',
          'status': 'normal'
        },
        {
          'name': 'RBC',
          'value': '5.2',
          'unit': '10^6/µL',
          'range': '4.5-5.9',
          'status': 'normal'
        },
        {
          'name': 'HGB',
          'value': '16.1',
          'unit': 'g/dL',
          'range': '13.5-17.5',
          'status': 'normal'
        },
        {
          'name': 'HCT',
          'value': '47.4',
          'unit': '%',
          'range': '41.0-53.0',
          'status': 'normal'
        },
        {
          'name': 'PLT',
          'value': '180',
          'unit': '10^3/µL',
          'range': '150-450',
          'status': 'normal'
        },
      ],
    },
    {
      'id': 'LAB002',
      'name': 'Lipid Profili',
      'date': '15.03.2024',
      'doctor': 'Dr. Ayşe Kaya',
      'department': 'Kardiyoloji',
      'status': 'Tamamlandı',
      'results': [
        {
          'name': 'Total Kolesterol',
          'value': '220',
          'unit': 'mg/dL',
          'range': '< 200',
          'status': 'high'
        },
        {
          'name': 'HDL',
          'value': '55',
          'unit': 'mg/dL',
          'range': '> 40',
          'status': 'normal'
        },
        {
          'name': 'LDL',
          'value': '140',
          'unit': 'mg/dL',
          'range': '< 130',
          'status': 'high'
        },
        {
          'name': 'Trigliserit',
          'value': '150',
          'unit': 'mg/dL',
          'range': '< 150',
          'status': 'normal'
        },
      ],
    },
    {
      'id': 'LAB003',
      'name': 'Karaciğer Fonksiyon Testleri',
      'date': '10.03.2024',
      'doctor': 'Dr. Burak Buz',
      'department': 'Gastroenteroloji',
      'status': 'Tamamlandı',
      'results': [
        {
          'name': 'ALT',
          'value': '32',
          'unit': 'U/L',
          'range': '7-56',
          'status': 'normal'
        },
        {
          'name': 'AST',
          'value': '28',
          'unit': 'U/L',
          'range': '10-40',
          'status': 'normal'
        },
        {
          'name': 'ALP',
          'value': '72',
          'unit': 'U/L',
          'range': '44-147',
          'status': 'normal'
        },
        {
          'name': 'GGT',
          'value': '30',
          'unit': 'U/L',
          'range': '8-61',
          'status': 'normal'
        },
        {
          'name': 'Bilirubin',
          'value': '0.8',
          'unit': 'mg/dL',
          'range': '0.1-1.2',
          'status': 'normal'
        },
      ],
    }
  ];

  // Örnek görüntüleme raporları
  final List<Map<String, dynamic>> _imagingReports = [
    {
      'id': 'IMG001',
      'name': 'Akciğer X-Ray',
      'date': '18.03.2024',
      'doctor': 'Dr. Zeynep Demir',
      'department': 'Radyoloji',
      'status': 'Tamamlandı',
      'result':
          'Akciğerler normal aerasyonda. Kalp gölgesi normal boyutlarda. Kemik yapılarda dejeneratif değişiklikler mevcut.',
      'image': 'assets/images/xray_placeholder.png',
    },
    {
      'id': 'IMG002',
      'name': 'Abdominal Ultrason',
      'date': '12.03.2024',
      'doctor': 'Dr. Ali Can',
      'department': 'Radyoloji',
      'status': 'Tamamlandı',
      'result':
          'Karaciğer, safra kesesi, pankreas, dalak ve böbrekler normal görünümde. Patoloji saptanmadı.',
      'image': 'assets/images/ultrasound_placeholder.png',
    },
    {
      'id': 'IMG003',
      'name': 'MRI - Lumbar',
      'date': '05.02.2024',
      'doctor': 'Dr. Hakan Taş',
      'department': 'Radyoloji',
      'status': 'Tamamlandı',
      'result':
          'L4-L5 seviyesinde disk protrüzyonu. L5-S1 seviyesinde minimal bulging. Spinal kanal çapı normal.',
      'image': 'assets/images/mri_placeholder.png',
    },
  ];

  // Örnek doktor raporları
  final List<Map<String, dynamic>> _doctorReports = [
    {
      'id': 'REP001',
      'title': 'Kardiyoloji Konsültasyon Raporu',
      'date': '15.03.2024',
      'doctor': 'Dr. Ayşe Kaya',
      'department': 'Kardiyoloji',
      'content':
          'Hasta hipertansiyon ve hiperlipidemi tanıları ile takip edilmektedir. EKG\'de sinüs ritmi, yükselmiş kolesterol değerleri mevcut. Düzenli ilaç kullanımının devamı, düşük yağlı diyet ve düzenli egzersiz önerilmiştir.',
      'recommendations': [
        'Atorvastatin 20mg 1x1 devam',
        'Benazeril 10mg 1x1 devam',
        'Tuz kısıtlaması',
        'Yürüyüş (haftada en az 3 gün, 30 dakika)',
        '3 ay sonra tekrar kontrol'
      ],
    },
    {
      'id': 'REP002',
      'title': 'Üroloji Muayene Raporu',
      'date': '22.03.2024',
      'doctor': 'Dr. Burak Buz',
      'department': 'Üroloji',
      'content':
          'Hasta idrar yaparken yanma, sık idrara çıkma şikayetleri ile başvurdu. İdrar tahlilinde lökositüri saptandı. Üriner sistem enfeksiyonu tanısı konuldu. 10 günlük antibiyotik tedavisi başlandı.',
      'recommendations': [
        'Cipro 500mg 1x1 (10 gün)',
        'Bol sıvı tüketimi (günde en az 2 litre)',
        'Tedavi bitiminde kontrol idrar tahlili'
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Sonuçları ve Raporlar'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Laboratuvar'),
            Tab(text: 'Görüntüleme'),
            Tab(text: 'Doktor Raporları'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLabTestsTab(),
                _buildImagingReportsTab(),
                _buildDoctorReportsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HealthApp.accentColor,
        onPressed: () {
          _showDownloadOptionsDialog(context);
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildLabTestsTab() {
    final filteredTests = _labTests.where((test) {
      return test['name'].toLowerCase().contains(_searchQuery) ||
          test['doctor'].toLowerCase().contains(_searchQuery) ||
          test['department'].toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredTests.isEmpty) {
      return _buildEmptyState('Laboratuvar testi bulunamadı');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTests.length,
      itemBuilder: (context, index) {
        final test = filteredTests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            childrenPadding: const EdgeInsets.all(16),
            title: Text(
              test['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tarih: ${test['date']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${test['doctor']} - ${test['department']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(test['status']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                test['status'],
                style: TextStyle(
                  color: _getStatusColor(test['status']),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            children: [
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Sonuçlar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => HealthApp.primaryColor.withOpacity(0.1),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Test',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Sonuç',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Birim',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Referans',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: test['results'].map<DataRow>((result) {
                    return DataRow(
                      cells: [
                        DataCell(Text(result['name'])),
                        DataCell(
                          Text(
                            result['value'],
                            style: TextStyle(
                              color: _getValueColor(result['status']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(Text(result['unit'])),
                        DataCell(Text(result['range'])),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Paylaş'),
                    onPressed: () {
                      // Paylaşma işlemi
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('İndir'),
                    onPressed: () {
                      // İndirme işlemi
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagingReportsTab() {
    final filteredReports = _imagingReports.where((report) {
      return report['name'].toLowerCase().contains(_searchQuery) ||
          report['doctor'].toLowerCase().contains(_searchQuery) ||
          report['department'].toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredReports.isEmpty) {
      return _buildEmptyState('Görüntüleme raporu bulunamadı');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        final report = filteredReports[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(report['status'])
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report['status'],
                            style: TextStyle(
                              color: _getStatusColor(report['status']),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tarih: ${report['date']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${report['doctor']} - ${report['department']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rapor Sonucu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(report['result']),
                    const SizedBox(height: 16),
                    // Placeholder görüntü (gerçek uygulamada resim olmalı)
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.share),
                          label: const Text('Paylaş'),
                          onPressed: () {
                            // Paylaşma işlemi
                          },
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.download),
                          label: const Text('İndir'),
                          onPressed: () {
                            // İndirme işlemi
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
    );
  }

  Widget _buildDoctorReportsTab() {
    final filteredReports = _doctorReports.where((report) {
      return report['title'].toLowerCase().contains(_searchQuery) ||
          report['doctor'].toLowerCase().contains(_searchQuery) ||
          report['department'].toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredReports.isEmpty) {
      return _buildEmptyState('Doktor raporu bulunamadı');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        final report = filteredReports[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            childrenPadding: const EdgeInsets.all(16),
            title: Text(
              report['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tarih: ${report['date']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${report['doctor']} - ${report['department']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            children: [
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Rapor İçeriği',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(report['content']),
              const SizedBox(height: 16),
              const Text(
                'Öneriler',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...report['recommendations'].map<Widget>((recommendation) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: HealthApp.accentColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(recommendation),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Paylaş'),
                    onPressed: () {
                      // Paylaşma işlemi
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('İndir'),
                    onPressed: () {
                      // İndirme işlemi
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Tamamlandı':
        return Colors.green;
      case 'Beklemede':
        return Colors.orange;
      case 'İptal':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Color _getValueColor(String status) {
    switch (status) {
      case 'high':
        return Colors.red;
      case 'low':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _showDownloadOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tüm Raporları İndir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDownloadOption(
                icon: Icons.picture_as_pdf,
                title: 'PDF olarak indir',
                subtitle: 'Tüm raporları tek bir PDF olarak al',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF indirme başlatıldı')),
                  );
                },
              ),
              const Divider(),
              _buildDownloadOption(
                icon: Icons.folder_zip,
                title: 'ZIP olarak indir',
                subtitle: 'Tüm raporları sıkıştırılmış dosya olarak al',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ZIP indirme başlatıldı')),
                  );
                },
              ),
              const Divider(),
              _buildDownloadOption(
                icon: Icons.email,
                title: 'E-posta olarak gönder',
                subtitle: 'Tüm raporları e-posta olarak al',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('E-posta gönderimi başlatıldı')),
                  );
                },
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
          ],
        );
      },
    );
  }

  Widget _buildDownloadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: HealthApp.accentColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
}
