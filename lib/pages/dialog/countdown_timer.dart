import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'date_countdown_util.dart';

class CountDownTimer extends StatefulWidget {
  /// Length of the timer
  final int seconds;
  final TextStyle? style;
  final Function? onCompleted;
  final bool? isDate;

  const CountDownTimer(
      {Key? key,
      required this.seconds,
      this.style,
      this.onCompleted,
      this.isDate})
      : super(key: key);

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  final Duration interval = const Duration(seconds: 1);

  // Timer
  Timer? _timer;
  // Current seconds
  late int _currentSeconds;

  @override
  Widget build(BuildContext context) {
    return widget.isDate == true ? buildDateView() : buildNumView();
  }

  Widget buildNumView() {
    var num = _currentSeconds / interval.inSeconds;
    return Text(
      num <= 0 ? '' : ' (${num.toStringAsFixed(0)}s) ',
      style: widget.style ?? TextStyle(fontSize: 24.sp, color: Colors.white),
    );
  }

  Widget buildDateView() {
    int computingTime = int.parse((_currentSeconds).toString());
    String computingTimeDate =
        DateCountDownUtil.constructFirstTime(computingTime);
    return Text(
      computingTimeDate.isEmpty ? '' : ' (${computingTimeDate} Left) ',
      style: widget.style ?? TextStyle(fontSize: 24.sp, color: Colors.white),
    );
  }

  @override
  void initState() {
    _currentSeconds = widget.seconds * interval.inSeconds;
    if (widget.isDate == true) {
      DateTime now = DateTime.now();
      DateTime endTimeDate =
      DateTime.fromMillisecondsSinceEpoch(_currentSeconds*1000);
      Duration difference = endTimeDate.difference(now);
      int computingTime = difference.inSeconds;
      _currentSeconds = computingTime * interval.inSeconds;
    }
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }

    super.dispose();
  }

  void _onTimerPaused() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
  }

  void _onTimerResumed() {
    _startTimer();
  }

  void _onTimerRestart() {
    setState(() {
      _currentSeconds = widget.seconds * interval.inSeconds;
    });

    _startTimer();
  }

  void _startTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }

    if (_currentSeconds != 0) {
      _timer = Timer.periodic(interval, (Timer timer) {
        if (_currentSeconds <= 0) {
          timer.cancel();
          if (widget.onCompleted != null) {
            widget.onCompleted!();
          }
        }
        setState(() {
          _currentSeconds = _currentSeconds - interval.inSeconds;
        });
      });
    }
  }
}
