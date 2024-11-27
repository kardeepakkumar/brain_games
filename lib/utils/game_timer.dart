import 'dart:async';

class GameTimer {
  Timer? _timer;
  int _elapsedSeconds = 0;

  /// Starts the timer and keeps track of elapsed seconds
  void startTimer() {
    _timer?.cancel(); // Ensure any previous timer is stopped
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
    });
  }

  /// Stops the timer
  void stopTimer() {
    _timer?.cancel();
  }

  /// Formats elapsed time into `hh:mm:ss`
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

  /// Returns the elapsed seconds
  int get elapsedSeconds => _elapsedSeconds;

  /// Checks if the timer is running
  bool get isRunning => _timer?.isActive ?? false;
}
