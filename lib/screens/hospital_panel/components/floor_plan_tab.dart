import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../../main.dart';

class FloorPlanTab extends StatefulWidget {
  const FloorPlanTab({super.key});

  @override
  State<FloorPlanTab> createState() => _FloorPlanTabState();
}

class _FloorPlanTabState extends State<FloorPlanTab> {
  // TODO: Backend'den kat planı verilerini çek
  final List<Map<String, dynamic>> _floorPlans = [
    {
      'name': '1. Kat Planı',
      'description': '1. katın genel planı',
      'lastUpdated': '1 Haziran 2024',
      'image': '', // Görsel yok, placeholder gösterilecek
      'isActive': true,
    },
    {
      'name': '2. Kat Planı',
      'description': '2. katın genel planı',
      'lastUpdated': '1 Haziran 2024',
      'image': '',
      'isActive': false,
    },
  ];

  String? _selectedFloor;
  Map<String, dynamic>? _currentFloorPlan;

  int _selectedFloorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _floorPlans.isEmpty
                ? _buildEmptyState()
                : Row(
                    children: [
                      _buildFloorList(),
                      Expanded(child: _buildFloorPlanView()),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadNewFloorPlan,
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
            'Hastane Kat Planları',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: _downloadCurrentPlan,
            icon: const Icon(Icons.download),
            label: const Text('İndir'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _printCurrentPlan,
            icon: const Icon(Icons.print),
            label: const Text('Yazdır'),
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
          Icon(Icons.map, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Henüz kat planı yüklenmemiş',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _uploadNewFloorPlan,
            icon: const Icon(Icons.upload_file),
            label: const Text('Kat Planı Yükle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HealthApp.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorList() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Kat ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _floorPlans.length,
              itemBuilder: (context, index) {
                final floorPlan = _floorPlans[index];
                final bool isSelected = index == _selectedFloorIndex;
                final bool isActive = floorPlan['isActive'] as bool;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  selected: isSelected,
                  selectedTileColor: HealthApp.primaryColor.withOpacity(0.1),
                  onTap: () {
                    setState(() {
                      _selectedFloorIndex = index;
                    });
                  },
                  leading: CircleAvatar(
                    backgroundColor: isActive
                        ? HealthApp.primaryColor
                        : Colors.grey[400],
                    child: Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    floorPlan['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(floorPlan['description'] as String),
                      const SizedBox(height: 4),
                      Text(
                        'Güncelleme: ${floorPlan['lastUpdated']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: isActive
                      ? const Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 12,
                        )
                      : const Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 12,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorPlanView() {
    if (_floorPlans.isEmpty || _selectedFloorIndex >= _floorPlans.length) {
      return const Center(
        child: Text('Kat planı bulunamadı.'),
      );
    }

    final floorPlan = _floorPlans[_selectedFloorIndex];
    final imagePath = floorPlan['image'] as String;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      floorPlan['name'] as String,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      floorPlan['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Düzenle',
                onPressed: () => _editFloorPlan(floorPlan),
              ),
              Switch(
                value: floorPlan['isActive'] as bool,
                onChanged: (value) {
                  setState(() {
                    floorPlan['isActive'] = value;
                  });
                },
                activeColor: HealthApp.primaryColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Placeholder for the floor plan image
                Center(
                  child: imagePath.startsWith('assets')
                      ? Image.asset(
                          'assets/images/floor_plan_placeholder.png',
                          fit: BoxFit.contain,
                        )
                      : imagePath.startsWith('file://')
                          ? Image.file(
                              File(imagePath.replaceFirst('file://', '')),
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey[400],
                            ),
                ),
                // Plan interaction overlay
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _uploadNewFloorPlan() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        // Show dialog to get floor details
        _showAddFloorPlanDialog(result.files.single.path!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dosya yükleme hatası: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddFloorPlanDialog(String imagePath) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Kat Planı Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Kat Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen kat adı girin'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              setState(() {
                _floorPlans.add({
                  'name': nameController.text,
                  'description':
                      descController.text.isEmpty ? '-' : descController.text,
                  'lastUpdated':
                      '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                  'image': 'file://$imagePath',
                  'isActive': true,
                });
                _selectedFloorIndex = _floorPlans.length - 1;
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kat planı başarıyla eklendi'),
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

  void _editFloorPlan(Map<String, dynamic> floorPlan) {
    final TextEditingController nameController =
        TextEditingController(text: floorPlan['name'] as String);
    final TextEditingController descController =
        TextEditingController(text: floorPlan['description'] as String);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kat Planını Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Kat Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen kat adı girin'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              setState(() {
                floorPlan['name'] = nameController.text;
                floorPlan['description'] = descController.text;
                floorPlan['lastUpdated'] =
                    '${DateTime.now().day} ${getMonthName(DateTime.now().month)} ${DateTime.now().year}';
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kat planı başarıyla güncellendi'),
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

  void _downloadCurrentPlan() {
    if (_floorPlans.isEmpty || _selectedFloorIndex >= _floorPlans.length) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kat planı indiriliyor...'),
      ),
    );

    // İndirme işlemi gerçekte backend ile olacak
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kat planı başarıyla indirildi'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _printCurrentPlan() {
    if (_floorPlans.isEmpty || _selectedFloorIndex >= _floorPlans.length) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kat planı yazdırılıyor...'),
      ),
    );

    // Yazdırma işlemi gerçekte bir yazdırma API'si ile olacak
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kat planı yazdırma işlemi başlatıldı'),
          backgroundColor: Colors.green,
        ),
      );
    });
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