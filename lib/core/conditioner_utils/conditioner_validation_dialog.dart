import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../constants.dart';

void showConditionerValidationDialog({required BuildContext context, required String firstName, required String lastName, String? company}) {
  final errorColor = context.colorScheme.error;
  final successColor = context.customColors.success;

  showMyDialogAlertCustom(
    context: context,
    title: context.l10n.danger,
    content: Column(
      children: [
        Text(context.l10n.user_data_mandatoryFields),
        Gaps.h24,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.firstName),
            firstName.isEmpty ? Icon(Icons.close, color: errorColor) : Icon(Icons.check, color: successColor),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.lastName),
            lastName.isEmpty ? Icon(Icons.close, color: errorColor) : Icon(Icons.check, color: successColor),
          ],
        ),
        if (company != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.company),
              company.isEmpty ? Icon(Icons.close, color: errorColor) : Icon(Icons.check, color: successColor),
            ],
          ),
      ],
    ),
  );
}
