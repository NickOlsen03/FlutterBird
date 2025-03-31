import 'package:flutter/material.dart';
import 'package:flappyflutter/landingpage.dart';
import 'package:flappyflutter/homepage.dart';
import 'SnakeGamePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/home': (context) => HomePage(),
        '/snake': (context) => SnakeGamePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}