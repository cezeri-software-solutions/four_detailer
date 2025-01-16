import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';

class AddEditServiceSmartItem extends StatefulWidget {
  final String currencySymbol;
  final ServiceSmartItem? serviceSmartItem;
  final void Function(ServiceSmartItem)? onServiceSmartItemChanged;

  const AddEditServiceSmartItem({
    required this.currencySymbol,
    required this.serviceSmartItem,
    this.onServiceSmartItemChanged,
    super.key,
  });

  @override
  State<AddEditServiceSmartItem> createState() => _AddEditServiceSmartItemState();
}

class _AddEditServiceSmartItemState extends State<AddEditServiceSmartItem> {
  bool _showTimerPicker = false;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _additionalGrossPriceController;
  late final TextEditingController _additionalMaterialGrossCostsController;

  late Duration _additionalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    if (widget.serviceSmartItem != null) {
      _nameController = TextEditingController(text: widget.serviceSmartItem!.name);
      _descriptionController = TextEditingController(text: widget.serviceSmartItem!.description);
      _additionalGrossPriceController = TextEditingController(text: widget.serviceSmartItem!.additionalGrossPrice.toString());
      _additionalMaterialGrossCostsController = TextEditingController(text: widget.serviceSmartItem!.additionalGrossMaterialCosts.toString());
      _additionalDuration = widget.serviceSmartItem!.additionalDuration;
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _additionalGrossPriceController = TextEditingController(text: '0.00');
      _additionalMaterialGrossCostsController = TextEditingController(text: '0.00');
      _additionalDuration = Duration.zero;
    }

    _nameController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _additionalGrossPriceController.addListener(_onFieldChanged);
    _additionalMaterialGrossCostsController.addListener(_onFieldChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          MyTextFormField(
            fieldTitle: context.l10n.title,
            controller: _nameController,
            isMandatory: true,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
          ),
          Gaps.h12,
          Row(
            children: [
              Expanded(
                child: MyTextFormField(
                  fieldTitle: context.l10n.service_detail_additionalPrice,
                  controller: _additionalGrossPriceController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  inputType: FieldInputType.double,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                  inputFormatters: [DoubleInputFormatter()],
                  suffixText: widget.currencySymbol,
                ),
              ),
              Gaps.w12,
              Expanded(
                child: MyTextFormField(
                  fieldTitle: context.l10n.service_detail_additionalMaterialCosts,
                  controller: _additionalMaterialGrossCostsController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  inputType: FieldInputType.double,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                  inputFormatters: [DoubleInputFormatter()],
                  suffixText: widget.currencySymbol,
                ),
              ),
            ],
          ),
          Gaps.h12,
          MyFieldButton(
            fieldTitle: context.l10n.service_detail_additionalDuration,
            onTap: () => setState(() => _showTimerPicker = !_showTimerPicker),
            trailing: Text('HH:mm', style: TextStyle(fontSize: 15, color: context.colorScheme.outline)),
            child: Text(_additionalDuration.toHHMM(), style: const TextStyle(fontSize: 17)),
          ),
          MyAnimatedExpansionContainer(
            isExpanded: _showTimerPicker,
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.hm,
                      initialTimerDuration: Duration(
                        hours: _additionalDuration.inHours % 24,
                        minutes: _additionalDuration.inMinutes % 60,
                      ),
                      onTimerDurationChanged: (duration) {
                        setState(() {
                          _additionalDuration = Duration(
                            hours: (_additionalDuration.inHours ~/ 24) * 24 + duration.inHours,
                            minutes: duration.inMinutes % 60,
                          );
                        });
                        _onFieldChanged();
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => _additionalDuration += const Duration(hours: 24));
                          _onFieldChanged();
                        },
                      ),
                      Text('${_additionalDuration.inHours ~/ 24} ${context.l10n.days}'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _additionalDuration.inHours >= 24
                            ? () {
                                setState(() => _additionalDuration -= const Duration(hours: 24));
                                _onFieldChanged();
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Gaps.h12,
          MyTextFormField(
            fieldTitle: context.l10n.service_detail_description,
            controller: _descriptionController,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  void _onFieldChanged() {
    if (widget.onServiceSmartItemChanged != null) {
      widget.onServiceSmartItemChanged!(_ssi);
    }
  }

  ServiceSmartItem get _ssi => (widget.serviceSmartItem ?? ServiceSmartItem.empty()).copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        additionalGrossPrice: _additionalGrossPriceController.text.toMyDouble(),
        additionalGrossMaterialCosts: _additionalMaterialGrossCostsController.text.toMyDouble(),
        additionalDuration: _additionalDuration,
      );
}
