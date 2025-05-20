import 'package:flutter/material.dart';
import '../../../main.dart';

class StaffTab extends StatefulWidget {
  const StaffTab({super.key});

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  // Örnek personel verileri
  final List<Map<String, dynamic>> _staffList = [
    {
      'id': '100345',
      'name': 'Dr. Mehmet Öz',
      'position': 'Kardiyoloji Uzmanı',
      'department': 'Kardiyoloji',
      'phone': '+90 532 123 4567',
      'email': 'mehmet.oz@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/male_doctor.png',
      'joinDate': '12 Ocak 2020',
      'schedule': 'Pazartesi-Cuma 09:00-17:00',
      'specialization': 'Kalp Cerrahisi',
    },
    {
      'id': '100346',
      'name': 'Hemş. Ayşe Yılmaz',
      'position': 'Başhemşire',
      'department': 'Dahiliye',
      'phone': '+90 532 234 5678',
      'email': 'ayse.yilmaz@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_nurse.png',
      'joinDate': '5 Şubat 2019',
      'schedule': 'Pazartesi-Cumartesi 08:00-16:00',
      'specialization': 'Yoğun Bakım',
    },
    {
      'id': '100347',
      'name': 'Dr. Zeynep Kaya',
      'position': 'Nöroloji Uzmanı',
      'department': 'Nöroloji',
      'phone': '+90 532 345 6789',
      'email': 'zeynep.kaya@hastane.com',
      'status': 'İzinli',
      'imageUrl': 'assets/images/staff/female_doctor.png',
      'joinDate': '20 Mart 2021',
      'schedule': 'Salı-Cumartesi 10:00-18:00',
      'specialization': 'Beyin ve Sinir Cerrahisi',
    },
    {
      'id': '100348',
      'name': 'Tek. Ahmet Demir',
      'position': 'Radyoloji Teknisyeni',
      'department': 'Radyoloji',
      'phone': '+90 532 456 7890',
      'email': 'ahmet.demir@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/male_technician.png',
      'joinDate': '15 Nisan 2022',
      'schedule': 'Pazartesi-Cuma 08:00-16:00',
      'specialization': 'MR ve Tomografi',
    },
    // Yeni eklenen personeller - Kardiyoloji
    {
      'id': '100349',
      'name': 'Dr. Emre Yıldız',
      'position': 'Kardiyoloji Uzmanı',
      'department': 'Kardiyoloji',
      'phone': '+90 533 567 8901',
      'email': 'emre.yildiz@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/male_doctor.png',
      'joinDate': '3 Haziran 2021',
      'schedule': 'Pazartesi-Cuma 09:00-17:00',
      'specialization': 'Aritmiler',
    },
    {
      'id': '100350',
      'name': 'Hemş. Deniz Şahin',
      'position': 'Kardiyoloji Hemşiresi',
      'department': 'Kardiyoloji',
      'phone': '+90 537 678 9012',
      'email': 'deniz.sahin@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_nurse.png',
      'joinDate': '10 Mayıs 2020',
      'schedule': 'Pazartesi-Cumartesi 08:00-16:00',
      'specialization': 'Kardiyak Bakım',
    },
    // Pediatri
    {
      'id': '100351',
      'name': 'Dr. Selin Aydın',
      'position': 'Pediatri Uzmanı',
      'department': 'Pediatri',
      'phone': '+90 535 789 0123',
      'email': 'selin.aydin@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_doctor.png',
      'joinDate': '5 Ocak 2018',
      'schedule': 'Salı-Cumartesi 09:00-17:00',
      'specialization': 'Çocuk Alerjisi',
    },
    {
      'id': '100352',
      'name': 'Dr. Kemal Tekin',
      'position': 'Pediatri Uzmanı',
      'department': 'Pediatri',
      'phone': '+90 538 890 1234',
      'email': 'kemal.tekin@hastane.com',
      'status': 'İzinli',
      'imageUrl': 'assets/images/staff/male_doctor.png',
      'joinDate': '20 Şubat 2019',
      'schedule': 'Pazartesi-Cuma 09:00-17:00',
      'specialization': 'Yenidoğan',
    },
    {
      'id': '100353',
      'name': 'Hemş. Ceyda Kartal',
      'position': 'Pediatri Hemşiresi',
      'department': 'Pediatri',
      'phone': '+90 536 901 2345',
      'email': 'ceyda.kartal@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_nurse.png',
      'joinDate': '15 Mart 2020',
      'schedule': 'Pazartesi-Cumartesi 08:00-16:00',
      'specialization': 'Çocuk Yoğun Bakım',
    },
    // Cerrahi
    {
      'id': '100354',
      'name': 'Dr. Ali Yılmaz',
      'position': 'Genel Cerrah',
      'department': 'Cerrahi',
      'phone': '+90 534 012 3456',
      'email': 'ali.yilmaz@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/male_doctor.png',
      'joinDate': '10 Nisan 2017',
      'schedule': 'Pazartesi-Cuma 09:00-18:00',
      'specialization': 'Mide-Bağırsak Cerrahisi',
    },
    {
      'id': '100355',
      'name': 'Dr. Banu Korkmaz',
      'position': 'Genel Cerrah',
      'department': 'Cerrahi',
      'phone': '+90 539 123 4567',
      'email': 'banu.korkmaz@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_doctor.png',
      'joinDate': '20 Mayıs 2018',
      'schedule': 'Salı-Cumartesi 08:30-17:30',
      'specialization': 'Meme Cerrahisi',
    },
    // Ortopedi
    {
      'id': '100356',
      'name': 'Dr. Serkan Demir',
      'position': 'Ortopedi Uzmanı',
      'department': 'Ortopedi',
      'phone': '+90 532 234 5678',
      'email': 'serkan.demir@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/male_doctor.png',
      'joinDate': '15 Haziran 2019',
      'schedule': 'Pazartesi-Cuma 09:00-17:00',
      'specialization': 'Spor Yaralanmaları',
    },
    {
      'id': '100357',
      'name': 'Fzt. Ece Öztürk',
      'position': 'Fizyoterapist',
      'department': 'Ortopedi',
      'phone': '+90 532 345 6789',
      'email': 'ece.ozturk@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_doctor.png',
      'joinDate': '1 Temmuz 2020',
      'schedule': 'Pazartesi-Cumartesi 09:00-17:00',
      'specialization': 'Kas İskelet Sistemi Rehabilitasyonu',
    },
    // Göz Hastalıkları
    {
      'id': '100358',
      'name': 'Dr. Melih Candan',
      'position': 'Göz Hastalıkları Uzmanı',
      'department': 'Göz Hastalıkları',
      'phone': '+90 532 456 7890',
      'email': 'melih.candan@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/male_doctor.png',
      'joinDate': '10 Ağustos 2021',
      'schedule': 'Pazartesi-Cuma 09:00-16:30',
      'specialization': 'Katarakt Cerrahisi',
    },
    // Yönetim
    {
      'id': '100359',
      'name': 'Murat Kaya',
      'position': 'Hastane Müdürü',
      'department': 'Yönetim',
      'phone': '+90 532 567 8901',
      'email': 'murat.kaya@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/male_admin.png',
      'joinDate': '5 Ocak 2015',
      'schedule': 'Pazartesi-Cuma 08:30-17:30',
      'specialization': 'Sağlık Yönetimi',
    },
    {
      'id': '100360',
      'name': 'Sevda Yıldırım',
      'position': 'İnsan Kaynakları Müdürü',
      'department': 'Yönetim',
      'phone': '+90 532 678 9012',
      'email': 'sevda.yildirim@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_admin.png',
      'joinDate': '3 Şubat 2017',
      'schedule': 'Pazartesi-Cuma 08:30-17:30',
      'specialization': 'İnsan Kaynakları Yönetimi',
    },
    // Laboratuvar
    {
      'id': '100361',
      'name': 'Dr. Leyla Yalçın',
      'position': 'Biyokimya Uzmanı',
      'department': 'Laboratuvar',
      'phone': '+90 532 789 0123',
      'email': 'leyla.yalcin@hastane.com',
      'status': 'Aktif',
      'imageUrl': 'assets/images/staff/female_doctor.png',
      'joinDate': '12 Mart 2018',
      'schedule': 'Pazartesi-Cuma 08:00-16:00',
      'specialization': 'Klinik Biyokimya',
    },
  ];

