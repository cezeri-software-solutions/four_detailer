import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/template_services/template_services_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../../../../core/core.dart';
import '../widgets/widgets.dart';
import 'widgets/add_edit_template_service.dart';
import 'widgets/add_edit_template_service_item.dart';

class TemplateServicesOverviewPage extends StatelessWidget {
  final TemplateServicesBloc templateServicesBloc;
  final TemplateServiceType templateServiceType;

  const TemplateServicesOverviewPage({super.key, required this.templateServicesBloc, required this.templateServiceType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemplateServicesBloc, TemplateServicesState>(
      builder: (context, state) {
        const loadingWidget = Center(child: MyLoadingIndicator());

        if (state.isLoadingTemplateServicesOnObserve) return loadingWidget;
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.listOfTemplateServices == null) return loadingWidget;
        if (state.listOfTemplateServices!.isEmpty) {
          return Center(child: MyEmptyList(title: context.l10n.template_services_overview_emptyList(templateServiceType.name)));
        }

        return _TemplateServicesOverviewContent(templateServicesBloc: templateServicesBloc, state: state);
      },
    );
  }
}

class _TemplateServicesOverviewContent extends StatelessWidget {
  final TemplateServicesBloc templateServicesBloc;
  final TemplateServicesState state;

  const _TemplateServicesOverviewContent({required this.templateServicesBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => templateServicesBloc.add(GetTemplateServicesEvent()),
      child: ListView(
        children: [
          ReorderableListView.builder(
            itemCount: state.listOfTemplateServices!.length,
            padding: EdgeInsets.all(context.breakpoint.isMobile ? 12 : 24),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            proxyDecorator: (child, index, animation) => Material(
              elevation: 8,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
            onReorder: (oldIndex, newIndex) => templateServicesBloc.add(UpdateTemplateServicePositionsEvent(newIndex: newIndex, oldIndex: oldIndex)),
            itemBuilder: (context, index) {
              final templateService = state.listOfTemplateServices![index];
              final items = templateService.items;
              if (items != null && items.isNotEmpty) items.sort((a, b) => a.position.compareTo(b.position));

              return Column(
                key: ValueKey(templateService.id),
                children: [
                  PressableCard(
                    title: templateService.name,
                    description: templateService.description,
                    onTap: () => showAddEditTemplateServiceSheet(
                      context: context,
                      templateServicesBloc: templateServicesBloc,
                      templateService: templateService,
                      templateServiceType: state.templateServiceType,
                    ),
                  ),
                  //! ############################################################################################
                  _ReorderableListViewItems(
                    templateServicesBloc: templateServicesBloc,
                    templateService: templateService,
                    isLoading: state.isLoadingTemplateServiceItemsOnCreate,
                  ),
                  //! ############################################################################################
                  if (state.isLoadingTemplateServicesOnCreate && index == state.listOfTemplateServices!.length - 1) ...[
                    Gaps.h12,
                    const LinearProgressIndicator()
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReorderableListViewItems extends StatelessWidget {
  final TemplateServicesBloc templateServicesBloc;
  final TemplateService templateService;
  final bool isLoading;

  const _ReorderableListViewItems({required this.templateServicesBloc, required this.templateService, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final items = templateService.items;
    if (items != null && items.isNotEmpty) items.sort((a, b) => a.position.compareTo(b.position));

    if (items == null || items.isEmpty) {
      return _AddTemplateItemButton(templateServicesBloc: templateServicesBloc, templateService: templateService, addLeftPadding: true);
    }

    return Column(
      children: [
        ReorderableListView.builder(
          itemCount: items.length,
          padding: EdgeInsets.only(top: 12, left: context.breakpoint.isMobile ? 12 : 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          proxyDecorator: (child, index, animation) => Material(
            elevation: 8,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
          onReorder: (oldIndex, newIndex) => templateServicesBloc.add(
            UpdateTemplateServiceItemPositionsEvent(templateService: templateService, newIndex: newIndex, oldIndex: oldIndex),
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return Column(
              key: ValueKey(item.id),
              children: [
                Padding(
                  padding: index != items.length - 1 ? const EdgeInsets.only(bottom: 12) : EdgeInsets.zero,
                  child: Row(
                    children: [
                      Text(
                        item.position.toString(),
                        style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                      Gaps.w8,
                      Expanded(
                        child: PressableCard(
                          title: item.name,
                          description: item.description,
                          onTap: () => showAddEditTemplateServiceItemSheet(
                            context: context,
                            templateServicesBloc: templateServicesBloc,
                            templateService: templateService,
                            templateServiceItem: item,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading && index == templateService.items!.length - 1) ...[Gaps.h12, const LinearProgressIndicator()],
              ],
            );
          },
        ),
        _AddTemplateItemButton(templateServicesBloc: templateServicesBloc, templateService: templateService, addLeftPadding: true),
      ],
    );
  }
}

class _AddTemplateItemButton extends StatelessWidget {
  final TemplateServicesBloc templateServicesBloc;
  final TemplateService templateService;
  final bool addLeftPadding;

  const _AddTemplateItemButton({required this.templateServicesBloc, required this.templateService, this.addLeftPadding = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (addLeftPadding) SizedBox(width: context.breakpoint.isMobile ? 12 : 24),
        Icon(Icons.add, color: context.customColors.success),
        Gaps.w4,
        TextButton(
          onPressed: () => showAddEditTemplateServiceItemSheet(
            context: context,
            templateServicesBloc: templateServicesBloc,
            templateService: templateService,
          ),
          child: Text(context.l10n.template_services_overview_createTemplateServiceItemTitle(templateService.type.name)),
        ),
      ],
    );
  }
}
