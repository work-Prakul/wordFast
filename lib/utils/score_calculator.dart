class ScoreCalculator {
  static int calculate(int elapsedMs, String typed, String target) {
    if (typed != target) return 0;
    final sec = (elapsedMs / 1000).ceil();
    if (sec == 1) return 5;
    if (sec == 2) return 4;
    if (sec == 3) return 3;
    if (sec == 4) return 2;
    return 1;
  }
}
