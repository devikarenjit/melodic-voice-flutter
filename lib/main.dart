
import 'package:flutter/material.dart';
import 'screens/register_child.dart';

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
      home: RegisterChildScreen(),
    );
  }
}
