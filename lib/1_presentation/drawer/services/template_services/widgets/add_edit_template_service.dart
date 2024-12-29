import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/3_domain/models/models.dart';
import '/core/core.dart';
import '../../../../../2_application/template_services/template_services_bloc.dart';
import '../../widgets/widgets.dart';

void showAddEditTemplateServiceSheet({
  required BuildContext context,
  required TemplateServicesBloc templateServicesBloc,
  required TemplateServiceType templateServiceType,
  TemplateService? templateService,
  String? infoText,
}) {
  final titleController = TextEditingController(text: templateService?.name ?? '');
  final descriptionController = TextEditingController(text: templateService?.description ?? '');
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
          title: templateService == null
              ? context.l10n.template_services_overview_createTemplateServiceTitle(templateServiceType.name)
              : context.l10n.template_services_overview_editTemplateServiceTitle(templateServiceType.name),
          onSave: () {
            if (formKey.currentState!.validate()) {
              if (templateService == null) {
                templateServicesBloc.add(
                  CreateTemplateServiceEvent(
                    templateService: TemplateService.empty().copyWith(name: titleController.text, description: descriptionController.text),
                  ),
                );
              } else {
                templateServicesBloc.add(
                  UpdateTemplateServiceEvent(
                    templateService: templateService.copyWith(name: titleController.text, description: descriptionController.text),
                  ),
                );
              }
              context.pop();
              if (templateService != null) {
                showMyDialogLoadingWolt(
                  context: context,
                  text: context.l10n.template_services_overview_loadingOnUpdate(templateServiceType.name),
                );
              }
            }
          },
          onDelete: () {
            templateServicesBloc.add(DeleteTemplateServiceEvent(templateServiceId: templateService!.id));
            context.pop();
            showMyDialogLoadingWolt(
              context: context,
              text: context.l10n.template_services_overview_loadingOnDelete(templateService.type.name),
            );
          },
          infoText: infoText,
        ),
      ];
    },
  );
}
