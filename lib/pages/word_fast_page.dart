import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wordfast/constants/app_strings.dart';
import 'package:wordfast/utils/score_calculator.dart';


import '../../data/word_list.dart';
import '../widgets/word_display.dart';
import '../widgets/input_field.dart';
import '../widgets/score_board.dart';

class WordFastPage extends StatefulWidget {
  const WordFastPage({super.key});
  @override
  State<WordFastPage> createState() => _WordFastPageState();
}

class _WordFastPageState extends State<WordFastPage> {
  final _ctrl = TextEditingController();
  final Random _rnd = Random();

  String _target = '';
  int _startTime = 0;
  int _elapsedMs = 0;
  Timer? _timer;
  int _lastScore = 0;
  int _bestScore = 0;
  int _totalScore = 0;

  @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => _showStartPopup());
    _nextWord();
  }
  
void _showStartPopup() {
  showDialog(
    context: context,
    barrierDismissible: false, // force user to press Start
    builder: (_) => AlertDialog(
      title: const Text('WordFast'),
      content: const Text('Press Start to begin the game!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _nextWord(); // starts first word and timer
          },
          child: const Text('Start'),
        ),
      ],
    ),
  );
}


  void _startTimer() {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {
        _elapsedMs = DateTime.now().millisecondsSinceEpoch - _startTime;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _elapsedMs = DateTime.now().millisecondsSinceEpoch - _startTime;
    });
  }

  void _nextWord() {
    _ctrl.clear();
    _elapsedMs = 0;
    _lastScore = 0;
    _target = wordList[_rnd.nextInt(wordList.length)];
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
    setState(() {});
  }

  void _submit() {
    _stopTimer();
    final typed = _ctrl.text.trim();
    final score = ScoreCalculator.calculate(_elapsedMs, typed, _target);
    _lastScore = score;
    _totalScore += score;
    if (score > _bestScore) _bestScore = score;
    setState(() {});
  }

  void _endGame() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Your Final Score: $_totalScore"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _totalScore = 0;
              _nextWord();
            },
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedSec = (_elapsedMs / 1000).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(title: const Text('WordFast')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text('Type this word as fast as you can:'),
            const SizedBox(height: 16),
            WordDisplay(word: _target),
            const SizedBox(height: 24),
            InputField(controller: _ctrl, onSubmit: _submit),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: _submit, child: const Text('Submit')),
                ),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _nextWord, child: const Text('Next')),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _endGame,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('END'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ScoreBoard(
              elapsedSec: elapsedSec,
              lastScore: _lastScore,
              bestScore: _bestScore,
              totalScore: _totalScore,
            ),
            const Spacer(),
            const Text(AppStrings.rules,
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    
    );
    
  }
}
