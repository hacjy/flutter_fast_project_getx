import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class ZeroNetworkImage extends StatelessWidget {
  const ZeroNetworkImage({
    Key? key,
    required this.width,
    required this.height,
    this.url,
  }) : super(key: key);
  final double width;
  final double height;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final url = this.url ?? '';
    if (url == '' || !RegexUtil.isURL(url) || url == 'null') {
      return Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        child: Image.asset(
          'assets/img/no_pcture.png',
          width: width,
          height: height,
        ),
      );
    }

    return CachedNetworkImage(
      placeholder: (context, url) => const CircularProgressIndicator(),
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
