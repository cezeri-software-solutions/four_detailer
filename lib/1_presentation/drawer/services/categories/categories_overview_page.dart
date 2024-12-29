import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_detailer/2_application/categories_overview/categories_overview_bloc.dart';
import 'package:four_detailer/core/core.dart';

import '../../../../constants.dart';
import '../widgets/widgets.dart';
import 'widgets/add_edit_category.dart';

class CategoriesOverviewPage extends StatelessWidget {
  final CategoriesOverviewBloc categoriesOverviewBloc;

  const CategoriesOverviewPage({super.key, required this.categoriesOverviewBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesOverviewBloc, CategoriesOverviewState>(
      builder: (context, state) {
        const loadingWidget = Expanded(child: Center(child: MyLoadingIndicator()));

        if (state.isLoadingCategoriesOnObserve) return loadingWidget;
        if (state.failure != null) return Expanded(child: Center(child: Text(state.failure!.message ?? state.failure!.toString())));
        if (state.listOfCategories == null) return loadingWidget;
        if (state.listOfCategories!.isEmpty) return Expanded(child: Center(child: MyEmptyList(title: context.l10n.categories_overview_emptyList)));

        return _CategoriesOverviewContent(categoriesOverviewBloc: categoriesOverviewBloc, state: state);
      },
    );
  }
}

class _CategoriesOverviewContent extends StatelessWidget {
  final CategoriesOverviewBloc categoriesOverviewBloc;
  final CategoriesOverviewState state;

  const _CategoriesOverviewContent({required this.categoriesOverviewBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator.adaptive(
        onRefresh: () async => categoriesOverviewBloc.add(GetCategoriesEvent(calcCount: true, currentPage: state.currentPage)),
        child: ListView(
          children: [
            ReorderableListView.builder(
              itemCount: state.listOfCategories!.length,
              padding: EdgeInsets.all(context.breakpoint.isMobile ? 12 : 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              proxyDecorator: (child, index, animation) => Material(
                elevation: 8,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
              onReorder: (oldIndex, newIndex) => categoriesOverviewBloc.add(UpdateCategoryPositionsEvent(newIndex: newIndex, oldIndex: oldIndex)),
              itemBuilder: (context, index) {
                final category = state.listOfCategories![index];

                return Column(
                  key: ValueKey(category.id),
                  children: [
                    Padding(
                      padding: index != state.listOfCategories!.length - 1 ? const EdgeInsets.only(bottom: 12) : EdgeInsets.zero,
                      child: PressableCard(
                        title: category.title,
                        description: category.description,
                        onTap: () => showAddEditCategorySheet(context: context, categoriesOverviewBloc: categoriesOverviewBloc, category: category),
                      ),
                    ),
                    if (state.isLoadingCategoriesOnCreate && index == state.listOfCategories!.length - 1) ...[
                      Gaps.h12,
                      const LinearProgressIndicator()
                    ]
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
