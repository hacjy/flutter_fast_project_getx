class DateCountDownUtil {
  static String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  static String constructFirstTime(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    int hour = seconds ~/ 3600 % 24;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day != 0) {
      return formatTime(day) +
          ':' +
          formatTime(hour) +
          ":" +
          formatTime(minute) +
          ":" +
          formatTime(second);
    } else if (hour != 0) {
      return formatTime(hour) +
          ":" +
          formatTime(minute) +
          ":" +
          formatTime(second);
    } else if (minute != 0) {
      return formatTime(minute) + ":" + formatTime(second);
    } else if (second != 0) {
      return formatTime(second);
    } else {
      return '';
    }
  }

  static String constructTime(int seconds) {
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(minute) + ":" + formatTime(second);
  }
}
