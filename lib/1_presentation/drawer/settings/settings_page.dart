import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/settings/settings_bloc.dart';
import '../../../3_domain/models/models.dart';
import '../../../core/core.dart';

class SettingsPage extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const SettingsPage({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);
    final isTablet = context.breakpoint.smallerOrEqualTo(TABLET);

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state.isLoadingSettingsOnOserve) {
          return const Center(child: MyLoadingIndicator());
        }
        if (state.failure != null) {
          return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        }
        if (state.settings == null) {
          return const Center(child: MyLoadingIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ResponsiveRowColumn(
              layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: _buildBasicSettings(context, state.settings!, isMobile),
                ),
                if (!isMobile) const ResponsiveRowColumnItem(child: SizedBox(width: 16)),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: _buildDocumentSettings(context, state.settings!, isMobile),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBasicSettings(BuildContext context, MainSettings settings, bool isMobile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grundeinstellungen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildSettingsField(
              label: 'Kleinunternehmer',
              child: Switch(
                value: settings.isSmallBusiness,
                onChanged: (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(isSmallBusiness: value),
                  ));
                },
              ),
            ),
            _buildSettingsField(
              label: 'Mehrwertsteuer (%)',
              child: SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: settings.tax.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final tax = double.tryParse(value);
                    if (tax != null) {
                      settingsBloc.add(UpdateSettingsEvent(
                        settings: settings.copyWith(tax: tax),
                      ));
                    }
                  },
                ),
              ),
            ),
            _buildSettingsField(
              label: 'Zahlungsfrist (Tage)',
              child: SizedBox(
                width: 100,
                child: TextFormField(
                  initialValue: settings.paymentDeadline.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final days = int.tryParse(value);
                    if (days != null) {
                      settingsBloc.add(UpdateSettingsEvent(settings: settings.copyWith(paymentDeadline: days)));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentSettings(BuildContext context, MainSettings settings, bool isMobile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dokumenteinstellungen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('Dokumentpräfixe'),
              children: [
                _buildPrefixField('Rechnung', settings.documentPraefixes.invoicePraefix, (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(
                      documentPraefixes: settings.documentPraefixes.copyWith(invoicePraefix: value),
                    ),
                  ));
                }),
                _buildPrefixField('Angebot', settings.documentPraefixes.offerPraefix, (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(
                      documentPraefixes: settings.documentPraefixes.copyWith(offerPraefix: value),
                    ),
                  ));
                }),
              ],
            ),
            ExpansionTile(
              title: const Text('Bankdaten'),
              children: [
                _buildPrefixField('IBAN', settings.bankDetails.iban, (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(
                      bankDetails: settings.bankDetails.copyWith(iban: value),
                    ),
                  ));
                }),
                _buildPrefixField('BIC', settings.bankDetails.bic, (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(
                      bankDetails: settings.bankDetails.copyWith(bic: value),
                    ),
                  ));
                }),
                _buildPrefixField('Bank', settings.bankDetails.bankName, (value) {
                  settingsBloc.add(UpdateSettingsEvent(
                    settings: settings.copyWith(
                      bankDetails: settings.bankDetails.copyWith(bankName: value),
                    ),
                  ));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          child,
        ],
      ),
    );
  }

  Widget _buildPrefixField(String label, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: value,
              onChanged: onChanged,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
