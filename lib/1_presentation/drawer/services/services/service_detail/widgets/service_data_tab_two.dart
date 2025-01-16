import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/2_application/service_detail/service_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';
import '../sheets/add_service_smart_item_sheet.dart';
import '../sheets/add_service_todo_sheet.dart';
import '../sheets/load_smart_items_from_template_sheet.dart';
import 'add_edit_service_smart_data.dart';
import 'add_edit_service_todo.dart';

class ServiceDataTabTwo extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;

  const ServiceDataTabTwo({super.key, required this.serviceDetailBloc, required this.service});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.isMobile;

    return Padding(
      padding: isMobile ? const EdgeInsets.only(left: 12, right: 12, bottom: 42) : const EdgeInsets.only(left: 12, right: 24, top: 12, bottom: 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditServiceSmartItem(serviceDetailBloc: serviceDetailBloc, service: service, type: ServiceSmartItemType.vehicleSize),
          isMobile ? Gaps.h12 : Gaps.h24,
          _EditServiceSmartItem(serviceDetailBloc: serviceDetailBloc, service: service, type: ServiceSmartItemType.contaminationLevel),
          isMobile ? Gaps.h12 : Gaps.h24,
          _ServiceDetailTodos(serviceDetailBloc: serviceDetailBloc, serviceTodos: service.todos ?? []),
        ],
      ),
    );
  }
}

class _EditServiceSmartItem extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;
  final ServiceSmartItemType type;

  const _EditServiceSmartItem({required this.serviceDetailBloc, required this.service, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.service_detail_serviceSmartItems(type.name), style: context.textTheme.titleLarge),
            Row(
              children: [
                IconButton(
                  onPressed: () => showLoadSmartItemsFromTemplateSheet(
                    context: context,
                    serviceDetailBloc: serviceDetailBloc,
                    type: type == ServiceSmartItemType.vehicleSize ? TemplateServiceType.vehicleSize : TemplateServiceType.contaminationLevel,
                  ),
                  icon: Icon(Icons.file_copy_outlined, color: context.colorScheme.primary),
                  tooltip: context.l10n.service_detail_loadFromTemplate,
                ),
                IconButton(
                  onPressed: () => showAddServiceSmartItemSheet(
                    context: context,
                    serviceDetailBloc: serviceDetailBloc,
                    serviceSmartItemType: type,
                    currencySymbol: service.currency.symbol,
                  ),
                  icon: Icon(Icons.add_box, color: context.customColors.success),
                  tooltip: context.l10n.service_detail_addServiceSmartItem(type.name),
                ),
              ],
            ),
          ],
        ),
        _ServiceSmartItemList(
          serviceDetailBloc: serviceDetailBloc,
          service: service,
          type: type,
          serviceSmartItems: type == ServiceSmartItemType.vehicleSize ? service.vehicleSizes ?? [] : service.contaminationLevels ?? [],
        ),
      ],
    );
  }
}

class _ServiceSmartItemList extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;
  final ServiceSmartItemType type;
  final List<ServiceSmartItem> serviceSmartItems;

  const _ServiceSmartItemList({required this.serviceDetailBloc, required this.service, required this.type, required this.serviceSmartItems});

  @override
  Widget build(BuildContext context) {
    if (serviceSmartItems.isEmpty) {
      return Text(
        context.l10n.service_detail_ServiceSmartItemInfoText(type.name),
        style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline),
      );
    }

    return MyReorderableListView(
      itemCount: serviceSmartItems.length,
      onReorder: (oldIndex, newIndex) {
        serviceDetailBloc.add(UpdateServiceSmartItemPositionsEvent(type: type, newIndex: newIndex, oldIndex: oldIndex));
      },
      itemBuilder: (context, index) {
        return MyReorderableItem(
          key: Key('service_smart_item_$index'),
          index: index,
          child: Padding(
            padding: index != serviceSmartItems.length - 1 ? EdgeInsets.only(bottom: context.breakpoint.isMobile ? 12 : 16) : EdgeInsets.zero,
            child: _ServiceItemCard(serviceDetailBloc: serviceDetailBloc, service: service, serviceSmartItem: serviceSmartItems[index], index: index),
          ),
        );
      },
    );
  }
}

class _ServiceItemCard extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;
  final ServiceSmartItem serviceSmartItem;
  final int index;

  const _ServiceItemCard({required this.serviceDetailBloc, required this.service, required this.serviceSmartItem, required this.index});

  @override
  State<_ServiceItemCard> createState() => _ServiceItemCardState();
}

