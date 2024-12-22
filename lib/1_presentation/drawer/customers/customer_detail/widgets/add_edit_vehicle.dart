import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '/3_domain/models/vehicle.dart';
import '/3_domain/repositories/database_repository.dart';
import '/constants.dart';
import '/core/core.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class AddEditVehicle extends StatefulWidget {
  final Vehicle? vehicle;
  final void Function(Vehicle)? onDeletePressed;
  final void Function(Vehicle)? onUpdatePressed;
  final void Function(Vehicle)? onVehicleUpdated;

  const AddEditVehicle({
    this.vehicle,
    this.onDeletePressed,
    this.onUpdatePressed,
    this.onVehicleUpdated,
    super.key,
  });

  @override
  State<AddEditVehicle> createState() => _AddEditVehicleState();
}

class _AddEditVehicleState extends State<AddEditVehicle> {
  final FocusNode _brandFocusNode = FocusNode();
  List<String> _listOfVehicles = [];
  bool _showSelectFirstRegistration = false;

  late FuelType _fuelType;
  late BodyType _bodyType;

  late DateTime? _firstRegistration;

  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _modelVariantController;
  late TextEditingController _mileageController;
  late TextEditingController _powerHPController;
  late TextEditingController _powerKWController;
  late TextEditingController _vinController;
  late TextEditingController _licensePlateController;
  late TextEditingController _colorController;
  late TextEditingController _colorCodeController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _fuelType = widget.vehicle!.fuelType;
      _bodyType = widget.vehicle!.bodyType;

      _firstRegistration = widget.vehicle!.firstRegistration;

      _brandController = TextEditingController(text: widget.vehicle!.brand);

