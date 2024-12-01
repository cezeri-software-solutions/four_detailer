import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_detailer/3_domain/repositories/auth_repository.dart';
import 'package:four_detailer/routes/router.gr.dart';
import 'package:get_it/get_it.dart';

import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/database_repository.dart';
import '../../4_infrastructur/functions/functions.dart';
import '../../constants.dart';
import '../../core/core.dart';

@RoutePage()
class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final bool _isLoading = false;
  final _padding = 12.0;

  Gender _gender = Gender.empty;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _compyanyController = TextEditingController();
  final _homepageController = TextEditingController();
  final _tel1Controller = TextEditingController();
  final _tel2Controller = TextEditingController();
  final _streetController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();

  Country _country = Country.empty();

  bool _isSmallBusiness = false;
  double _taxRate = 19;
  List<double> _taxRateItems = [19, 20];

  Currency _currency = Currency.main();
  List<Currency> _currencyItems = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final countryCode = Localizations.localeOf(context).countryCode;
      if (countryCode != null) {
        _loadCountyByIsoCode(countryCode);
        _loadTaxByIsoCode(countryCode);
      }
      _loadTaxes();
      _loadCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = context.brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: SizedBox(
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.h32,
                      Image.asset(isLightMode ? 'assets/logo/logo_advertised_black.png' : 'assets/logo/logo_advertised_white.png', width: 250),
                      Gaps.h12,
                      Text(context.l10n.user_data_needInformation, style: context.textTheme.titleMedium),
                      Gaps.h32,
                      MyDropdownButton(
                        fieldTitle: context.l10n.gender,
                        maxWidth: context.screenSize.width / 2 < 300 ? context.screenSize.width / 2 - _padding - 6 : 300 - 6,
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
                      Gaps.h32,
                      Text(context.l10n.user_data_companyTitle, style: context.textTheme.titleMedium),
                      Gaps.h12,
                      MyTextFormField(
                        fieldTitle: context.l10n.company,
                        controller: _compyanyController,
                        isMandatory: true,
                        prefixIcon: const Icon(Icons.business),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      Gaps.h12,
                      MyTextFormField(
                        fieldTitle: context.l10n.homepage,
                        controller: _homepageController,
                        prefixIcon: const Icon(Icons.web),
                        textInputAction: TextInputAction.next,
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
                      MyCountryFieldButton(
                        onTap: (country) {
                          if (country == null) return;
                          setState(() => _country = country);
                        },
                        country: _country,
                      ),
                      Gaps.h32,
                      Text(context.l10n.user_data_taxDataTitle, style: context.textTheme.titleMedium),
                      Gaps.h12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.l10n.user_data_isSmallBusiness),
                          Switch.adaptive(value: _isSmallBusiness, onChanged: (val) => setState(() => _isSmallBusiness = val)),
                        ],
                      ),
                      MyAnimatedExpansionContainer(
                        isExpanded: !_isSmallBusiness,
                        child: Column(
                          children: [
                            Gaps.h12,
                            MyDropdownButton(
                              value: _taxRate.toString(),
                              itemAsString: (val) => '${context.l10n.tax_abbreviated} $val %',
                              onChanged: (val) => setState(() => _taxRate = double.parse(val!)),
                              fieldTitle: context.l10n.tax,
                              isMandatory: true,
                              cacheItems: false,
                              showSearch: false,
                              items: _taxRateItems.map((e) => e.toString()).toList(),
                              itemBuilder: (context, item, isSelected, isDisabled) {
                                return ListTile(
                                  dense: true,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(context.l10n.tax_abbreviated, style: context.textTheme.bodyLarge),
                                      Text('$item %', style: context.textTheme.bodyLarge),
                                    ],
                                  ),
                                  selected: isDisabled,
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Gaps.h12,
                      MyDropdownButtonObject<Currency>(
                        value: _currency,
                        itemAsString: (cur) => '${cur.name} (${cur.code} / ${cur.symbol})',
                        onChanged: (cur) => setState(() => _currency = cur!),
                        fieldTitle: context.l10n.currency,
                        isMandatory: true,
                        cacheItems: false,
                        showSearch: false,
                        items: _currencyItems,
                        compareFn: (Currency? item, Currency? selectedItem) {
                          return item?.id == selectedItem?.id;
                        },
                        itemBuilder: (context, item, isSelected, isDisabled) {
                          return ListTile(
                            dense: true,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.name, style: context.textTheme.bodyLarge),
                                Text('(${item.code} / ${item.symbol})', style: context.textTheme.bodyLarge),
                              ],
                            ),
                            selected: isDisabled,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
                          );
                        },
                      ),
                      Gaps.h24,
                      Visibility.maintain(visible: _isLoading, child: const LinearProgressIndicator()),
                      Gaps.h24,
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _createUserDataPressed,
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colorScheme.primaryContainer,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(context.l10n.login, style: context.textTheme.headlineSmall),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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

  void _loadCountyByIsoCode(String localCountryCode) async {
    final repo = GetIt.I<DatabaseRepository>();

    final fos = await repo.getCountyByIsoCode(localCountryCode);
    if (fos.isLeft() && mounted) return;

    setState(() => _country = fos.getRight());
  }

  void _loadTaxByIsoCode(String localCountryCode) async {
    final repo = GetIt.I<DatabaseRepository>();

    final fos = await repo.getTaxByCountryCode(localCountryCode);
    if (fos.isLeft() && mounted) return;

    setState(() => _taxRate = fos.getRight().rate);
  }

  void _loadTaxes() async {
    final repo = GetIt.I<DatabaseRepository>();

    final fos = await repo.getTaxes();
    if (fos.isLeft() && mounted) return;

    setState(() => _taxRateItems = fos.getRight().map((e) => e.rate).toList());
  }

  void _loadCurrencies() async {
    final repo = GetIt.I<DatabaseRepository>();

    final fos = await repo.getCurrencies();
    if (fos.isLeft() && mounted) return;

    setState(() => _currencyItems = fos.getRight());
  }

  Future<Address> _genAddress() async {
    final coordinates =
        await getCoordinatesFromAddress('${_streetController.text}, ${_zipCodeController.text} ${_cityController.text}, ${_country.name}');

    final address = Address.empty().copyWith(
      country: _country,
      city: _cityController.text,
      street: _streetController.text,
      postalCode: _zipCodeController.text,
      latitude: coordinates != null ? coordinates['latitude'] : null,
      longitude: coordinates != null ? coordinates['longitude'] : null,
    );

    return address;
  }

  Future<Conditioner> _genConditioner() async {
    final address = await _genAddress();

    final conditioner = Conditioner.empty().copyWith(
      gender: _gender,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: getCurrentUserEmail(),
      address: address,
      tel1: _tel1Controller.text,
      tel2: _tel2Controller.text,
      conditionerTyp: ConditionerType.owner,
      isActive: true,
    );

    return conditioner;
  }

  Future<Branch> _genBranch() async {
    final address = await _genAddress();

    final branch = Branch.empty().copyWith(
      branchNumber: MainSettings.empty().numberCounters.nextBranchNumber - 1,
      branchName: _compyanyController.text,
      tel1: _tel1Controller.text,
      tel2: _tel2Controller.text,
      email: getCurrentUserEmail(),
      address: address,
      homepage: _homepageController.text,
      isMainBranch: true,
      serviceType: ServiceType.stationary,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return branch;
  }

  MainSettings _getSettings() => MainSettings.empty().copyWith(tax: _taxRate, currency: _currency, isSmallBusiness: _isSmallBusiness);

  CashRegister _getCashRegister() {
    final cashRegister = CashRegister.empty().copyWith(
      name: context.l10n.defaultCashRegisterName,
      shortName: context.l10n.defaultCashRegisterShortName,
      isDefault: true,
    );

    return cashRegister;
  }

  PaymentMethod _getPaymentMethod() {
    final paymentMethod = PaymentMethod.empty().copyWith(
      name: context.l10n.defaultPaymentMethodName,
      shortName: context.l10n.defaultPaymentMethodShortName,
      isDefault: true,
    );

    return paymentMethod;
  }

  bool _canCreate() => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty && _compyanyController.text.isNotEmpty;

  void _createUserDataPressed() async {
    // final bb = await _genBranch();

    // printJson(bb.toJson());
    // return;
    if (!_canCreate()) {
      showConditionerValidationDialog(
        context: context,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        company: _compyanyController.text,
      );
      return;
    }
    showMyDialogLoading(context: context, text: context.l10n.user_data_loadingText);

    final repo = GetIt.I<AuthRepository>();

    final conditioner = await _genConditioner();
    final settings = _getSettings();
    final branch = await _genBranch();
    final cashRegister = _getCashRegister();
    final paymentMethod = _getPaymentMethod();

    final response = await repo.createNewCondtionerOnSignUp(
      conditioner: conditioner,
      settings: settings,
      branch: branch,
      cashRegister: cashRegister,
      paymentMethod: paymentMethod,
    );

    if (response.isLeft() && mounted) {
      context.pop();

      showMyDialogAlert(
        context: context,
        title: context.l10n.error,
        content: response.getLeft().toString(),
      );

      return;
    }

    if (mounted) context.router.replaceAll([const SplashRoute()]);
  }
}