class _ServiceItemCardState extends State<_ServiceItemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.serviceSmartItem.isDeleted ? context.colorScheme.error.withValues(alpha: 0.2) : null,
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.serviceSmartItem.isDeleted ? null : () => setState(() => _isExpanded = !_isExpanded),
            child: _CollapsedServiceSmartItem(item: widget.serviceSmartItem, currencySymbol: widget.service.currency.symbol),
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isExpanded,
            child: _ExpandedServiceSmartItem(
              serviceDetailBloc: widget.serviceDetailBloc,
              item: widget.serviceSmartItem,
              index: widget.index,
              currencySymbol: widget.service.currency.symbol,
              collapseCard: () => setState(() => _isExpanded = false),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsedServiceSmartItem extends StatelessWidget {
  final ServiceSmartItem item;
  final String currencySymbol;

  const _CollapsedServiceSmartItem({required this.item, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final infoStyle = context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline);
    final itemName = item.isDeleted ? item.name : '${item.position}. ${item.name}';

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(itemName, style: context.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
              context.breakpoint.largerThan(MOBILE) ? Gaps.w16 : Gaps.w8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(context.l10n.service_detail_additionalDuration, style: infoStyle),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: item.additionalDuration.toHHMM()),
                        const TextSpan(text: ' '),
                        TextSpan(text: 'HH:mm', style: infoStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gaps.h8,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.service_detail_additionalPrice, style: infoStyle),
                  Text('${item.additionalGrossPrice.toMyCurrencyStringToShow()} $currencySymbol'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(context.l10n.service_detail_additionalMaterialCosts, style: infoStyle),
                  Text('${item.additionalGrossMaterialCosts.toMyCurrencyStringToShow()} $currencySymbol'),
                ],
              ),
            ],
          ),
          if (item.description.isNotEmpty) ...[
            Gaps.h8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.service_detail_description, style: infoStyle),
                Text(item.description),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpandedServiceSmartItem extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final ServiceSmartItem item;
  final int index;
  final String currencySymbol;
  final VoidCallback collapseCard;

  const _ExpandedServiceSmartItem({
    required this.serviceDetailBloc,
    required this.item,
    required this.index,
    required this.currencySymbol,
    required this.collapseCard,
  });

  @override
  State<_ExpandedServiceSmartItem> createState() => _ExpandedServiceSmartItemState();
}

class _ExpandedServiceSmartItemState extends State<_ExpandedServiceSmartItem> {
  late ServiceSmartItem _serviceSmartItem;

  @override
  void initState() {
    super.initState();

    _serviceSmartItem = widget.item.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.service_detail_editServiceSmartItem(widget.item.type.name), style: context.textTheme.titleMedium),
              IconButton(
                onPressed: () => showMyDialogDeleteWolt(
                    context: context,
                    content: context.l10n.service_detail_deleteText(widget.item.type.name),
                    onConfirm: () {
                      widget.collapseCard();
                      widget.serviceDetailBloc.add(RemoveServiceSmartItemEvent(serviceSmartItem: widget.item, index: widget.index));
                    }),
                icon: Icon(Icons.delete, color: context.colorScheme.error),
              ),
              IconButton(
                onPressed: () {
                  if (widget.item.name.isEmpty) {
                    showTitleRequiredDialogWolt(context: context);
                  } else {
                    widget.collapseCard();
                    widget.serviceDetailBloc.add(EditServiceSmartItemEvent(serviceSmartItem: _serviceSmartItem, index: widget.index));
                  }
                },
                icon: Icon(Icons.save, color: context.customColors.success),
              ),
            ],
          ),
          AddEditServiceSmartItem(
            currencySymbol: widget.currencySymbol,
            serviceSmartItem: _serviceSmartItem,
            onServiceSmartItemChanged: (ssi) => setState(() => _serviceSmartItem = ssi),
          ),
        ],
      ),
    );
  }
}

