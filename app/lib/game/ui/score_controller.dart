import 'package:flutter/material.dart';

class ProgressBarController extends ChangeNotifier {
  static final ProgressBarController _singleton =
      ProgressBarController._internal();

  factory ProgressBarController() {
    return _singleton;
  }

  ProgressBarController._internal();

  double _life = 0;
  int _goals = 28;
  int _enemies = 15;

  reset() {
    _life = 0;
    _goals = 28;
    _enemies = 15;
    notifyListeners();
  }

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
