import 'package:flutter/material.dart';
import '../../main.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  // Hasta bilgileri
  final Map<String, dynamic> _patientInfo = {
    'id': 'PT001',
    'name': 'Ahmet Yılmaz',
    'birthDate': '01.01.1980',
    'gender': 'Erkek',
    'blood': 'A Rh+',
    'phoneNumber': '0532 123 45 67',
    'email': 'ahmet.yilmaz@email.com',
    'address': 'Atatürk Mah. Cumhuriyet Cad. No:123 D:4 İstanbul',
    'emergencyContact': 'Ayşe Yılmaz - 0533 234 56 78 (Eşi)',
    'insurance': 'SGK',
    'chronicDiseases': ['Diyabet', 'Hipertansiyon'],
    'allergies': ['Penisilin', 'Fındık'],
  };

  // Genel sağlık verileri
  final Map<String, dynamic> _healthData = {
    'height': 178,
    'weight': 82,
    'bmi': 25.9,
    'bloodPressure': {'systolic': 130, 'diastolic': 85},
    'bloodSugar': 110,
    'cholesterol': {'ldl': 110, 'hdl': 55, 'total': 180},
    'heartRate': 71,
    'bloodPressureHistory': [
      {'date': '01.03.2024', 'systolic': 128, 'diastolic': 84},
      {'date': '01.02.2024', 'systolic': 130, 'diastolic': 86},
      {'date': '01.01.2024', 'systolic': 132, 'diastolic': 87},
      {'date': '01.12.2023', 'systolic': 135, 'diastolic': 88},
      {'date': '01.11.2023', 'systolic': 134, 'diastolic': 87},
      {'date': '01.10.2023', 'systolic': 130, 'diastolic': 85},
    ],
    'bloodSugarHistory': [
      {'date': '01.03.2024', 'value': 108},
      {'date': '01.02.2024', 'value': 112},
      {'date': '01.01.2024', 'value': 115},
      {'date': '01.12.2023', 'value': 118},
      {'date': '01.11.2023', 'value': 114},
      {'date': '01.10.2023', 'value': 110},
    ],
  };

  // Son muayeneler
  final List<Map<String, dynamic>> _lastExaminations = [
    {
      'date': '15.03.2024',
      'doctor': 'Prof. Dr. Burak Buz',
      'department': 'Üroloji',
      'diagnosis': 'Üriner Sistem Enfeksiyonu',
      'treatment': 'Antibiyotik tedavisi, bol sıvı tüketimi',
    },
    {
      'date': '02.02.2024',
      'doctor': 'Uzm. Dr. Ayşe Kaya',
      'department': 'Kardiyoloji',
      'diagnosis': 'Sınırda Hipertansiyon',
      'treatment': 'Diyet düzenlemesi, egzersiz',
    },
    {
      'date': '10.12.2023',
      'doctor': 'Uzm. Dr. Mehmet Yılmaz',
      'department': 'Dahiliye',
      'diagnosis': 'Grip',
      'treatment': 'Semptomatik tedavi',
    },
  ];

  // Reçeteler
  final List<Map<String, dynamic>> _prescriptions = [
    {
      'date': '15.03.2024',
      'doctor': 'Prof. Dr. Burak Buz',
      'medications': [
        {'name': 'Cipro 500mg', 'dose': '1x1', 'duration': '10 gün'},
        {'name': 'Parol 500mg', 'dose': '2x1', 'duration': '5 gün'},
      ],
      'active': true,
    },
    {
      'date': '02.02.2024',
      'doctor': 'Uzm. Dr. Ayşe Kaya',
      'medications': [
        {'name': 'Beloc 50mg', 'dose': '1x1', 'duration': 'Sürekli'},
      ],
      'active': true,
    },
    {
      'date': '10.12.2023',
      'doctor': 'Uzm. Dr. Mehmet Yılmaz',
      'medications': [
        {'name': 'Theraflu', 'dose': '2x1', 'duration': '5 gün'},
        {'name': 'Aferin', 'dose': '2x1', 'duration': '5 gün'},
      ],
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasta Profili'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Profili paylaşma
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Profili düzenleme
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(),
            const SizedBox(height: 16),
            _buildHealthDataSummary(),
            const SizedBox(height: 16),
            _buildTabView(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HealthApp.primaryColor.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: HealthApp.accentColor,
                child: Text(
                  _patientInfo['name']![0],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _patientInfo['name'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hasta ID: ${_patientInfo['id']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Doğum Tarihi: ${_patientInfo['birthDate']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.bloodtype,
                          size: 16,
                          color: Colors.red[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Kan Grubu: ${_patientInfo['blood']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                Icons.monitor_weight,
                '${_healthData['weight']} kg',
              ),
              _buildInfoChip(
                Icons.height,
                '${_healthData['height']} cm',
              ),
              _buildInfoChip(
                Icons.favorite,
                '${_healthData['heartRate']} bpm',
                color: Colors.red[400],
              ),
              _buildInfoChip(
                Icons.speed,
                'BMI: ${_healthData['bmi']}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? HealthApp.accentColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color ?? HealthApp.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDataSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genel Sağlık Durumu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildHealthDataCard(
                  'Kan Basıncı',
                  '${_healthData['bloodPressure']['systolic']}/${_healthData['bloodPressure']['diastolic']} mmHg',
                  Icons.favorite_border,
                  _getBpStatusColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthDataCard(
                  'Kan Şekeri',
                  '${_healthData['bloodSugar']} mg/dL',
                  Icons.opacity,
                  _getBloodSugarStatusColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHealthDataCard(
                  'Total Kolesterol',
                  '${_healthData['cholesterol']['total']} mg/dL',
                  Icons.science,
                  _getCholesterolStatusColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHealthDataCard(
                  'Kalp Atış Hızı',
                  '${_healthData['heartRate']} bpm',
                  Icons.favorite,
                  _getHeartRateStatusColor(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getBpStatusColor() {
    final int systolic = _healthData['bloodPressure']['systolic'];
    final int diastolic = _healthData['bloodPressure']['diastolic'];

    if (systolic >= 140 || diastolic >= 90) {
      return Colors.red;
    } else if (systolic >= 130 || diastolic >= 85) {
      return Colors.orange;
    } else if (systolic >= 120 || diastolic >= 80) {
      return Colors.yellow.shade700;
    } else {
      return Colors.green;
    }
  }

  Color _getBloodSugarStatusColor() {
    final int bloodSugar = _healthData['bloodSugar'];

    if (bloodSugar >= 126) {
      return Colors.red;
    } else if (bloodSugar >= 100) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Color _getCholesterolStatusColor() {
    final int totalCholesterol = _healthData['cholesterol']['total'];

    if (totalCholesterol >= 240) {
      return Colors.red;
    } else if (totalCholesterol >= 200) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Color _getHeartRateStatusColor() {
    final int heartRate = _healthData['heartRate'];

    if (heartRate >= 100 || heartRate <= 50) {
      return Colors.red;
    } else if (heartRate >= 90 || heartRate <= 60) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Widget _buildHealthDataCard(
      String title, String value, IconData icon, Color statusColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            labelColor: HealthApp.accentColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: HealthApp.accentColor,
            tabs: [
              Tab(text: 'Kişisel Bilgiler'),
              Tab(text: 'Tıbbi Geçmiş'),
              Tab(text: 'Reçeteler'),
              Tab(text: 'Laboratuvar'),
            ],
          ),
          SizedBox(
            height: 500, // Sabit yükseklik
            child: TabBarView(
              children: [
                _buildPersonalInfoTab(),
                _buildMedicalHistoryTab(),
                _buildPrescriptionsTab(),
                _buildLabResultsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection('Kişisel Bilgiler', [
            {'label': 'Ad Soyad', 'value': _patientInfo['name']},
            {'label': 'Doğum Tarihi', 'value': _patientInfo['birthDate']},
            {'label': 'Cinsiyet', 'value': _patientInfo['gender']},
            {'label': 'Kan Grubu', 'value': _patientInfo['blood']},
          ]),
          const SizedBox(height: 16),
          _buildInfoSection('İletişim Bilgileri', [
            {'label': 'Telefon', 'value': _patientInfo['phoneNumber']},
            {'label': 'E-posta', 'value': _patientInfo['email']},
            {'label': 'Adres', 'value': _patientInfo['address']},
            {
              'label': 'Acil Durum Kişisi',
              'value': _patientInfo['emergencyContact']
            },
          ]),
          const SizedBox(height: 16),
          _buildInfoSection('Sağlık Bilgileri', [
            {'label': 'Sigorta', 'value': _patientInfo['insurance']},
          ]),
          const SizedBox(height: 16),
          const Text(
            'Kronik Hastalıklar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _patientInfo['chronicDiseases'].map<Widget>((disease) {
              return Chip(
                label: Text(disease),
                backgroundColor: HealthApp.primaryColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Alerjiler',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _patientInfo['allergies'].map<Widget>((allergy) {
              return Chip(
                label: Text(allergy),
                backgroundColor: Colors.red[100],
                labelStyle: TextStyle(color: Colors.red[800]),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: HealthApp.accentColor,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['label']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    item['value']!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildMedicalHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lastExaminations.length,
      itemBuilder: (context, index) {
        final examination = _lastExaminations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
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
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medical_services,
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
                            examination['diagnosis'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            examination['date'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildExaminationDetail('Doktor', examination['doctor']),
                _buildExaminationDetail('Bölüm', examination['department']),
                _buildExaminationDetail('Teşhis', examination['diagnosis']),
                _buildExaminationDetail('Tedavi', examination['treatment']),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExaminationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _prescriptions.length,
      itemBuilder: (context, index) {
        final prescription = _prescriptions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
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
                        color: prescription['active']
                            ? Colors.green.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medical_services,
                        color:
                            prescription['active'] ? Colors.green : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reçete - ${prescription['date']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prescription['doctor'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: prescription['active']
                            ? Colors.green.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        prescription['active'] ? 'Aktif' : 'Sona Erdi',
                        style: TextStyle(
                          fontSize: 12,
                          color: prescription['active']
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                const Text(
                  'İlaçlar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...prescription['medications'].map<Widget>((medication) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${medication['name']} - ${medication['dose']} (${medication['duration']})',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabResultsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.science_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Laboratuvar sonuçları henüz eklenmedi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Sonuç Ekle'),
            onPressed: () {
              // Sonuç ekleme
            },
          ),
        ],
      ),
    );
  }
}
