import 'package:flutter_test/flutter_test.dart';
import 'package:blinkdoro/core.dart';

void main() {
  late BlinkDoro blinkDoro;

  setUp(() {
    blinkDoro = BlinkDoro();
  });

  tearDown(() {
    blinkDoro.dispose();
  });

  group('Timer Configuration', () {
    test('Default timer values are set correctly', () {
      expect(blinkDoro.pomodoroWorkTime, 90 * 60);
      expect(blinkDoro.pomodoroBreakTime, 25 * 60);
      expect(blinkDoro.pomodoroLongBreakTime, 60 * 60);
      expect(blinkDoro.pomodoroLongBreakInterval, 4);
    });

    test('Timer values can be modified', () {
      blinkDoro.pomodoroWorkTime = 45 * 60;
      blinkDoro.pomodoroBreakTime = 15 * 60;
      blinkDoro.pomodoroLongBreakTime = 30 * 60;
      blinkDoro.pomodoroLongBreakInterval = 2;

      expect(blinkDoro.pomodoroWorkTime, 45 * 60);
      expect(blinkDoro.pomodoroBreakTime, 15 * 60);
      expect(blinkDoro.pomodoroLongBreakTime, 30 * 60);
      expect(blinkDoro.pomodoroLongBreakInterval, 2);
    });
  });

  group('Timer Control', () {
    test('Timer starts correctly', () async {
      bool started = false;
      blinkDoro.onTick = (time) => started = true;
      
      blinkDoro.start();
      // Wait for the first tick
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(blinkDoro.isRunning, true);
      expect(started, true);
    });

    test('Timer pauses correctly', () {
      blinkDoro.start();
      blinkDoro.pause();
      expect(blinkDoro.isRunning, false);
    });

    test('Timer resumes correctly', () {
      blinkDoro.start();
      blinkDoro.pause();
      blinkDoro.resume();
      expect(blinkDoro.isRunning, true);
    });

    test('Timer resets correctly', () {
      blinkDoro.start();
      blinkDoro.reset();
      expect(blinkDoro.isRunning, false);
      expect(blinkDoro.currentTime, blinkDoro.pomodoroWorkTime);
      expect(blinkDoro.currentPomodoroCount, 0);
      expect(blinkDoro.currentRunType, 0);
    });

    test('Skip break works correctly', () {
      blinkDoro.start();
      // Force break state
      blinkDoro.currentRunType = 1;
      blinkDoro.skipBreak();
      expect(blinkDoro.currentRunType, 0);
      expect(blinkDoro.currentTime, blinkDoro.pomodoroWorkTime);
    });

    test('Cannot skip break during work', () {
      blinkDoro.start();
      final initialTime = blinkDoro.currentTime;
      blinkDoro.skipBreak();
      expect(blinkDoro.currentTime, initialTime);
    });
  });

  group('Session Transitions', () {
    test('Work to break transition', () {
      bool breakStarted = false;
      blinkDoro.onBreakComplete = () => breakStarted = true;
      
      blinkDoro.start();
      // Force work completion
      blinkDoro.currentTime = 0;
      blinkDoro.handleTimerComplete();
      
      expect(blinkDoro.currentRunType, 1);
      expect(breakStarted, true);
    });

    test('Break to work transition', () {
      bool workStarted = false;
      blinkDoro.onComplete = () => workStarted = true;
      
      blinkDoro.start();
      // Force break state and completion
      blinkDoro.currentRunType = 1;
      blinkDoro.currentTime = 0;
      blinkDoro.handleTimerComplete();
      
      expect(blinkDoro.currentRunType, 0);
      expect(workStarted, true);
    });

    test('Long break after interval', () {
      bool longBreakStarted = false;
      blinkDoro.onLongBreakComplete = () => longBreakStarted = true;
      
      blinkDoro.start();
      // Force work completion after interval
      blinkDoro.currentPomodoroCount = blinkDoro.pomodoroLongBreakInterval - 1;
      blinkDoro.currentTime = 0;
      blinkDoro.handleTimerComplete();
      
      expect(blinkDoro.currentRunType, 2);
      expect(longBreakStarted, true);
    });
  });

  group('Blink Reminder', () {
    test('Blink reminder triggers within range', () {
      bool blinkTriggered = false;
      blinkDoro.onBlink = (_) => blinkTriggered = true;
      
      blinkDoro.start();
      // Force blink trigger
      blinkDoro.triggerBlink();
      
      expect(blinkDoro.isBlinkActive, true);
      expect(blinkTriggered, true);
    });

    test('Blink reminder auto-dismisses', () async {
      blinkDoro.start();
      blinkDoro.triggerBlink();
      
      // Wait for blink interval
      await Future.delayed(Duration(seconds: blinkDoro.blinkInterval + 1));
      
      expect(blinkDoro.isBlinkActive, false);
    });

    test('Blink reminder respects running state', () async {
      bool blinkTriggered = false;
      blinkDoro.onBlink = (_) => blinkTriggered = true;
      
      blinkDoro.start();
      blinkDoro.pause();
      // Wait for any pending operations
      await Future.delayed(const Duration(milliseconds: 100));
      blinkDoro.triggerBlink();
      
      // Wait for blink state to update
      await Future.delayed(const Duration(milliseconds: 100));
      expect(blinkDoro.isBlinkActive, false);
      expect(blinkTriggered, false);
    });
  });

  group('Time Formatting', () {
    test('Time decrements correctly', () async {
      int lastTime = 0;
      blinkDoro.onTick = (time) => lastTime = time;
      
      blinkDoro.start();
      // Wait for a few seconds
      await Future.delayed(const Duration(seconds: 3));
      expect(lastTime, lessThan(blinkDoro.pomodoroWorkTime));
    });
  });
} 