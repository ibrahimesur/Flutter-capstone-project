import 'package:flutter/material.dart';
import '../../../main.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  // Örnek mesaj verileri
  final List<Map<String, dynamic>> _conversations = [
    {
      'patientId': '1',
      'patientName': 'Ahmet Yılmaz',
      'lastMessage': 'İlaçları düzenli kullanıyorum doktor bey, teşekkür ederim.',
      'time': '10:30',
      'date': 'Bugün',
      'unread': true,
      'avatar': 'AY',
    },
    {
      'patientId': '2',
      'patientName': 'Ayşe Kaya',
      'lastMessage': 'Randevumu iptal etmem gerekiyor, acaba ne zaman müsait olursunuz?',
      'time': '09:15',
      'date': 'Bugün',
      'unread': true,
      'avatar': 'AK',
    },
    {
      'patientId': '3',
      'patientName': 'Mehmet Demir',
      'lastMessage': 'Tahlil sonuçlarım sisteme yüklendi mi acaba?',
      'time': '18:45',
      'date': 'Dün',
      'unread': false,
      'avatar': 'MD',
    },
    {
      'patientId': '4',
      'patientName': 'Zeynep Yıldız',
      'lastMessage': 'Teşekkür ederim doktor hanım.',
      'time': '11:20',
      'date': '23 Şub',
      'unread': false,
      'avatar': 'ZY',
    },
  ];

  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    // Arama sonucuna göre filtrelenmiş mesajlar
    final filteredConversations = _searchQuery.isEmpty
        ? _conversations
        : _conversations.where((conv) => 
            conv['patientName']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false).toList();
    
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Hasta ara...',
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
            child: filteredConversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty 
                              ? 'Mesaj yok' 
                              : 'Aramanızla eşleşen hasta bulunamadı',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredConversations.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final conversation = filteredConversations[index];
                      return _buildMessageTile(conversation);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HealthApp.primaryColor,
        child: const Icon(Icons.message, color: Colors.white),
        onPressed: () {
          // Yeni mesaj başlatma işlevi
        },
      ),
    );
  }

  Widget _buildMessageTile(Map<String, dynamic> conversation) {
    final bool hasUnread = conversation['unread'] ?? false;
    final String patientName = conversation['patientName']?.toString() ?? 'İsimsiz Hasta';
    final String patientId = conversation['patientId']?.toString() ?? '0';
    final String avatar = conversation['avatar']?.toString() ?? 'X';
    final String lastMessage = conversation['lastMessage']?.toString() ?? '';
    final String date = conversation['date']?.toString() ?? '';
    final String time = conversation['time']?.toString() ?? '';
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(
              patientName: patientName,
              patientId: patientId,
              avatar: avatar,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: HealthApp.primaryColor,
                  child: Text(
                    avatar.isEmpty ? 'X' : avatar,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        patientName,
                        style: TextStyle(
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$date, $time',
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread ? HealthApp.primaryColor : Colors.grey,
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lastMessage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: hasUnread ? Colors.black87 : Colors.grey[600],
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
}

class ChatDetailScreen extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String avatar;

  const ChatDetailScreen({
    super.key, 
    required this.patientName, 
    required this.patientId,
    required this.avatar,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Örnek mesaj geçmişi
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'patient',
      'message': 'Merhaba doktor bey, ilaçlarımla ilgili bir sorum olacaktı.',
      'time': '09:45',
      'date': '16 Şub 2024',
    },
    {
      'sender': 'doctor',
      'message': 'Merhaba, sizi dinliyorum. Hangi ilaçla ilgili sorununuz var?',
      'time': '09:47',
      'date': '16 Şub 2024',
    },
    {
      'sender': 'patient',
      'message': 'Tansiyon ilacımı yemeklerden önce mi sonra mı almalıyım? Bir de baş ağrısı yapıyor gibi, normal mi?',
      'time': '09:50',
      'date': '16 Şub 2024',
    },
    {
      'sender': 'doctor',
      'message': 'Tansiyon ilacınızı sabahları kahvaltıdan sonra almanızı öneririm. Baş ağrısı ilk haftalarda görülebilen bir yan etki, genelde geçiyor. Bir hafta daha devam ederse kontrole gelin lütfen.',
      'time': '09:55',
      'date': '16 Şub 2024',
    },
    {
      'sender': 'patient',
      'message': 'Teşekkür ederim, bir sorum daha var. Üç gün önce söylediğiniz tahlilleri yaptırdım, sonuçları sisteme yüklendi mi?',
      'time': '10:15',
      'date': '16 Şub 2024',
    },
    {
      'sender': 'doctor',
      'message': 'Henüz görmedim, kontrol edeyim. Biraz bekleyin lütfen.',
      'time': '10:20',
      'date': '16 Şub 2024',
    },
    {
      'sender': 'doctor', 
      'message': 'Evet, sonuçlarınız sisteme yüklenmiş. Genel olarak normal görünüyor, bir sonraki randevuda detaylı değerlendireceğiz.',
      'time': '10:30',
      'date': '16 Şub 2024',
    },
    {
      'sender': 'patient',
      'message': 'İlaçları düzenli kullanıyorum doktor bey, teşekkür ederim.',
      'time': '10:30',
      'date': '16 Şub 2024',
    },
  ];
  
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'sender': 'doctor',
        'message': _messageController.text,
        'time': '${DateTime.now().hour}:${DateTime.now().minute}',
        'date': 'Bugün',
      });
      _messageController.clear();
    });
    
    // Mesaj listesinin en altına kaydırma
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HealthApp.primaryColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text(
                widget.avatar,
                style: TextStyle(
                  color: HealthApp.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Hasta',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Video görüşmesi başlat
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // Sesli arama başlat
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Daha fazla seçenek
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isMe = message['sender'] == 'doctor';
                final String messageText = message['message']?.toString() ?? '';
                final String messageTime = message['time']?.toString() ?? '';
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe) 
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            widget.avatar.isEmpty ? 'X' : widget.avatar.substring(0, 1),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!isMe) const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? HealthApp.primaryColor : Colors.grey[200],
                            borderRadius: BorderRadiusDirectional.only(
                              topStart: const Radius.circular(18),
                              topEnd: const Radius.circular(18),
                              bottomStart: isMe ? const Radius.circular(18) : const Radius.circular(4),
                              bottomEnd: isMe ? const Radius.circular(4) : const Radius.circular(18),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageText,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isMe ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                messageTime,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isMe ? Colors.white70 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isMe) const SizedBox(width: 8),
                      if (isMe) 
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: HealthApp.primaryColor.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: HealthApp.primaryColor,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    // Dosya ekleme işlevi
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: HealthApp.primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 