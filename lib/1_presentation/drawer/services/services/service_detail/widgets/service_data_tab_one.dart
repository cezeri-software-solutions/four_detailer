import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/2_application/service_detail/service_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';
import '../sheets/select_service_category_sheet.dart';

class ServiceDataTabOne extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;

  const ServiceDataTabOne({super.key, required this.serviceDetailBloc, required this.service});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);
    final padding = isMobile ? const EdgeInsets.only(left: 12, right: 12, top: 12) : const EdgeInsets.only(left: 24, right: 12, top: 24);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.service_detail_serviceData, style: context.textTheme.titleLarge),
          isMobile ? Gaps.h12 : Gaps.h24,
          _EditServiceDataContent(serviceDetailBloc: serviceDetailBloc, service: service),
        ],
      ),
    );
  }
}

class _EditServiceDataContent extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;

  const _EditServiceDataContent({required this.serviceDetailBloc, required this.service});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditServiceGeneralData(serviceDetailBloc: serviceDetailBloc, service: service),
          context.breakpoint.isMobile ? Gaps.h12 : Gaps.h24,
          _SelectServiceCategory(serviceDetailBloc: serviceDetailBloc, service: service),
        ],
      ),
    );
  }
}

class _EditServiceGeneralData extends StatefulWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;

  const _EditServiceGeneralData({required this.serviceDetailBloc, required this.service});

  @override
  State<_EditServiceGeneralData> createState() => _EditServiceGeneralDataState();
}

class _EditServiceGeneralDataState extends State<_EditServiceGeneralData> {
  late final FocusNode _numberFocusNode;
  late final FocusNode _nameFocusNode;
  late final FocusNode _netPriceFocusNode;
  late final FocusNode _grossPriceFocusNode;
  late final FocusNode _shortDescriptionFocusNode;
  late final FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _numberFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    _netPriceFocusNode = FocusNode();
    _grossPriceFocusNode = FocusNode();
    _shortDescriptionFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    _nameFocusNode.dispose();
    _netPriceFocusNode.dispose();
    _grossPriceFocusNode.dispose();
    _shortDescriptionFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    return FocusScope(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    fieldTitle: context.l10n.service_detail_articleNumber,
                    isMandatory: true,
                    initialValue: widget.service.number,
                    focusNode: _numberFocusNode,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (_) => _fieldFocusChange(context, _numberFocusNode, _nameFocusNode),
                    onChanged: (value) => widget.serviceDetailBloc.add(EditServiceEvent(service: widget.service.copyWith(number: value))),
                  ),
                ),
                Gaps.w12,
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
            isMobile ? Gaps.h8 : Gaps.h12,
            MyTextFormField(
              fieldTitle: context.l10n.service_detail_serviceName,
              isMandatory: true,
              initialValue: widget.service.name,
              focusNode: _nameFocusNode,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              onFieldSubmitted: (_) => _fieldFocusChange(context, _nameFocusNode, _netPriceFocusNode),
              onChanged: (value) => widget.serviceDetailBloc.add(EditServiceEvent(service: widget.service.copyWith(name: value))),
            ),
            isMobile ? Gaps.h8 : Gaps.h12,
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    fieldTitle: context.l10n.service_detail_priceNet,
                    isMandatory: true,
                    controller: widget.serviceDetailBloc.state.netPriceController,
                    focusNode: _netPriceFocusNode,
                    textInputAction: TextInputAction.next,
                    inputType: FieldInputType.double,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                    inputFormatters: [DoubleInputFormatter()],
                    suffix: Text(widget.service.currency.symbol),
                    onFieldSubmitted: (_) => _fieldFocusChange(context, _netPriceFocusNode, _grossPriceFocusNode),
                    onChanged: (value) => widget.serviceDetailBloc.add(OnNetPriceChangedEvent()),
                  ),
                ),
                Gaps.w12,
                Expanded(
                  child: MyTextFormField(
                    fieldTitle: context.l10n.service_detail_priceGross,
                    isMandatory: true,
                    controller: widget.serviceDetailBloc.state.grossPriceController,
                    focusNode: _grossPriceFocusNode,
                    textInputAction: TextInputAction.next,
                    inputType: FieldInputType.double,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                    inputFormatters: [DoubleInputFormatter()],
                    suffix: Text(widget.service.currency.symbol),
                    onFieldSubmitted: (_) => _fieldFocusChange(context, _grossPriceFocusNode, _shortDescriptionFocusNode),
                    onChanged: (value) => widget.serviceDetailBloc.add(OnGrossPriceChangedEvent()),
                  ),
                ),
              ],
            ),
            isMobile ? Gaps.h8 : Gaps.h12,
            MyTextFormField(
              fieldTitle: context.l10n.service_detail_shortDescription,
              initialValue: widget.service.shortDescription,
              focusNode: _shortDescriptionFocusNode,
              maxLines: null,
              minLines: 4,
              textCapitalization: TextCapitalization.sentences,
              onFieldSubmitted: (_) => _fieldFocusChange(context, _shortDescriptionFocusNode, _descriptionFocusNode),
              onChanged: (value) => widget.serviceDetailBloc.add(EditServiceEvent(service: widget.service.copyWith(shortDescription: value))),
            ),
            isMobile ? Gaps.h8 : Gaps.h12,
            MyTextFormField(
              fieldTitle: context.l10n.service_detail_description,
              initialValue: widget.service.description,
              focusNode: _descriptionFocusNode,
              maxLines: null,
              minLines: 6,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => widget.serviceDetailBloc.add(EditServiceEvent(service: widget.service.copyWith(description: value))),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectServiceCategory extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;

  const _SelectServiceCategory({required this.serviceDetailBloc, required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.service_detail_category, style: context.textTheme.titleLarge),
            IconButton(
              onPressed: () => showSelectServiceCategorySheet(
                context: context,
                serviceDetailBloc: serviceDetailBloc,
                selectedCategory: service.category,
              ),
              icon: service.category == null
                  ? Icon(Icons.add_box, color: context.customColors.success)
                  : Icon(Icons.edit, color: context.colorScheme.primary),
              tooltip: context.l10n.service_detail_selectCategory,
            ),
          ],
        ),
        _SelectedCategory(
          serviceDetailBloc: serviceDetailBloc,
          service: service,
        ),
      ],
    );
  }
}

class _SelectedCategory extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final Service service;

  const _SelectedCategory({required this.serviceDetailBloc, required this.service});

  @override
  Widget build(BuildContext context) {
    if (service.category == null) {
      return Text(
        context.l10n.service_detail_category_notSelected,
        style: context.textTheme.bodySmall!.copyWith(color: context.colorScheme.outline),
      );
    }

    return MyFormFieldContainer(
      padding: const EdgeInsets.all(8.0),
      borderColor: context.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Text(service.category!.title, style: context.textTheme.titleMedium),
        ],
      ),
    );
  }
}
