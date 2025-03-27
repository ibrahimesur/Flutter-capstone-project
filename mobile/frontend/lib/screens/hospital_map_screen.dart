import 'package:flutter/material.dart';
import '../main.dart';

class FloorPlan {
  final String floorName;
  final String description;
  final List<String> departments;

  const FloorPlan({
    required this.floorName,
    required this.description,
    required this.departments,
  });
}

class HospitalMapScreen extends StatelessWidget {
  final List<FloorPlan> floors = const [
    FloorPlan(
      floorName: 'Zemin Kat',
      description: 'Ana Giriş ve Poliklinikler',
      departments: const [
        'Danışma',
        'Acil Servis',
        'Kan Alma',
        'Radyoloji',
        'Kafeterya',
      ],
    ),
    FloorPlan(
      floorName: '1. Kat',
      description: 'Poliklinikler',
      departments: const [
        'Üroloji',
        'Kardiyoloji',
        'Dahiliye',
        'Göz Hastalıkları',
      ],
    ),
    FloorPlan(
      floorName: '2. Kat',
      description: 'Ameliyathaneler ve Yoğun Bakım',
      departments: const [
        'Ameliyathane',
        'Yoğun Bakım Ünitesi',
        'Sterilizasyon',
      ],
    ),
  ];

  const HospitalMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastane Kat Planı'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: floors.length,
        itemBuilder: (context, index) {
          final floor = floors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text(
                floor.floorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: HealthApp.accentColor,
                ),
              ),
              subtitle: Text(
                floor.description,
                style: const TextStyle(fontSize: 12),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bölümler:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HealthApp.accentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: floor.departments.map((department) {
                          return Chip(
                            label: Text(department),
                            backgroundColor:
                                HealthApp.primaryColor.withOpacity(0.2),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
