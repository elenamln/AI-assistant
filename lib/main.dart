import 'package:flutter/material.dart';
// lib/main.dart
import 'screens/chatbot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: const ChatbotPage(), 
    );
  }
}
