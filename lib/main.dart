import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Socket.IO Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = []; // 채팅 메시지 리스트

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    // Socket.IO 서버에 연결
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'], // WebSocket만 사용
      'autoConnect': true,
    });

    // 연결 성공
    socket.onConnect((_) {
      print('Connected to server');
    });

    // 메시지 수신
    socket.on('receive_message', (data) {
      setState(() {
        messages.add({'sender': data['sender'], 'message': data['message']});
      });
    });

    // 연결 해제
    socket.onDisconnect((_) => print('Disconnected from server'));
  }

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    // 메시지 서버로 전송
    socket.emit('send_message', {
      'sender': 'User1', // 보내는 사람 이름 (예: 로그인한 사용자)
      'message': _messageController.text,
    });

    setState(() {
      messages.add({'sender': 'You', 'message': _messageController.text});
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    socket.dispose(); // 소켓 연결 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Socket.IO'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(
                    message['message']!,
                    style: TextStyle(
                      color: message['sender'] == 'You' ? Colors.blue : Colors.black,
                    ),
                  ),
                  subtitle: Text(message['sender']!),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
