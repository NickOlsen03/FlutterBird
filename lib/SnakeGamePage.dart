import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeGamePage extends StatefulWidget {
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int _rowCount = 20;
  static const int _columnCount = 20;
  static const int _initialSnakeLength = 3;
  static const Duration _gameSpeed = Duration(milliseconds: 300);

  List<Offset> _snake = [];
  Offset _food = Offset.zero;
  String _direction = 'right';
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _snake = List.generate(_initialSnakeLength, (index) => Offset(_initialSnakeLength - index - 1, 0));
    _generateFood();
    _isGameOver = false;
    _direction = 'right';
    _timer = Timer.periodic(_gameSpeed, (timer) {
      setState(() {
        _moveSnake();
        if (_isGameOver) {
          timer.cancel();
          _showGameOverDialog();
        } else if (_snake.length >= 8) {
          timer.cancel();
          _navigateToHomePage();
        }
      });
    });
  }

  void _generateFood() {
    final random = Random();
    Offset newFood;
    do {
      newFood = Offset(
        random.nextInt(_columnCount).toDouble(),
        random.nextInt(_rowCount).toDouble(),
      );
    } while (_snake.contains(newFood));
    _food = newFood;
  }

  void _moveSnake() {
    final newHead = _getNewHead();
    if (_isCollision(newHead)) {
      _isGameOver = true;
      return;
    }
    _snake.insert(0, newHead);
    if (newHead == _food) {
      _generateFood();
    } else {
      _snake.removeLast();
    }
  }

  Offset _getNewHead() {
    final head = _snake.first;
    switch (_direction) {
      case 'up':
        return Offset(head.dx, head.dy - 1);
      case 'down':
        return Offset(head.dx, head.dy + 1);
      case 'left':
        return Offset(head.dx - 1, head.dy);
      case 'right':
      default:
        return Offset(head.dx + 1, head.dy);
    }
  }

  bool _isCollision(Offset position) {
    return position.dx < 0 ||
        position.dx >= _columnCount ||
        position.dy < 0 ||
        position.dy >= _rowCount ||
        _snake.contains(position);
  }

  void _changeDirection(String newDirection) {
    if ((_direction == 'up' && newDirection != 'down') ||
        (_direction == 'down' && newDirection != 'up') ||
        (_direction == 'left' && newDirection != 'right') ||
        (_direction == 'right' && newDirection != 'left')) {
      _direction = newDirection;
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('You scored ${_snake.length - _initialSnakeLength} points.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHomePage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: GridView.builder(
              itemCount: _rowCount * _columnCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _columnCount,
              ),
              itemBuilder: (context, index) {
                final x = index % _columnCount;
                final y = index ~/ _columnCount;
                final offset = Offset(x.toDouble(), y.toDouble());
                final isSnake = _snake.contains(offset);
                final isFood = offset == _food;
                return Container(
                  margin: EdgeInsets.all(1),
                  color: isSnake ? Colors.green : isFood ? Colors.red : Colors.grey[800],
                );
              },
            ),
          ),
          Positioned(
            bottom: 50,
            left: 50,
            child: Column(
              children: [
                _buildDirectionButton(Icons.arrow_drop_up, 'up'),
                Row(
                  children: [
                    _buildDirectionButton(Icons.arrow_left, 'left'),
                    SizedBox(width: 50),
                    _buildDirectionButton(Icons.arrow_right, 'right'),
                  ],
                ),
                _buildDirectionButton(Icons.arrow_drop_down, 'down'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionButton(IconData icon, String direction) {
    return GestureDetector(
      onTap: () => _changeDirection(direction),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}