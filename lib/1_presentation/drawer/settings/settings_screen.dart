import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/auth/auth_bloc.dart';
import '../../../2_application/settings/settings_bloc.dart';
import '../../../core/core.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import 'settings_page.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with AutomaticKeepAliveClientMixin {
  late final SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = sl<SettingsBloc>();
    _settingsBloc.add(LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _settingsBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<SettingsBloc, SettingsState>(
            listenWhen: (p, c) => p.fosSettingsOnUpdateOption != c.fosSettingsOnUpdateOption,
            listener: (context, state) {
              state.fosSettingsOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) {
                    showSuccessSnackBar(context: context, text: 'Einstellungen erfolgreich aktualisiert');
                    context.router.popUntilRouteWithName(SettingsRoute.name);
                  },
                ),
              );
            },
          ),
        ],
        child: Scaffold(
          drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
          appBar: AppBar(
            title: Text(context.l10n.settings_title),
            actions: [
              IconButton(
                onPressed: () => _settingsBloc.add(LoadSettingsEvent()),
                icon: const Icon(Icons.refresh),
              ),
              MySaveButton(
                label: context.l10n.save,
                isLoading: _settingsBloc.state.isLoadingSettingsOnUpdate,
                onPressed: () => _settingsBloc.add(SaveMainSettingsEvent()),
              ),
            ],
          ),
          body: SafeArea(child: SettingsPage(settingsBloc: _settingsBloc)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
