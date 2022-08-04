import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ImagePath {
  static const String prefix = 'assets/img';

  static const String facebook = '$prefix/login_facebook.png';
  static const String google = '$prefix/login_google.png';
  static const String apple = '$prefix/login_apple.png';

  static Widget svg(
      {String assetName = '',
      color = Colors.black,
      String? semanticsLabel = ''}) {
    return SvgPicture.asset(
      assetName,
      semanticsLabel: semanticsLabel,
      color: color,
    );
  }
}
