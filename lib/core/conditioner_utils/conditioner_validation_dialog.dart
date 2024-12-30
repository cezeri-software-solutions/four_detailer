import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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

void showConditionerValidationDialogWolt({
  required BuildContext context,
  required String firstName,
  required String lastName,
  String? company,
}) {
  final errorColor = context.colorScheme.error;
  final successColor = context.customColors.success;

  WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          leadingNavBarWidget: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text(
              context.l10n.danger,
              style: context.textTheme.titleLarge,
            ),
          ),
          isTopBarLayerAlwaysVisible: true,
          child: Padding(
            padding: context.breakpoint.isMobile
                ? const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 106)
                : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 94),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
          ),
          stickyActionBar: Padding(
            padding: EdgeInsets.only(
              right: 12,
              left: 12,
              top: 12,
              bottom: context.breakpoint.isMobile ? 12 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: context.pop,
                  child: Text(context.l10n.ok),
                ),
              ],
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.alertDialog(),
  );
}

void showNewEmployeeValidationDialogWolt({
  required BuildContext context,
  required String firstName,
  required String lastName,
  required String email,
  required String password,
}) {
  final errorColor = context.colorScheme.error;
  final successColor = context.customColors.success;

  WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          leadingNavBarWidget: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text(
              context.l10n.danger,
              style: context.textTheme.titleLarge,
            ),
          ),
          isTopBarLayerAlwaysVisible: true,
          child: Padding(
            padding: context.breakpoint.isMobile
                ? const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 106)
                : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 94),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.email),
                    email.isEmpty ? Icon(Icons.close, color: errorColor) : Icon(Icons.check, color: successColor),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(context.l10n.emailValid)),
                    !EmailValidator.validate(email) ? Icon(Icons.close, color: errorColor) : Icon(Icons.check, color: successColor),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.password),
                    password.isEmpty ? Icon(Icons.close, color: errorColor) : Icon(Icons.check, color: successColor),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(context.l10n.passwordValid)),
                    password.length < 8 ? Icon(Icons.close, color: errorColor) : Icon(Icons.check, color: successColor),
                  ],
                ),
              ],
            ),
          ),
          stickyActionBar: Padding(
            padding: EdgeInsets.only(
              right: 12,
              left: 12,
              top: 12,
              bottom: context.breakpoint.isMobile ? 12 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: context.pop,
                  child: Text(context.l10n.ok),
                ),
              ],
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.alertDialog(),
  );
}
