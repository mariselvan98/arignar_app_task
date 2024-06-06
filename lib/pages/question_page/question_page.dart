import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.questions});

  final List questions;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late List questions = widget.questions;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("HELLO"),
      ),
    );
  }
}
