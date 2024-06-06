import 'package:arignar_app_task/widgets/appbar.dart';
import 'package:arignar_app_task/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.questions});

  final List questions;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late List questions = widget.questions;
  bool isListening = false;
  String spokenText = '';
  FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText speech = stt.SpeechToText();

  Future<void> _initializeTts() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  int currentQuestionIndex = 0;

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
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

  Future<void> listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        speech.listen(
          onResult: (val) => setState(() {
            spokenText = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              print('Confidence: ${val.confidence}');
            }
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTts();
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
            // const SizedBox(height: 20),
            // const SizedBox(height: 20),
            // Image.network(questions[currentQuestionIndex]['queston']),
            // const SizedBox(height: 20),
            // Row(
            //   children: [
            //     ElevatedButton(
            //       onPressed: preQuestion,
            //       child: const Text('prv'),
            //     ),
            //     ElevatedButton(
            //       onPressed: nextQuestion,
            //       child: const Text('Next'),
            //     ),
            //   ],
            // )

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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      icon: Icon(isListening ? Icons.mic : Icons.mic_none),
                      onPressed: listen,
                    ),
                    Text(spokenText),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: preQuestion,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Previous'),
                          ),
                          ElevatedButton(
                            onPressed: nextQuestion,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Next'),
                          ),
                        ],
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
