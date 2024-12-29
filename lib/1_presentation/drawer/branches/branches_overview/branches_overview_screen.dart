import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/auth/auth_bloc.dart';
import '../../../../2_application/branches_overview/branches_overview_bloc.dart';
import '../../../../core/core.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import 'branches_overview_page.dart';

@RoutePage()
class BranchesOverviewScreen extends StatefulWidget {
  const BranchesOverviewScreen({super.key});

  @override
  State<BranchesOverviewScreen> createState() => _BranchesOverviewScreenState();
}

class _BranchesOverviewScreenState extends State<BranchesOverviewScreen> with AutomaticKeepAliveClientMixin {
  late final BranchesOverviewBloc _branchesOverviewBloc;

  @override
  void initState() {
    super.initState();

    _branchesOverviewBloc = sl<BranchesOverviewBloc>();
    _branchesOverviewBloc.add(GetBranchesEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _branchesOverviewBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<BranchesOverviewBloc, BranchesOverviewState>(
            listenWhen: (p, c) => p.fosBranchesOption != c.fosBranchesOption,
            listener: (context, state) {
              state.fosBranchesOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
        ],
        child: Scaffold(
          drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
          appBar: AppBar(
            title: MyAppBarTitle(title: context.l10n.branches_overview_title),
            actions: [
              IconButton(
                onPressed: () => _branchesOverviewBloc.add(GetBranchesEvent()),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(child: BranchesOverviewPage(branchesOverviewBloc: _branchesOverviewBloc)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
