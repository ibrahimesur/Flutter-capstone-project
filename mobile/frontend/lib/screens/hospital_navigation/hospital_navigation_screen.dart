import 'package:flutter/material.dart';
import '../../main.dart';

class HospitalNavigationScreen extends StatefulWidget {
  const HospitalNavigationScreen({Key? key}) : super(key: key);

  @override
  _HospitalNavigationScreenState createState() =>
      _HospitalNavigationScreenState();
}

class _HospitalNavigationScreenState extends State<HospitalNavigationScreen> {
  final List<String> _floors = [
    'Zemin Kat',
    '1. Kat',
    '2. Kat',
    '3. Kat',
    '4. Kat'
  ];
  String _selectedFloor = 'Zemin Kat';
  String? _selectedDepartment;
  String? _selectedDestination;
  String? _startingPoint;
  bool _showDirections = false;

  // Katlardaki bölümler (örnek veri)
  final Map<String, List<String>> _departments = {
    'Zemin Kat': [
      'Ana Giriş',
      'Acil Servis',
      'Bilgi Masası',
      'Eczane',
      'Kafeterya'
    ],
    '1. Kat': [
      'Radyoloji',
      'Laboratuvar',
      'Nöroloji',
      'Dahiliye',
      'Kardiyoloji'
    ],
    '2. Kat': [
      'Göz Hastalıkları',
      'Kulak Burun Boğaz',
      'Cildiye',
      'Ortopedi',
      'Fizik Tedavi'
    ],
    '3. Kat': ['Genel Cerrahi', 'Üroloji', 'Kadın Doğum', 'Plastik Cerrahi'],
    '4. Kat': ['Yönetim', 'Toplantı Salonları', 'Yatan Hasta Servisi'],
  };

