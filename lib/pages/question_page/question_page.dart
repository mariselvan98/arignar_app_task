import 'package:arignar_app_task/widgets/appbar.dart';
import 'package:arignar_app_task/widgets/dialog.dart';
import 'package:arignar_app_task/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.questions});

  final List questions;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late List questions = widget.questions;
  bool isListening = false, isCorrectAnswer = false;
  String spokenText = '';
  FlutterTts flutterTts = FlutterTts();

  Future<void> _initializeTts() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  int currentQuestionIndex = 0;

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        spokenText = '';
      });
    }
  }

  void preQuestion() {
    if (currentQuestionIndex > 1) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  final SpeechToText _speechToText = SpeechToText();
  void _initSpeech() async {
    isListening = await _speechToText.initialize();
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_En",
    );
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      spokenText = result.recognizedWords;
      isListening = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeTts();
    if (!isListening) {
      _initSpeech();
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentQuestionIndex + 1) / questions.length;
    return Scaffold(
      drawer: drawer(context),
      appBar: appbar("Domestic Animals"),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: LinearPercentIndicator(
                percent: progress,
                lineHeight: 20,
                progressColor: const Color(0xff7abeb0),
                backgroundColor: const Color(0xffc9f2ea),
                center:
                    Text('${currentQuestionIndex + 1} of ${questions.length}'),
                barRadius: const Radius.circular(10),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Card(
                color: const Color(0xffc9f2ea),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        questions[currentQuestionIndex]['queston'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              questions[currentQuestionIndex]['answer'],
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () {
                                _speak(
                                    questions[currentQuestionIndex]['answer']);
                              },
                            ),
                          ]),
                    ),
                    IconButton(
                      icon: Icon(
                        isListening
                            ? Icons.mic_none_rounded
                            : Icons.mic_off_outlined,
                        size: 60,
                      ),
                      onPressed: _startListening,
                    ),
                    Text(spokenText),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (questions[currentQuestionIndex]['answer']
                                .toUpperCase() ==
                            spokenText.toUpperCase()) {
                          setState(() {
                            isCorrectAnswer = true;
                          });
                        } else {
                          setState(() {
                            isCorrectAnswer = false;
                          });
                        }
                        showResultDialog(
                            context, isCorrectAnswer, nextQuestion);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          color: Colors.white,
                          child: const Text(
                            'Custom Button',
                            style: TextStyle(
                                color: Color(0xff7abeb0),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
