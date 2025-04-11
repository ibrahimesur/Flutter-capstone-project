import 'package:flutter/material.dart';
import '../../main.dart';

class SymptomAnalysisScreen extends StatefulWidget {
  const SymptomAnalysisScreen({Key? key}) : super(key: key);

  @override
  _SymptomAnalysisScreenState createState() => _SymptomAnalysisScreenState();
}

class _SymptomAnalysisScreenState extends State<SymptomAnalysisScreen> {
  final List<String> _bodyParts = [
    'Baş',
    'Boyun',
    'Göğüs',
    'Karın',
    'Sırt',
    'Kollar',
    'Bacaklar'
  ];

  final Map<String, List<String>> _symptoms = {
    'Baş': [
      'Baş ağrısı',
      'Baş dönmesi',
      'Görme bulanıklığı',
      'Kulak çınlaması',
      'Burun tıkanıklığı'
    ],
    'Boyun': [
      'Boyun ağrısı',
      'Yutma güçlüğü',
      'Boyunda şişlik',
      'Boyun tutulması'
    ],
    'Göğüs': [
      'Göğüs ağrısı',
      'Nefes darlığı',
      'Çarpıntı',
      'Öksürük',
      'Hırıltılı solunum'
    ],
    'Karın': [
      'Karın ağrısı',
      'Bulantı',
      'Kusma',
      'İshal',
      'Kabızlık',
      'Şişkinlik'
    ],
    'Sırt': ['Sırt ağrısı', 'Bel ağrısı', 'Omurga ağrısı'],
    'Kollar': [
      'Kol ağrısı',
      'Eklem ağrısı',
      'Uyuşma',
      'Karıncalanma',
      'Kas güçsüzlüğü'
    ],
    'Bacaklar': ['Bacak ağrısı', 'Ayak ağrısı', 'Şişlik', 'Uyuşma', 'Kramp'],
  };

  String _selectedBodyPart = 'Baş';
  final List<String> _selectedSymptoms = [];
  bool _isAnalyzing = false;
  List<Map<String, dynamic>>? _analysisResults;

  // Hastalık - semptom ilişkileri (örnek veri)
  final Map<String, List<String>> _diseaseSymptoms = {
    'Migren': ['Baş ağrısı', 'Baş dönmesi', 'Görme bulanıklığı', 'Bulantı'],
    'Grip': [
      'Baş ağrısı',
      'Öksürük',
      'Nefes darlığı',
      'Ateş',
      'Burun tıkanıklığı'
    ],
    'Sinüzit': ['Baş ağrısı', 'Burun tıkanıklığı', 'Yüz ağrısı'],
    'Bel Fıtığı': ['Bel ağrısı', 'Bacak ağrısı', 'Uyuşma', 'Karıncalanma'],
    'Gastrit': ['Karın ağrısı', 'Bulantı', 'Şişkinlik', 'Hazımsızlık'],
    'Boyun Fıtığı': ['Boyun ağrısı', 'Kol ağrısı', 'Uyuşma', 'Boyun tutulması'],
    'Kalp Krizi': ['Göğüs ağrısı', 'Nefes darlığı', 'Çarpıntı', 'Terleme'],
    'Anksiyete': ['Çarpıntı', 'Nefes darlığı', 'Terleme', 'Baş dönmesi'],
  };

