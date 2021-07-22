import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  int score = 0;

  List<Widget> scoreKepper = [];

  QuizBrain quizBrain = new QuizBrain();

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    setState(
      () {
        if( quizBrain.isFinished() == true)
        {
          Alert(
            context: context,
            type: AlertType.success,
            title: "Finished",
            desc: "you've reached the end of the quiz \n you've got $score out of 15",
            buttons: [
              DialogButton(
                child: Text(
                  "RESET",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
                color: Colors.green.shade600,
              ),
              DialogButton(
                child: Text(
                  "EXIT",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => SystemNavigator.pop(),
                width: 120,
                color: Colors.red.shade600,
              ),
            ],
          ).show();
          quizBrain.reset();
          scoreKepper = [];
        }
        else {
          if (userPickedAnswer == correctAnswer) {
            score++;
            scoreKepper.add(
              Icon(
                Icons.check,
                color: Colors.green,
              ),
            );
            quizBrain.nextQuestion();
          }
          else {
            scoreKepper.add(
              Icon(
                Icons.close,
                color: Colors.red,
              ),
            );
            quizBrain.nextQuestion();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKepper,
        )
      ],
    );
  }
}
