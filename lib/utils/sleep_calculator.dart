class SleepCalculator {
  static const int _cycleMinutes = 90;
  static const int _fallAsleepMinutes = 15;
  static const int _numberOfSuggestions = 6;

  static List<DateTime> calculateBedtimes(DateTime wakeUpTime) {
    List<DateTime> bedtimes = [];

    for (int cycles = 4; cycles <= _numberOfSuggestions + 3; cycles++) {
      int totalMinutes = (cycles * _cycleMinutes) + _fallAsleepMinutes;
      DateTime bedtime = wakeUpTime.subtract(Duration(minutes: totalMinutes));
      bedtimes.add(bedtime);
    }

    return bedtimes.reversed.toList();
  }

  static List<DateTime> calculateWakeUpTimes(DateTime bedTime) {
    List<DateTime> wakeUpTimes = [];
    DateTime sleepTime = bedTime.add(
      const Duration(minutes: _fallAsleepMinutes),
    );

    for (int cycles = 4; cycles <= _numberOfSuggestions + 3; cycles++) {
      int totalMinutes = cycles * _cycleMinutes;
      DateTime wakeUpTime = sleepTime.add(Duration(minutes: totalMinutes));
      wakeUpTimes.add(wakeUpTime);
    }

    return wakeUpTimes;
  }

  static String formatTime(DateTime time) {
    String period = time.hour >= 12 ? 'PM' : 'AM';
    int hour = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  static int getCycleCount(DateTime start, DateTime end, bool isBedtime) {
    int totalMinutes;
    if (isBedtime) {
      totalMinutes = end.difference(start).inMinutes - _fallAsleepMinutes;
    } else {
      totalMinutes = end
          .difference(start.add(Duration(minutes: _fallAsleepMinutes)))
          .inMinutes;
    }
    return (totalMinutes / _cycleMinutes).round();
  }
}
