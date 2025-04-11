import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/department.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<Department> departments = [
    Department(
      id: 'urology',
      name: 'Üroloji',
      description: 'Üriner sistem ve erkek üreme sistemi hastalıkları',
      doctors: [
        'Prof. Dr. Burak Buz',
        'Doç. Dr. Mehmet Yılmaz',
        'Uzm. Dr. Ayşe Kaya'
      ],
      icon: 'medical_services',
      specialties: [
        'Prostat Hastalıkları',
        'Böbrek Taşı',
        'Mesane Hastalıkları',
        'Erkek Kısırlığı',
        'Ürolojik Onkoloji',
        'Taş Hastalıkları'
      ],
    ),
    Department(
      id: 'cardiology',
      name: 'Kardiyoloji',
      description: 'Kalp ve damar hastalıkları',
      doctors: ['Prof. Dr. Ayşe Demir', 'Uzm. Dr. Ali Yıldız'],
      icon: 'assets/icons/cardiology.png',
    ),
    Department(
      id: 'internal_medicine',
      name: 'İç Hastalıkları',
      description: 'Dahiliye ve metabolik hastalıklar',
      doctors: ['Prof. Dr. Zeynep Kaya', 'Uzm. Dr. Ahmet Şahin'],
      icon: 'assets/icons/internal.png',
    ),
    Department(
      id: 'neurology',
      name: 'Nöroloji',
      description: 'Sinir sistemi hastalıkları',
      doctors: ['Prof. Dr. Can Özkan', 'Doç. Dr. Elif Yılmaz'],
      icon: 'assets/icons/neurology.png',
    ),
    Department(
      id: 'orthopedics',
      name: 'Ortopedi',
      description: 'Kas ve iskelet sistemi hastalıkları',
      doctors: ['Prof. Dr. Murat Demir', 'Uzm. Dr. Seda Arslan'],
      icon: 'assets/icons/orthopedics.png',
    ),
    Department(
      id: 'dermatology',
      name: 'Dermatoloji',
      description: 'Cilt hastalıkları',
      doctors: ['Prof. Dr. Deniz Yıldırım', 'Doç. Dr. Aylin Kara'],
      icon: 'assets/icons/dermatology.png',
    ),
  ];

  Department? selectedDepartment;
  String? selectedDoctor;
  DateTime? selectedDate;
  String? selectedTime;

  final List<String> availableHours = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30'
  ];

  @override
  void initState() {
    super.initState();
    selectedDepartment = departments.firstWhere((dept) => dept.id == 'urology');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Al'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bölüm Seçiniz',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HealthApp.accentColor,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final department = departments[index];
                final isSelected = selectedDepartment?.id == department.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: isSelected ? 4 : 1,
                  color: isSelected ? HealthApp.primaryColor : Colors.white,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        selectedDepartment = department;
                        selectedDoctor = null;
                      });
                    },
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? HealthApp.accentColor
                          : HealthApp.primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.medical_services,
                        color:
                            isSelected ? Colors.white : HealthApp.accentColor,
                      ),
                    ),
                    title: Text(
                      department.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      department.description,
                      style: TextStyle(
                        color: isSelected ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              },
            ),
            if (selectedDepartment != null) ...[
              const SizedBox(height: 24),
              _buildDoctorSelection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doktor Seçiniz',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: HealthApp.accentColor,
          ),
        ),
        const SizedBox(height: 16),
        ...selectedDepartment!.doctors.map((doctor) {
          final isMainDoctor = doctor == 'Prof. Dr. Burak Buz';
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: isMainDoctor ? 4 : 1,
            child: ExpansionTile(
              initiallyExpanded: isMainDoctor,
              leading: CircleAvatar(
                backgroundColor: isMainDoctor
                    ? HealthApp.accentColor
                    : HealthApp.primaryColor,
                child: Text(
                  doctor.split(' ').last[0],
                  style: TextStyle(
                    color: isMainDoctor
                        ? HealthApp.primaryColor
                        : HealthApp.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                doctor,
                style: TextStyle(
                  fontWeight:
                      isMainDoctor ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                isMainDoctor
                    ? 'Üroloji Uzmanı - 20 Yıl Deneyim - Bölüm Başkanı'
                    : '${selectedDepartment!.name} Uzmanı',
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMainDoctor) ...[
                        const Text(
                          'Uzmanlık Alanları:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedDepartment!.specialties
                              .map(
                                (specialty) => Chip(
                                  label: Text(specialty),
                                  backgroundColor:
                                      HealthApp.primaryColor.withOpacity(0.2),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Çalışma Saatleri:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Pazartesi - Cuma: 09:00 - 17:00'),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Randevu Al'),
                              onPressed: () {
                                setState(() {
                                  selectedDoctor = doctor;
                                  _showDateTimePicker(context);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor:
                                    isMainDoctor ? HealthApp.accentColor : null,
                                foregroundColor:
                                    isMainDoctor ? Colors.white : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (selectedDoctor != null && selectedDate != null) ...[
          const SizedBox(height: 24),
          _buildTimeSelection(),
          const SizedBox(height: 24),
          _buildSelectedAppointmentInfo(),
        ],
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Uygun Saatler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: HealthApp.accentColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableHours
              .map(
                (time) => ChoiceChip(
                  label: Text(time),
                  selected: selectedTime == time,
                  onSelected: (selected) {
                    setState(() {
                      selectedTime = selected ? time : null;
                    });
                  },
                  selectedColor: HealthApp.primaryColor,
                  backgroundColor: Colors.grey[200],
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedAppointmentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seçilen Randevu Bilgileri',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: HealthApp.accentColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Bölüm:', selectedDepartment!.name),
            _buildInfoRow('Doktor:', selectedDoctor!),
            if (selectedDate != null)
              _buildInfoRow('Tarih:', _formatDate(selectedDate!)),
            if (selectedTime != null) _buildInfoRow('Saat:', selectedTime!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmAppointment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Randevuyu Onayla'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: HealthApp.primaryColor,
              onPrimary: HealthApp.accentColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
      _showTimePicker(context);
    }
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: HealthApp.primaryColor,
              onPrimary: HealthApp.accentColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _confirmAppointment() {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen randevu tarih ve saatini seçiniz.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Randevu Onayı'),
        content: Text(
            'Randevunuz ${_formatDate(selectedDate!)} tarihinde saat $selectedTime\'de ${selectedDoctor!} ile onaylanacaktır. Onaylıyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Randevunuz başarıyla oluşturuldu!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Burada randevu kayıt işlemleri yapılabilir
            },
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
  }
}
