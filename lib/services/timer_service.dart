import 'dart:async';

class TimerService {
  late Timer _timer;
  int _remainingSeconds;
  final Function(int) onTick;
  final Function() onComplete;
  bool _isRunning = false;
  
  TimerService({
    required int durationInSeconds,
    required this.onTick,
    required this.onComplete,
  }) : _remainingSeconds = durationInSeconds;
  
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  
  void start() {
    if (_isRunning) return;
    
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        onTick(_remainingSeconds);
      } else {
        stop();
        onComplete();
      }
    });
  }
  
  void stop() {
    if (_isRunning) {
      _timer.cancel();
      _isRunning = false;
    }
  }
  
  void reset(int durationInSeconds) {
    stop();
    _remainingSeconds = durationInSeconds;
  }
  
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
  }
}