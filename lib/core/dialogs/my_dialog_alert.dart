import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../constants.dart';

Future<void> showMyDialogAlert({required BuildContext context, required String title, required String content, bool canPop = true}) async {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_rounded, color: context.colorScheme.error, size: 32),
                      Gaps.w10,
                      Text(title, style: context.textTheme.headlineLarge),
                    ],
                  ),
                  Gaps.h24,
                  Text(content, style: context.textTheme.titleMedium, textAlign: TextAlign.center),
                  Gaps.h32,
                  SizedBox(width: 140, child: FilledButton(onPressed: context.pop, child: Text(context.l10n.ok))),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showMyDialogAlertCustom({required BuildContext context, required String title, required Widget content, bool canPop = true}) async {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_rounded, color: context.colorScheme.error, size: 32),
                      Gaps.w10,
                      Text(title, style: context.textTheme.headlineLarge),
                    ],
                  ),
                  Gaps.h24,
                  content,
                  Gaps.h32,
                  SizedBox(width: 140, child: FilledButton(onPressed: context.pop, child: Text(context.l10n.ok))),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
