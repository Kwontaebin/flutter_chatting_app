import 'package:flutter/material.dart';
import 'package:flutter_chatting_app/splash/view/splash.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chatting app',
      home: SplashScreen(),
    );
  }
}