import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/core/core.dart';

Future<void> showMyDialogLoading({required BuildContext context, String? text, bool canPop = false}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: canPop,
    builder: (_) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60, width: 60, child: MyLoadingIndicator()),
                if (text != null && text.isNotEmpty) ...[
                  const SizedBox(height: 38),
                  Text(text, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showMyDialogLoadingWolt({
  required BuildContext context,
  String? text,
  bool canPop = false,
}) async {
  await WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: PopScope(
            canPop: canPop,
            child: SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60, width: 60, child: MyLoadingIndicator()),
                    if (text != null && text.isNotEmpty) ...[
                      const SizedBox(height: 38),
                      Text(text, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
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
