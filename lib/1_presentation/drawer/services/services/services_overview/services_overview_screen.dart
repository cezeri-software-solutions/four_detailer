import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/auth/auth_bloc.dart';
import '/2_application/services_overview/services_overview_bloc.dart';
import '/core/core.dart';
import '/injection.dart';
import '/routes/router.gr.dart';
import 'services_overview_page.dart';

@RoutePage()
class ServicesOverviewScreen extends StatefulWidget {
  const ServicesOverviewScreen({super.key});

  @override
  State<ServicesOverviewScreen> createState() => _ServicesOverviewScreenState();
}

class _ServicesOverviewScreenState extends State<ServicesOverviewScreen> with AutomaticKeepAliveClientMixin {
  late final ServicesOverviewBloc _servicesOverviewBloc;

  @override
  void initState() {
    super.initState();

    _servicesOverviewBloc = sl<ServicesOverviewBloc>();
    _servicesOverviewBloc.add(GetServicesEvent(calcCount: true, currentPage: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _servicesOverviewBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<ServicesOverviewBloc, ServicesOverviewState>(
            listenWhen: (p, c) => p.fosServicesOnObserveOption != c.fosServicesOnObserveOption,
            listener: (context, state) {
              state.fosServicesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<ServicesOverviewBloc, ServicesOverviewState>(
            listenWhen: (p, c) => p.fosServicesOnDeleteOption != c.fosServicesOnDeleteOption,
            listener: (context, state) {
              state.fosServicesOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: context.l10n.services_overview_delete_services_success),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ServicesOverviewBloc, ServicesOverviewState>(
          builder: (context, state) {
            return Scaffold(
              drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
              appBar: AppBar(
                title: MyAppBarTitle(title: context.l10n.services_overview_title),
                actions: [
                  if (!context.breakpoint.isMobile)
                    _ServiceSearchField(
                      servicesOverviewBloc: _servicesOverviewBloc,
                      searchController: state.searchController,
                      currentPage: state.currentPage,
                    ),
                  IconButton(
                    onPressed: () => _servicesOverviewBloc.add(GetServicesEvent(calcCount: true, currentPage: state.currentPage)),
                    icon: const Icon(Icons.refresh),
                  ),
                  MyAppBarActionAddButton(onPressed: () => context.router.push(ServiceDetailRoute(serviceId: null))),
                ],
              ),
              body: SafeArea(
                  child: Column(
                children: [
                  if (context.breakpoint.isMobile)
                    _ServiceSearchField(
                      servicesOverviewBloc: _servicesOverviewBloc,
                      searchController: state.searchController,
                      currentPage: state.currentPage,
                    ),
                  ServicesOverviewPage(servicesOverviewBloc: _servicesOverviewBloc),
                  const Divider(height: 0),
                  PagesPaginationBar(
                    currentPage: state.currentPage,
                    totalPages: (state.totalQuantity / state.itemsPerPage).ceil(),
                    itemsPerPage: state.itemsPerPage,
                    totalItems: state.totalQuantity,
                    onPageChanged: (newPage) => _servicesOverviewBloc.add(GetServicesEvent(calcCount: false, currentPage: newPage)),
                    onItemsPerPageChanged: (newValue) => _servicesOverviewBloc.add(ItemsPerPageChangedEvent(value: newValue)),
                  ),
                ],
              )),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ServiceSearchField extends StatelessWidget {
  final ServicesOverviewBloc servicesOverviewBloc;
  final TextEditingController searchController;
  final int currentPage;

  const _ServiceSearchField({required this.servicesOverviewBloc, required this.searchController, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.breakpoint.isMobile ? const EdgeInsets.only(left: 12, right: 12, bottom: 8) : EdgeInsets.zero,
      child: SizedBox(
        width: context.breakpoint.isMobile ? null : 300,
        child: CupertinoSearchTextField(
          controller: searchController,
          onChanged: (_) => servicesOverviewBloc.add(GetServicesEvent(calcCount: false, currentPage: currentPage)),
          onSuffixTap: () => servicesOverviewBloc.add(OnSearchFieldClearedEvent()),
          style: TextStyle(color: context.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
