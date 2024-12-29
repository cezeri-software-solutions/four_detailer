import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/auth/auth_bloc.dart';
import '../../../../2_application/customers_overview/customers_overview_bloc.dart';
import '../../../../core/core.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import 'customers_overview_page.dart';

@RoutePage()
class CustomersOverviewScreen extends StatefulWidget {
  const CustomersOverviewScreen({super.key});

  @override
  State<CustomersOverviewScreen> createState() => _CustomersOverviewScreenState();
}

class _CustomersOverviewScreenState extends State<CustomersOverviewScreen> with AutomaticKeepAliveClientMixin {
  late final CustomersOverviewBloc _customersOverviewBloc;

  @override
  void initState() {
    super.initState();

    _customersOverviewBloc = sl<CustomersOverviewBloc>();
    _customersOverviewBloc.add(GetCustomersEvent(calcCount: true, currentPage: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _customersOverviewBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<CustomersOverviewBloc, CustomersOverviewState>(
            listenWhen: (p, c) => p.fosCustomersOption != c.fosCustomersOption,
            listener: (context, state) {
              state.fosCustomersOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<CustomersOverviewBloc, CustomersOverviewState>(
            listenWhen: (p, c) => p.fosDeleteCustomersOption != c.fosDeleteCustomersOption,
            listener: (context, state) {
              state.fosDeleteCustomersOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: context.l10n.customers_overview_delete_customers_success),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<CustomersOverviewBloc, CustomersOverviewState>(
          builder: (context, state) {
            return Scaffold(
              drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
              appBar: AppBar(
                title: MyAppBarTitle(title: context.l10n.customers_overview_title),
                actions: [
                  if (!context.breakpoint.isMobile)
                    _CustomerSearchField(
                      customersOverviewBloc: _customersOverviewBloc,
                      searchController: state.searchController,
                      currentPage: state.currentPage,
                    ),
                  IconButton(
                    onPressed: () => _customersOverviewBloc.add(GetCustomersEvent(calcCount: true, currentPage: state.currentPage)),
                    icon: const Icon(Icons.refresh),
                  ),
                  MyAppBarActionAddButton(onPressed: () => context.router.push(CustomerDetailRoute(customerId: null))),
                ],
              ),
              body: SafeArea(
                  child: Column(
                children: [
                  if (context.breakpoint.isMobile)
                    _CustomerSearchField(
                      customersOverviewBloc: _customersOverviewBloc,
                      searchController: state.searchController,
                      currentPage: state.currentPage,
                    ),
                  CustomersOverviewPage(customersOverviewBloc: _customersOverviewBloc),
                  const Divider(height: 0),
                  PagesPaginationBar(
                    currentPage: state.currentPage,
                    totalPages: (state.totalQuantity / state.itemsPerPage).ceil(),
                    itemsPerPage: state.itemsPerPage,
                    totalItems: state.totalQuantity,
                    onPageChanged: (newPage) => _customersOverviewBloc.add(GetCustomersEvent(calcCount: false, currentPage: newPage)),
                    onItemsPerPageChanged: (newValue) => _customersOverviewBloc.add(ItemsPerPageChangedEvent(value: newValue)),
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

class _CustomerSearchField extends StatelessWidget {
  final CustomersOverviewBloc customersOverviewBloc;
  final TextEditingController searchController;
  final int currentPage;

  const _CustomerSearchField({required this.customersOverviewBloc, required this.searchController, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.breakpoint.isMobile ? const EdgeInsets.only(left: 12, right: 12, bottom: 8) : EdgeInsets.zero,
      child: SizedBox(
        width: context.breakpoint.isMobile ? null : 300,
        child: CupertinoSearchTextField(
          controller: searchController,
          onChanged: (_) => customersOverviewBloc.add(GetCustomersEvent(calcCount: false, currentPage: currentPage)),
          onSuffixTap: () => customersOverviewBloc.add(OnSearchFieldClearedEvent()),
          style: TextStyle(color: context.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
