class FormatDateTime {

  static String formatTime(int elapsedSeconds) {
    final int hours = elapsedSeconds ~/ 3600;
    final int minutes = (elapsedSeconds % 3600) ~/ 60;
    final int seconds = elapsedSeconds % 60;
    return [hours, minutes, seconds]
        .map((e) => e.toString().padLeft(2, '0'))
        .join(':');
  }

  static String getToday() {
    final String date = DateTime.now().toIso8601String().split('T').first;
    return date;
  }
}
