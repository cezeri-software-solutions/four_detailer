import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/auth/auth_bloc.dart';
import '/core/core.dart';
import '/injection.dart';
import '/routes/router.gr.dart';
import '../../../../2_application/conditioner_detail/conditioner_detail_bloc.dart';
import 'conditioner_detail_page.dart';

@RoutePage()
class ConditionerDetailScreen extends StatefulWidget {
  final String conditionerId;

  const ConditionerDetailScreen({super.key, @PathParam('conditionerId') required this.conditionerId});

  @override
  State<ConditionerDetailScreen> createState() => _ConditionerDetailScreenState();
}

class _ConditionerDetailScreenState extends State<ConditionerDetailScreen> with AutomaticKeepAliveClientMixin {
  late final ConditionerDetailBloc _conditionerDetailBloc;

  @override
  void initState() {
    super.initState();

    _conditionerDetailBloc = sl<ConditionerDetailBloc>();
    _conditionerDetailBloc.add(GetConditionerEvent(conditionerId: widget.conditionerId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _conditionerDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<ConditionerDetailBloc, ConditionerDetailState>(
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
          BlocListener<ConditionerDetailBloc, ConditionerDetailState>(
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
          drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
          appBar: AppBar(
            actions: [
              IconButton(onPressed: () => _conditionerDetailBloc.add(GetCurrentConditionerEvent()), icon: const Icon(Icons.refresh)),
            ],
          ),
          body: SafeArea(child: ConditionerDetailPage(conditionerDetailBloc: _conditionerDetailBloc)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
