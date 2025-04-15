import 'dart:async';
import 'dart:math';

class DonationSimulator {
  final int initialUsers;
  final double growthRate; // Average daily growth rate (e.g., 0.02 for 2% growth)
  final Duration interval;
  final double speedMultiplier; // Multiplier to adjust simulation speed

  final List<Timer> _timers = [];
  final Random _random = Random();
  final List<void Function(double donation, int users)> _listeners = [];
  double _currentTotalDonations = 0.0;
  int _currentUsers;

  double get currentTotalDonations => _currentTotalDonations;
  int get currentUsers => _currentUsers;

  DonationSimulator({
    this.initialUsers = 300, // Default to a few hundred users
    this.growthRate = 0.02, // Default 2% daily growth
    this.interval = const Duration(days: 1), // Simulate daily donations
    this.speedMultiplier = 1.0, // Default to normal speed
  }) : _currentUsers = initialUsers {
    _currentTotalDonations = _currentUsers * 10.0 * _random.nextInt(max(1, 5)); // Each user donates a random amount between 1 and 10
  }

  void start() {
    _scheduleNextDay();
  }

  void _scheduleNextDay() {
    // Simulate donations for the current number of users
    for (int i = 0; i < _currentUsers; i++) {
      final scaledInterval = (interval.inMilliseconds / speedMultiplier).round();
      final randomDelay = Duration(milliseconds: _random.nextInt(scaledInterval));
      final timer = Timer(randomDelay, () {
        _currentTotalDonations += 10.0; // Each user donates a fixed amount of 10.0
        for (final listener in _listeners) {
          listener(_currentTotalDonations, _currentUsers);
        }
      });
      _timers.add(timer);
    }

    // Update the number of users with some variation and steady growth
    _currentUsers += (_currentUsers * growthRate).round() +
        _random.nextInt(10) - 5; // Add random variation (-5 to +5 users)

    // Schedule the next day's donations
    Timer(Duration(milliseconds: (interval.inMilliseconds / speedMultiplier).round()), _scheduleNextDay);
  }

  void stop() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  void addListener(void Function(double donation, int users) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(double donation, int users) listener) {
    _listeners.remove(listener);
  }

  void Function() subscribe(void Function(double donation, int users) listener) {
    addListener(listener);
    return () => unsubscribe(listener);
  }

  void unsubscribe(void Function(double donation, int users) listener) {
    removeListener(listener);
  }
}
