import 'package:flutter_test/flutter_test.dart';
import 'package:brain_games/utils/game_timer.dart';

void main() {
  group('GameTimer', () {

    late GameTimer gameTimer;

    setUp(() {
      gameTimer = GameTimer();
    });

    tearDown(() async {
      gameTimer.stopTimer();
    });

    test('Timer starts and increments elapsed time', () async {
      gameTimer.startTimer();
      expect(gameTimer.elapsedSeconds, 0);
      await Future.delayed(const Duration(seconds: 2));
      gameTimer.stopTimer();
      expect(gameTimer.elapsedSeconds, 2);
    });

    test('Timer stops correctly', () async {
      gameTimer.startTimer();
      await Future.delayed(const Duration(seconds: 2));
      gameTimer.stopTimer();
      int elapsedAtStop = gameTimer.elapsedSeconds;
      await Future.delayed(const Duration(seconds: 2));
      expect(gameTimer.elapsedSeconds, elapsedAtStop);
    });

    test('Time is formatted as hh:mm:ss', () async {
      gameTimer.startTimer();
      await Future.delayed(const Duration(seconds: 2));
      gameTimer.stopTimer();
      expect(['00:00:02', '00:00:01'], contains(gameTimer.formatTime()));
    });

    test('Check if the timer is running', () async {
      gameTimer.stopTimer();
      expect(gameTimer.isRunning, isFalse);

      gameTimer.startTimer();
      expect(gameTimer.isRunning, isTrue);

      gameTimer.stopTimer();
      expect(gameTimer.isRunning, isFalse);
    });
  });
}
