import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';

class StaffTab extends StatefulWidget {
  const StaffTab({super.key});

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  // TODO: Backend'den personel verilerini çek
  final List<Map<String, dynamic>> _staffList = [];

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
    fetchDoctors();
    _filteredStaffList = [..._staffList];
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/list-doctors'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _staffList.clear();
          _staffList.addAll(data.map((doctor) => {
            'id': doctor['doctor_id'].toString(),
            'name': doctor['name'] ?? '',
            'position': 'Doktor',
            'department': doctor['department'] ?? '',
            'phone': '+90 5XX XXX XX XX', // Backend'den gelmiyor, örnek
            'email': doctor['institutional_id'] ?? '',
            'status': 'Aktif', // Backend'den gelmiyor, örnek
            'joinDate': '',
            'schedule': '',
            'specialization': '',
          }));
          _filterStaff();
        });
      } else {
        print('Doktorlar çekilemedi: \\${response.statusCode}');
      }
    } catch (e) {
      print('Doktorlar çekilirken hata oluştu: \\${e.toString()}');
    }
  }

  void _filterStaff() {
    setState(() {
      _filteredStaffList = _staffList.where((staff) {
        // İsim veya pozisyona göre arama
        final nameMatches = staff['name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            staff['position']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        // Departman filtresi
        final departmentMatches = _selectedDepartment == 'Tümü' ||
            staff['department'] == _selectedDepartment;

        // Durum filtresi
        final statusMatches =
            _selectedStatus == 'Tümü' || staff['status'] == _selectedStatus;

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
            _searchQuery.isEmpty &&
                    _selectedDepartment == 'Tümü' &&
                    _selectedStatus == 'Tümü'
                ? 'Henüz personel kaydı bulunmuyor'
                : 'Arama kriterlerine uygun personel bulunamadı',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty ||
              _selectedDepartment != 'Tümü' ||
              _selectedStatus != 'Tümü') ...[
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
          List<Map<String, dynamic>> departmentStaff =
              staffByDepartment[department]!;

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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
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
                            backgroundColor:
                                HealthApp.primaryColor.withOpacity(0.1),
                            child: Text(
                              staff['name']
                                  .toString()
                                  .split(' ')
                                  .map((e) => e[0])
                                  .join(''),
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
                                  Icon(Icons.phone,
                                      size: 14, color: Colors.grey[600]),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
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
                                onPressed: () =>
                                    _showStaffOptionsBottomSheet(staff),
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
                  staff['status'] == 'Aktif'
                      ? Icons.cancel
                      : Icons.check_circle,
                  color: staff['status'] == 'Aktif' ? Colors.red : Colors.green,
                ),
                title: Text(
                  staff['status'] == 'Aktif' ? 'Pasife Al' : 'Aktife Al',
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    staff['status'] =
                        staff['status'] == 'Aktif' ? 'Pasif' : 'Aktif';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${staff['name']} ${staff['status'] == 'Aktif' ? 'aktif' : 'pasif'} duruma alındı'),
                      backgroundColor: staff['status'] == 'Aktif'
                          ? Colors.green
                          : Colors.grey,
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
