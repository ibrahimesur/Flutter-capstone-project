import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import 'doctor_appointments.dart';
import 'doctor_patients.dart';
import 'doctor_messages.dart';

class DoctorDashboard extends StatefulWidget {
  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DoctorAppointmentsPage(),
    DoctorMessagesPage(),
    DoctorPatientsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doktor Paneli'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Bildirimler
            },
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/doctor_avatar.png'),
              // Varsayılan avatar kullanılabilir
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Profil'),
                value: 'profile',
              ),
              PopupMenuItem(
                child: Text('Çıkış Yap'),
                value: 'logout',
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                // Çıkış işlemi
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Randevular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Hastalar',
          ),
        ],
      ),
    );
  }
}

class DoctorMessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasta Mesajları',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: HealthApp.accentColor,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Örnek veri
              itemBuilder: (context, index) {
                return _buildMessageCard(
                  context,
                  patientName: 'Hasta ${index + 1}',
                  lastMessage: 'Son mesaj içeriği...',
                  time: '14:30',
                  unread: index % 3 == 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(
    BuildContext context, {
    required String patientName,
    required String lastMessage,
    required String time,
    bool unread = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: unread ? HealthApp.primaryColor : Colors.grey[300],
          child: Text(
            patientName[0],
            style: TextStyle(
              color: unread ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
        title: Text(
          patientName,
          style: TextStyle(
            fontWeight: unread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(lastMessage),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                color: unread ? HealthApp.accentColor : Colors.grey,
              ),
            ),
            if (unread)
              Container(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: HealthApp.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(patientName: patientName),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String patientName;

  ChatScreen({required this.patientName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.patientName),
            Text(
              'Son görülme: Bugün 14:30',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Hasta bilgileri
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  message['text'],
                  message['isDoctor'],
                  message['time'],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    // Dosya ekleme
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'text': _messageController.text,
                          'isDoctor': true,
                          'time': DateTime.now(),
                        });
                        _messageController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isDoctor, DateTime time) {
    return Align(
      alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDoctor ? HealthApp.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isDoctor ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${time.hour}:${time.minute}',
              style: TextStyle(
                fontSize: 12,
                color: isDoctor ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 