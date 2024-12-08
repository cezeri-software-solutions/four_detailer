import 'package:flutter/material.dart';

import '/2_application/branch_detail/branch_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';

class BranchDetailEdit extends StatefulWidget {
  final BranchDetailBloc branchDetailBloc;
  final Branch branch;
  final bool isLoading;

  const BranchDetailEdit({
    required this.branchDetailBloc,
    required this.branch,
    required this.isLoading,
    super.key,
  });

  @override
  State<BranchDetailEdit> createState() => _BranchDetailEditState();
}

class _BranchDetailEditState extends State<BranchDetailEdit> {
  final _padding = 12.0;

  late final TextEditingController _branchNameController;
  late final TextEditingController _tel1Controller;
  late final TextEditingController _tel2Controller;
  late final TextEditingController _emailController;
  late final TextEditingController _homepageController;
  late final TextEditingController _uidNumberController;
  late final TextEditingController _districtCourtController;
  late final TextEditingController _commercialRegisterController;
  late final TextEditingController _streetController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;

  late ServiceType _serviceType;
  late bool _isMainBranch;
  late bool _isActive;
  late Country _country;

  @override
  void initState() {
    super.initState();

    _branchNameController = TextEditingController(text: widget.branch.branchName);
    _tel1Controller = TextEditingController(text: widget.branch.tel1);
    _tel2Controller = TextEditingController(text: widget.branch.tel2);
    _emailController = TextEditingController(text: widget.branch.email);
    _homepageController = TextEditingController(text: widget.branch.homepage ?? '');
    _uidNumberController = TextEditingController(text: widget.branch.uidNumber ?? '');
    _districtCourtController = TextEditingController(text: widget.branch.districtCourt ?? '');
    _commercialRegisterController = TextEditingController(text: widget.branch.commercialRegister ?? '');
    _streetController = TextEditingController(text: widget.branch.address.street);
    _zipCodeController = TextEditingController(text: widget.branch.address.postalCode);
    _cityController = TextEditingController(text: widget.branch.address.city);
    _stateController = TextEditingController(text: widget.branch.address.state);

    _serviceType = widget.branch.serviceType;
    _isMainBranch = widget.branch.isMainBranch;
    _isActive = widget.branch.isActive;
    _country = widget.branch.address.country;
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
                  if (context.breakpoint.isMobile) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.l10n.branch_detail_isActive, style: context.textTheme.bodyLarge),
                        Checkbox.adaptive(value: _isActive, onChanged: (value) => setState(() => _isActive = value ?? true)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.l10n.branch_detail_isMainBranch, style: context.textTheme.bodyLarge),
                        Checkbox.adaptive(value: _isMainBranch, onChanged: (value) => setState(() => _isMainBranch = value ?? false)),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(context.l10n.branch_detail_isActive, style: context.textTheme.bodyLarge),
                              Checkbox.adaptive(value: _isActive, onChanged: (value) => setState(() => _isActive = value ?? true)),
                            ],
                          ),
                        ),
                        Gaps.w24,
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(context.l10n.branch_detail_isMainBranch, style: context.textTheme.bodyLarge),
                              Checkbox.adaptive(value: _isMainBranch, onChanged: (value) => setState(() => _isMainBranch = value ?? false)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.branch_detail_branchName,
                    controller: _branchNameController,
                    isMandatory: true,
                    prefixIcon: const Icon(Icons.business),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
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
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.email,
                    controller: _emailController,
                    isMandatory: true,
                    prefixIcon: const Icon(Icons.email),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.homepage,
                    controller: _homepageController,
                    prefixIcon: const Icon(Icons.language),
                    textInputAction: TextInputAction.next,
                  ),
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.branch_detail_uidNumber,
                    controller: _uidNumberController,
                    prefixIcon: const Icon(Icons.numbers),
                    textInputAction: TextInputAction.next,
                  ),
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.branch_detail_districtCourt,
                    controller: _districtCourtController,
                    prefixIcon: const Icon(Icons.gavel),
                    textInputAction: TextInputAction.next,
                  ),
                  Gaps.h12,
                  MyTextFormField(
                    fieldTitle: context.l10n.branch_detail_commercialRegister,
                    controller: _commercialRegisterController,
                    prefixIcon: const Icon(Icons.article),
                    textInputAction: TextInputAction.next,
                  ),
                  Gaps.h24,
                  MyDropdownButton(
                    fieldTitle: context.l10n.branch_detail_serviceType,
                    showSearch: false,
                    value: _serviceType.toLocalizedString(context),
                    onChanged: _onServiceTypeChanged,
                    items: ServiceType.values.map((type) => type.toLocalizedString(context)).toList(),
                  ),
                  Gaps.h32,
                  Text(context.l10n.branch_detail_address, style: context.textTheme.titleMedium),
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
                        ),
                      ),
                      Gaps.w12,
                      Expanded(
                        flex: 25,
                        child: MyTextFormField(
                          fieldTitle: context.l10n.city,
                          controller: _cityController,
                          textInputAction: TextInputAction.next,
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
                    textCapitalization: TextCapitalization.words,
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

  void _onServiceTypeChanged(String? value) {
    if (value == null) return;
    setState(() => _serviceType = ServiceType.values.firstWhere((type) => type == value.toServiceType(context)));
  }

  void _onSavePressed() async {
    if (!_canCreate()) {
      showErrorSnackbar(
        context: context,
        text: context.l10n.branch_detail_validationMessage,
      );
      return;
    }

    final branch = await _genBranch();
    print(branch.serviceType);
    widget.branchDetailBloc.add(UpdateBranchEvent(branch: branch));
  }

  bool _canCreate() => _branchNameController.text.isNotEmpty && _emailController.text.isNotEmpty;

  bool _isCoordinatesChanged() =>
      _streetController.text != widget.branch.address.street ||
      _zipCodeController.text != widget.branch.address.postalCode ||
      _cityController.text != widget.branch.address.city;

  Future<Branch> _genBranch() async {
    final coordinates = _isCoordinatesChanged()
        ? await getCoordinatesFromAddress('${_streetController.text}, ${_zipCodeController.text} ${_cityController.text}, ${_country.name}')
        : {'latitude': widget.branch.address.latitude, 'longitude': widget.branch.address.longitude};

    final address = widget.branch.address.copyWith(
      country: _country,
      state: _stateController.text,
      city: _cityController.text,
      street: _streetController.text,
      postalCode: _zipCodeController.text,
      latitude: coordinates != null ? coordinates['latitude'] : null,
      longitude: coordinates != null ? coordinates['longitude'] : null,
    );

    return widget.branch.copyWith(
      branchName: _branchNameController.text,
      tel1: _tel1Controller.text,
      tel2: _tel2Controller.text,
      email: _emailController.text,
      homepage: _homepageController.text,
      uidNumber: _uidNumberController.text,
      districtCourt: _districtCourtController.text,
      commercialRegister: _commercialRegisterController.text,
      serviceType: _serviceType,
      isMainBranch: _isMainBranch,
      isActive: _isActive,
      address: address,
    );
  }
}
