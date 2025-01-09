import 'package:flutter/material.dart';
import 'package:flutter_chatting_app/common/component/custom_appbar.dart';
import 'package:flutter_chatting_app/common/component/custom_text_field.dart';
import 'package:flutter_chatting_app/common/function/sizeFn.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../common/const/data.dart';

/*
  리스너로 토큰이 만료되면 로그인 화면으로 이동하는 코드 필요
 */

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  late IO.Socket socket;
  String message = "";
  List<Map<String, String>> messages = []; // 채팅 메시지 리스트
  String? userId;

  @override
  void initState() {
    super.initState();
    connectToServer();
    getName();
  }

  Future<String?> getName() async {
    userId = (await prefs()).getStringList('userValue')?.last;
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

      print(socket.id);
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

  Future<void> sendMessage() async {
    if (message.isEmpty) return;

    // 메시지 서버로 전송
    socket.emit('send_message', {
      'sender': userId, // 보내는 사람 이름 (예: 로그인한 사용자)
      'message': message,
    });

    setState(() {
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
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: deviceHeight(context) * 1.0,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: deviceHeight(context) * 0.8,
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        bool isSenderYou = message['sender'] == userId;

                        return ListTile(
                          title: Text(
                            message['sender']!,
                            textAlign: isSenderYou ? TextAlign.end : TextAlign.start,
                            style: TextStyle(
                              fontSize: sizeFn(context).width * 0.03,
                            ),
                          ),
                          subtitle: Align(
                            alignment: isSenderYou ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // 내용에 대한 패딩
                              margin: const EdgeInsets.symmetric(vertical: 5), // 위아래 여백
                              decoration: BoxDecoration(
                                color: isSenderYou ? Colors.purple[100] : Colors.blue[300],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15),
                                  topRight: const Radius.circular(15),
                                  bottomLeft: isSenderYou ? const Radius.circular(15) : const Radius.circular(0),
                                  bottomRight: isSenderYou ? const Radius.circular(0) : const Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                message['message']!,
                                style: const TextStyle(
                                  color: Colors.white, // 텍스트 색상
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
                          textSpacing: true,
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
      ),
    );
  }
}
