import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/auth/auth_bloc.dart';
import '../../../../2_application/conditioners_overview/conditioners_overview_bloc.dart';
import '../../../../core/core.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import 'conditioners_overview_page.dart';

@RoutePage()
class ConditionersOverviewScreen extends StatefulWidget {
  const ConditionersOverviewScreen({super.key});

  @override
  State<ConditionersOverviewScreen> createState() => _ConditionersOverviewScreenState();
}

class _ConditionersOverviewScreenState extends State<ConditionersOverviewScreen> with AutomaticKeepAliveClientMixin {
  late final ConditionersOverviewBloc _conditionersOverviewBloc;

  @override
  void initState() {
    super.initState();

    _conditionersOverviewBloc = sl<ConditionersOverviewBloc>();
    _conditionersOverviewBloc.add(GetConditionersEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _conditionersOverviewBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<ConditionersOverviewBloc, ConditionersOverviewState>(
            listenWhen: (p, c) => p.fosConditionersOption != c.fosConditionersOption,
            listener: (context, state) {
              state.fosConditionersOption.fold(() => null,
                  (a) => a.fold((failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()), (_) => null));
            },
          ),
        ],
        child: Scaffold(
          drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
          appBar: AppBar(
            title: Text(context.l10n.conditioners_overview_title),
            actions: [
              IconButton(
                onPressed: () => _conditionersOverviewBloc.add(GetConditionersEvent()),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(child: ConditionersOverviewPage(conditionersOverviewBloc: _conditionersOverviewBloc)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
