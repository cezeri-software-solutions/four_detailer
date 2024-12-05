import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../../../2_application/settings/settings_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../settings_page.dart';

class NumberCountersCard extends StatelessWidget {
  final MainSettings settings;
  final bool isMobile;
  final SettingsBloc settingsBloc;

  const NumberCountersCard({
    super.key,
    required this.settings,
    required this.isMobile,
    required this.settingsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: context.l10n.settings_numberCounters,
      icon: Icons.numbers,
      isMobile: isMobile,
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_counterNextOffer)),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.numberCounters.nextOfferNumber.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [IntegerInputFormatter()],
                onChanged: (value) {
                  final number = int.tryParse(value);
                  if (number != null) {
                    settingsBloc.add(UpdateSettingsEvent(
                      settings: settings.copyWith(numberCounters: settings.numberCounters.copyWith(nextOfferNumber: number)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_counterNextAppointment)),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.numberCounters.nextAppointmentNumber.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [IntegerInputFormatter()],
                onChanged: (value) {
                  final number = int.tryParse(value);
                  if (number != null) {
                    settingsBloc.add(UpdateSettingsEvent(
                      settings: settings.copyWith(numberCounters: settings.numberCounters.copyWith(nextAppointmentNumber: number)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_counterNextInvoice)),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.numberCounters.nextInvoiceNumber.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [IntegerInputFormatter()],
                onChanged: (value) {
                  final number = int.tryParse(value);
                  if (number != null) {
                    settingsBloc.add(UpdateSettingsEvent(
                      settings: settings.copyWith(numberCounters: settings.numberCounters.copyWith(nextInvoiceNumber: number)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_counterNextIncomingInvoice)),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.numberCounters.nextIncomingInvoiceNumber.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [IntegerInputFormatter()],
                onChanged: (value) {
                  final number = int.tryParse(value);
                  if (number != null) {
                    settingsBloc.add(UpdateSettingsEvent(
                      settings: settings.copyWith(numberCounters: settings.numberCounters.copyWith(nextIncomingInvoiceNumber: number)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_counterNextBranch)),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.numberCounters.nextBranchNumber.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [IntegerInputFormatter()],
                onChanged: (value) {
                  final number = int.tryParse(value);
                  if (number != null) {
                    settingsBloc.add(UpdateSettingsEvent(
                      settings: settings.copyWith(numberCounters: settings.numberCounters.copyWith(nextBranchNumber: number)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        Gaps.h12,
        Row(
          children: [
            Expanded(flex: 2, child: Text(context.l10n.settings_counterNextCustomer)),
            Expanded(
              flex: 1,
              child: MyTextFormField(
                initialValue: settings.numberCounters.nextCustomerNumber.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [IntegerInputFormatter()],
                onChanged: (value) {
                  final number = int.tryParse(value);
                  if (number != null) {
                    settingsBloc.add(UpdateSettingsEvent(
                      settings: settings.copyWith(numberCounters: settings.numberCounters.copyWith(nextCustomerNumber: number)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
