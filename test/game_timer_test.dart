import 'package:flutter_test/flutter_test.dart';
import 'package:brain_games/utils/game_timer.dart';

void main() {
  group('GameTimer', () {
    late GameTimer gameTimer;

    setUp(() {
      gameTimer = GameTimer();
    });

    test('Timer starts and increments elapsed time', () async {
      gameTimer.startTimer();
      expect(gameTimer.elapsedSeconds, 0);
      // Wait for 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      gameTimer.stopTimer();

      expect(gameTimer.elapsedSeconds, inInclusiveRange(3, 4));
    });

    test('Timer stops correctly', () async {
      gameTimer.startTimer();

      // Wait for 2 seconds and stop
      await Future.delayed(const Duration(seconds: 2));
      gameTimer.stopTimer();

      int elapsedAtStop = gameTimer.elapsedSeconds;

      // Wait for another second to ensure it doesn't increment further
      await Future.delayed(const Duration(seconds: 1));

      expect(gameTimer.elapsedSeconds, elapsedAtStop);
    });

    test('Time is formatted as hh:mm:ss', () async {
      gameTimer.startTimer();
      await Future.delayed(const Duration(seconds: 2));
      gameTimer.stopTimer();

    expect(['00:00:02', '00:00:01'], contains(gameTimer.formatTime()));
    });

    test('Check if the timer is running', () async {
      expect(gameTimer.isRunning, isFalse);

      gameTimer.startTimer();
      expect(gameTimer.isRunning, isTrue);

      gameTimer.stopTimer();
      expect(gameTimer.isRunning, isFalse);
    });
  });
}