  // Önemli noktalar (örnek veri)
  final List<String> _points = [
    'Ana Giriş',
    'Asansörler',
    'Acil Çıkış',
    'Tuvalet',
    'Bekleme Alanı'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastane İçi Navigasyon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body:
          _showDirections ? _buildDirectionsView() : _buildNavigationSelector(),
    );
  }

  Widget _buildNavigationSelector() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          const Text(
            'Kat Seçin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildFloorSelector(),
          const SizedBox(height: 24),
          const Text(
            'Gitmek İstediğiniz Bölüm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildDepartmentSelector(),
          const SizedBox(height: 24),
          const Text(
            'Başlangıç Noktası',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildStartingPointSelector(),
          const SizedBox(height: 32),
          _buildNavigateButton(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: HealthApp.accentColor,
                  size: 28,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hastane İçi Yol Tarifi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Hastane içinde gitmek istediğiniz bölüme kolayca ulaşmak için, lütfen aşağıdaki bilgileri doldurun.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorSelector() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _floors.length,
        itemBuilder: (context, index) {
          final floor = _floors[index];
          final isSelected = floor == _selectedFloor;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFloor = floor;
                  _selectedDepartment = null;
                });
              },
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  color: isSelected ? HealthApp.primaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: Text(
                  floor,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepartmentSelector() {
    final departments = _departments[_selectedFloor] ?? [];

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: departments.map((department) {
        final isSelected = department == _selectedDepartment;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDepartment = department;
              _selectedDestination = department;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? HealthApp.accentColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? HealthApp.accentColor : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Text(
              department,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStartingPointSelector() {
    return Column(
      children: [
        // Mevcut konum seçimi
        InkWell(
          onTap: () {
            setState(() {
              _startingPoint = 'Mevcut Konum';
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _startingPoint == 'Mevcut Konum'
                  ? HealthApp.primaryColor.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _startingPoint == 'Mevcut Konum'
                    ? HealthApp.primaryColor
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.my_location,
                  color: HealthApp.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Mevcut Konumum',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Radio<String>(
                  value: 'Mevcut Konum',
                  groupValue: _startingPoint,
                  onChanged: (value) {
                    setState(() {
                      _startingPoint = value;
                    });
                  },
                  activeColor: HealthApp.accentColor,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Önemli noktalar seçimi
        const Text(
          'Veya bir başlangıç noktası seçin:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(_points.length, (index) {
          final point = _points[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _startingPoint = point;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _startingPoint == point
                      ? HealthApp.primaryColor.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _startingPoint == point
                        ? HealthApp.primaryColor
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getIconForPoint(point),
                      color: Colors.grey[700],
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Radio<String>(
                      value: point,
                      groupValue: _startingPoint,
                      onChanged: (value) {
                        setState(() {
                          _startingPoint = value;
                        });
                      },
                      activeColor: HealthApp.accentColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  IconData _getIconForPoint(String point) {
    switch (point) {
      case 'Ana Giriş':
        return Icons.door_front_door;
      case 'Asansörler':
        return Icons.elevator;
      case 'Acil Çıkış':
        return Icons.exit_to_app;
      case 'Tuvalet':
        return Icons.wc;
      case 'Bekleme Alanı':
        return Icons.weekend;
      default:
        return Icons.location_on;
    }
  }

  Widget _buildNavigateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_selectedDestination != null && _startingPoint != null)
            ? () {
                setState(() {
                  _showDirections = true;
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: HealthApp.accentColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Yol Tarifi Al',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionsView() {
    return Column(
      children: [
        Container(
          color: HealthApp.primaryColor.withOpacity(0.1),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yol Tarifi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: HealthApp.accentColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_startingPoint → $_selectedDestination',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Yeni'),
                    onPressed: () {
                      setState(() {
                        _showDirections = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: HealthApp.accentColor,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Aşağıdaki kat planını takip ederek hedefinize ulaşabilirsiniz.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Kat planı (Örnek gösterim)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Stack(
                        children: [
                          // Kat planı gösterimi (örnek olarak basit bir gösterim)
                          Center(
                            child: Text(
                              'Kat Planı: $_selectedFloor',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Örnek rota çizimi
                          CustomPaint(
                            size: Size.infinite,
                            painter: RoutePainter(),
                          ),

                          // Başlangıç noktası
                          Positioned(
                            left: 50,
                            top: 120,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue[700],
                                  size: 30,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Başlangıç',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bitiş noktası
                          Positioned(
                            right: 80,
                            top: 80,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: Colors.red[700],
                                  size: 30,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red[700],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _selectedDestination ?? 'Hedef',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Ara noktalar
                          Positioned(
                            left: 200,
                            top: 150,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Adım adım yönlendirmeler
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Adım Adım Yönlendirmeler',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: HealthApp.accentColor,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Örnek yönlendirmeler
                          _buildDirectionStep(
                            1,
                            _startingPoint == 'Mevcut Konum'
                                ? 'Bulunduğunuz konumdan çıkış yapın ve ana koridora girin.'
                                : '$_startingPoint noktasından başlayın.',
                            '10 metre',
                          ),
                          _buildDirectionStep(
                            2,
                            'Koridorda sağa dönün ve asansörlere doğru ilerleyin.',
                            '20 metre',
                          ),
                          _buildDirectionStep(
                            3,
                            '$_selectedFloor\'a çıkın.',
                            '',
                          ),
                          _buildDirectionStep(
                            4,
                            'Asansörden çıkıp, koridorda sola dönün.',
                            '5 metre',
                          ),
                          _buildDirectionStep(
                            5,
                            'Koridorda düz ilerleyin.',
                            '25 metre',
                          ),
                          _buildDirectionStep(
                            6,
                            '$_selectedDestination bölümüne ulaştınız.',
                            '',
                            isLast: true,
                          ),

                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Tahmini süre: 3 dakika',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.straighten,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Toplam mesafe: 60 metre',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildDirectionStep(int step, String instruction, String distance,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: HealthApp.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                instruction,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              if (distance.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    distance,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 20,
                  width: 2,
                  color: Colors.grey[300],
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hastane İçi Navigasyon Hakkında'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bu özellik, hastane içerisinde gitmek istediğiniz yere en kolay şekilde ulaşmanızı sağlamak için tasarlanmıştır.',
                ),
                SizedBox(height: 12),
                Text(
                  '• Önce gitmek istediğiniz katı seçin.',
                ),
                Text(
                  '• Sonra hedef departmanı veya noktayı belirleyin.',
                ),
                Text(
                  '• Şu an bulunduğunuz yeri veya başlangıç noktasını seçin.',
                ),
                Text(
                  '• "Yol Tarifi Al" butonuna tıklayarak adım adım yönlendirmeyi görüntüleyin.',
                ),
                SizedBox(height: 12),
                Text(
                  'Not: Konumunuzu daha doğru tespit etmek için, lütfen konum hizmetlerinizin açık olduğundan emin olun.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anladım'),
            ),
          ],
        );
      },
    );
  }
}

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HealthApp.accentColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(50, 120); // Başlangıç noktası
    path.lineTo(200, 150); // Ara nokta 1
    path.lineTo(size.width - 80, 80); // Bitiş noktası

    canvas.drawPath(path, paint);

    // Yol üzerine ok işaretleri
    final dashPaint = Paint()
      ..color = HealthApp.accentColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 3.0;

    double startX = 50;
    while (startX < size.width - 80) {
      canvas.drawLine(
        Offset(startX, 120 + (startX / 300) * 30),
        Offset(startX + dashWidth, 120 + ((startX + dashWidth) / 300) * 30),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
