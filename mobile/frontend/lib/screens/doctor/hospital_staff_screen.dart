import 'package:flutter/material.dart';
import '../../models/hospital_staff.dart';
import '../../main.dart';

class HospitalStaffScreen extends StatefulWidget {
  const HospitalStaffScreen({super.key});

  @override
  _HospitalStaffScreenState createState() => _HospitalStaffScreenState();
}

class _HospitalStaffScreenState extends State<HospitalStaffScreen> {
  final List<HospitalStaff> staffList = [
    HospitalStaff(
      name: 'Burak Buz',
      title: 'Prof. Dr.',
      department: 'Üroloji',
      role: 'Doktor',
      staffId: 'DR001',
    ),
    HospitalStaff(
      name: 'Ayşe Yılmaz',
      title: 'Uzm. Dr.',
      department: 'Kardiyoloji',
      role: 'Doktor',
      staffId: 'DR002',
    ),
    HospitalStaff(
      name: 'Mehmet Demir',
      title: 'Hemşire',
      department: 'Acil Servis',
      role: 'Hemşire',
      staffId: 'NR001',
    ),
    // Daha fazla personel buraya eklenebilir
  ];

  String _searchQuery = '';
  String _selectedDepartment = 'Tümü';

  List<String> get departments {
    final deps = staffList.map((e) => e.department).toSet().toList();
    deps.insert(0, 'Tümü');
    return deps;
  }

  List<HospitalStaff> get filteredStaff {
    return staffList.where((staff) {
      final matchesSearch = staff.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          staff.department.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDepartment = _selectedDepartment == 'Tümü' ||
          staff.department == _selectedDepartment;
      return matchesSearch && matchesDepartment;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastane Personeli'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Personel Ara...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: const InputDecoration(
                    labelText: 'Departman',
                  ),
                  items: departments.map((department) {
                    return DropdownMenuItem(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStaff.length,
              itemBuilder: (context, index) {
                final staff = filteredStaff[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: HealthApp.primaryColor,
                      child: Text(
                        staff.name[0],
                        style: const TextStyle(
                          color: HealthApp.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${staff.title} ${staff.name}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(staff.department),
                        Text(
                          'Personel ID: ${staff.staffId}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(staff.role),
                      backgroundColor: HealthApp.primaryColor.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
