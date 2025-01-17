import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../../../2_application/settings/settings_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../settings_page.dart';

class DocumentPrefixesCard extends StatelessWidget {
  final MainSettings settings;
  final bool isMobile;
  final SettingsBloc settingsBloc;

  const DocumentPrefixesCard({
    super.key,
    required this.settings,
    required this.isMobile,
    required this.settingsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: context.l10n.settings_documentPrefixes,
      icon: Icons.format_list_numbered,
      isMobile: isMobile,
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_prefixOffer, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.documentPraefixes.offerPraefix,
                onChanged: (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(documentPraefixes: settings.documentPraefixes.copyWith(offerPraefix: value)),
                  ));
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(context.l10n.settings_prefixAppointment, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.documentPraefixes.appointmentPraefix,
                onChanged: (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(documentPraefixes: settings.documentPraefixes.copyWith(appointmentPraefix: value)),
                  ));
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_prefixInvoice, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.documentPraefixes.invoicePraefix,
                onChanged: (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(documentPraefixes: settings.documentPraefixes.copyWith(invoicePraefix: value)),
                  ));
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_prefixCredit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.documentPraefixes.creditPraefix,
                onChanged: (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(documentPraefixes: settings.documentPraefixes.copyWith(creditPraefix: value)),
                  ));
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(
                flex: 2, child: Text(context.l10n.settings_prefixIncomingInvoice, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.documentPraefixes.incomingInvoicePraefix,
                onChanged: (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(documentPraefixes: settings.documentPraefixes.copyWith(incomingInvoicePraefix: value)),
                  ));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
