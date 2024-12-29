import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/settings/settings_bloc.dart';
import '../../../3_domain/models/models.dart';
import '../../../constants.dart';
import '../../../core/core.dart';
import 'widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const SettingsPage({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state.isLoadingSettingsOnOserve) return const Center(child: MyLoadingIndicator());
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.settings == null) return const Center(child: MyLoadingIndicator());

        return RefreshIndicator.adaptive(
          onRefresh: () async => settingsBloc.add(LoadSettingsEvent()),
          child: ListView(
            children: [
              Visibility(
                visible: state.isLoadingSettingsOnUpdate,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: const Center(child: LinearProgressIndicator()),
              ),
              SettingsContent(
                settings: state.settings!,
                availableCurrencies: state.availableCurrencies ?? [],
                isMobile: isMobile,
                settingsBloc: settingsBloc,
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsContent extends StatelessWidget {
  final MainSettings settings;
  final List<Currency> availableCurrencies;
  final bool isMobile;
  final SettingsBloc settingsBloc;

  const SettingsContent({
    super.key,
    required this.settings,
    required this.availableCurrencies,
    required this.isMobile,
    required this.settingsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: isMobile ? const EdgeInsets.all(12) : const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveRowColumn(
              layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              rowMainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Column(
                    children: [
                      BasicSettingsCard(settings: settings, currencies: availableCurrencies, isMobile: isMobile, settingsBloc: settingsBloc),
                      Gaps.h24,
                      BankSettingsCard(settings: settings, isMobile: isMobile, settingsBloc: settingsBloc),
                      Gaps.h24,
                    ],
                  ),
                ),
                if (!isMobile) const ResponsiveRowColumnItem(child: Gaps.w24),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Column(
                    children: [
                      DocumentPrefixesCard(settings: settings, isMobile: isMobile, settingsBloc: settingsBloc),
                      Gaps.h24,
                      NumberCountersCard(settings: settings, isMobile: isMobile, settingsBloc: settingsBloc),
                      Gaps.h24,
                      DocumentTextsCard(settings: settings, isMobile: isMobile, settingsBloc: settingsBloc),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isMobile;
  final List<Widget> children;

  const SettingsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isMobile,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      padding: EdgeInsets.zero,
      borderColor: context.colorScheme.outlineVariant,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.2),
                border: Border(left: BorderSide(color: context.colorScheme.primary, width: 4)),
              ),
              child: Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 12),
                  Text(title, style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
