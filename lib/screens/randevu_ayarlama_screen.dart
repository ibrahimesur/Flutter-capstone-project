import 'package:flutter/material.dart';
import '../services/randevu.dart';

class RandevuAyarlamaScreen extends StatefulWidget {
  final String department;
  const RandevuAyarlamaScreen({Key? key, required this.department})
      : super(key: key);

  @override
  State<RandevuAyarlamaScreen> createState() => _RandevuAyarlamaScreenState();
}

class _RandevuAyarlamaScreenState extends State<RandevuAyarlamaScreen> {
  String? selectedDepartment;
  String? selectedDoctor;
  DateTime? selectedDate;
  String? selectedTime;

  // Demo: Bölüm ve doktorlar
  final Map<String, List<String>> departmentDoctors = {
    'Psychiatry': ['Dr. Ayşe Yılmaz', 'Dr. Mehmet Demir'],
    'Otolaryngology': ['Dr. Selin Kaya', 'Dr. Barış Aksoy'],
    'Endocrinology': ['Dr. Ece Güneş', 'Dr. Cem Korkmaz'],
    'Urology': ['Dr. Bora Yıldız', 'Dr. Zeynep Şahin'],
    'Internal Medicine': ['Dr. Ahmet Yılmaz', 'Dr. Elif Kılıç'],
    'Pulmonology': ['Dr. Paul Pulmo', 'Dr. Selda Solunum'],
  };

  // Demo: Doktor ve uygun saatler
  final Map<String, List<String>> doctorTimes = {
    'Dr. Ayşe Yılmaz': ['09:00', '10:00', '14:00'],
    'Dr. Mehmet Demir': ['11:00', '15:00'],
    'Dr. Selin Kaya': ['09:30', '13:00'],
    'Dr. Barış Aksoy': ['10:30', '16:00'],
    'Dr. Ece Güneş': ['08:00', '12:00'],
    'Dr. Cem Korkmaz': ['09:00', '11:00', '17:00'],
    'Dr. Bora Yıldız': ['10:00', '14:30'],
    'Dr. Zeynep Şahin': ['13:00', '15:30'],
    'Dr. Ahmet Yılmaz': ['09:00', '10:30', '13:30'],
    'Dr. Elif Kılıç': ['11:00', '16:00'],
    'Dr. Paul Pulmo': ['09:00', '11:00', '15:00'],
    'Dr. Selda Solunum': ['10:00', '14:00'],
  };

  List<Randevu> globalRandevuList = [];

  @override
  void initState() {
    super.initState();
    // Eğer yönlendirilerek gelindiyse departmanı otomatik seç
    if (widget.department.isNotEmpty &&
        departmentDoctors.containsKey(widget.department)) {
      selectedDepartment = widget.department;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Randevu Ayarlama'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Randevu Bilgileri',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              // Bölüm seçimi
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Bölüm Seçiniz',
                  prefixIcon: Icon(Icons.local_hospital),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                items: departmentDoctors.keys
                    .map((dep) => DropdownMenuItem(
                          value: dep,
                          child: Text(dep),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedDepartment = val;
                    selectedDoctor = null;
                  });
                },
              ),
              SizedBox(height: 20),
              // Doktor seçimi
              DropdownButtonFormField<String>(
                value: selectedDoctor,
                decoration: InputDecoration(
                  labelText: 'Doktor Seçiniz',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                items: (selectedDepartment != null)
                    ? departmentDoctors[selectedDepartment]!
                        .map((doc) => DropdownMenuItem(
                              value: doc,
                              child: Text(doc),
                            ))
                        .toList()
                    : [],
                onChanged: (val) {
                  setState(() {
                    selectedDoctor = val;
                  });
                },
              ),
              SizedBox(height: 20),
              // Tarih ve saat seçimi
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.calendar_today),
                      label: Text(selectedDate == null
                          ? 'Tarih Seç'
                          : '${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}'),
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: now,
                          lastDate: now.add(Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2C3E50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.access_time),
                      label: Text(
                          selectedTime == null ? 'Saat Seç' : selectedTime!),
                      onPressed: (selectedDoctor == null)
                          ? null
                          : () async {
                              final times = doctorTimes[selectedDoctor] ?? [];
                              String? picked = await showDialog<String>(
                                context: context,
                                builder: (context) => SimpleDialog(
                                  title: Text('Uygun Saatler'),
                                  children: times
                                      .map((t) => SimpleDialogOption(
                                            child: Text(t),
                                            onPressed: () =>
                                                Navigator.pop(context, t),
                                          ))
                                      .toList(),
                                ),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedTime = picked;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2C3E50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(vertical: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              // Randevu Al butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (selectedDepartment != null &&
                          selectedDoctor != null &&
                          selectedDate != null &&
                          selectedTime != null)
                      ? () {
                          globalRandevuList.add(Randevu(
                            department: selectedDepartment!,
                            doctor: selectedDoctor!,
                            date: selectedDate!,
                            time: selectedTime!,
                          ));
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2C3E50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(vertical: 22),
                  ),
                  child: Text('Randevu Al',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
