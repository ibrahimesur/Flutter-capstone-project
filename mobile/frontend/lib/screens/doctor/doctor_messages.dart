import 'package:flutter/material.dart';
import '../../main.dart';

class DoctorMessagesPage extends StatelessWidget {
  final List<Map<String, dynamic>> conversations = [
    {
      'patientName': 'Ayşe Yılmaz',
      'lastMessage': 'Doktor bey, test sonuçlarım hakkında sormak istediğim...',
      'time': '14:30',
      'unread': true,
      'profileImage': null,
      'lastVisit': '10 Mart 2024',
      'department': 'Dahiliye',
      'status': 'Aktif Hasta',
    },
    {
      'patientName': 'Mehmet Demir',
      'lastMessage': 'İlaçları kullanmaya başladım, teşekkür ederim.',
      'time': '12:15',
      'unread': false,
      'profileImage': null,
      'lastVisit': '8 Mart 2024',
      'department': 'Dahiliye',
      'status': 'Takip Hastası',
    },
    // Daha fazla konuşma eklenebilir
  ];

  const DoctorMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Hasta ara...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _buildConversationCard(context, conversation);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationCard(BuildContext context, Map<String, dynamic> conversation) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: conversation['unread'] ? HealthApp.primaryColor : Colors.grey[300],
              child: Text(
                conversation['patientName'][0],
                style: TextStyle(
                  color: conversation['unread'] ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
            if (conversation['unread'])
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          conversation['patientName'],
          style: TextStyle(
            fontWeight: conversation['unread'] ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              conversation['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              conversation['status'],
              style: const TextStyle(
                color: HealthApp.accentColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              conversation['time'],
              style: TextStyle(
                color: conversation['unread'] ? HealthApp.accentColor : Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Son ziyaret: ${conversation['lastVisit']}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                patientName: conversation['patientName'],
                patientInfo: conversation,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String patientName;
  final Map<String, dynamic> patientInfo;

  const ChatScreen({Key? key, 
    required this.patientName,
    required this.patientInfo,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _showQuickResponses = false;

  @override
  void initState() {
    super.initState();
    // Örnek mesajları yükle
    _messages = [
      {
        'text': 'Merhaba doktor bey, test sonuçlarım hakkında sormak istediğim bir şey var.',
        'isDoctor': false,
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      },
      {
        'text': 'Merhaba, tabii ki. Test sonuçlarınızı buradan paylaşabilirsiniz.',
        'isDoctor': true,
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      },
      {
        'text': 'Kan değerlerimde demir biraz düşük çıkmış, bu konuda ne yapmam gerekiyor?',
        'isDoctor': false,
        'time': DateTime.now().subtract(const Duration(hours: 1)),
      },
    ];
  }

  final List<String> _quickResponses = [
    'Lütfen test sonuçlarınızı yükleyin.',
    'İlaçlarınızı düzenli kullanmayı unutmayın.',
    'Nasıl hissediyorsunuz?',
    'Kontrol için randevu alabilirsiniz.',
    'Bir süre daha takip edelim.',
    'Sonuçlarınız normal görünüyor.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: HealthApp.primaryColor.withOpacity(0.2),
              child: Text(widget.patientName[0]),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.patientName),
                Text(
                  widget.patientInfo['status'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              _showAttachmentOptions();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showPatientInfo();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(
                  message['text'],
                  message['isDoctor'],
                  message['time'],
                );
              },
            ),
          ),
          if (_showQuickResponses)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _quickResponses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(_quickResponses[index]),
                      selected: false,
                      onSelected: (selected) {
                        if (selected) {
                          _sendMessage(_quickResponses[index]);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
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
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: HealthApp.accentColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _showQuickResponses = !_showQuickResponses;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: HealthApp.accentColor,
                  ),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
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

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                // Galeri işlemleri
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                // Kamera işlemleri
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: const Text('Dosya'),
              onTap: () {
                // Dosya işlemleri
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Test Sonuçları'),
              onTap: () {
                // Test sonuçları işlemleri
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'isDoctor': true,
        'time': DateTime.now(),
      });
      _messageController.clear();
      _showQuickResponses = false;
    });
  }

  Widget _buildMessageBubble(String message, bool isDoctor, DateTime time) {
    return Align(
      alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
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
            const SizedBox(height: 4),
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

  void _showPatientInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hasta Bilgileri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Ad Soyad', widget.patientName),
            _buildInfoRow('Durum', widget.patientInfo['status']),
            _buildInfoRow('Son Ziyaret', widget.patientInfo['lastVisit']),
            _buildInfoRow('Bölüm', widget.patientInfo['department']),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Randevu Oluştur'),
                  onPressed: () {
                    // Randevu oluşturma işlemi
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.medical_services),
                  label: const Text('Hasta Dosyası'),
                  onPressed: () {
                    // Hasta dosyası görüntüleme
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
} 