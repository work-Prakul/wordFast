import 'package:flutter/material.dart';
import 'package:wordfast/pages/word_fast_page.dart';

class WordFastApp extends StatelessWidget {
  const WordFastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordFast',
      theme: ThemeData.dark().copyWith(),
      home: const WordFastPage(),
    );
  }
}
