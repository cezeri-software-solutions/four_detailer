import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/core/core.dart';
import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/database_repository.dart';

Future<Country?> showSelectCountrySheet(BuildContext context) async {
  final title = Padding(
    padding: const EdgeInsets.only(left: 24, top: 20),
    child: Text(context.l10n.select_country, style: context.textTheme.titleLarge),
  );

  final closeButton = Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
  );

  final selectedCountry = await WoltModalSheet.show<Country?>(
    context: context,
    barrierDismissible: false,
    enableDrag: true,
    showDragHandle: false,
    useSafeArea: false,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        leadingNavBarWidget: title,
        trailingNavBarWidget: closeButton,
        forceMaxHeight: true,
        child: _SelectCountry(),
      ),
    ],
  );

  return selectedCountry;
}

class _SelectCountry extends StatefulWidget {
  @override
  State<_SelectCountry> createState() => __SelectCountryState();
}

class __SelectCountryState extends State<_SelectCountry> {
  List<Country>? _countries;
  List<Country> _filteredCountries = [];

  final _searchController = SearchController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _loadCountries();

    // Den Fokus beim Starten auf das Suchfeld setzen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) FocusScope.of(context).requestFocus(_searchFocusNode);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _searchController.dispose();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_countries == null) return SizedBox(height: context.screenSize.height - 200, child: const Center(child: MyLoadingIndicator()));

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 24)),
      child: Column(
        children: [
          CupertinoSearchTextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (value) {
              if (value.isEmpty) setState(() => _filteredCountries = _countries!);

              setState(() => _filteredCountries = _countries!
                  .where((country) =>
                      country.name.toLowerCase().contains(value.toLowerCase()) || country.nameEnglish.toLowerCase().contains(value.toLowerCase()))
                  .toList());
            },
            onSuffixTap: () {
              _searchController.clear();
              setState(() => _filteredCountries = _countries!);
            },
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 12),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemCount: _filteredCountries.length,
            itemBuilder: (context, index) {
              final country = _filteredCountries[index];

              return ListTile(
                dense: true,
                leading: MyCountryFlag(country: country),
                title: Text(country.name),
                onTap: () => context.pop(country),
              );
            },
          ),
        ],
      ),
    );
  }

  void _loadCountries() async {
    final repo = GetIt.I<DatabaseRepository>();

    final fos = await repo.getCountries();
    if (fos.isLeft() && mounted) {
      showMyDialogAlert(context: context, title: context.l10n.error, content: context.l10n.error_on_load_countries);
      return;
    }

    setState(() {
      _countries = fos.getRight();
      _filteredCountries = _countries!;
    });
  }
}
