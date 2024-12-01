import 'package:flutter/material.dart';

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
