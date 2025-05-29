import 'package:flutter/material.dart';
import '../models/randevu.dart';

class RandevuScreen extends StatefulWidget {
  const RandevuScreen({super.key});

  @override
  _RandevuScreenState createState() => _RandevuScreenState();
}

class _RandevuScreenState extends State<RandevuScreen> {
  String? secilenBolum;
  String? secilenDoktor;
  DateTime? secilenTarih;
  String? secilenSaat;

  // TODO: Backend'den bölümleri çek
  final List<String> bolumler = [];
  // TODO: Backend'den seçilen doktor ve tarihe göre müsait saatleri çek
  final List<String> saatler = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Bölüm Seçiniz'),
            value: secilenBolum,
            items: bolumler.map((bolum) {
              return DropdownMenuItem(
                value: bolum,
                child: Text(bolum),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                secilenBolum = value;
                secilenDoktor = null;
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final DateTime? tarih = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
              );
              if (tarih != null) {
                setState(() {
                  secilenTarih = tarih;
                });
              }
            },
            child: Text('Tarih Seçiniz'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Randevu kaydetme işlemi
            },
            child: Text('Randevu Oluştur'),
          ),
        ],
      ),
    );
  }
}
