import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  String source;
  double radius;
  double? borderWidth,
      badgeSize,
      badgeBorderWidth,
      badgePositionLeft,
      badgePositionRight,
      badgePositionTop,
      badgePositionBottom;
  String? placeHoldeAsset;
  GestureTapCallback? onBadgeTap;
  GestureTapCallback? onImageTap;
  Color? borderColor, badgeBgColor, badgeBorderColor;
  Widget? badge;
  CircularImage({
    Key? key,
    required this.source,
    this.radius = 25,
    this.placeHoldeAsset,
    this.borderWidth,
    this.onBadgeTap,
    this.onImageTap,
    this.borderColor,
    this.badgeSize,
    this.badge,
    this.badgeBgColor = Colors.white,
    this.badgeBorderWidth,
    this.badgeBorderColor = Colors.black,
    this.badgePositionLeft,
    this.badgePositionRight = 20,
    this.badgePositionTop,
    this.badgePositionBottom = 20,
  }) : super(key: key);

  Widget get defaultIcon => Image.asset(
        'assets/img/no_pcture.png',
        width: radius,
        height: radius,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: badge == null ? null : (radius + 8) * 2,
      width: badge == null ? null : (radius + 8) * 2,
      child: Stack(children: [
        Container(
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: borderWidth == null
                  ? null
                  : Border.all(
                      width: borderWidth ?? 1,
                      color: borderColor ?? Colors.white)),
          child: GestureDetector(
            onTap: onImageTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: source.startsWith('http')
                  ? Image.network(
                      source,
                      height: radius * 2,
                      width: radius * 2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) {
                        if (placeHoldeAsset != null &&
                            placeHoldeAsset!.isNotEmpty) {
                          return Image.asset(
                            source,
                            height: radius * 2,
                            width: radius * 2,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, __) {
                              return defaultIcon;
                            },
                          );
                        }
                        return defaultIcon;
                      },
                    )
                  : Image.asset(
                      source,
                      height: radius * 2,
                      width: radius * 2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) {
                        if (placeHoldeAsset != null &&
                            placeHoldeAsset!.isNotEmpty) {
                          return Image.asset(
                            source,
                            height: radius * 2,
                            width: radius * 2,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, __) {
                              return defaultIcon;
                            },
                          );
                        }

                        return defaultIcon;
                      },
                    ),
            ),
          ),
        ),
        badge == null
            ? const SizedBox(
                height: 0,
                width: 0,
              )
            : Positioned(
                left: badgePositionLeft,
                right: badgePositionRight,
                top: badgePositionTop,
                bottom: badgePositionBottom,
                child: GestureDetector(
                  onTap: onBadgeTap,
                  child: Container(
                      height: badgeSize ?? 25,
                      width: badgeSize ?? 25,
                      decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius:
                              BorderRadius.circular(badgeSize ?? 25 / 2),
                          border: badgeBorderWidth == null
                              ? null
                              : Border.all(
                                  width: badgeBorderWidth ?? 1,
                                  color: badgeBorderColor ?? Colors.black)),
                      child: Center(child: badge)),
                ),
              )
      ]),
    );
  }
}
