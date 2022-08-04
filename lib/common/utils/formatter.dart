import 'package:timezone/timezone.dart' as tz;

String centsToDollars(int? cents) {
  return cents != null ? '\$${(cents.ceil() / 100).toStringAsFixed(2)}' : '';
}

DateTime timestampToDate(int timestamp, [String? timeZone]) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);

  if (timeZone == null) {
    return dateTime;
  }

  final pacificTimeZone = tz.getLocation(timeZone);
  return tz.TZDateTime.from(dateTime, pacificTimeZone);
}
