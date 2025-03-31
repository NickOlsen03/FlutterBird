import 'dart:async';
import 'package:flappyflutter/barriers.dart';
import 'package:flappyflutter/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  static double birdyaxis = 0;
  double time = 0;
  double height = 0;
  double initialheight = birdyaxis;
  bool started = false;
  int score = 0;
  int highScore = 0;

  static double BarrierXone = 1;
  double BarrierXtwo = BarrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      initialheight = birdyaxis;
    });
  }

  void startgame() {
    started = true;
    Timer.periodic(Duration(milliseconds: 65), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.5 * time;

      setState(() {
        birdyaxis = initialheight - height;
      });

      setState(() {
        if (BarrierXone < -2) {
          BarrierXone += 3.5;
        } else {
          BarrierXone -= 0.05;
          if (BarrierXone < 0 && BarrierXone > -0.05) {
            score++;
          }
        }
      });

      setState(() {
        if (BarrierXtwo < -2) {
          BarrierXtwo += 3.5;
        } else {
          BarrierXtwo -= 0.05;
          if (BarrierXtwo < 0 && BarrierXtwo > -0.05) {
            score++;
          }
        }
      });

      if (birdyaxis > 1 || checkCollision()) {
        timer.cancel();
        started = false;
        if (score > highScore) {
          highScore = score;
        }
        showScoreboard();
      }
    });
  }

  bool checkCollision() {
    // Check if the bird hits the barriers
    if ((BarrierXone < 0.1 && BarrierXone > -0.1 && (birdyaxis < -0.6 || birdyaxis > 0.6)) ||
        (BarrierXtwo < 0.1 && BarrierXtwo > -0.1 && (birdyaxis < -0.6 || birdyaxis > 0.6))) {
      return true;
    }
    return false;
  }

  void showScoreboard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Your Score: $score\nHigh Score: $highScore"),
          actions: [
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      birdyaxis = 0;
      time = 0;
      height = 0;
      initialheight = birdyaxis;
      started = false;
      score = 0;
      BarrierXone = 1;
      BarrierXtwo = BarrierXone + 1.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (started) {
          jump();
        } else {
          startgame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdyaxis),
                      color: Colors.blue,
                      duration: Duration(milliseconds: 0),
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: started
                          ? Text(" ")
                          : Text("T A P  TO  J U M P",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(BarrierXone, 1.1), // Position the barrier to the right
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(BarrierXone, -1.1), // Position the barrier to the right
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(BarrierXtwo, 1.1), // Position the barrier to the right
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 150.0,
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(BarrierXtwo, -1.1), // Position the barrier to the right
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 250.0,
                      ),
                    )
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Score",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$score",
                          style: TextStyle(color: Colors.white, fontSize: 38),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Best",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$highScore",
                          style: TextStyle(color: Colors.white, fontSize: 38),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}