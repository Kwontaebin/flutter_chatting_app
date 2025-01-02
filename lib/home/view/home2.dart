import 'package:flutter/material.dart';
import 'package:flutter_chatting_app/common/component/custom_appbar.dart';
import 'package:flutter_chatting_app/common/component/custom_text_field.dart';
import 'package:flutter_chatting_app/common/function/sizeFn.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late IO.Socket socket;
  String message = "";
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
    if (message.isEmpty) return;

    // 메시지 서버로 전송
    socket.emit('send_message', {
      'sender': 'User1', // 보내는 사람 이름 (예: 로그인한 사용자)
      'message': message,
    });

    setState(() {
      messages.add({'sender': 'You', 'message': message});
      message = "";
    });

    print(message);
    print(messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "chatting",
        showLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 빈 공간 클릭 시 포커스 해제
        },
        child: Container(
          width: double.infinity,
          height: deviceHeight(context) * 1.0,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: deviceHeight(context) * 0.8,
                  color: Colors.white70),
              SizedBox(
                width: sizeFn(context).width * 0.9,
                height: deviceHeight(context) * 0.2,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldWidget(
                        hintText: "입력하세요",
                        onChanged: (value) {
                          setState(() {
                            message = value;
                          });
                        },
                        myControllerText: message,
                        width: sizeFn(context).width * 0.77,
                        clearText: true,
                      ),
                    ),
                    SizedBox(width: sizeFn(context).width * 0.01),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
