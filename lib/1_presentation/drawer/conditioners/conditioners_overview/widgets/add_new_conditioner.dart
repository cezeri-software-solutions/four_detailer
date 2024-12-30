import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/conditioners_overview/conditioners_overview_bloc.dart';
import '/3_domain/models/models.dart';
import '/3_domain/repositories/database_repository.dart';
import '/constants.dart';
import '/core/core.dart';

void showAddNewConditionerSheet({
  required BuildContext context,
  required ConditionersOverviewBloc conditionersOverviewBloc,
}) {
  final formKey = GlobalKey<_AddNewConditionerState>();

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
            child: Text(context.l10n.conditioners_overview_newConditioner, style: context.textTheme.titleLarge),
          ),
          child: _AddNewConditioner(key: formKey, conditionersOverviewBloc: conditionersOverviewBloc),
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
                  onPressed: () => formKey.currentState?._onSavePressed(),
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

class _AddNewConditioner extends StatefulWidget {
  final ConditionersOverviewBloc conditionersOverviewBloc;

  const _AddNewConditioner({super.key, required this.conditionersOverviewBloc});

  @override
  State<_AddNewConditioner> createState() => _AddNewConditionerState();
}

class _AddNewConditionerState extends State<_AddNewConditioner> {
  final _padding = 12.0;

  bool _passwordVisible = false;

  Gender _gender = Gender.empty;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _tel1Controller = TextEditingController();
  final _tel2Controller = TextEditingController();
  final _streetController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Country _country = Country.germany();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _setDefaultCountry());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.breakpoint.isMobile
          ? EdgeInsets.only(top: _padding, left: _padding, right: _padding, bottom: 106)
          : EdgeInsets.only(top: _padding, left: _padding, right: _padding, bottom: 94),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
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
              MyTextFormField(
                fieldTitle: context.l10n.email,
                controller: _emailController,
                prefixIcon: const Icon(Icons.email_outlined),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
              ),
              Gaps.h12,
              MyTextFormField(
                fieldTitle: context.l10n.password,
                controller: _passwordController,
                prefixIcon: const Icon(Icons.lock_outline),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_passwordVisible,
                suffixIcon: InkWell(
                  onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                  child: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                ),
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
            ],
          ),
        ],
      ),
    );
  }

  void _onSavePressed() async {
    if (!_canCreate()) {
      showNewEmployeeValidationDialogWolt(
        context: context,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      return;
    }

    final conditioner = await _genConditioner();
    widget.conditionersOverviewBloc.add(CreateNewConditionerEvent(conditioner: conditioner, password: _passwordController.text));
    if (mounted) context.pop();
  }

  bool _canCreate() =>
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      EmailValidator.validate(_emailController.text) &&
      _passwordController.text.length > 7;

  Future<Conditioner> _genConditioner() async {
    final coordinates = await getCoordinatesFromAddress(
      '${_streetController.text}, ${_zipCodeController.text} ${_cityController.text}, ${_country.name}',
    );

    final address = Address.empty().copyWith(
      country: _country,
      state: _stateController.text,
      city: _cityController.text,
      street: _streetController.text,
      postalCode: _zipCodeController.text,
      latitude: coordinates?['latitude'],
      longitude: coordinates?['longitude'],
    );

    return Conditioner.empty().copyWith(
      gender: _gender,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      address: address,
      tel1: _tel1Controller.text,
      tel2: _tel2Controller.text,
    );
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

  void _setDefaultCountry() async {
    final countryCode = Localizations.localeOf(context).countryCode;
    if (countryCode == null) return;

    final repo = GetIt.I<DatabaseRepository>();
    final fos = await repo.getCountyByIsoCode(countryCode);
    if (fos.isLeft()) return;
    final loadedCountry = fos.getRight();
    setState(() => _country = loadedCountry);
  }
}
