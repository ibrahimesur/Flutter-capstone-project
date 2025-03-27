import 'package:flutter/material.dart';
import '../../main.dart';

class Doctor {
  final String name;
  final String title;
  final String specialty;
  final String imageUrl;

  const Doctor({
    required this.name,
    required this.title,
    required this.specialty,
    this.imageUrl = 'assets/images/doctor_placeholder.png',
  });
}

class DoctorDashboard extends StatelessWidget {
  final List<Doctor> doctors = const [
    Doctor(
      name: 'Burak Buz',
      title: 'Prof. Dr.',
      specialty: 'Üroloji',
    ),
    // Diğer doktorlar buraya eklenebilir
  ];

  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doktorlarımız'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: HealthApp.primaryColor,
                child: Text(
                  doctor.name[0],
                  style: const TextStyle(
                    color: HealthApp.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                '${doctor.title} ${doctor.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                doctor.specialty,
                style: const TextStyle(
                  color: HealthApp.accentColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
