import 'package:flutter/material.dart';

import '/core/core.dart';

class MyLoadingDialog extends StatelessWidget {
  const MyLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 220,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHigh.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: MyLoadingIndicator()),
    );
  }
}

class MyLoadingIndicator extends StatefulWidget {
  const MyLoadingIndicator({super.key});

  @override
  State<MyLoadingIndicator> createState() => _MyLoadingIndicatorState();
}

class _MyLoadingIndicatorState extends State<MyLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final double containerSize = 60;
  final double logoSize = 40;

  @override
  Widget build(BuildContext context) {
    final isLightMode = context.brightness == Brightness.light;

    return Stack(
      children: [
        SizedBox(
          height: containerSize,
          width: containerSize,
          child: Center(
            child: Image.asset(
              isLightMode ? 'assets/logo/logo_black.png' : 'assets/logo/logo_white.png',
              width: logoSize,
              height: logoSize,
            ),
          ),
        ),
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
          child: SizedBox(
            width: containerSize,
            height: containerSize,
            child: const CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 6,
            ),
          ),
        ),
      ],
    );
  }
}
