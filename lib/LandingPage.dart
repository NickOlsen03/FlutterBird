import 'package:flutter/material.dart';
import 'package:flappyflutter/homepage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int stage = 0;
  int tapCount = 0;
  final TextEditingController _controller = TextEditingController();
  String _feedback = '';

  void _nextStage() {
    setState(() {
      stage++;
      _controller.clear();
      _feedback = '';
    });
  }

  void _checkAnswer(String correctAnswer) {
    if (_controller.text.trim().toLowerCase() == correctAnswer.toLowerCase()) {
      _nextStage();
    } else {
      setState(() {
        _feedback = 'Incorrect answer. Try again.';
      });
    }
  }

  void _handleTap() {
    setState(() {
      tapCount++;
      if (tapCount >= 100) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (stage == 0) {
      return _buildQuestionPage(
        question: 'What is Flutter?',
        correctAnswer: 'A UI toolkit',
      );
    } else if (stage == 1) {
      return _buildQuestionPage(
        question: 'What language is used to write Flutter apps?',
        correctAnswer: 'Dart',
      );
    } else if (stage == 2) {
      return _buildQuestionPage(
        question: 'What widget is used to create a scrollable list?',
        correctAnswer: 'ListView',
      );
    } else {
      return _buildFinalStage();
    }
  }

  Widget _buildQuestionPage({required String question, required String correctAnswer}) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer The Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question, style: TextStyle(fontSize: 18)),
            TextField(controller: _controller),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkAnswer(correctAnswer),
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(_feedback, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalStage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is the worst game you will ever play"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tap the button 105 times to start the game.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _handleTap,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    "Play",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Taps: $tapCount",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}