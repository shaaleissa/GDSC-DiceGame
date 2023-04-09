import 'dart:convert';
import 'dart:math';

import 'package:dice_game/Saved/max_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final diceImages = [
    'assets/dice1.png',
    'assets/dice2.png',
    'assets/dice3.png',
    'assets/dice4.png',
    'assets/dice5.png',
    'assets/dice6.png',
  ];
  int leftDice = 1;
  int rightDice = 1;
  int total = 0;
  int max = 0;

  void switchDice() {
    setState(() {
      leftDice = Random().nextInt(6);
      rightDice = Random().nextInt(6);
    });
  }

  void equal() {
    if (leftDice == rightDice) {
      setState(() {
        total++;
        _incrementCounter(total);
      });
    } else {
      setState(() {
        total = 0;
      });
    }
    switchDice();
  }

  void notEqual() {
    if (leftDice != rightDice) {
      setState(() {
        total++;
        _incrementCounter(total);
      });
    } else {
      setState(() {
        total = 0;
      });
    }
    switchDice();
  }

  List highScores = [];

  Future<void> _incrementCounter(int score) async {
    HighScore(score: score).save();

    setState(() {
      max++;
    });
  }

  getScores() async {
    var prefs = await SharedPreferences.getInstance();
    String? source = prefs.getString('highscores');
    var maps = source != null ? jsonDecode(source) : [];
    setState(() {
      highScores = maps.map((e) => HighScore.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: switchDice,
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.asset(diceImages[leftDice]),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Image.asset(diceImages[rightDice]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: equal,
                      child: const Text('Equal' , style: TextStyle(fontSize: 20, color: Colors.white),),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: notEqual,
                      child: const Text('Not Equal', style: TextStyle(fontSize: 20, color: Colors.white),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Score: $total',
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 20),
              Text('Max Score: $max',
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
