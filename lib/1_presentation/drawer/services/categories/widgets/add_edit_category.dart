import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/categories_overview/categories_overview_bloc.dart';
import '/3_domain/models/models.dart';
import '/core/core.dart';
import '../../widgets/widgets.dart';

void showAddEditCategorySheet({
  required BuildContext context,
  required CategoriesOverviewBloc categoriesOverviewBloc,
  Category? category,
  String? infoText,
}) {
  final titleController = TextEditingController(text: category?.title ?? '');
  final descriptionController = TextEditingController(text: category?.description ?? '');
  final formKey = GlobalKey<FormState>();

  WoltModalSheet.show<void>(
    context: context,
    barrierDismissible: true,
    useSafeArea: true,
    showDragHandle: false,
    pageListBuilder: (context) {
      return [
        getTitleDescriptionWoltPage(
          context: context,
          formKey: formKey,
          titleController: titleController,
          descriptionController: descriptionController,
          title: category == null ? context.l10n.categories_overview_createCategory : context.l10n.categories_overview_editCategory,
          onSave: () {
            if (formKey.currentState!.validate()) {
              if (category == null) {
                categoriesOverviewBloc.add(
                  CreateCategoryEvent(
                    category: Category.empty().copyWith(title: titleController.text, description: descriptionController.text),
                  ),
                );
              } else {
                categoriesOverviewBloc.add(
                  UpdateCategoryEvent(category: category.copyWith(title: titleController.text, description: descriptionController.text)),
                );
              }
              context.pop();
              if (category != null) showMyDialogLoadingWolt(context: context, text: context.l10n.categories_overview_loadingOnUpdate);
            }
          },
          infoText: infoText,
        ),
      ];
    },
  );
}
