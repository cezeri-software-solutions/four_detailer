import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../../../2_application/settings/settings_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../settings_page.dart';

class BasicSettingsCard extends StatelessWidget {
  final MainSettings settings;
  final List<Currency> currencies;
  final bool isMobile;
  final SettingsBloc settingsBloc;

  const BasicSettingsCard({
    super.key,
    required this.settings,
    required this.currencies,
    required this.isMobile,
    required this.settingsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: context.l10n.settings_basic,
      icon: Icons.settings,
      isMobile: isMobile,
      children: [
        _SettingsField(
          label: context.l10n.settings_smallBusiness,
          child: Switch.adaptive(
            value: settings.isSmallBusiness,
            activeColor: context.colorScheme.primary,
            onChanged: (value) {
              settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(isSmallBusiness: value)));
            },
          ),
        ),
        _SettingsField(
          label: context.l10n.settings_taxPercent,
          child: SizedBox(
            width: 120,
            child: MyTextFormField(
              initialValue: settings.tax.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [DoubleInputFormatter()],
              onChanged: (value) {
                final tax = double.tryParse(value);
                if (tax != null) settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(tax: tax)));
              },
            ),
          ),
        ),
        _SettingsField(
          label: context.l10n.settings_paymentDeadline,
          child: SizedBox(
            width: 120,
            child: MyTextFormField(
              initialValue: settings.paymentDeadline.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [IntegerInputFormatter()],
              onChanged: (value) {
                final days = int.tryParse(value);
                if (days != null) settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(paymentDeadline: days)));
              },
            ),
          ),
        ),
        MyDropdownButtonObject<Currency>(
          value: settings.currency,
          itemAsString: (cur) => '${cur.name} (${cur.code} / ${cur.symbol})',
          onChanged: (value) {
            if (value != null) settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(currency: value)));
          },
          fieldTitle: context.l10n.currency,
          cacheItems: false,
          showSearch: false,
          items: currencies,
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
      ],
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String label;
  final Widget child;

  const _SettingsField({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          child,
        ],
      ),
    );
  }
}
