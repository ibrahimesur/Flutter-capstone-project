import 'package:flutter/material.dart';
import '../../../main.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // Örnek doktor profil bilgileri
  final Map<String, dynamic> _doctorProfile = {
    'name': 'Dr. Ayşe Yılmaz',
    'specialty': 'Kardiyoloji Uzmanı',
    'imageUrl': '', // Profil fotoğrafı
    'email': 'dr.ayse.yilmaz@hospital.com',
    'phone': '+90 555 123 4567',
    'biography': 'İstanbul Üniversitesi Tıp Fakültesi mezunu olup, kardiyoloji alanında 15 yıllık deneyime sahibim. Özellikle koroner arter hastalıkları ve hipertansiyon konularında uzmanlaşmış bulunmaktayım.',
    'hospital': {
      'name': 'Medica Plus Hastanesi',
      'address': 'Barbaros Bulvarı No:145, Beşiktaş, İstanbul',
      'phone': '+90 212 345 6789',
      'workingHours': 'Pazartesi-Cuma: 09:00-17:00',
      'website': 'www.medicaplus.com.tr',
    },
    'education': [
      {
        'title': 'Kardiyoloji Uzmanlığı',
        'institution': 'Ankara Üniversitesi Tıp Fakültesi',
        'year': '2010',
      },
      {
        'title': 'Tıp Fakültesi',
        'institution': 'İstanbul Üniversitesi',
        'year': '2005',
      },
    ],
    'certifications': [
      {
        'title': 'Avrupa Kardiyoloji Derneği Üyeliği',
        'year': '2012',
      },
      {
        'title': 'İleri Kardiyak Yaşam Desteği Sertifikası',
        'year': '2011',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Kişisel Bilgiler'),
                  _buildInfoCard(
                    icon: Icons.email,
                    title: 'E-posta',
                    subtitle: _doctorProfile['email'],
                  ),
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: 'Telefon',
                    subtitle: _doctorProfile['phone'],
                  ),
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Biyografi',
                    subtitle: _doctorProfile['biography'],
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Hastane Bilgileri'),
                  _buildHospitalInfo(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Eğitim'),
                  _buildEducationList(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Sertifikalar'),
                  _buildCertificationsList(),
                  
                  const SizedBox(height: 24),
                  _buildSettingsButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: HealthApp.primaryColor.withOpacity(0.05),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: HealthApp.primaryColor,
            child: Text(
              _doctorProfile['name'].toString().substring(0, 2),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _doctorProfile['name'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _doctorProfile['specialty'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem('500+', 'Hasta'),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem('10+', 'Yıl Deneyim'),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 24),
              ),
              _buildStatItem('4.9', 'Puan'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: HealthApp.primaryColor,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: HealthApp.primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: HealthApp.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalInfo() {
    final hospital = _doctorProfile['hospital'] as Map<String, dynamic>;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: HealthApp.primaryColor),
                const SizedBox(width: 12),
                Text(
                  hospital['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildHospitalDetail(Icons.location_on, hospital['address']),
            const SizedBox(height: 8),
            _buildHospitalDetail(Icons.phone, hospital['phone']),
            const SizedBox(height: 8),
            _buildHospitalDetail(Icons.access_time, hospital['workingHours']),
            const SizedBox(height: 8),
            _buildHospitalDetail(Icons.language, hospital['website']),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Haritada Göster'),
                onPressed: () {
                  // Harita uygulamasını açma işlevi
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalDetail(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Icon(icon, size: 18, color: Colors.grey[600]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationList() {
    return Column(
      children: List.generate(
        _doctorProfile['education'].length,
        (index) => _buildEducationItem(_doctorProfile['education'][index]),
      ),
    );
  }

  Widget _buildEducationItem(Map<String, dynamic> education) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: HealthApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.school,
                color: HealthApp.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    education['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    education['institution'],
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: HealthApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                education['year'],
                style: TextStyle(
                  color: HealthApp.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsList() {
    return Column(
      children: List.generate(
        _doctorProfile['certifications'].length,
        (index) => _buildCertificationItem(_doctorProfile['certifications'][index]),
      ),
    );
  }

  Widget _buildCertificationItem(Map<String, dynamic> certification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: HealthApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.verified,
                color: HealthApp.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certification['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: HealthApp.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                certification['year'],
                style: TextStyle(
                  color: HealthApp.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.settings),
        label: const Text('Ayarlar'),
        onPressed: () {
          // Ayarlar ekranına yönlendirme
          _showSettingsModal(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: HealthApp.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  
  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: scrollController,
              children: [
                const Center(
                  child: Text(
                    'Ayarlar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSettingsCategory(
                  'Hesap Ayarları',
                  [
                    _buildSettingsItem(
                      'Profil Bilgilerini Düzenle',
                      Icons.edit,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'Şifre Değiştir',
                      Icons.lock_outline,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'E-posta Adresini Güncelle',
                      Icons.email_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingsCategory(
                  'Çalışma Saatleri',
                  [
                    _buildSettingsItem(
                      'Çalışma Saatlerini Düzenle',
                      Icons.access_time,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'İzin Günlerini Ayarla',
                      Icons.event_busy,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingsCategory(
                  'Sistem Ayarları',
                  [
                    _buildSettingsItem(
                      'Bildirim Tercihleri',
                      Icons.notifications_outlined,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'Dil Ayarları',
                      Icons.language,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'Gizlilik ve Güvenlik',
                      Icons.security,
                      onTap: () {},
                    ),
                    _buildSettingsItem(
                      'Yardım ve Destek',
                      Icons.help_outline,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Çıkış Yap'),
                  onPressed: () {
                    // Çıkış işlemi
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsCategory(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: HealthApp.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: HealthApp.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
} 