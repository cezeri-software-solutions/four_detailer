import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/auth/auth_bloc.dart';
import '../../../../2_application/categories_overview/categories_overview_bloc.dart';
import '../../../../core/core.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import 'categories_overview_page.dart';
import 'widgets/add_edit_category.dart';

// TODO: Löschen von Kategorien
//* Soll ein Modal aufpoppen, welches den User fragt, ob die Kategorie auch von allen Dienstleistungen gelöscht werden soll?
//* Sollen auch alle Dienstleistungen gelöscht werden, die dieser Kategorie zugeordnet sind?

@RoutePage()
class CategoriesOverviewScreen extends StatefulWidget {
  const CategoriesOverviewScreen({super.key});

  @override
  State<CategoriesOverviewScreen> createState() => _CategoriesOverviewScreenState();
}

class _CategoriesOverviewScreenState extends State<CategoriesOverviewScreen> with AutomaticKeepAliveClientMixin {
  late final CategoriesOverviewBloc _categoriesOverviewBloc;

  @override
  void initState() {
    super.initState();

    _categoriesOverviewBloc = sl<CategoriesOverviewBloc>();
    _categoriesOverviewBloc.add(GetCategoriesEvent(calcCount: true, currentPage: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _categoriesOverviewBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<CategoriesOverviewBloc, CategoriesOverviewState>(
            listenWhen: (p, c) => p.fosCategoriesOnObserveOption != c.fosCategoriesOnObserveOption,
            listener: (context, state) {
              state.fosCategoriesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<CategoriesOverviewBloc, CategoriesOverviewState>(
            listenWhen: (p, c) => p.fosCategoriesOnCreateOption != c.fosCategoriesOnCreateOption,
            listener: (context, state) {
              state.fosCategoriesOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: 'Kategorie erfolgreich erstellt'),
                ),
              );
            },
          ),
          BlocListener<CategoriesOverviewBloc, CategoriesOverviewState>(
            listenWhen: (p, c) => p.fosCategoriesOnUpdateOption != c.fosCategoriesOnUpdateOption,
            listener: (context, state) {
              context.router.popUntilRouteWithName(CategoriesOverviewRoute.name);

              state.fosCategoriesOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: 'Kategorie erfolgreich aktualisiert'),
                ),
              );
            },
          ),
          BlocListener<CategoriesOverviewBloc, CategoriesOverviewState>(
            listenWhen: (p, c) => p.fosCategoriesOnDeleteOption != c.fosCategoriesOnDeleteOption,
            listener: (context, state) {
              state.fosCategoriesOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: 'Kategorie erfolgreich gelöscht'),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<CategoriesOverviewBloc, CategoriesOverviewState>(
          builder: (context, state) {
            return Scaffold(
              drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
              appBar: AppBar(
                title: MyAppBarTitle(title: context.l10n.categories_overview_title),
                actions: [
                  IconButton(
                    onPressed: () => _categoriesOverviewBloc.add(GetCategoriesEvent(calcCount: true, currentPage: state.currentPage)),
                    icon: const Icon(Icons.refresh),
                  ),
                  MyAppBarActionAddButton(
                    onPressed: () => showAddEditCategorySheet(context: context, categoriesOverviewBloc: _categoriesOverviewBloc),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    CategoriesOverviewPage(categoriesOverviewBloc: _categoriesOverviewBloc),
                    const Divider(height: 0),
                    PagesPaginationBar(
                      currentPage: state.currentPage,
                      totalPages: (state.totalQuantity / state.itemsPerPage).ceil(),
                      itemsPerPage: state.itemsPerPage,
                      totalItems: state.totalQuantity,
                      onPageChanged: (newPage) => _categoriesOverviewBloc.add(GetCategoriesEvent(calcCount: false, currentPage: newPage)),
                      onItemsPerPageChanged: (newValue) => _categoriesOverviewBloc.add(ItemsPerPageChangedEvent(value: newValue)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
