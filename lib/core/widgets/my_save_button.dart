import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/core/core.dart';

class MySaveButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const MySaveButton({super.key, required this.label, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    if (isMobile) {
      return IconButton(onPressed: isLoading ? null : onPressed, icon: Icon(Icons.save, color: context.customColors.success));
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading ? const CircularProgressIndicator.adaptive() : Text(label),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
