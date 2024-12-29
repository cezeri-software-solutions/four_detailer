part of 'categories_overview_bloc.dart';

@immutable
sealed class CategoriesOverviewEvent {}

class SetCategoriesStateToInitialEvent extends CategoriesOverviewEvent {}

class GetCategoriesEvent extends CategoriesOverviewEvent {
  final bool calcCount;
  final int currentPage;

  GetCategoriesEvent({
    required this.calcCount,
    required this.currentPage,
  });
}

class CreateCategoryEvent extends CategoriesOverviewEvent {
  final Category category;

  CreateCategoryEvent({required this.category});
}

class UpdateCategoryEvent extends CategoriesOverviewEvent {
  final Category category;

  UpdateCategoryEvent({required this.category});
}

class DeleteCategoryEvent extends CategoriesOverviewEvent {
  final String categoryId;

  DeleteCategoryEvent({required this.categoryId});
}

class UpdateCategoryPositionsEvent extends CategoriesOverviewEvent {
  final int newIndex;
  final int oldIndex;

  UpdateCategoryPositionsEvent({required this.newIndex, required this.oldIndex});
}

//* --- Helper Pagination --- *//

class ItemsPerPageChangedEvent extends CategoriesOverviewEvent {
  final int value;

  ItemsPerPageChangedEvent({required this.value});
}
