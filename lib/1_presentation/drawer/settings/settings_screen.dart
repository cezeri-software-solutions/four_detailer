import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_detailer/1_presentation/drawer/settings/settings_page.dart';

import '../../../2_application/settings/settings_bloc.dart';
import '../../../core/core.dart';
import '../../../injection.dart';

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
        listeners: const [],
        child: Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            actions: [IconButton(onPressed: () => _settingsBloc.add(LoadSettingsEvent()), icon: const Icon(Icons.refresh))],
          ),
          body: SafeArea(child: SettingsPage(settingsBloc: _settingsBloc)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
