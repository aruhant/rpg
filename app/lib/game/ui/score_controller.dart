import 'package:flutter/material.dart';

class ProgressBarController extends ChangeNotifier {
  static final ProgressBarController _singleton =
      ProgressBarController._internal();

  factory ProgressBarController() {
    return _singleton;
  }

  ProgressBarController._internal();

  double _maxLife = 100;
  double _maxProgress = 0;
  get maxLife => _maxLife;
  get maxProgress => _maxProgress;

  double _life = 0;
  double _progress = 0;

  double get score => _life;
  double get progress => _progress;

  set score(double newLife) {
    _life = newLife;
    notifyListeners();
  }

  set progress(double progress) {
    _progress = progress;
    notifyListeners();
  }

  void configure({required double maxLife, required double maxProgress}) {
    _life = _maxLife = maxLife;
    _maxProgress = maxProgress;
    notifyListeners();
  }

  void increaseProgress(int value) {
    progress += value;
    if (progress > 100) {
      progress = 100;
    }
  }

  void decrementProgress(int value) {
    progress -= value;
    if (progress < 0) {
      progress = 0;
    }
  }

  void updateLife(double life) {
    if (this.score != life) {
      this.score = life;
    }
  }
}
