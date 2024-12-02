import 'package:flutter_test/flutter_test.dart';
import 'package:brain_games/utils/format_time.dart';

void main() {
  group('Time Formats correctly', () {
    test('Timer starts and increments elapsed time', () async {
      expect(FormatDateTime.formatTime(10), "00:00:10");
      expect(FormatDateTime.formatTime(60), "00:01:00");
      expect(FormatDateTime.formatTime(3601), "01:00:01");
      expect(FormatDateTime.formatTime(0), "00:00:00");
    });

    test('Date formats correctly', () async {
      expect(FormatDateTime.getToday().length, 10);
    });
  });
}