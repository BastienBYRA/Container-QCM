import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(QcmApp());
}

class QcmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: fetchQuestions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Question> questions = snapshot.data as List<Question>;
            return QcmScreen(questions: questions);
          }
        },
      ),
    );
  }

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse('http://localhost:3000/'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data = json.decode(response.body);
      return data.map((questionData) {
        List<Response> responses = questionData['responses']
            .map<Response>(
                (response) => Response(response['name'], response['isCorrect']))
            .toList();
        return Question(questionData['question'], responses);
      }).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

class QcmScreen extends StatefulWidget {
  final List<Question> questions;

  QcmScreen({required this.questions});

  @override
  _QcmScreenState createState() => _QcmScreenState();
}

class _QcmScreenState extends State<QcmScreen> {
  int questionIndex = 0; // Index de la question actuelle
  int score = 0; // Score du joueur

  void checkAnswer(String selectedAnswer) {
    bool isCorrect = widget.questions[questionIndex].answerOptions
        .firstWhere((option) => option.responseText == selectedAnswer)
        .isCorrect;

    if (isCorrect) {
      setState(() {
        score++;
      });
    }
    nextQuestion();
  }

  void nextQuestion() {
    if (questionIndex < widget.questions.length - 1) {
      setState(() {
        questionIndex++;
      });
    } else {
      // Afficher le score final
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Score final'),
            content: Text(
                'Vous avez obtenu $score sur ${widget.questions.length} questions.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetQuiz();
                },
                child: Text('Rejouer'),
              ),
            ],
          );
        },
      );
    }
  }

  void resetQuiz() {
    setState(() {
      questionIndex = 0;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QCM Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.questions[questionIndex].questionText,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Column(
              children: widget.questions[questionIndex].answerOptions
                  .map(
                    (option) => ElevatedButton(
                      onPressed: () => checkAnswer(option.responseText),
                      child: Text(option.responseText),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  String questionText;
  List<Response> answerOptions;

  Question(this.questionText, this.answerOptions);
}

class Response {
  String responseText;
  bool isCorrect;

  Response(this.responseText, this.isCorrect);
}
