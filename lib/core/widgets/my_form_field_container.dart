import 'package:flutter/material.dart';

class MyFormFieldContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? borderColor;

  const MyFormFieldContainer({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.height,
    this.width,
    this.borderRadius = 14,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final themeData = Theme.of(context);

    return SizedBox(
      width: width ?? (screenWidth > 600 ? 600 : screenWidth),
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.transparent),
          color: themeData.colorScheme.surfaceContainerLowest, //Colors.blueGrey[50],
          borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
        ),
        child: child,
      ),
    );
  }
}
