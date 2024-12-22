import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/core/core.dart';

class MyAppBarActionAddButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool? isLoading;
  final VoidCallback onPressed;

  const MyAppBarActionAddButton({
    super.key,
    required this.onPressed,
    this.isLoading,
    this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    if (isMobile) {
      return IconButton(
        onPressed: (isLoading != null && isLoading! == true) ? null : onPressed,
        icon: Icon(Icons.add, color: context.customColors.success),
      );
    }

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: (isLoading != null && isLoading! == true) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.customColors.success,
            foregroundColor: context.customColors.onSuccess,
          ),
          label: (isLoading != null && isLoading! == true) ? const CircularProgressIndicator.adaptive() : Text(label ?? context.l10n.neww),
          icon: Icon(icon ?? Icons.add, color: context.customColors.onSuccess),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
