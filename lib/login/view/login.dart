import 'package:flutter/material.dart';
import 'package:flutter_chatting_app/common/component/custom_appbar.dart';
import 'package:flutter_chatting_app/common/component/custom_elevatedButton.dart';
import 'package:flutter_chatting_app/common/component/custom_text_field.dart';
import 'package:flutter_chatting_app/common/const/data.dart';
import 'package:flutter_chatting_app/common/function/navigator.dart';
import 'package:flutter_chatting_app/common/function/sizeFn.dart';
import 'package:flutter_chatting_app/home/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/function/postDio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String id = "";
  String pw = "";
  Map<String, dynamic> requestData = {};

  Future<void> login() async {
    setState(() {
      requestData = {
        'id': id,
        'pw': pw,
      };
    });
    (id == '' || pw == '')
        ? print("모두 다 작성해주세요")
        : await postDio(
            postData: requestData,
            url: "login",
            onData: (Map<String, dynamic> data) async {
              print(data);
              if(data["statusCode"] == 200) {
                await (await prefs()).setStringList("userValue", [data["token"], id]);
                navigatorFn(context, const ChattingScreen());
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "login",
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFieldWidget(
                hintText: "아이디를 입력하세요",
                onChanged: (value) {
                  id = value;
                },
              ),
              const SizedBox(height: 16.0),
              CustomTextFieldWidget(
                hintText: "비밀번호를 입력하세요",
                obscureText: true,
                onChanged: (value) {
                  pw = value;
                },
              ),
              const SizedBox(height: 16.0),
              customElevatedButton(
                context,
                text: "login",
                onPressed: () {
                  login();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
