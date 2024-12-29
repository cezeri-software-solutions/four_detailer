import 'package:flutter/widgets.dart';

import '../core.dart';

class MyFilledLoadingContainer extends StatelessWidget {
  const MyFilledLoadingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(color: context.colorScheme.scrim.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(14)),
        child: Center(
          child: Container(
            height: 140,
            width: 200,
            decoration: BoxDecoration(color: context.colorScheme.surface, borderRadius: BorderRadius.circular(14)),
            child: const Center(child: MyLoadingIndicator()),
          ),
        ),
      ),
    );
  }
}
