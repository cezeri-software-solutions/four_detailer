import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../constants.dart';

Future<void> showMyDialogInfo({
  required BuildContext context,
  required String title,
  required String content,
  bool canPop = true,
  bool showButton = true,
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
                  Text(title, style: context.textTheme.headlineLarge),
                  Gaps.h24,
                  Text(content, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                  if (showButton) ...[
                    Gaps.h32,
                    SizedBox(width: 140, child: FilledButton(onPressed: context.pop, child: Text(context.l10n.ok))),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
