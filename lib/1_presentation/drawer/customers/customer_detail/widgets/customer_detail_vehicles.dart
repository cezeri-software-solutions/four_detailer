import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/customer_detail/customer_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';
import 'widgets.dart';

class CustomerDetailVehicles extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final List<Vehicle> vehicles;

  const CustomerDetailVehicles({
    super.key,
    required this.customerDetailBloc,
    required this.vehicles,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);
    final padding = isMobile ? const EdgeInsets.only(left: 12, right: 12) : const EdgeInsets.only(left: 12, right: 24, top: 12);
    final notDeletedVehicles = vehicles.where((e) => !e.isDeleted).toList();

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.customer_detail_vehicles, style: context.textTheme.titleLarge),
              IconButton(
                onPressed: () => _showAddVehicleDialog(context, customerDetailBloc),
                icon: Icon(Icons.add_box, color: context.customColors.success),
              ),
            ],
          ),
          Gaps.h24,
          if (isMobile)
            _CustomerDetailVehiclesContent(customerDetailBloc: customerDetailBloc, vehicles: notDeletedVehicles)
          else
            Expanded(
              child: SingleChildScrollView(
                child: _CustomerDetailVehiclesContent(customerDetailBloc: customerDetailBloc, vehicles: notDeletedVehicles),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomerDetailVehiclesContent extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final List<Vehicle> vehicles;

  const _CustomerDetailVehiclesContent({required this.customerDetailBloc, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 42),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: vehicles.length,
        separatorBuilder: (context, index) => Gaps.h8,
        itemBuilder: (context, index) {
          return _CustomerVehicleItem(customerDetailBloc: customerDetailBloc, vehicle: vehicles[index], index: index);
        },
      ),
    );
  }
}

class _CustomerVehicleItem extends StatefulWidget {
  final CustomerDetailBloc customerDetailBloc;
  final Vehicle vehicle;
  final int index;

  const _CustomerVehicleItem({required this.customerDetailBloc, required this.vehicle, required this.index});

  @override
  State<_CustomerVehicleItem> createState() => _CustomerVehicleItemState();
}

class _CustomerVehicleItemState extends State<_CustomerVehicleItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  MyAvatar(name: widget.vehicle.brand, radius: 32, fontSize: 24),
                  Gaps.w16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.vehicle.brand} ${widget.vehicle.model} ${widget.vehicle.modelVariant}',
                          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Gaps.h4,
                        Row(
                          children: [
                            Icon(MdiIcons.license, size: 16),
                            Gaps.w4,
                            Expanded(child: Text(widget.vehicle.licensePlate, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        if (widget.vehicle.mileage > 0) ...[
                          Gaps.h4,
                          Row(
                            children: [
                              const Icon(Icons.wysiwyg_sharp, size: 16),
                              Gaps.w4,
                              Text('${widget.vehicle.mileage} km'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _isExpanded,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AddEditVehicle(
                vehicle: widget.vehicle,
                onDeletePressed: (_) {
                  showMyDialogDeleteWolt(context: context, onConfirm: () => widget.customerDetailBloc.add(RemoveVehicleEvent(index: widget.index)));
                },
                onUpdatePressed: (vh) {
                  setState(() => _isExpanded = false);
                  widget.customerDetailBloc.add(EditVehicleEvent(vehicle: vh, index: widget.index));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAddVehicleDialog(BuildContext context, CustomerDetailBloc customerDetailBloc) {
  final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);
  Vehicle newVehicle = Vehicle.empty();

  WoltModalSheet.show<void>(
    context: context,
    barrierDismissible: true,
    useSafeArea: true,
    showDragHandle: false,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        hasTopBarLayer: true,
        leadingNavBarWidget: Padding(
          padding: const EdgeInsets.only(left: 16, top: 20),
          child: Text(context.l10n.customer_detail_newVehicle, style: context.textTheme.titleLarge),
        ),
        isTopBarLayerAlwaysVisible: true,
        child: Padding(
          padding: isMobile
              ? const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 106)
              : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 94),
          child: AddEditVehicle(onVehicleUpdated: (vehicle) => newVehicle = vehicle),
        ),
        stickyActionBar: Padding(
          padding: EdgeInsets.only(right: 12, top: 12, bottom: isMobile ? 12 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                  onPressed: () {
                    context.pop();
                    customerDetailBloc.add(ShowAddEditVehicleContainerEvent(value: false));
                  },
                  child: Text(context.l10n.cancel)),
              Gaps.w12,
              FilledButton(
                onPressed: () {
                  if (newVehicle.brand.isEmpty) {
                    showMyDialogAlertWolt(
                      context: context,
                      title: context.l10n.danger,
                      content: context.l10n.customer_detail_vehicleBrandIsMandatory,
                    );
                  } else {
                    context.pop();
                    customerDetailBloc.add(AddNewVehicleEvent(vehicle: newVehicle));
                  }
                },
                style: FilledButton.styleFrom(backgroundColor: context.customColors.success),
                child: Text(context.l10n.save),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
