import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class DoctorPatientsPage extends StatelessWidget {
  final List<Map<String, dynamic>> patients = [
    {
      'name': 'Ayşe Yılmaz',
      'age': 45,
      'lastVisit': '10 Mart 2024',
      'diagnosis': 'Hipertansiyon',
      'medications': ['Beloc 50mg', 'Coraspin 100mg'],
      'tests': [
        {
          'name': 'Kan Tahlili',
          'date': '10 Mart 2024',
          'status': 'Beklemede'
        },
        {
          'name': 'EKG',
          'date': '5 Mart 2024',
          'status': 'Tamamlandı'
        }
      ],
      'notes': 'Düzenli tansiyon takibi yapılıyor',
    },
    // Daha fazla hasta eklenebilir
  ];

  const DoctorPatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Hasta Ara...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(patient['name']),
                  subtitle: Text('Son ziyaret: ${patient['lastVisit']}'),
                  leading: CircleAvatar(
                    backgroundColor: HealthApp.primaryColor,
                    child: Text(patient['name'][0]),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection('Tanı', patient['diagnosis']),
                          _buildSection('İlaçlar', (patient['medications'] as List).join(', ')),
                          _buildTestsSection(patient['tests'] as List),
                          _buildSection('Notlar', patient['notes']),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.edit),
                                label: Text('Düzenle'),
                                onPressed: () {},
                              ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.medical_services),
                                label: Text('Reçete Yaz'),
                                onPressed: () {},
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
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: HealthApp.accentColor,
          ),
        ),
        SizedBox(height: 4),
        Text(content),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTestsSection(List tests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tahliller',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: HealthApp.accentColor,
          ),
        ),
        SizedBox(height: 4),
        ...tests.map((test) => Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${test['name']} (${test['date']})'),
              Chip(
                label: Text(
                  test['status'],
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: test['status'] == 'Beklemede'
                    ? Colors.orange[100]
                    : Colors.green[100],
              ),
            ],
          ),
        )),
        SizedBox(height: 16),
      ],
    );
  }
} 