class _ServiceDetailTodos extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final List<ServiceTodo> serviceTodos;

  const _ServiceDetailTodos({required this.serviceDetailBloc, required this.serviceTodos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Todo`s', style: context.textTheme.titleLarge),
            Row(
              children: [
                IconButton(
                  onPressed: () => showLoadSmartItemsFromTemplateSheet(
                    context: context,
                    serviceDetailBloc: serviceDetailBloc,
                    type: TemplateServiceType.todo,
                  ),
                  icon: Icon(Icons.file_copy_outlined, color: context.colorScheme.primary),
                  tooltip: context.l10n.service_detail_loadFromTemplate,
                ),
                IconButton(
                  onPressed: () => showAddServiceTodoSheet(context: context, serviceDetailBloc: serviceDetailBloc),
                  icon: Icon(Icons.add_box, color: context.customColors.success),
                  tooltip: 'Todo hinzufügen',
                ),
              ],
            ),
          ],
        ),
        _ServiceTodoList(
          serviceDetailBloc: serviceDetailBloc,
          serviceTodos: serviceTodos,
        ),
        Gaps.h24,
      ],
    );
  }
}

class _ServiceTodoList extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final List<ServiceTodo> serviceTodos;

  const _ServiceTodoList({required this.serviceDetailBloc, required this.serviceTodos});

  @override
  Widget build(BuildContext context) {
    if (serviceTodos.isEmpty) {
      return Text(
        context.l10n.service_detail_ServiceTodosInfoText,
        style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline),
      );
    }

    return MyReorderableListView(
      itemCount: serviceTodos.length,
      onReorder: (oldIndex, newIndex) => serviceDetailBloc.add(UpdateServiceTodoPositionsEvent(newIndex: newIndex, oldIndex: oldIndex)),
      itemBuilder: (context, index) {
        return MyReorderableItem(
          key: Key('service_todo_$index'),
          index: index,
          child: Padding(
            padding: index != serviceTodos.length - 1 ? EdgeInsets.only(bottom: context.breakpoint.isMobile ? 12 : 16) : EdgeInsets.zero,
            child: _ServiceTodoCard(serviceDetailBloc: serviceDetailBloc, serviceTodo: serviceTodos[index], index: index),
          ),
        );
      },
    );
  }
}

class _ServiceTodoCard extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final ServiceTodo serviceTodo;
  final int index;

  const _ServiceTodoCard({required this.serviceDetailBloc, required this.serviceTodo, required this.index});

  @override
  State<_ServiceTodoCard> createState() => _ServiceTodoCardState();
}

class _ServiceTodoCardState extends State<_ServiceTodoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.serviceTodo.isDeleted ? context.colorScheme.error.withValues(alpha: 0.2) : null,
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.serviceTodo.isDeleted ? null : () => setState(() => _isExpanded = !_isExpanded),
            child: _CollapsedTodoItem(item: widget.serviceTodo),
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isExpanded,
            child: _ExpandedTodoItem(
              serviceDetailBloc: widget.serviceDetailBloc,
              item: widget.serviceTodo,
              index: widget.index,
              collapseCard: () => setState(() => _isExpanded = false),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsedTodoItem extends StatelessWidget {
  final ServiceTodo item;

  const _CollapsedTodoItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final infoStyle = context.textTheme.bodyMedium!.copyWith(color: context.colorScheme.outline);
    final itemName = item.isDeleted ? item.name : '${item.position}. ${item.name}';

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(itemName, style: context.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (item.description.isNotEmpty) Text(item.description, style: infoStyle),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpandedTodoItem extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final ServiceTodo item;
  final int index;
  final VoidCallback collapseCard;

  const _ExpandedTodoItem({
    required this.serviceDetailBloc,
    required this.item,
    required this.index,
    required this.collapseCard,
  });

  @override
  State<_ExpandedTodoItem> createState() => _ExpandedTodoItemState();
}

class _ExpandedTodoItemState extends State<_ExpandedTodoItem> {
  late ServiceTodo _serviceTodo;

  @override
  void initState() {
    super.initState();

    _serviceTodo = widget.item.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.service_detail_editServiceTodo, style: context.textTheme.titleMedium),
              IconButton(
                onPressed: () => showMyDialogDeleteWolt(
                    context: context,
                    content: context.l10n.service_detail_deleteText('todo'),
                    onConfirm: () {
                      widget.collapseCard();
                      widget.serviceDetailBloc.add(RemoveServiceTodoEvent(serviceTodo: widget.item, index: widget.index));
                    }),
                icon: Icon(Icons.delete, color: context.colorScheme.error),
              ),
              IconButton(
                onPressed: () {
                  if (widget.item.name.isEmpty) {
                    showTitleRequiredDialogWolt(context: context);
                  } else {
                    widget.collapseCard();
                    widget.serviceDetailBloc.add(EditServiceTodoEvent(serviceTodo: _serviceTodo, index: widget.index));
                  }
                },
                icon: Icon(Icons.save, color: context.customColors.success),
              ),
            ],
          ),
          AddEditServiceTodo(serviceTodo: _serviceTodo, onServiceTodoChanged: (std) => setState(() => _serviceTodo = std)),
        ],
      ),
    );
  }
}
