import 'dart:async';

import 'package:flappyflutter/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  static double birdyaxis = 0;
  double time = 0; // Time variable to control the jump height
  double height = 0; // Height of the jump
  double initialheight = birdyaxis; // Initial height of the jump
  bool started = false; // Flag to check if the game has started



void jump() {
  setState(() {
  time = 0;
  initialheight = birdyaxis; // Set the initial height to the current bird position
  });
}

void startgame() {
  started = true; // Set the game as started
  Timer.periodic(Duration(milliseconds: 65), (timer) {
    time += 0.05; // Increment time to simulate the jump
    height = -4.9 * time * time + 2.5 * time; // Calculate the height using the quadratic formula
    setState(() {
      birdyaxis = initialheight - height; // Update the bird's position based on the calculated height
    });
    if (birdyaxis > 1) {
      // If the bird goes beyond the screen height, stop the timer
      timer.cancel();
      started = false; // Reset the game state
    }
  });
}







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                if (started) {
                  jump();
                }
                else {
                   startgame();

                }
              },
            child: AnimatedContainer( 
              alignment: Alignment(0, birdyaxis),
              color: Colors.blue,
              duration: Duration(milliseconds: 0),
              child:MyBird(),
            ),
          ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
