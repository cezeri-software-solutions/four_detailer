import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/core/core.dart';

class MyAppBarActionSaveButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback onPressed;

  const MyAppBarActionSaveButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    if (isMobile) {
      return IconButton(onPressed: isLoading ? null : onPressed, icon: Icon(Icons.save, color: context.colorScheme.primary));
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.primary,
            foregroundColor: context.colorScheme.onPrimary,
          ),
          child: isLoading ? const CircularProgressIndicator.adaptive() : Text(label ?? context.l10n.save),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
