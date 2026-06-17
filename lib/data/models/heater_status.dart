/// Heater operating mode.
enum HeaterMode { auto, manual, off }

/// Heater status for condensation prevention.
class HeaterStatus {
  final HeaterMode mode;
  final bool isActive;
  final Duration cycleInterval;   // 30 minutes
  final Duration activeDuration;  // 20 seconds
  final Duration? timeToNextCycle;
  final Duration totalRuntime;
  final int cyclesCompleted;
  final DateTime? lastActivation;

  const HeaterStatus({
    this.mode = HeaterMode.auto,
    this.isActive = false,
    this.cycleInterval = const Duration(minutes: 30),
    this.activeDuration = const Duration(seconds: 20),
    this.timeToNextCycle,
    this.totalRuntime = Duration.zero,
    this.cyclesCompleted = 0,
    this.lastActivation,
  });

  HeaterStatus copyWith({
    HeaterMode? mode,
    bool? isActive,
    Duration? timeToNextCycle,
    Duration? totalRuntime,
    int? cyclesCompleted,
    DateTime? lastActivation,
  }) {
    return HeaterStatus(
      mode: mode ?? this.mode,
      isActive: isActive ?? this.isActive,
      cycleInterval: cycleInterval,
      activeDuration: activeDuration,
      timeToNextCycle: timeToNextCycle ?? this.timeToNextCycle,
      totalRuntime: totalRuntime ?? this.totalRuntime,
      cyclesCompleted: cyclesCompleted ?? this.cyclesCompleted,
      lastActivation: lastActivation ?? this.lastActivation,
    );
  }

  /// Status display text
  String get statusText => isActive ? 'Active' : 'Idle';

  /// Mode display text
  String get modeText {
    switch (mode) {
      case HeaterMode.auto:
        return 'Auto';
      case HeaterMode.manual:
        return 'Manual';
      case HeaterMode.off:
        return 'Off';
    }
  }
}
