import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/3_domain/models/models.dart';
import '/core/core.dart';
import '../../../../../2_application/template_services/template_services_bloc.dart';
import '../../widgets/widgets.dart';

void showAddEditTemplateServiceItemSheet({
  required BuildContext context,
  required TemplateServicesBloc templateServicesBloc,
  required TemplateService templateService,
  TemplateServiceItem? templateServiceItem,
  String? infoText,
}) {
  final titleController = TextEditingController(text: templateServiceItem?.name ?? '');
  final descriptionController = TextEditingController(text: templateServiceItem?.description ?? '');
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
          title: templateServiceItem == null
              ? context.l10n.template_services_overview_createTemplateServiceItemTitle(templateService.type.name)
              : context.l10n.template_services_overview_editTemplateServiceItemTitle(templateService.type.name),
          onSave: () {
            if (formKey.currentState!.validate()) {
              if (templateServiceItem == null) {
                templateServicesBloc.add(
                  CreateTemplateServiceItemEvent(
                    templateService: templateService,
                    templateServiceItem: TemplateServiceItem.empty().copyWith(name: titleController.text, description: descriptionController.text),
                  ),
                );
              } else {
                templateServicesBloc.add(
                  UpdateTemplateServiceItemEvent(
                    templateService: templateService,
                    templateServiceItem: templateServiceItem.copyWith(name: titleController.text, description: descriptionController.text),
                  ),
                );
              }
              context.pop();
              if (templateServiceItem != null) {
                showMyDialogLoadingWolt(
                  context: context,
                  text: context.l10n.template_services_overview_loadingOnUpdate(templateService.type.name),
                );
              }
            }
          },
          onDelete: templateServiceItem != null
              ? () {
                  templateServicesBloc.add(DeleteTemplateServiceItemEvent(templateServiceItemId: templateServiceItem.id));
                  context.pop();
                  showMyDialogLoadingWolt(
                    context: context,
                    text: context.l10n.template_services_overview_loadingOnDeleteItem(templateService.type.name),
                  );
                }
              : null,
          infoText: infoText,
        ),
      ];
    },
  );
}