      _modelController = TextEditingController(text: widget.vehicle!.model);
      _modelVariantController = TextEditingController(text: widget.vehicle!.modelVariant);
      _mileageController = TextEditingController(text: widget.vehicle!.mileage.toString());
      _powerHPController = TextEditingController(text: widget.vehicle!.powerHP.toString());
      _powerKWController = TextEditingController(text: widget.vehicle!.powerKW.toString());
      _vinController = TextEditingController(text: widget.vehicle!.vin);
      _licensePlateController = TextEditingController(text: widget.vehicle!.licensePlate);
      _colorController = TextEditingController(text: widget.vehicle!.color);
      _colorCodeController = TextEditingController(text: widget.vehicle!.colorCode);
      _commentController = TextEditingController(text: widget.vehicle!.comment);
    } else {
      _fuelType = FuelType.petrol;
      _bodyType = BodyType.sedan;

      _firstRegistration = null;

      _brandController = TextEditingController()
        ..addListener(() {
          if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
        });
      _modelController = TextEditingController();
      _modelVariantController = TextEditingController();
      _mileageController = TextEditingController();
      _powerHPController = TextEditingController()
        ..addListener(() {
          if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
        });
      _powerKWController = TextEditingController()
        ..addListener(() {
          if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
        });
      _vinController = TextEditingController();
      _licensePlateController = TextEditingController();
      _colorController = TextEditingController();
      _colorCodeController = TextEditingController();
      _commentController = TextEditingController();
    }
    _brandFocusNode.addListener(() {
      if (!_brandFocusNode.hasFocus) {
        if (_listOfVehicles.any((e) => _brandController.text.trim().toLowerCase() == e.trim().toLowerCase())) {
          _brandController.text = _listOfVehicles.firstWhere((e) => _brandController.text.trim().toLowerCase() == e.trim().toLowerCase());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.vehicle != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.vehicle != null ? context.l10n.customer_detail_editVehicle : context.l10n.customer_detail_newVehicle,
                style: context.textTheme.titleMedium,
              ),
              if (widget.vehicle != null) ...[
                if (widget.onDeletePressed != null)
                  IconButton(onPressed: () => widget.onDeletePressed!(vehicle), icon: Icon(Icons.delete, color: context.colorScheme.error)),
                if (widget.onUpdatePressed != null)
                  IconButton(
                    onPressed: () {
                      if (vehicle.brand.isEmpty) {
                        showMyDialogAlertWolt(
                          context: context,
                          title: context.l10n.danger,
                          content: context.l10n.customer_detail_vehicleBrandIsMandatory,
                        );
                      } else {
                        widget.onUpdatePressed!(vehicle);
                      }
                    },
                    icon: Icon(Icons.save, color: context.customColors.success),
                  ),
              ],
            ],
          ),
          Gaps.h12,
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldTitle(fieldTitle: context.l10n.customer_detail_vehicleFuelType, isMandatory: false),
            Gaps.h4,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<FuelType>(
                segments: FuelType.values
                    .map((type) => ButtonSegment<FuelType>(
                          value: type,
                          label: Text(type.convert(context)),
                        ))
                    .toList(),
                selected: {_fuelType},
                onSelectionChanged: (Set<FuelType> newSelection) {
                  setState(() {
                    _fuelType = newSelection.first;
                  });
                  if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  visualDensity: VisualDensity.comfortable, // Reduziert die vertikale Höhe
                  // tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimiert den Tap-Bereich
                ),
              ),
            ),
          ],
        ),
        Gaps.h16,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldTitle(fieldTitle: context.l10n.customer_detail_vehicleBodyType, isMandatory: false),
            Gaps.h4,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<BodyType>(
                segments: [
                  ButtonSegment<BodyType>(
                    value: BodyType.compact,
                    icon: Icon(MdiIcons.carHatchback, size: 28),
                    tooltip: BodyType.compact.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.sedan,
                    icon: Icon(MdiIcons.car, size: 28),
                    tooltip: BodyType.sedan.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.wagon,
                    icon: Icon(MdiIcons.carEstate, size: 28),
                    tooltip: BodyType.wagon.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.convertible,
                    icon: Icon(MdiIcons.carConvertible, size: 28),
                    tooltip: BodyType.convertible.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.coupe,
                    icon: Icon(MdiIcons.carSports, size: 28),
                    tooltip: BodyType.coupe.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.suv,
                    icon: Icon(MdiIcons.car, size: 28),
                    tooltip: BodyType.suv.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.van,
                    icon: Icon(MdiIcons.vanPassenger, size: 28),
                    tooltip: BodyType.van.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.transporter,
                    icon: Icon(MdiIcons.vanUtility, size: 28),
                    tooltip: BodyType.transporter.convert(context),
                  ),
                  ButtonSegment<BodyType>(
                    value: BodyType.other,
                    icon: Icon(MdiIcons.carOff, size: 28),
                    tooltip: BodyType.other.convert(context),
                  ),
                ],
                selected: {_bodyType},
                onSelectionChanged: (Set<BodyType> newSelection) {
                  setState(() {
                    _bodyType = newSelection.first;
                  });
                  if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
                },
                multiSelectionEnabled: false,
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  visualDensity: VisualDensity.comfortable, // Reduziert die vertikale Höhe
                  // tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimiert den Tap-Bereich
                ),
              ),
            ),
          ],
        ),
        Gaps.h16,
        Row(
          children: [
            Expanded(
              child: MyAutocompleteTextField(
                controller: _brandController,
                focusNode: _brandFocusNode,
                fieldTitle: context.l10n.customer_detail_vehicleBrand,
                onSelected: (value) {
                  _brandController.text = value;
                  if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
                },
                isMandatory: true,
                mustSelect: false,
                maxWidth: 200,
                loadItems: (value) async {
                  final databaseRepo = GetIt.I<DatabaseRepository>();

                  final result = await databaseRepo.getVehicleBrands(searchTerm: value.text);
                  if (result.isRight()) {
                    final brands = result.getRight();
                    _listOfVehicles = brands;
                    return brands;
                  }

                  return [];
                },
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehicleModel,
                controller: _modelController,
                textInputAction: TextInputAction.next,
                onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
                validator: (value) {
                  if (value == null || value.isEmpty) return context.l10n.mandatory;
                  return null;
                },
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehicleModelVariant,
                controller: _modelVariantController,
                textInputAction: TextInputAction.next,
                onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
              ),
            ),
          ],
        ),
        Gaps.h8,
        Row(
          children: [
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehicleMileage,
                controller: _mileageController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehiclePowerHP,
                controller: _powerHPController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  _onPowerHpChanged();
                  if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
                },
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehiclePowerKW,
                controller: _powerKWController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  _onPowerKwChanged();
                  if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
                },
              ),
            ),
          ],
        ),
        Gaps.h8,
        Row(
          children: [
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehicleLicensePlate,
                controller: _licensePlateController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [UpperCaseTextFormatter()],
                onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehicleVin,
                controller: _vinController,
                textInputAction: TextInputAction.next,
                onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
              ),
            ),
          ],
        ),
        Gaps.h8,
        Row(
          children: [
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehicleColor,
                controller: _colorController,
                textInputAction: TextInputAction.next,
                onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
              ),
            ),
            Gaps.w8,
            Expanded(
              child: MyTextFormField(
                fieldTitle: context.l10n.customer_detail_vehicleColorCode,
                controller: _colorCodeController,
                textInputAction: TextInputAction.next,
                onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
              ),
            ),
          ],
        ),
        Gaps.h8,
        MyFieldButton(
          fieldTitle: context.l10n.customer_detail_vehicleFirstRegistration,
          trailing: const Icon(Icons.clear),
          onTap: () {
            setState(() => _showSelectFirstRegistration = !_showSelectFirstRegistration);
          },
          onTrailingTap: () => setState(() {
            _firstRegistration = null;
            _showSelectFirstRegistration = false;
            if (widget.onVehicleUpdated != null) widget.onVehicleUpdated!(vehicle);
          }),
          child: Text(_firstRegistration?.toFormattedDayMonthYear() ?? ''),
        ),
        MyAnimatedExpansionContainer(
          isExpanded: _showSelectFirstRegistration,
          child: SizedBox(
            height: 150,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _firstRegistration,
              onDateTimeChanged: (date) => setState(() => _firstRegistration = date),
            ),
          ),
        ),
        Gaps.h8,
        MyTextFormField(
          fieldTitle: context.l10n.customer_detail_vehicleComment,
          controller: _commentController,
          textInputAction: TextInputAction.newline,
          maxLines: 3,
          unfocusOnTapOutside: true,
          textCapitalization: TextCapitalization.sentences,
          onChanged: widget.onVehicleUpdated != null ? (value) => widget.onVehicleUpdated!(vehicle) : null,
        ),
      ],
    );
  }

  void _onPowerHpChanged() {
    final powerHP = int.tryParse(_powerHPController.text) ?? 0;

    _powerKWController.text = (powerHP / 1.36).toStringAsFixed(0);

    if (_powerHPController.text.isEmpty) {
      _powerKWController.text = '';
    } else {
      _powerKWController.text = (powerHP / 1.36).toStringAsFixed(0);
    }
  }

  void _onPowerKwChanged() {
    final powerKW = int.tryParse(_powerKWController.text) ?? 0;

    if (_powerKWController.text.isEmpty) {
      _powerHPController.text = '';
    } else {
      _powerHPController.text = (powerKW * 1.36).toStringAsFixed(0);
    }
  }

  Vehicle get vehicle => (widget.vehicle ?? Vehicle.empty()).copyWith(
        brand: _brandController.text,
        model: _modelController.text,
        modelVariant: _modelVariantController.text,
        mileage: int.tryParse(_mileageController.text) ?? 0,
        powerHP: int.tryParse(_powerHPController.text) ?? 0,
        powerKW: int.tryParse(_powerKWController.text) ?? 0,
        vin: _vinController.text,
        licensePlate: _licensePlateController.text,
        color: _colorController.text,
        colorCode: _colorCodeController.text,
        comment: _commentController.text,
        fuelType: _fuelType,
        bodyType: _bodyType,
        firstRegistration: _firstRegistration,
        isActive: widget.vehicle?.isActive ?? true,
        createdAt: widget.vehicle?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
}
