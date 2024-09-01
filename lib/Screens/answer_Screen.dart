import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  final String word;
  const AnswerPage({super.key, required this.word});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer for "${widget.word}"'),
      ),
      body: Center(
        child: Text('Answer for "${widget.word}"'),
      ),
    );
  }
}



