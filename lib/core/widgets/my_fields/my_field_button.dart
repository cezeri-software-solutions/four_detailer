import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../core.dart';

class MyFieldButton extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final Widget? trailing;
  final String? fieldTitle;
  final bool? isMandatory;
  final bool readOnly;
  final bool filled;
  final VoidCallback? onTap;
  final VoidCallback? onTrailingTap;

  const MyFieldButton({
    super.key,
    required this.child,
    this.maxWidth,
    this.trailing,
    this.fieldTitle,
    this.isMandatory = false,
    this.readOnly = false,
    this.filled = false,
    this.onTap,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fieldTitle != null) FieldTitle(fieldTitle: fieldTitle!, isMandatory: isMandatory!),
        InkWell(
          onTap: onTap,
          child: Container(
            // height: 32,
            width: maxWidth ?? double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: isDesktop ? 4 : 4),
            decoration: BoxDecoration(
              color: onTap == null || readOnly ? context.colorScheme.surfaceContainerHighest : context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: context.colorScheme.surfaceContainerLow),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: child),
                trailing != null ? Flexible(child: GestureDetector(onTap: onTrailingTap, child: trailing!)) : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
