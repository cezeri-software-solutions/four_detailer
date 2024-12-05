import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../../../2_application/settings/settings_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../settings_page.dart';

class DocumentTextsCard extends StatelessWidget {
  final MainSettings settings;
  final bool isMobile;
  final SettingsBloc settingsBloc;

  const DocumentTextsCard({
    super.key,
    required this.settings,
    required this.isMobile,
    required this.settingsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: context.l10n.settings_documentTexts,
      icon: Icons.description,
      isMobile: isMobile,
      children: [
        MyTextFormField(
          fieldTitle: context.l10n.settings_textOffer,
          initialValue: settings.documentTexts.offerDocumentText,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(
              settings: settings.copyWith(
                documentTexts: settings.documentTexts.copyWith(offerDocumentText: value),
              ),
            ));
          },
          maxLines: 3,
        ),
        Gaps.h16,
        MyTextFormField(
          fieldTitle: context.l10n.settings_textAppointment,
          initialValue: settings.documentTexts.appointmentDocumentText,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(
              settings: settings.copyWith(
                documentTexts: settings.documentTexts.copyWith(appointmentDocumentText: value),
              ),
            ));
          },
          maxLines: 3,
        ),
        Gaps.h16,
        MyTextFormField(
          fieldTitle: context.l10n.settings_textInvoice,
          initialValue: settings.documentTexts.invoiceDocumentText,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(
              settings: settings.copyWith(
                documentTexts: settings.documentTexts.copyWith(invoiceDocumentText: value),
              ),
            ));
          },
          maxLines: 3,
        ),
        Gaps.h16,
        MyTextFormField(
          fieldTitle: context.l10n.settings_textCredit,
          initialValue: settings.documentTexts.creditDocumentText,
          onChanged: (value) {
            settingsBloc.add(UpdateSettingsEvent(
              settings: settings.copyWith(
                documentTexts: settings.documentTexts.copyWith(creditDocumentText: value),
              ),
            ));
          },
          maxLines: 3,
        ),
      ],
    );
  }
}
