import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/2_application/service_detail/service_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';
import '../../../../../../3_domain/repositories/category_repository.dart';

void showSelectServiceCategorySheet({
  required BuildContext context,
  required ServiceDetailBloc serviceDetailBloc,
  required Category? selectedCategory,
}) {
  WoltModalSheet.show<void>(
    context: context,
    barrierDismissible: true,
    useSafeArea: true,
    showDragHandle: false,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text(context.l10n.service_detail_selectCategory, style: context.textTheme.titleLarge),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: context.breakpoint.isMobile ? 106 : 94),
            child: _SelectServiceCategorySheet(selectedCategory: selectedCategory, onCategorySelected: (category) => selectedCategory = category),
          ),
          stickyActionBar: Padding(
            padding: EdgeInsets.only(right: 12, left: 12, top: 12, bottom: context.breakpoint.isMobile ? 12 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: context.pop,
                  child: Text(context.l10n.cancel),
                ),
                Gaps.w12,
                FilledButton(
                  onPressed: () {
                    serviceDetailBloc.add(OnServiceCategorySelectedEvent(category: selectedCategory));
                    context.pop();
                  },
                  style: FilledButton.styleFrom(backgroundColor: context.customColors.success),
                  child: Text(context.l10n.save),
                ),
              ],
            ),
          ),
        ),
      ];
    },
  );
}

class _SelectServiceCategorySheet extends StatefulWidget {
  final Category? selectedCategory;
  final void Function(Category? category) onCategorySelected;

  const _SelectServiceCategorySheet({required this.selectedCategory, required this.onCategorySelected});

  @override
  State<_SelectServiceCategorySheet> createState() => _SelectServiceCategorySheetState();
}

class _SelectServiceCategorySheetState extends State<_SelectServiceCategorySheet> {
  List<Category>? _categories;
  late Category? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _loadCategories();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    if (_categories == null) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const MyLoadingIndicator(), Gaps.h12, Text(context.l10n.service_detail_selectCategoryLoading)],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories!.length,
      separatorBuilder: (context, index) => Gaps.h12,
      itemBuilder: (context, index) {
        final category = _categories![index];
        final isSelected = _selectedCategory != null && _selectedCategory!.id == category.id;

        return Card(
          color: isSelected ? context.customColors.success.withValues(alpha: 0.2) : null,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (isSelected) {
                widget.onCategorySelected(null);
                setState(() => _selectedCategory = null);
                return;
              }

              widget.onCategorySelected(category);
              setState(() => _selectedCategory = category);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category.title),
                  if (isSelected) Icon(Icons.check_circle, color: context.customColors.success),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _loadCategories() async {
    final categoryRepo = GetIt.I<CategoryRepository>();

    final fosCategories = await categoryRepo.getCategories();
    if (fosCategories.isLeft()) return;

    setState(() => _categories = fosCategories.getRight());
  }
}
