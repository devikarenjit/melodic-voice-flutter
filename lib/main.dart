
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MelodicVoiceApp());
}

class MelodicVoiceApp extends StatelessWidget {
  const MelodicVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Melodic Voice',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const SplashScreen(),
    );
  }
}
