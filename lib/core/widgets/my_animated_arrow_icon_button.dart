import 'dart:math';

import 'package:flutter/material.dart';

import '/core/core.dart';

class MyAnimatedIconButtonArrow extends StatelessWidget {
  final bool boolValue;
  final void Function() onPressed;
  final Color? collapsedColor;
  final Color? expandedColor;
  final double? iconSize;

  const MyAnimatedIconButtonArrow({
    super.key,
    required this.boolValue,
    required this.onPressed,
    this.collapsedColor = Colors.grey,
    this.expandedColor,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    final expandedColor = this.expandedColor ?? context.colorScheme.primary;

    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: switch (boolValue) {
        true => Icon(Icons.arrow_drop_down_circle, size: iconSize, color: expandedColor),
        false => Transform.rotate(
            angle: -pi / 2,
            child: Icon(Icons.arrow_drop_down_circle, size: iconSize, color: collapsedColor, grade: 25),
          ),
      },
    );
  }
}
