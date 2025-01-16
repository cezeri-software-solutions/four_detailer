import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/service_detail/service_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/3_domain/repositories/template_service_repository.dart';
import '/constants.dart';
import '/core/core.dart';
import '../widgets/add_edit_service_smart_data.dart';
import '../widgets/add_edit_service_todo.dart';

void showLoadSmartItemsFromTemplateSheet({
  required BuildContext context,
  required ServiceDetailBloc serviceDetailBloc,
  required TemplateServiceType type,
}) {
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
  final ValueNotifier<TemplateService?> selectedTemplateServiceNotifier = ValueNotifier(null);
  final ValueNotifier<List<ServiceSmartItem>?> itemsNotifier = ValueNotifier(null);
  final ValueNotifier<List<ServiceTodo>?> todosNotifier = ValueNotifier(null);

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
            child: Text(context.l10n.service_detail_selectTemplate, style: context.textTheme.titleLarge),
          ),
          child: _TemplateItemsList(
            serviceDetailBloc: serviceDetailBloc,
            type: type,
            onTemplateServiceSelected: (templateService) {
              selectedTemplateServiceNotifier.value = templateService;
              pageIndexNotifier.value = 1;
            },
          ),
        ),
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text(context.l10n.service_detail_customizeServiceSmartItems(type.name), style: context.textTheme.titleLarge),
          ),
          trailingNavBarWidget: IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.close),
          ),
          child: ValueListenableBuilder<TemplateService?>(
            valueListenable: selectedTemplateServiceNotifier,
            builder: (context, selectedTemplateService, _) {
              if (selectedTemplateService == null) return const SizedBox.shrink();
              return selectedTemplateService.type == TemplateServiceType.todo
                  ? _TemplateTodo(
                      serviceDetailBloc: serviceDetailBloc,
                      templateService: selectedTemplateService,
                      onItemsChanged: (items) => todosNotifier.value = items,
                    )
                  : _TemplateSmartService(
                      serviceDetailBloc: serviceDetailBloc,
                      templateService: selectedTemplateService,
                      currencySymbol: '€',
                      onItemsChanged: (items) => itemsNotifier.value = items,
                    );
            },
          ),
          stickyActionBar: ValueListenableBuilder(
            valueListenable: selectedTemplateServiceNotifier,
            builder: (context, selectedTemplateService, _) {
              return selectedTemplateService?.type == TemplateServiceType.todo
                  ? _StickyActionBar<ServiceTodo>(
                      itemsNotifier: todosNotifier,
                      pageIndexNotifier: pageIndexNotifier,
                      onSave: (items) => serviceDetailBloc.add(AddServiceTodosFromTemplateEvent(serviceTodos: items)),
                    )
                  : _StickyActionBar<ServiceSmartItem>(
                      itemsNotifier: itemsNotifier,
                      pageIndexNotifier: pageIndexNotifier,
                      onSave: (items) => serviceDetailBloc.add(AddServiceSmartItemsFromTemplateEvent(serviceSmartItems: items)),
                    );
            },
          ),
        ),
      ];
    },
    pageIndexNotifier: pageIndexNotifier,
  );
}

class _StickyActionBar<T> extends StatelessWidget {
  final ValueNotifier<List<T>?> itemsNotifier;
  final ValueNotifier<int> pageIndexNotifier;
  final void Function(List<T>) onSave;

  const _StickyActionBar({
    required this.itemsNotifier,
    required this.pageIndexNotifier,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>?>(
      valueListenable: itemsNotifier,
      builder: (context, items, _) {
        return Padding(
          padding: EdgeInsets.only(right: 12, left: 12, top: 12, bottom: context.breakpoint.isMobile ? 12 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => pageIndexNotifier.value = 0,
                child: Text(context.l10n.cancel),
              ),
              Gaps.w12,
              FilledButton(
                onPressed: items == null
                    ? null
                    : () {
                        onSave(items);
                        context.pop();
                      },
                style: FilledButton.styleFrom(backgroundColor: context.customColors.success),
                child: Text(context.l10n.save),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TemplateItemsList extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final TemplateServiceType type;
  final void Function(TemplateService) onTemplateServiceSelected;

  const _TemplateItemsList({required this.serviceDetailBloc, required this.type, required this.onTemplateServiceSelected});

  @override
  State<_TemplateItemsList> createState() => _TemplateItemsListState();
}

class _TemplateItemsListState extends State<_TemplateItemsList> {
  List<TemplateService>? _templateServices;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplateServices();
  }

  @override
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const MyLoadingIndicator(), Gaps.h12, Text(context.l10n.service_detail_loadTemplateItems)],
          ),
        ),
      );
    }

