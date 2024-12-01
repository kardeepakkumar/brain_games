import 'dart:async';

class GameTimer {
  Timer? _timer;
  int _elapsedSeconds = 0;

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _timer?.isActive ?? false;

  void startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _elapsedSeconds++);
  }

  void stopTimer() {
    _timer?.cancel();
  }

  String formatTime() {
    final int hours = _elapsedSeconds ~/ 3600;
    final int minutes = (_elapsedSeconds % 3600) ~/ 60;
    final int seconds = _elapsedSeconds % 60;
    return [hours, minutes, seconds]
        .map((e) => e.toString().padLeft(2, '0'))
        .join(':');
  }

  String formatDate() {
    final String date = DateTime.now().toIso8601String().split('T').first;
    return date;
  }
}
