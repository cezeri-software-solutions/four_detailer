import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../constants.dart';

Future<void> showMyDialogNotImplemented({
  required BuildContext context,
  String? title,
  String? content,
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
                  Text(title ?? context.l10n.danger, style: context.textTheme.headlineLarge),
                  Gaps.h16,
                  Text(content ?? context.l10n.my_dialog_notImplementedYet, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                  Gaps.h32,
                  FilledButton(onPressed: context.pop, child: Text(context.l10n.ok)),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
