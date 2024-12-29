part of 'categories_overview_bloc.dart';

@immutable
class CategoriesOverviewState {
  final List<Category>? listOfCategories;
  final AbstractFailure? failure;
  final bool isLoadingCategoriesOnObserve;
  final bool isLoadingCategoriesOnCreate;
  final bool isLoadingCategoriesOnUpdate;
  final bool isLoadingCategoiesOnDelete;
  final Option<Either<AbstractFailure, List<Category>>> fosCategoriesOnObserveOption;
  final Option<Either<AbstractFailure, Category>> fosCategoriesOnCreateOption;
  final Option<Either<AbstractFailure, Category>> fosCategoriesOnUpdateOption;
  final Option<Either<AbstractFailure, Unit>> fosCategoriesOnDeleteOption;

  //* Helper Pagination *//
  final int itemsPerPage;
  final int totalQuantity;
  final int currentPage;

  const CategoriesOverviewState({
    required this.listOfCategories,
    required this.failure,
    required this.isLoadingCategoriesOnObserve,
    required this.isLoadingCategoriesOnCreate,
    required this.isLoadingCategoriesOnUpdate,
    required this.isLoadingCategoiesOnDelete,
    required this.fosCategoriesOnObserveOption,
    required this.fosCategoriesOnCreateOption,
    required this.fosCategoriesOnUpdateOption,
    required this.fosCategoriesOnDeleteOption,
    required this.itemsPerPage,
    required this.totalQuantity,
    required this.currentPage,
  });

  factory CategoriesOverviewState.initial() => CategoriesOverviewState(
        listOfCategories: null,
        failure: null,
        isLoadingCategoriesOnObserve: true,
        isLoadingCategoriesOnCreate: false,
        isLoadingCategoriesOnUpdate: false,
        isLoadingCategoiesOnDelete: false,
        fosCategoriesOnObserveOption: none(),
        fosCategoriesOnCreateOption: none(),
        fosCategoriesOnUpdateOption: none(),
        fosCategoriesOnDeleteOption: none(),
        itemsPerPage: 25,
        totalQuantity: 1,
        currentPage: 1,
      );

  CategoriesOverviewState copyWith({
    List<Category>? listOfCategories,
    bool? resetFailure,
    AbstractFailure? failure,
    bool? isLoadingCategoriesOnObserve,
    bool? isLoadingCategoriesOnCreate,
    bool? isLoadingCategoriesOnUpdate,
    bool? isLoadingCategoiesOnDelete,
    Option<Either<AbstractFailure, List<Category>>>? fosCategoriesOnObserveOption,
    Option<Either<AbstractFailure, Category>>? fosCategoriesOnCreateOption,
    Option<Either<AbstractFailure, Category>>? fosCategoriesOnUpdateOption,
    Option<Either<AbstractFailure, Unit>>? fosCategoriesOnDeleteOption,
    int? itemsPerPage,
    int? totalQuantity,
    int? currentPage,
  }) {
    return CategoriesOverviewState(
      listOfCategories: listOfCategories ?? this.listOfCategories,
      failure: resetFailure == true ? null : failure ?? this.failure,
      isLoadingCategoriesOnObserve: isLoadingCategoriesOnObserve ?? this.isLoadingCategoriesOnObserve,
      isLoadingCategoriesOnCreate: isLoadingCategoriesOnCreate ?? this.isLoadingCategoriesOnCreate,
      isLoadingCategoriesOnUpdate: isLoadingCategoriesOnUpdate ?? this.isLoadingCategoriesOnUpdate,
      isLoadingCategoiesOnDelete: isLoadingCategoiesOnDelete ?? this.isLoadingCategoiesOnDelete,
      fosCategoriesOnObserveOption: fosCategoriesOnObserveOption ?? this.fosCategoriesOnObserveOption,
      fosCategoriesOnCreateOption: fosCategoriesOnCreateOption ?? this.fosCategoriesOnCreateOption,
      fosCategoriesOnUpdateOption: fosCategoriesOnUpdateOption ?? this.fosCategoriesOnUpdateOption,
      fosCategoriesOnDeleteOption: fosCategoriesOnDeleteOption ?? this.fosCategoriesOnDeleteOption,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
