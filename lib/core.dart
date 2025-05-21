// async
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class BlinkDoro {
  /**
   * a pomodoro timer with interval callbacks for blinks
   * 
  */

  /// SECTION
  /// pomodoro component
  /// in seconds
  int pomodoroWorkTime = 90 * 60;
  int pomodoroBreakTime = 25 * 60;
  int pomodoroLongBreakTime = 60 * 60;
  int pomodoroLongBreakInterval = 4;

  //timer
  Timer? _timer;
  Timer? _blinkTimer;
  int _currentTime = 0;
  int _currentRunType = 0; // 0: work, 1: break, 2: long break
  int _currentPomodoroCount = 0;
  bool _isRunning = false;
  bool _isBlinkActive = false;

  //callbacks
  Function(int)? onTick;
  Function()? onComplete;
  Function()? onBreakComplete;
  Function()? onLongBreakComplete;
  Function(BlinkDoro)? onBlink;
  /// !SECTION
  /// SECTION blink
  // random low and high interval to trigger blink callback
  int blinkRangeLow = 5 * 60;
  int blinkRangeHigh = 10 * 60;
  // how many seconds to blink
  int blinkInterval = 10;

  //constructor
  BlinkDoro({
    this.onTick,
    this.onComplete,
    this.onBreakComplete,
    this.onLongBreakComplete,
    this.onBlink,
  }) {
    _currentTime = pomodoroWorkTime;
  }

  // Timer control methods
  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _currentTime = _getCurrentDuration();
    _startTimer();
    _scheduleNextBlink();
    // Trigger initial tick
    onTick?.call(_currentTime);
  }

  void pause() {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();
    _blinkTimer?.cancel();
    _isBlinkActive = false;
  }

  void resume() {
    if (_isRunning) return;
    _isRunning = true;
    _startTimer();
    _scheduleNextBlink();
  }

  void reset() {
    pause();
    _currentTime = _getCurrentDuration();
    _currentPomodoroCount = 0;
    _currentRunType = 0;
    onTick?.call(_currentTime);
  }

  void skipBreak() {
    if (_currentRunType == 0) return; // Can't skip during work
    _currentRunType = 0;
    _currentTime = pomodoroWorkTime;
    onTick?.call(_currentTime);
  }

  // Helper methods
  int _getCurrentDuration() {
    switch (_currentRunType) {
      case 0:
        return pomodoroWorkTime;
      case 1:
        return pomodoroBreakTime;
      case 2:
        return pomodoroLongBreakTime;
      default:
        return pomodoroWorkTime;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        _currentTime--;
        onTick?.call(_currentTime);
      } else {
        _handleTimerComplete();
      }
    });
  }

  void _handleTimerComplete() {
    _timer?.cancel();
    switch (_currentRunType) {
      case 0: // Work completed
        _currentPomodoroCount++;
        if (_currentPomodoroCount % pomodoroLongBreakInterval == 0) {
          _currentRunType = 2; // Long break
          onLongBreakComplete?.call();
        } else {
          _currentRunType = 1; // Regular break
          onBreakComplete?.call();
        }
        break;
      case 1: // Break completed
      case 2: // Long break completed
        _currentRunType = 0; // Back to work
        onComplete?.call();
        break;
    }
    _currentTime = _getCurrentDuration();
    onTick?.call(_currentTime);
  }

  // Blink reminder methods
  void _scheduleNextBlink() {
    if (!_isRunning || _isBlinkActive) return;
    
    final random = Random();
    final nextBlink = blinkRangeLow + 
        random.nextInt(blinkRangeHigh - blinkRangeLow);
    
    _blinkTimer?.cancel();
    _blinkTimer = Timer(Duration(seconds: nextBlink), () {
      if (_isRunning && !_isBlinkActive) {
        _triggerBlink();
      }
    });
  }

  void _triggerBlink() {
    if (!_isRunning) return;
    _isBlinkActive = true;
    onBlink?.call(this);
    
    // Schedule blink end
    Timer(Duration(seconds: blinkInterval), () {
      _isBlinkActive = false;
      _scheduleNextBlink();
    });
  }

  // Getters for current state
  bool get isRunning => _isRunning;
  bool get isBlinkActive => _isBlinkActive;
  int get currentTime => _currentTime;
  int get currentRunType => _currentRunType;
  int get currentPomodoroCount => _currentPomodoroCount;

  // Setters for testing
  @visibleForTesting
  set currentTime(int value) => _currentTime = value;
  @visibleForTesting
  set currentRunType(int value) => _currentRunType = value;
  @visibleForTesting
  set currentPomodoroCount(int value) => _currentPomodoroCount = value;
  @visibleForTesting
  void handleTimerComplete() => _handleTimerComplete();
  @visibleForTesting
  void triggerBlink() => _triggerBlink();

  // Cleanup
  void dispose() {
    _timer?.cancel();
    _blinkTimer?.cancel();
  }

  void updateConfig(Map<String, int> newConfig) {
    // Update configuration values
    pomodoroWorkTime = newConfig['workDuration'] ?? pomodoroWorkTime;
    pomodoroBreakTime = newConfig['shortBreak'] ?? pomodoroBreakTime;
    pomodoroLongBreakTime = newConfig['longBreak'] ?? pomodoroLongBreakTime;
    pomodoroLongBreakInterval = newConfig['sessionsUntilLongBreak'] ?? pomodoroLongBreakInterval;
    blinkRangeLow = newConfig['minBlinkInterval'] ?? blinkRangeLow;
    blinkRangeHigh = newConfig['maxBlinkInterval'] ?? blinkRangeHigh;
    blinkInterval = newConfig['blinkDuration'] ?? blinkInterval;

    // If timer is not running, update the current duration
    if (!isRunning) {
      _currentTime = pomodoroWorkTime;
      onTick?.call(_currentTime);
    }
  }
}