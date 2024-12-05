import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../../../2_application/settings/settings_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../settings_page.dart';

class BankSettingsCard extends StatelessWidget {
  final MainSettings settings;
  final bool isMobile;
  final SettingsBloc settingsBloc;

  const BankSettingsCard({
    super.key,
    required this.settings,
    required this.isMobile,
    required this.settingsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: context.l10n.settings_bank,
      icon: Icons.account_balance,
      isMobile: isMobile,
      children: [
        MyTextFormField(
          fieldTitle: context.l10n.settings_bankName,
          initialValue: settings.bankDetails.bankName,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(bankDetails: settings.bankDetails.copyWith(bankName: value))));
          },
        ),
        Gaps.h12,
        MyTextFormField(
          fieldTitle: context.l10n.settings_accountHolder,
          initialValue: settings.bankDetails.accountHolder,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(bankDetails: settings.bankDetails.copyWith(accountHolder: value))));
          },
        ),
        Gaps.h12,
        MyTextFormField(
          fieldTitle: context.l10n.settings_iban,
          initialValue: settings.bankDetails.iban,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(bankDetails: settings.bankDetails.copyWith(iban: value))));
          },
        ),
        Gaps.h12,
        MyTextFormField(
          fieldTitle: context.l10n.settings_bic,
          initialValue: settings.bankDetails.bic,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(bankDetails: settings.bankDetails.copyWith(bic: value))));
          },
        ),
        Gaps.h12,
        MyTextFormField(
          fieldTitle: context.l10n.settings_paypal,
          initialValue: settings.bankDetails.paypalEmail,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(bankDetails: settings.bankDetails.copyWith(paypalEmail: value))));
          },
        ),
      ],
    );
  }
}
