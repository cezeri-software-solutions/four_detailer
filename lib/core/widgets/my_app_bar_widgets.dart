import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/core/core.dart';

class MyAppBarTitle extends StatelessWidget {
  final String title;
  const MyAppBarTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    if (context.breakpoint.isMobile) return Text(title);

    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Text(title),
    );
  }
}

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
