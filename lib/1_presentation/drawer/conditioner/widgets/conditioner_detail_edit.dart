import 'package:flutter/material.dart';
import 'package:four_detailer/2_application/conditioner/conditioner_bloc.dart';

import '/core/core.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';

class ConditionerDetailEdit extends StatefulWidget {
  final ConditionerBloc conditionerBloc;
  final Conditioner conditioner;
  final bool isLoading;

  const ConditionerDetailEdit({super.key, required this.conditionerBloc, required this.conditioner, required this.isLoading});

  @override
  State<ConditionerDetailEdit> createState() => _ConditionerDetailEditState();
}

class _ConditionerDetailEditState extends State<ConditionerDetailEdit> {
  final _padding = 12.0;

  late Gender _gender;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _tel1Controller;
  late final TextEditingController _tel2Controller;
  late final TextEditingController _streetController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;

  late Country _country;

  @override
  void initState() {
    super.initState();

    _gender = widget.conditioner.gender;
    _firstNameController = TextEditingController(text: widget.conditioner.firstName);
    _lastNameController = TextEditingController(text: widget.conditioner.lastName);
    _tel1Controller = TextEditingController(text: widget.conditioner.tel1);
    _tel2Controller = TextEditingController(text: widget.conditioner.tel2);
    _streetController = TextEditingController(text: widget.conditioner.address.street);
    _zipCodeController = TextEditingController(text: widget.conditioner.address.postalCode);
    _cityController = TextEditingController(text: widget.conditioner.address.city);
    _stateController = TextEditingController(text: widget.conditioner.address.state);

    _country = widget.conditioner.address.country;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(context.l10n.edit, style: context.textTheme.titleLarge),
        Gaps.h16,
        Stack(
          children: [
            MyFormFieldContainer(
              padding: EdgeInsets.all(_padding),
              borderColor: context.colorScheme.outlineVariant,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyDropdownButton(
                    fieldTitle: context.l10n.gender,
                    maxWidth: context.screenSize.width / 2 < 300 ? context.screenSize.width / 2 - _padding - 6 : 300 - _padding - 6,
                    value: _gender.convert(context),
                    onChanged: (value) => _onGenderChanged(value),
                    showSearch: false,
                    items: ['', context.l10n.gender_male, context.l10n.gender_female],
                  ),
                  Gaps.h12,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(
                          fieldTitle: context.l10n.firstName,
                          controller: _firstNameController,
                          isMandatory: true,
                          prefixIcon: const Icon(Icons.person),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Gaps.w12,
                      Expanded(
                        child: MyTextFormField(
                          fieldTitle: context.l10n.lastName,
                          controller: _lastNameController,
                          isMandatory: true,
                          prefixIcon: const Icon(Icons.person_outline),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h12,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(
                          fieldTitle: context.l10n.tel1,
                          controller: _tel1Controller,
                          prefixIcon: const Icon(Icons.phone),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Gaps.w12,
                      Expanded(
                        child: MyTextFormField(
                          fieldTitle: context.l10n.tel2,
                          controller: _tel2Controller,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.street,
                    controller: _streetController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                  ),
                  Gaps.h12,
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: MyTextFormField(
                          fieldTitle: context.l10n.zip,
                          controller: _zipCodeController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Gaps.w12,
                      Expanded(
                        flex: 25,
                        child: MyTextFormField(
                          fieldTitle: context.l10n.city,
                          controller: _cityController,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.state,
                    controller: _stateController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  Gaps.h12,
                  MyCountryFieldButton(
                    onTap: (country) {
                      if (country == null) return;
                      setState(() => _country = country);
                    },
                    country: _country,
                  ),
                  Gaps.h32,
                  Align(
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      onPressed: _onSavePressed,
                      child: Text(context.l10n.save),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isLoading) const MyFilledLoadingContainer(),
          ],
        ),
      ],
    );
  }

  void _onSavePressed() async {
    if (!_canCreate()) {
      showConditionerValidationDialog(context: context, firstName: _firstNameController.text, lastName: _lastNameController.text);
      return;
    }

    final conditioner = await _genConditioner();

    widget.conditionerBloc.add(UpdatetConditionerEvent(conditioner: conditioner));
  }

  bool _canCreate() => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;

  bool _isCoordinatesChanged() =>
      _streetController.text != widget.conditioner.address.street ||
      _zipCodeController.text != widget.conditioner.address.postalCode ||
      _cityController.text != widget.conditioner.address.city;

  Future<Conditioner> _genConditioner() async {
    final coordinates = _isCoordinatesChanged()
        ? await getCoordinatesFromAddress('${_streetController.text}, ${_zipCodeController.text} ${_cityController.text}, ${_country.name}')
        : {'latitude': widget.conditioner.address.latitude, 'longitude': widget.conditioner.address.longitude};

    final address = widget.conditioner.address.copyWith(
      country: _country,
      state: _stateController.text,
      city: _cityController.text,
      street: _streetController.text,
      postalCode: _zipCodeController.text,
      latitude: coordinates != null ? coordinates['latitude'] : null,
      longitude: coordinates != null ? coordinates['longitude'] : null,
    );

    final conditioner = widget.conditioner.copyWith(
      gender: _gender,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address: address,
      tel1: _tel1Controller.text,
      tel2: _tel2Controller.text,
    );

    return conditioner;
  }

  void _onGenderChanged(String? gender) {
    if (gender == null) return;

    if (gender == context.l10n.gender_male) {
      setState(() => _gender = Gender.male);
    } else if (gender == context.l10n.gender_female) {
      setState(() => _gender = Gender.female);
    } else {
      setState(() => _gender = Gender.empty);
    }
  }
}
