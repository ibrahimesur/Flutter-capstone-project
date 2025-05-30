import 'package:flutter/material.dart';
import '../../../main.dart';

class HospitalInfoTab extends StatefulWidget {
  const HospitalInfoTab({super.key});

  @override
  State<HospitalInfoTab> createState() => _HospitalInfoTabState();
}

class _HospitalInfoTabState extends State<HospitalInfoTab> {
  // TODO: Backend'den hastane bilgilerini çek
  Map<String, dynamic> _hospitalInfo = {
    'name': 'Örnek Hastane',
    'address': 'Örnek Mah. Örnek Cad. No: 123',
    'phone': '+90 123 456 7890',
    'email': 'info@ornekhastane.com.tr',
    'website': 'www.ornekhastane.com.tr',
    'foundationYear': '2000',
    'capacity': {
      'beds': 500,
      'icuBeds': 50,
    },
    'staff': {
      'doctors': 150,
      'nurses': 300,
      'technicians': 100,
    },
    'departments': [
      'Acil Servis',
      'Kardiyoloji',
      'Nöroloji',
      'Ortopedi',
      'Dahiliye',
      'Genel Cerrahi',
    ],
    'statistics': {
      'dailyPatients': 1000,
      'monthlyOperations': 200,
    },
    'workingHours': {
      'weekdays': 'Pazartesi - Cuma: 08:00 - 17:00',
      'weekends': 'Cumartesi: 08:00 - 13:00, Pazar: Kapalı',
    },
    'insurances': [
      'SGK',
      'Özel Sigorta A',
      'Özel Sigorta B',
    ],
  };

  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _foundationYearController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _hospitalInfo['name']);
    _addressController = TextEditingController(text: _hospitalInfo['address']);
    _phoneController = TextEditingController(text: _hospitalInfo['phone']);
    _emailController = TextEditingController(text: _hospitalInfo['email']);
    _websiteController = TextEditingController(text: _hospitalInfo['website']);
    _foundationYearController =
        TextEditingController(text: _hospitalInfo['foundationYear']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _foundationYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildCapacitySection(),
            const SizedBox(height: 24),
            _buildStaffSection(),
            const SizedBox(height: 24),
            _buildDepartmentsSection(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
            const SizedBox(height: 24),
            _buildWorkingHoursSection(),
            const SizedBox(height: 24),
            _buildInsurancesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _isEditing ? 'Hastane Bilgilerini Düzenle' : 'Hastane Bilgileri',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        _isEditing
            ? Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _initializeControllers();
                      });
                    },
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveChanges,
                    child: const Text('Kaydet'),
                  ),
                ],
              )
            : ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Düzenle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HealthApp.primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: HealthApp.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Temel Bilgiler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _isEditing
                ? Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Hastane Adı',
                        ),
                      ),
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Adres',
                        ),
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefon',
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-posta',
                        ),
                      ),
                      TextField(
                        controller: _websiteController,
                        decoration: const InputDecoration(
                          labelText: 'Web Sitesi',
                        ),
                      ),
                      TextField(
                        controller: _foundationYearController,
                        decoration: const InputDecoration(
                          labelText: 'Kuruluş Yılı',
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Hastane Adı', _hospitalInfo['name']),
                      _buildInfoRow('Adres', _hospitalInfo['address']),
                      _buildInfoRow('Telefon', _hospitalInfo['phone']),
                      _buildInfoRow('E-posta', _hospitalInfo['email']),
                      _buildInfoRow('Web Sitesi', _hospitalInfo['website']),
                      _buildInfoRow(
                          'Kuruluş Yılı', _hospitalInfo['foundationYear']),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacitySection() {
    final capacity = _hospitalInfo['capacity'] as Map<String, dynamic>? ?? {};
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bed, color: HealthApp.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Kapasite',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityItem(
                    'Yatak Sayısı',
                    capacity['beds']?.toString() ?? 'N/A',
                    Icons.hotel,
                  ),
                ),
                Expanded(
                  child: _buildCapacityItem(
                    'Yoğun Bakım',
                    capacity['icuBeds']?.toString() ?? 'N/A',
                    Icons.monitor_heart,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityItem(
                    'Ameliyathane',
                    capacity['operatingRooms']?.toString() ?? 'N/A',
                    Icons.medical_services,
                  ),
                ),
                Expanded(
                  child: _buildCapacityItem(
                    'Acil Kapasite',
                    capacity['emergencyCapacity']?.toString() ?? 'N/A',
                    Icons.emergency,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffSection() {
    final staff = _hospitalInfo['staff'] as Map<String, dynamic>? ?? {};
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: HealthApp.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Personel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityItem(
                    'Doktor',
                    staff['doctors']?.toString() ?? 'N/A',
                    Icons.health_and_safety,
                  ),
                ),
                Expanded(
                  child: _buildCapacityItem(
                    'Hemşire',
                    staff['nurses']?.toString() ?? 'N/A',
                    Icons.favorite,
                  ),
                ),
                Expanded(
                  child: _buildCapacityItem(
                    'Teknisyen',
                    staff['technicians']?.toString() ?? 'N/A',
                    Icons.biotech,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityItem(
                    'İdari',
                    staff['administrative']?.toString() ?? 'N/A',
                    Icons.work,
                  ),
                ),
                Expanded(
                  child: _buildCapacityItem(
                    'Diğer',
                    staff['other']?.toString() ?? 'N/A',
                    Icons.group,
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentsSection() {
    final departments = _hospitalInfo['departments'] as List<dynamic>? ?? [];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: HealthApp.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Bölümler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: departments.map((department) {
                return Chip(
                  label: Text(department.toString()),
                  backgroundColor: HealthApp.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: HealthApp.primaryColor),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final stats = _hospitalInfo['statistics'] as Map<String, dynamic>? ?? {};
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: HealthApp.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'İstatistikler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Günlük Hasta',
                    stats['dailyPatients']?.toString() ?? 'N/A',
                    Icons.person,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Aylık Ameliyat',
                    stats['monthlyOperations']?.toString() ?? 'N/A',
                    Icons.medical_services,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Yatak Doluluk',
                    stats['bedOccupancyRate']?.toString() ?? 'N/A',
                    Icons.hotel,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Günlük Acil',
                    stats['emergencyVisitsPerDay']?.toString() ?? 'N/A',
                    Icons.emergency,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHoursSection() {
    final hours = _hospitalInfo['workingHours'] as Map<String, dynamic>? ?? {};
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: HealthApp.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Çalışma Saatleri (Meslek Bazlı)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildWorkingHoursRow(
                'Doktorlar', hours['doktor'] ?? 'N/A', Icons.medical_services),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildWorkingHoursRow(
                'Hemşireler', hours['hemşire'] ?? 'N/A', Icons.healing),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildWorkingHoursRow(
                'Teknisyenler', hours['teknisyen'] ?? 'N/A', Icons.biotech),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildWorkingHoursRow('İdari Personel',
                hours['idari_personel'] ?? 'N/A', Icons.business_center),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildWorkingHoursRow('Temizlik Personeli',
                hours['temizlik'] ?? 'N/A', Icons.cleaning_services),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildWorkingHoursRow(
                'Güvenlik', hours['güvenlik'] ?? 'N/A', Icons.security),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _buildWorkingHoursRow(
                'Acil Servis', hours['acil_servis'] ?? 'N/A', Icons.emergency,
                isHighlighted: true),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHoursRow(String position, String hours, IconData icon,
      {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Icon(icon,
              color: isHighlighted ? Colors.red : HealthApp.primaryColor,
              size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hours,
                  style: TextStyle(
                    color: isHighlighted ? Colors.red : Colors.black87,
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsurancesSection() {
    final insurances = _hospitalInfo['insurances'] as List<dynamic>? ?? [];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: HealthApp.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Anlaşmalı Kurumlar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: insurances.map((insurance) {
                return Chip(
                  label: Text(insurance.toString()),
                  backgroundColor: Colors.green.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.green),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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

  Widget _buildCapacityItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: HealthApp.primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HealthApp.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: HealthApp.primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    setState(() {
      _hospitalInfo['name'] = _nameController.text;
      _hospitalInfo['address'] = _addressController.text;
      _hospitalInfo['phone'] = _phoneController.text;
      _hospitalInfo['email'] = _emailController.text;
      _hospitalInfo['website'] = _websiteController.text;
      _hospitalInfo['foundationYear'] = _foundationYearController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hastane bilgileri güncellendi'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
