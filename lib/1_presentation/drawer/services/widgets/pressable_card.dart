import 'package:flutter/material.dart';

import '/constants.dart';
import '/core/core.dart';

class PressableCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const PressableCard({required this.title, required this.description, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (description.isNotEmpty) ...[
                      Gaps.h4,
                      Text(description, style: TextStyle(color: context.colorScheme.outline), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.drag_handle),
            ],
          ),
        ),
      ),
    );
  }
}
