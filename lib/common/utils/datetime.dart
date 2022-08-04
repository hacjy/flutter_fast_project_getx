import 'package:intl/intl.dart';

extension DateTimeInt on int {
  String hmStr(int offset) {
    final date = DateTime.fromMillisecondsSinceEpoch(this, isUtc: true)
        .add(Duration(milliseconds: offset));
    return '${date.hour < 10 ? '0${date.hour}' : date.hour}:${date.minute < 10 ? '0${date.minute}' : date.minute}';
  }

  String get ymdhmsStrUtc {
    final date = DateTime.fromMillisecondsSinceEpoch(this, isUtc: true);
    // date.toUtc()
    return date.toString();
  }
}

extension DateTimeFormate on DateTime {
  ///如5/19/2022 16:40
  // ignore: non_constant_identifier_names
  String MdyHm() =>
      '${DateFormat.yMd().format(this)}  ${DateFormat.Hm().format(this)}';
}

extension DateTimeStrFormate on String {
  ///时间转时间戳
  int hmsTs() => hmsDate().millisecondsSinceEpoch;
  int hmsTsTomorrow() => hmsDateTomorrow().millisecondsSinceEpoch;

  ///时间字符串转日期 "12:00:00" -> "2022-05-19 12:00:00"

  DateTime hmsDate() => DateFormat('yyyy-MM-dd HH:mm:ss').parse(
        hmsDateStr(),
        true,
      );
  DateTime hmsDateTomorrow() => DateFormat('yyyy-MM-dd HH:mm:ss').parse(
        hmsDateTomorrowStr(),
        true,
      );

  ///时间字符串转日期 "12:00:00" -> "2022-05-19 12:00:00"
  String hmsDateStr() => DateTimeUtil.dateUtcStrNow + ' ' + this;
  String hmsDateTomorrowStr() => DateTimeUtil.dateUtcStrTomorrow + ' ' + this;
}

class DateTimeUtil {
  static String get dateUtcStrNow =>
      DateTime.now().toUtc().toString().split(' ')[0];

  static String get dateUtcStrTomorrow =>
      DateTime.now().add(Duration(days: 1)).toUtc().toString().split(' ')[0];

  ///当前时间字符串，如"12:00:00"
  static String hmsStrNow() => DateFormat.Hms().format(DateTime.now());

  static List<int> getTimePoints({
    required int start,
    required int end,
    required int nowTs,
  }) {
    List<int> res = [];
    final now = nowTs;
    if (now > end) return [];
    if (now > start) start = now;

    final startMin = DateTime.fromMillisecondsSinceEpoch(
      start,
      isUtc: true,
    ).minute;
    for (int i = 1; i < 4; i++) {
      if (startMin < i * 20) {
        start += Duration(minutes: (i * 20 - startMin)).inMilliseconds;
        break;
      }
    }
    for (int i = start; i < end; i += Duration(minutes: 20).inMilliseconds) {
      res.add(i);
    }
    res.sort((a, b) => a.compareTo(b));
    return res;
  }
}
