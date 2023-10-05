import 'package:flutter/material.dart';

void main() {
  runApp(QcmApp());
}

class QcmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QcmScreen(),
    );
  }
}

class QcmScreen extends StatefulWidget {
  @override
  _QcmScreenState createState() => _QcmScreenState();
}

class _QcmScreenState extends State<QcmScreen> {
  // Liste de questions et de réponses
  List<Question> questions = [
    Question(
      "Qu'est ce que Docker ?",
      [
        'un outil conçu pour aider les développeurs à créer et gérer leurs applications de manière simple et organisée',
        'un serveur de data sans OS',
        'un ouvrier employé au chargement et au déchargement des navires',
        'La mer noire'
      ],
      'un outil conçu pour aider les développeurs à créer et gérer leurs applications de manière simple et organisée',
    ),
    Question(
      'Que sont les conteneurs ?',
      [
        'une grosse boite sur un bateau',
        'un outil',
        'un outil que Docker utilise pour regrouper et expédier les applications de développement vers leur destination cible',
        'La mer noire'
      ],
      'un outil que Docker utilise pour regrouper et expédier les applications de développement vers leur destination cible',
    ),
    Question(
      "Qu'est-ce qu'un fichier Dockerfile?",
      [
        'Un fichier yml',
        'Un fichier JPEG ',
        'La mer noire',
        "Un ensemble d'instructions"
      ],
      "Un ensemble d'instructions",
    ),
  ];

  int questionIndex = 0; // Index de la question actuelle
  int score = 0; // Score du joueur

  void checkAnswer(String selectedAnswer) {
    String correctAnswer = questions[questionIndex].correctAnswer;
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score++;
      });
    }
    nextQuestion();
  }

  void nextQuestion() {
    if (questionIndex < questions.length - 1) {
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
                'Vous avez obtenu $score sur ${questions.length} questions.'),
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
              questions[questionIndex].questionText,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Column(
              children: questions[questionIndex]
                  .answerOptions
                  .map(
                    (option) => ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      child: Text(option),
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
  List<String> answerOptions;
  String correctAnswer;

  Question(this.questionText, this.answerOptions, this.correctAnswer);
}
