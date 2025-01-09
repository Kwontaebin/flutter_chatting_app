import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting_app/common/const/data.dart';
import 'package:flutter_chatting_app/common/function/navigator.dart';
import 'package:flutter_chatting_app/home/view/home.dart';
import 'package:flutter_chatting_app/login/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<String?> _checkToken() async {
    String? token = (await prefs()).getStringList('userValue')?.first;

    // 토큰이 유효하지 않을 떄 동작이 추가로 필요
    if (mounted) {
      if (token != null) {
        try {
          Response response = await dio.get(
              "$IP/protected",
              options: Options(
                  headers: {
                    'Authorization': 'Bearer $token',
                  }
              )
          );
          if(response?.statusCode == 200) navigatorFn(context, const ChattingScreen());
        } on DioException catch (e) {
          print(e.response?.statusCode);

          if(e.response?.statusCode == 403 || e.response?.statusCode == 400) {
            print('에러 상태 코드: ${e.response?.statusCode}');
            print('에러 메시지: ${e.response?.data}');

            (await prefs()).remove('userValue');
            navigatorFn(context, const LoginScreen());
          }
        }
      } else {
        navigatorFn(context, const LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, height: double.infinity, color: Colors.white);
  }
}