  void _analyzeSymptoms() {
    if (_selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir semptom seçin')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    // Analiz simülasyonu
    Future.delayed(const Duration(seconds: 2), () {
      final results = <Map<String, dynamic>>[];

      _diseaseSymptoms.forEach((disease, symptoms) {
        int matchCount = 0;
        for (var symptom in _selectedSymptoms) {
          if (symptoms.contains(symptom)) {
            matchCount++;
          }
        }

        if (matchCount > 0) {
          final matchPercentage = (matchCount / symptoms.length) * 100;
          if (matchPercentage >= 30) {
            // En az %30 eşleşme olsun
            results.add({
              'disease': disease,
              'matchPercentage': matchPercentage,
              'matchedSymptoms':
                  _selectedSymptoms.where((s) => symptoms.contains(s)).toList(),
              'totalSymptoms': symptoms,
            });
          }
        }
      });

      results
          .sort((a, b) => b['matchPercentage'].compareTo(a['matchPercentage']));

      setState(() {
        _analysisResults = results;
        _isAnalyzing = false;
      });
    });
  }

  void _resetAnalysis() {
    setState(() {
      _selectedSymptoms.clear();
      _analysisResults = null;
    });
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semptom Analizi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetAnalysis,
          ),
        ],
      ),
      body: _analysisResults != null
          ? _buildResultsView()
          : Column(
              children: [
                _buildBodyPartSelector(),
                Expanded(
                  child: _buildSymptomList(),
                ),
                _buildSelectedSymptoms(),
                _buildAnalyzeButton(),
              ],
            ),
    );
  }

  Widget _buildBodyPartSelector() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Vücut bölgesi seçin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _bodyParts.length,
              itemBuilder: (context, index) {
                final bodyPart = _bodyParts[index];
                final isSelected = bodyPart == _selectedBodyPart;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedBodyPart = bodyPart;
                      });
                    },
                    child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? HealthApp.primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: Text(
                        bodyPart,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomList() {
    final symptoms = _symptoms[_selectedBodyPart] ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: symptoms.length,
      itemBuilder: (context, index) {
        final symptom = symptoms[index];
        final isSelected = _selectedSymptoms.contains(symptom);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? HealthApp.primaryColor : Colors.transparent,
              width: isSelected ? 2 : 0,
            ),
          ),
          child: InkWell(
            onTap: () => _toggleSymptom(symptom),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color:
                        isSelected ? HealthApp.primaryColor : Colors.grey[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      symptom,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: HealthApp.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Seçildi',
                        style: TextStyle(
                          fontSize: 12,
                          color: HealthApp.primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedSymptoms() {
    if (_selectedSymptoms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seçilen Semptomlar (${_selectedSymptoms.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedSymptoms.map((symptom) {
              return Chip(
                label: Text(symptom),
                backgroundColor: HealthApp.primaryColor.withOpacity(0.1),
                labelStyle: const TextStyle(color: HealthApp.primaryColor),
                deleteIcon: const Icon(
                  Icons.cancel,
                  size: 18,
                ),
                onDeleted: () => _toggleSymptom(symptom),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed:
            _selectedSymptoms.isEmpty || _isAnalyzing ? null : _analyzeSymptoms,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: HealthApp.accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isAnalyzing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Semptomları Analiz Et',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildResultsView() {
    if (_analysisResults!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Seçilen semptomlarla eşleşen bir sonuç bulunamadı',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Yeni Analiz'),
              onPressed: _resetAnalysis,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: HealthApp.primaryColor.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analiz Sonuçları',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HealthApp.accentColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Seçilen semptomlar ile ${_analysisResults!.length} olası durum eşleşti',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedSymptoms.map((symptom) {
                  return Chip(
                    label: Text(symptom),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _analysisResults!.length,
            itemBuilder: (context, index) {
              final result = _analysisResults![index];
              final disease = result['disease'];
              final matchPercentage = result['matchPercentage'].toInt();
              final matchedSymptoms = result['matchedSymptoms'] as List<String>;
              final totalSymptoms = result['totalSymptoms'] as List<String>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services,
                            color: _getMatchColor(matchPercentage),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              disease,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getMatchColor(matchPercentage)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '%$matchPercentage',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getMatchColor(matchPercentage),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Eşleşen Semptomlar (${matchedSymptoms.length}/${totalSymptoms.length}):',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: totalSymptoms.map((symptom) {
                          final isMatched = matchedSymptoms.contains(symptom);
                          return Chip(
                            label: Text(
                              symptom,
                              style: TextStyle(
                                color: isMatched ? Colors.white : Colors.black,
                                fontWeight: isMatched
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            backgroundColor: isMatched
                                ? HealthApp.accentColor
                                : Colors.grey[200],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.info_outline),
                              label: const Text('Daha Fazla Bilgi'),
                              onPressed: () {
                                // Hastalık hakkında daha fazla bilgi göster
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: HealthApp.accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Randevu Al'),
                              onPressed: () {
                                // Randevu sayfasına yönlendir
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HealthApp.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (matchPercentage >= 70)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_outlined,
                                color: Colors.red[700],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Semptomlarınız ciddi bir durum ile yüksek eşleşme gösteriyor. En kısa sürede bir doktora başvurmanız önerilir.',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yeni Analiz'),
                  onPressed: _resetAnalysis,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: HealthApp.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 70) {
      return Colors.red;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
