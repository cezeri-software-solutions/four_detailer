import 'package:flutter/material.dart';
import 'package:four_detailer/core/extensions/context_extensions.dart';

class FieldTitle extends StatelessWidget {
  final String fieldTitle;
  final bool isMandatory;

  const FieldTitle({super.key, required this.fieldTitle, required this.isMandatory});

  @override
  Widget build(BuildContext context) {
    if (!isMandatory) {
      return Text(
        ' $fieldTitle',
        style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Row(
      children: [
        Text(
          ' $fieldTitle',
          style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text('*', maxLines: 1, style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.error)),
      ],
    );
  }
}
