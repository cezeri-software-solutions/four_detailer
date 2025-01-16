import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/service_detail/service_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';
import '../widgets/add_edit_service_todo.dart';

void showAddServiceTodoSheet({
  required BuildContext context,
  required ServiceDetailBloc serviceDetailBloc,
}) {
  ServiceTodo? serviceTodo;

  WoltModalSheet.show<void>(
    context: context,
    barrierDismissible: true,
    useSafeArea: true,
    showDragHandle: false,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text(context.l10n.service_detail_newServiceTodoTitle, style: context.textTheme.titleLarge),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: context.breakpoint.isMobile ? 106 : 94),
            child: AddEditServiceTodo(
              serviceTodo: serviceTodo,
              onServiceTodoChanged: (std) => serviceTodo = ServiceTodo.empty().copyWith(name: std.name, description: std.description),
            ),
          ),
          stickyActionBar: Padding(
            padding: EdgeInsets.only(right: 12, left: 12, top: 12, bottom: context.breakpoint.isMobile ? 12 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: context.pop,
                  child: Text(context.l10n.cancel),
                ),
                Gaps.w12,
                FilledButton(
                  onPressed: () {
                    if (serviceTodo == null || serviceTodo!.name.isEmpty) {
                      showTitleRequiredDialogWolt(context: context);
                    } else {
                      serviceDetailBloc.add(AddNewServiceTodoEvent(serviceTodo: serviceTodo!));
                      context.pop();
                    }
                  },
                  style: FilledButton.styleFrom(backgroundColor: context.customColors.success),
                  child: Text(context.l10n.save),
                ),
              ],
            ),
          ),
        ),
      ];
    },
  );
}
