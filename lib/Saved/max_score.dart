import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HighScore {
  final int score;

  HighScore(
      { required this.score});

  Map<String, dynamic> toMap() {
    return {

      'score': score,
    };
  }

  factory HighScore.fromMap(Map<String, dynamic> map) {
    return HighScore(
        score: map['score'] as int);
  }

  save() async {

  final prefs = await SharedPreferences.getInstance();

  String? initialHighScores = prefs.getString('highscores');
  List currentHighScores = [];
  Map map = toMap();

  if (initialHighScores != null) {
    currentHighScores = jsonDecode(initialHighScores);
  }

  currentHighScores.add(map);
  await prefs.setString('highscores', jsonEncode(currentHighScores));
}
}