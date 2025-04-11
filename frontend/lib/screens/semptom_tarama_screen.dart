import 'package:flutter/material.dart';
import '../services/semptom_service.dart';

class SemptomTaramaScreen extends StatefulWidget {
  const SemptomTaramaScreen({super.key});

  @override
  _SemptomTaramaScreenState createState() => _SemptomTaramaScreenState();
}

class _SemptomTaramaScreenState extends State<SemptomTaramaScreen> {
  List<String> secilenSemptomlar = [];
  final List<String> tumSemptomlar = [
    'Ateş',
    'Öksürük',
    'Baş ağrısı',
    'Mide bulantısı',
    'Halsizlik',
    'Kas ağrısı',
    'Boğaz ağrısı',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semptomlarınızı Seçiniz',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: tumSemptomlar.length,
              itemBuilder: (context, index) {
                final semptom = tumSemptomlar[index];
                return CheckboxListTile(
                  title: Text(semptom),
                  value: secilenSemptomlar.contains(semptom),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        secilenSemptomlar.add(semptom);
                      } else {
                        secilenSemptomlar.remove(semptom);
                      }
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // ML servisi ile hastalık tahmini
            },
            child: Text('Analiz Et'),
          ),
        ],
      ),
    );
  }
} 