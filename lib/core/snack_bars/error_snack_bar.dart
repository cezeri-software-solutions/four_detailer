import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../constants.dart';

void showErrorSnackbar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      // behavior: SnackBarBehavior.floating,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: context.colorScheme.error, shape: BoxShape.circle),
            child: Center(child: Icon(Icons.priority_high_outlined, color: context.colorScheme.surface, size: 14)),
          ),
          Gaps.w8,
          Expanded(child: Text(text)),
        ],
      ),
    ),
  );
}
