import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../2_application/settings/settings_bloc.dart';
import '../core/root_layout.dart';
import '../injection.dart';

@RoutePage()
class RootLayoutRoute extends StatefulWidget {
  const RootLayoutRoute({super.key});

  @override
  State<RootLayoutRoute> createState() => _RootLayoutRouteState();
}

class _RootLayoutRouteState extends State<RootLayoutRoute> with AutomaticKeepAliveClientMixin {
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

    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _settingsBloc)],
      child: const RootLayout(child: AutoRouter()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
