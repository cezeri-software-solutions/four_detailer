import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/auth/auth_bloc.dart';
import '../../../../2_application/branch_detail/branch_detail_bloc.dart';
import '../../../../core/core.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import 'branch_detail_page.dart';

@RoutePage()
class BranchDetailScreen extends StatefulWidget {
  final String branchId;

  const BranchDetailScreen({super.key, required this.branchId});

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> with AutomaticKeepAliveClientMixin {
  late final BranchDetailBloc _branchDetailBloc;

  @override
  void initState() {
    super.initState();

    _branchDetailBloc = sl<BranchDetailBloc>();
    _branchDetailBloc.add(GetBranchEvent(branchId: widget.branchId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _branchDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<BranchDetailBloc, BranchDetailState>(
            listenWhen: (p, c) => p.fosBranchOnObserveOption != c.fosBranchOnObserveOption,
            listener: (context, state) {
              state.fosBranchOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<BranchDetailBloc, BranchDetailState>(
            listenWhen: (p, c) => p.fosBranchOnUpdateOption != c.fosBranchOnUpdateOption,
            listener: (context, state) {
              state.fosBranchOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) {
                    showSuccessSnackBar(context: context, text: context.l10n.branch_detail_updateSuccess);
                    context.router.popUntilRouteWithName(BranchDetailRoute.name);
                  },
                ),
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => _branchDetailBloc.add(GetBranchEvent(branchId: widget.branchId)),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(child: BranchDetailPage(branchDetailBloc: _branchDetailBloc)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
