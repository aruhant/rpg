import 'package:flutter/material.dart';

class ProgressBarController extends ChangeNotifier {
  static final ProgressBarController _singleton =
      ProgressBarController._internal();

  factory ProgressBarController() {
    return _singleton;
  }

  ProgressBarController._internal();

  double _life = 0;
  int _goals = 0;
  int _enemies = 0;

  double get life => _life;
  int get goals => _goals;
  int get enemies => _enemies;

  set life(double newLife) {
    _life = newLife;
    notifyListeners();
  }

  set goals(int g) {
    _goals = g;
    notifyListeners();
  }

  set enemies(int e) {
    _enemies = e;
    notifyListeners();
  }

  void configure(
      {required double life, required int goals, required int enemies}) {
    _life = life;
    _goals = goals;
    _enemies = enemies;
    notifyListeners();
  }
}
