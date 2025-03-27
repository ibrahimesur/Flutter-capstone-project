import 'package:flutter/material.dart';
import '../../main.dart';

class DoctorAppointmentsPage extends StatelessWidget {
  final List<Map<String, dynamic>> appointments = [
    {
      'patientName': 'Ayşe Yılmaz',
      'date': '15 Mart 2024',
      'time': '09:30',
      'reason': 'Kontrol',
      'status': 'Onaylandı',
      'department': 'Dahiliye',
      'notes': 'Kan tahlili sonuçlarıyla gelecek',
    },
    {
      'patientName': 'Mehmet Demir',
      'date': '15 Mart 2024',
      'time': '10:00',
      'reason': 'İlk Muayene',
      'status': 'Beklemede',
      'department': 'Dahiliye',
      'notes': 'Yüksek tansiyon şikayeti',
    },
    // Daha fazla randevu eklenebilir
  ];

  const DoctorAppointmentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Bugünkü Randevular'),
              Tab(text: 'Gelecek Randevular'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAppointmentsList(context, appointments),
                _buildAppointmentsList(context, []), // Gelecek randevular
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context, List<Map<String, dynamic>> appointments) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(appointment['patientName']),
            subtitle: Text('${appointment['time']} - ${appointment['status']}'),
            leading: CircleAvatar(
              backgroundColor: HealthApp.primaryColor,
              child: Text(appointment['patientName'][0]),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Bölüm', appointment['department']),
                    _buildInfoRow('Sebep', appointment['reason']),
                    _buildInfoRow('Notlar', appointment['notes']),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Onayla'),
                          onPressed: () {},
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit_note),
                          label: const Text('Not Ekle'),
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 