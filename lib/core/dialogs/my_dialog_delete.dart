import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/core/core.dart';
import '../../constants.dart';

Future<void> showMyDialogDelete({
  required BuildContext context,
  String? title,
  String? content,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title ?? context.l10n.delete, style: context.textTheme.headlineLarge),
                  Gaps.h16,
                  Text(content ?? context.l10n.my_dialog_confirmDeleteContent, style: context.textTheme.bodyLarge, textAlign: TextAlign.center),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(onPressed: context.pop, child: Text(context.l10n.cancel)),
                      FilledButton(
                        onPressed: onConfirm,
                        style: FilledButton.styleFrom(backgroundColor: context.colorScheme.error),
                        child: Text(context.l10n.delete),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showMyDialogDeleteWolt({
  required BuildContext context,
  String? title,
  String? content,
  required VoidCallback onConfirm,
  bool canPop = true,
}) async {
  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasSabGradient: false,
          topBarTitle: Text(
            title ?? context.l10n.delete,
            style: context.textTheme.headlineMedium,
          ),
          isTopBarLayerAlwaysVisible: true,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  content ?? context.l10n.my_dialog_confirmDeleteContent,
                  style: context.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Gaps.h32,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: context.pop,
                      child: Text(context.l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        onConfirm();
                        context.pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colorScheme.error,
                      ),
                      child: Text(context.l10n.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (_) => WoltModalType.dialog(),
    onModalDismissedWithBarrierTap: canPop ? () => context.pop() : null,
    barrierDismissible: canPop,
  );
}
