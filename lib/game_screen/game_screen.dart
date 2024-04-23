import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_pro/game_screen/painter.dart';

class BrickBreakerGame extends StatefulWidget {
  const BrickBreakerGame({super.key});


  @override
  _BrickBreakerGameState createState() => _BrickBreakerGameState();
}

class _BrickBreakerGameState extends State<BrickBreakerGame> {
  static const double brickWidth = 60.0;
  static const double brickHeight = 20.0;
  static const double ballRadius = 10.0;
  static const double paddleWidth = 100.0;
  static const double paddleHeight = 10.0;

  late Timer timer;
  late double ballX, ballY, dx, dy;
  late double paddleX;
  late bool gameStarted;
  late int score;
  late List<List<bool>> bricks;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    gameStarted = true;
    resetBall();
    resetPaddle();
    resetBricks();
    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (gameStarted) {
        moveBall();
        checkCollisions();
      }
      setState(() {});
    });
  }

  void resetBall() {
    ballX = 150.0;
    ballY = 300.0;
    dx = 3.0;
    dy = -3.0;
  }

  void resetPaddle() {
    paddleX = 150.0;
  }

  void resetBricks() {
    bricks = List.generate(3, (i) => List.generate(5, (j) => true));
  }

  void moveBall() {
    ballX += dx;
    ballY += dy;
    if (ballX < ballRadius || ballX > 300.0 - ballRadius) {
      dx = -dx;
    }
    if (ballY < ballRadius) {
      dy = -dy;
    }
    if (ballY > 400.0 - ballRadius) {
      gameOver();
    }
  }

  void checkCollisions() {
    double nextBallX = ballX + dx;
    double nextBallY = ballY + dy;
    if (nextBallX > paddleX && nextBallX < paddleX + paddleWidth && nextBallY > 390.0 - ballRadius && nextBallY < 390.0) {
      dy = -dy;
    }
    int row = (nextBallY / brickHeight).floor();
    int col = (nextBallX / brickWidth).floor();
    if (row >= 0 && row < 3 && col >= 0 && col < 5 && bricks[row][col]) {
      bricks[row][col] = false;
      score++;
      dy = -dy;
      if (score == 15) {
        gameOver();
      }
    }
  }

  void gameOver() {
    timer.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brick Breaker'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            paddleX += details.delta.dx;
          });
        },
        child: Stack(
          children: [
            CustomPaint(
              painter: BrickBreakerPainter(bricks),
              size: Size(300, 400),
            ),
            Positioned(
              left: paddleX,
              bottom: 0,
              child: Container(
                width: paddleWidth,
                height: paddleHeight,
                color: Colors.green,
              ),
            ),
            Positioned(
              left: ballX - ballRadius,
              top: ballY - ballRadius,
              child: Container(
                width: ballRadius * 2,
                height: ballRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
            if (!gameStarted)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      gameStarted = true;
                    });
                  },
                  child: Text(
                    'Tap to Start',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}