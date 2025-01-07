import 'package:flutter/material.dart';
import 'package:flutter_chatting_app/common/component/custom_appbar.dart';
import 'package:flutter_chatting_app/common/component/custom_elevatedButton.dart';
import 'package:flutter_chatting_app/common/component/custom_text_field.dart';
import 'package:flutter_chatting_app/common/function/navigator.dart';
import 'package:flutter_chatting_app/common/function/sizeFn.dart';
import 'package:flutter_chatting_app/home/view/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/function/postDio.dart';


/*
  새로고침(앱에 다시 접속)을 하면 사용자 이름이 없는 이슈가 있음
  계속 provider 사용할지 shared_preferences로 변경할지 고민
  보안에 해로운 사항은 아니라서 shared_preferences로 저장해도 괜찮을지도....
 */

class DataProvider with ChangeNotifier {
  String _userId = "";

  String get userId => _userId;

  void setId(String userId) {
    _userId = userId;

    notifyListeners();
  }
}

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
            onSuccess: (Map<String, dynamic> data) async {
              if (data['statusCode'] == 200) {
                print(data);
                // Provider에 ID 저장
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', data["token"]);
                context.read<DataProvider>().setId(id);
                navigatorFn(context, const ChattingScreen());
              }
            },
          );

    print("로그인 성공: ${context.read<DataProvider>().userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "login",
        showLeading: false,
      ),
      body: Container(
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
              onPressed: ()  {
                login();
              },
            )
          ],
        ),
      ),
    );
  }
}