    if (_templateServices == null) return SizedBox(height: 400, child: Center(child: Text(context.l10n.error)));

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.service_detail_serviceSmartItems(widget.type.name), style: context.textTheme.titleLarge),
          Gaps.h12,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _templateServices!.length,
            separatorBuilder: (context, index) => Gaps.h12,
            itemBuilder: (context, index) => _TemplateItem(
              serviceDetailBloc: widget.serviceDetailBloc,
              templateService: _templateServices![index],
              onTemplateServiceSelected: widget.onTemplateServiceSelected,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTemplateServices() async {
    try {
      final templateServiceRepo = GetIt.I.get<TemplateServiceRepository>();
      final fosTemplateServices = await templateServiceRepo.getTemplateServices(widget.type);

      if (!mounted) return;

      setState(() {
        _templateServices = fosTemplateServices.isRight() ? fosTemplateServices.getRight() : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _templateServices = null;
        _isLoading = false;
      });
    }
  }
}

class _TemplateItem extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final TemplateService templateService;
  final void Function(TemplateService) onTemplateServiceSelected;

  const _TemplateItem({required this.serviceDetailBloc, required this.templateService, required this.onTemplateServiceSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onTemplateServiceSelected(templateService),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(templateService.name, style: context.textTheme.titleMedium),
                  Gaps.h8,
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: templateService.items!.length,
                    itemBuilder: (context, index) => Text('  - ${templateService.items![index].name}'),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _TemplateSmartService extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final TemplateService templateService;
  final String currencySymbol;
  final ValueChanged<List<ServiceSmartItem>> onItemsChanged;

  const _TemplateSmartService({
    required this.serviceDetailBloc,
    required this.templateService,
    required this.currencySymbol,
    required this.onItemsChanged,
  });

  @override
  State<_TemplateSmartService> createState() => _TemplateSmartServiceState();
}

class _TemplateSmartServiceState extends State<_TemplateSmartService> {
  final Map<int, ServiceSmartItem> _editedItems = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onItemsChanged(_allItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.templateService.name, style: context.textTheme.titleLarge),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.templateService.items!.length,
              separatorBuilder: (context, index) => Gaps.h12,
              itemBuilder: (context, index) {
                final item = widget.templateService.items![index];
                final emptySmartItem = ServiceSmartItem.empty().copyWith(
                  name: item.name,
                  type: ServiceSmartItemType.values.firstWhere((t) => t.name == widget.templateService.type.name),
                );

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AddEditServiceSmartItem(
                      currencySymbol: widget.currencySymbol,
                      serviceSmartItem: _editedItems[index] ?? emptySmartItem,
                      onServiceSmartItemChanged: (item) => _onItemEdited(item, index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemEdited(ServiceSmartItem item, int index) {
    setState(() {
      _editedItems[index] = item.copyWith(type: ServiceSmartItemType.values.firstWhere((t) => t.name == widget.templateService.type.name));
      widget.onItemsChanged(_allItems);
    });
  }

  List<ServiceSmartItem> get _allItems {
    final items = List<ServiceSmartItem>.generate(
      widget.templateService.items!.length,
      (index) {
        if (_editedItems.containsKey(index)) {
          return _editedItems[index]!;
        }

        final item = widget.templateService.items![index];
        return ServiceSmartItem.empty().copyWith(
          name: item.name,
          type: ServiceSmartItemType.values.firstWhere(
            (t) => t.name == widget.templateService.type.name,
          ),
        );
      },
    );
    return items;
  }
}

class _TemplateTodo extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final TemplateService templateService;
  final ValueChanged<List<ServiceTodo>> onItemsChanged;

  const _TemplateTodo({
    required this.serviceDetailBloc,
    required this.templateService,
    required this.onItemsChanged,
  });

  @override
  State<_TemplateTodo> createState() => _TemplateTodoState();
}

class _TemplateTodoState extends State<_TemplateTodo> {
  final Map<int, ServiceTodo> _editedItems = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onItemsChanged(_allItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 74),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.templateService.name, style: context.textTheme.titleLarge),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.templateService.items!.length,
              separatorBuilder: (context, index) => Gaps.h12,
              itemBuilder: (context, index) {
                final item = widget.templateService.items![index];
                final emptyTodo = ServiceTodo.empty().copyWith(name: item.name, description: item.description);

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AddEditServiceTodo(
                      serviceTodo: _editedItems[index] ?? emptyTodo,
                      onServiceTodoChanged: (item) => _onItemEdited(item, index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemEdited(ServiceTodo item, int index) {
    setState(() {
      _editedItems[index] = item.copyWith(name: item.name, description: item.description);
      widget.onItemsChanged(_allItems);
    });
  }

  List<ServiceTodo> get _allItems {
    final items = List<ServiceTodo>.generate(
      widget.templateService.items!.length,
      (index) {
        if (_editedItems.containsKey(index)) return _editedItems[index]!;

        final item = widget.templateService.items![index];
        return ServiceTodo.empty().copyWith(name: item.name, description: item.description);
      },
    );
    return items;
  }
}
