import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/auth/auth_bloc.dart';
import '/2_application/conditioner/conditioner_bloc.dart';
import '/core/core.dart';
import '/injection.dart';
import '/routes/router.gr.dart';
import 'conditioner_detail_page.dart';

@RoutePage()
class ConditionerDetailScreen extends StatefulWidget {
  const ConditionerDetailScreen({super.key});

  @override
  State<ConditionerDetailScreen> createState() => _ConditionerDetailScreenState();
}

class _ConditionerDetailScreenState extends State<ConditionerDetailScreen> with AutomaticKeepAliveClientMixin {
  late final ConditionerBloc _conditionerBloc;

  @override
  void initState() {
    super.initState();

    _conditionerBloc = sl<ConditionerBloc>();
    _conditionerBloc.add(GetCurrentConditionerEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _conditionerBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<ConditionerBloc, ConditionerState>(
            listenWhen: (p, c) => p.fosConditionerOnObserveOption != c.fosConditionerOnObserveOption,
            listener: (context, state) {
              state.fosConditionerOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<ConditionerBloc, ConditionerState>(
            listenWhen: (p, c) => p.fosConditionerOnUpdateOption != c.fosConditionerOnUpdateOption,
            listener: (context, state) {
              state.fosConditionerOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) {
                    showSuccessSnackBar(context: context, text: 'Aufbereiter erfolgreich aktualisiert');
                    context.router.popUntilRouteWithName(ConditionerDetailRoute.name);
                  },
                ),
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(onPressed: () => _conditionerBloc.add(GetCurrentConditionerEvent()), icon: const Icon(Icons.refresh)),
            ],
          ),
          body: ConditionerDetailPage(conditionerBloc: _conditionerBloc),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