  List<Map<String, dynamic>> _filteredStaffList = [];
  String _searchQuery = '';
  String _selectedStatus = 'Tümü';
  String _selectedDepartment = 'Tümü';

  final List<String> _departments = [
    'Tümü',
    'Kardiyoloji',
    'Dahiliye',
    'Nöroloji',
    'Radyoloji',
    'Cerrahi',
    'Pediatri',
    'Ortopedi',
    'Göz Hastalıkları',
    'Laboratuvar',
    'Yönetim',
  ];

  final List<String> _statuses = [
    'Tümü',
    'Aktif',
    'İzinli',
    'Pasif',
  ];

  @override
  void initState() {
    super.initState();
    _filteredStaffList = [..._staffList];
  }

  void _filterStaff() {
    setState(() {
      _filteredStaffList = _staffList.where((staff) {
        // İsim veya pozisyona göre arama
        final nameMatches = staff['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            staff['position'].toString().toLowerCase().contains(_searchQuery.toLowerCase());

        // Departman filtresi
        final departmentMatches = _selectedDepartment == 'Tümü' ||
            staff['department'] == _selectedDepartment;

        // Durum filtresi
        final statusMatches = _selectedStatus == 'Tümü' ||
            staff['status'] == _selectedStatus;

        return nameMatches && departmentMatches && statusMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(
            child: _filteredStaffList.isEmpty
                ? _buildEmptyState()
                : _buildStaffList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStaffDialog,
        backgroundColor: HealthApp.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HealthApp.backgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Hastane Personeli',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {
              // PDF/Excel export işlemi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Personel listesi dışa aktarılıyor...'),
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Dışa Aktar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Personel ara...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterStaff();
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: InputDecoration(
                    labelText: 'Departman',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  items: _departments.map((department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value!;
                      _filterStaff();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Durum',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  items: _statuses.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                      _filterStaff();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty && _selectedDepartment == 'Tümü' && _selectedStatus == 'Tümü'
                ? 'Henüz personel kaydı bulunmuyor'
                : 'Arama kriterlerine uygun personel bulunamadı',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty || _selectedDepartment != 'Tümü' || _selectedStatus != 'Tümü') ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedDepartment = 'Tümü';
                  _selectedStatus = 'Tümü';
                  _filteredStaffList = [..._staffList];
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Filtreleri Temizle'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStaffList() {
    // Personelleri departmanlara göre gruplandır
    Map<String, List<Map<String, dynamic>>> staffByDepartment = {};
    
    for (var staff in _filteredStaffList) {
      String department = staff['department'] as String;
      if (!staffByDepartment.containsKey(department)) {
        staffByDepartment[department] = [];
      }
      staffByDepartment[department]!.add(staff);
    }
    
    // Eğer belirli bir departman seçilmişse sadece o departmanı göster
    if (_selectedDepartment != 'Tümü') {
      return _buildStaffByDepartment(_filteredStaffList);
    } else {
      // Tüm departmanları ayrı ayrı göster, ama daha güzel bir tasarımla
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: staffByDepartment.length,
        itemBuilder: (context, index) {
          String department = staffByDepartment.keys.elementAt(index);
          List<Map<String, dynamic>> departmentStaff = staffByDepartment[department]!;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Departman başlığı
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HealthApp.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        department,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${departmentStaff.length} Personel',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Departman personelleri
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: departmentStaff.length,
                  itemBuilder: (context, staffIndex) {
                    final staff = departmentStaff[staffIndex];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: HealthApp.primaryColor.withOpacity(0.1),
                            child: Text(
                              staff['name'].toString().split(' ').map((e) => e[0]).join(''),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: HealthApp.primaryColor,
                              ),
                            ),
                          ),
                          title: Text(
                            staff['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(staff['position']),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    staff['phone'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: staff['status'] == 'Aktif'
                                      ? Colors.green.withOpacity(0.2)
                                      : staff['status'] == 'İzinli'
                                          ? Colors.amber.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  staff['status'],
                                  style: TextStyle(
                                    color: staff['status'] == 'Aktif'
                                        ? Colors.green
                                        : staff['status'] == 'İzinli'
                                            ? Colors.amber[800]
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () => _showStaffOptionsBottomSheet(staff),
                              ),
                            ],
                          ),
                          onTap: () => _showStaffDetailsDialog(staff),
                        ),
                        if (staffIndex < departmentStaff.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
  
  Widget _buildStaffByDepartment(List<Map<String, dynamic>> staffList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: HealthApp.primaryColor.withOpacity(0.1),
              child: Text(
                staff['name'].toString().split(' ').map((e) => e[0]).join(''),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: HealthApp.primaryColor,
                ),
              ),
            ),
            title: Text(
              staff['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(staff['position']),
                const SizedBox(height: 4),
                Text(
                  staff['department'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: staff['status'] == 'Aktif'
                    ? Colors.green.withOpacity(0.2)
                    : staff['status'] == 'İzinli'
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                staff['status'],
                style: TextStyle(
                  color: staff['status'] == 'Aktif'
                      ? Colors.green
                      : staff['status'] == 'İzinli'
                          ? Colors.amber[800]
                          : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow('ID', staff['id']),
                    _buildInfoRow('Telefon', staff['phone']),
                    _buildInfoRow('E-posta', staff['email']),
                    _buildInfoRow('Başlangıç Tarihi', staff['joinDate']),
                    _buildInfoRow('Çalışma Saatleri', staff['schedule']),
                    _buildInfoRow('Uzmanlık', staff['specialization']),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => _showEditStaffDialog(staff),
                          icon: const Icon(Icons.edit),
                          label: const Text('Düzenle'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _showStaffDetailsDialog(staff),
                          icon: const Icon(Icons.visibility),
                          label: const Text('Detaylar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HealthApp.primaryColor,
                            foregroundColor: Colors.white,
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
      },
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

  void _showAddStaffDialog() {
    final nameController = TextEditingController();
    final positionController = TextEditingController();
    String selectedDepartment = _departments[1]; // İlk gerçek departman
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    String selectedStatus = 'Aktif';
    final scheduleController = TextEditingController();
    final specializationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Personel Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: 'Pozisyon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Departman',
                  border: OutlineInputBorder(),
                ),
                items: _departments.where((d) => d != 'Tümü').map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedDepartment = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Durum',
                  border: OutlineInputBorder(),
                ),
                items: _statuses.where((s) => s != 'Tümü').map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Çalışma Saatleri',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: specializationController,
                decoration: const InputDecoration(
                  labelText: 'Uzmanlık',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  positionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen gerekli alanları doldurun'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              setState(() {
                _staffList.add({
                  'id': '10${_staffList.length + 1000}',
                  'name': nameController.text,
                  'position': positionController.text,
                  'department': selectedDepartment,
                  'phone': phoneController.text.isEmpty
                      ? '+90 5XX XXX XX XX'
                      : phoneController.text,
                  'email': emailController.text.isEmpty
                      ? '${nameController.text.toLowerCase().replaceAll(' ', '.')}@hastane.com'
                      : emailController.text,
                  'status': selectedStatus,
                  'imageUrl': 'assets/images/staff/placeholder.png',
                  'joinDate':
                      '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                  'schedule': scheduleController.text.isEmpty
                      ? 'Pazartesi-Cuma 09:00-17:00'
                      : scheduleController.text,
                  'specialization': specializationController.text.isEmpty
                      ? '-'
                      : specializationController.text,
                });
                _filterStaff();
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Personel başarıyla eklendi'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HealthApp.primaryColor,
            ),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditStaffDialog(Map<String, dynamic> staff) {
    final nameController = TextEditingController(text: staff['name']);
    final positionController = TextEditingController(text: staff['position']);
    String selectedDepartment = staff['department'];
    final phoneController = TextEditingController(text: staff['phone']);
    final emailController = TextEditingController(text: staff['email']);
    String selectedStatus = staff['status'];
    final scheduleController = TextEditingController(text: staff['schedule']);
    final specializationController =
        TextEditingController(text: staff['specialization']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personel Bilgilerini Düzenle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                  labelText: 'Pozisyon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Departman',
                  border: OutlineInputBorder(),
                ),
                items: _departments.where((d) => d != 'Tümü').map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedDepartment = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Durum',
                  border: OutlineInputBorder(),
                ),
                items: _statuses.where((s) => s != 'Tümü').map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Çalışma Saatleri',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: specializationController,
                decoration: const InputDecoration(
                  labelText: 'Uzmanlık',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  positionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen gerekli alanları doldurun'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              setState(() {
                staff['name'] = nameController.text;
                staff['position'] = positionController.text;
                staff['department'] = selectedDepartment;
                staff['phone'] = phoneController.text;
                staff['email'] = emailController.text;
                staff['status'] = selectedStatus;
                staff['schedule'] = scheduleController.text;
                staff['specialization'] = specializationController.text;
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Personel bilgileri güncellendi'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HealthApp.primaryColor,
            ),
            child: const Text('Güncelle'),
          ),
        ],
      ),
    );
  }

  void _showStaffDetailsDialog(Map<String, dynamic> staff) {
    // Burada daha detaylı personel bilgileri gösterilecek
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(staff['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: HealthApp.primaryColor.withOpacity(0.1),
              child: Text(
                staff['name'].toString().split(' ').map((e) => e[0]).join(''),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: HealthApp.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('ID', staff['id']),
            _buildInfoRow('Pozisyon', staff['position']),
            _buildInfoRow('Departman', staff['department']),
            _buildInfoRow('Telefon', staff['phone']),
            _buildInfoRow('E-posta', staff['email']),
            _buildInfoRow('Durum', staff['status']),
            _buildInfoRow('Başlangıç Tarihi', staff['joinDate']),
            _buildInfoRow('Çalışma Saatleri', staff['schedule']),
            _buildInfoRow('Uzmanlık', staff['specialization']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void _showStaffOptionsBottomSheet(Map<String, dynamic> staff) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Detayları Görüntüle'),
                onTap: () {
                  Navigator.pop(context);
                  _showStaffDetailsDialog(staff);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Düzenle'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditStaffDialog(staff);
                },
              ),
              ListTile(
                leading: Icon(
                  staff['status'] == 'Aktif' ? Icons.cancel : Icons.check_circle,
                  color: staff['status'] == 'Aktif' ? Colors.red : Colors.green,
                ),
                title: Text(
                  staff['status'] == 'Aktif' ? 'Pasife Al' : 'Aktife Al',
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    staff['status'] = staff['status'] == 'Aktif' ? 'Pasif' : 'Aktif';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${staff['name']} ${staff['status'] == 'Aktif' ? 'aktif' : 'pasif'} duruma alındı'),
                      backgroundColor: staff['status'] == 'Aktif' ? Colors.green : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Statik ay isimleri fonksiyonu
String getMonthName(int month) {
  const monthNames = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık'
  ];
  return monthNames[month - 1];
} 