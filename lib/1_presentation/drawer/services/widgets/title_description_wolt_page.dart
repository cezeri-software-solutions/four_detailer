import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/constants.dart';
import '/core/core.dart';

WoltModalSheetPage getTitleDescriptionWoltPage({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required TextEditingController descriptionController,
  required String title,
  required VoidCallback onSave,
  VoidCallback? onDelete,
  required String? infoText,
}) {
  return WoltModalSheetPage(
    hasTopBarLayer: true,
    leadingNavBarWidget: Padding(
      padding: const EdgeInsets.only(left: 16, top: 20),
      child: Text(title, style: context.textTheme.titleLarge),
    ),
    isTopBarLayerAlwaysVisible: true,
    child: Padding(
      padding: context.breakpoint.isMobile
          ? const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 106)
          : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 94),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (infoText != null && infoText.isNotEmpty) ...[
              Text(infoText, style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline)),
              Gaps.h16,
            ],
            MyTextFormField(
              controller: titleController,
              fieldTitle: context.l10n.categories_overview_categoryTitle,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.isEmpty) return context.l10n.mandatory;
                return null;
              },
            ),
            Gaps.h16,
            MyTextFormField(
              controller: descriptionController,
              fieldTitle: context.l10n.categories_overview_categoryDescription,
              textCapitalization: TextCapitalization.sentences,
              minLines: 4,
              maxLines: null,
            ),
          ],
        ),
      ),
    ),
    stickyActionBar: Padding(
      padding: EdgeInsets.only(right: 12, left: 12, top: 12, bottom: context.breakpoint.isMobile ? 12 : 16),
      child: Row(
        mainAxisAlignment: onDelete != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
        children: [
          if (onDelete != null) IconButton(onPressed: onDelete, icon: Icon(Icons.delete, color: context.colorScheme.error)),
          Row(
            children: [
              OutlinedButton(
                onPressed: context.pop,
                child: Text(context.l10n.cancel),
              ),
              Gaps.w12,
              FilledButton(
                onPressed: onSave,
                style: FilledButton.styleFrom(backgroundColor: context.customColors.success),
                child: Text(context.l10n.save),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
