import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting_app/common/function/navigator.dart';
import 'package:flutter_chatting_app/common/function/postDio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login/view/login.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final Color bgColor;
  final VoidCallback? leadingOnPressed; // Nullable로 변경

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.bgColor = Colors.blue,
    this.leadingOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: bgColor,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 24,
        ),
      ),
      elevation: 0,
      centerTitle: true,
      leading: showLeading
          ? IconButton(
              onPressed: () async {
                await logout(context);
              },
              icon: const Icon(Icons.logout),
              color: Colors.red,
            )
          : const SizedBox.shrink(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Future<void> logout(BuildContext context) async {
  // 저장된 토큰 가져오기
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getStringList('userValue')?.first;

  postDio(
    url: 'logout',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
    onData: (Map<String, dynamic> data) async {
      if (data['statusCode'] == 200) {
        print("프론트: 로그아웃 성공");

        await prefs.remove('userValue');
        navigatorFn(context, const LoginScreen());
      } else if(data['statusCode'] == 400 || data['statusCode'] == 403) {
        print('프론트: 토큰이 유효하지 않습니다.');

        await prefs.remove('userValue');
        navigatorFn(context, const LoginScreen());
      }
    },
  );
}
