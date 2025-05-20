import 'package:flutter/material.dart';
import '../../main.dart';
import 'components/floor_plan_tab.dart';
import 'components/staff_tab.dart';
import 'components/hospital_info_tab.dart';

class HospitalPanelScreen extends StatefulWidget {
  const HospitalPanelScreen({super.key});

  @override
  State<HospitalPanelScreen> createState() => _HospitalPanelScreenState();
}

class _HospitalPanelScreenState extends State<HospitalPanelScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    StaffTab(),
    HospitalInfoTab(),
    FloorPlanTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastane Yönetim Paneli'),
        backgroundColor: HealthApp.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Bildirimler
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Personel',
          ),
          NavigationDestination(
            icon: Icon(Icons.info),
            label: 'Hastane Bilgisi',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Kat Planı',
          ),
        ],
      ),
    );
  }
} 