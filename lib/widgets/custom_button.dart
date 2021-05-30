import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';

import 'package:log_book/utils/index.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final double constraints;
  final double iconSize;
  final double radius;
  final Color backgroundColor;

  const CustomButton({
    Key key,
    this.constraints: 20,
    this.iconSize: 10,
    this.radius: 7,
    this.icon,
    this.tooltip,
    this.onPressed,
    this.backgroundColor: bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return IconButton(
        tooltip: tooltip,
        splashRadius: 3,
        padding: EdgeInsets.zero,
        iconSize: sy(constraints),
        icon: Container(
          height: sy(constraints),
          width: sy(constraints),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Icon(
            icon,
            color: textColor,
            size: sy(iconSize),
          ),
        ),
        onPressed: onPressed,
      );
    });
  }
}
