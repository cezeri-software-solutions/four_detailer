import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_detailer/3_domain/models/categories/category.dart';
import 'package:four_detailer/3_domain/repositories/category_repository.dart';
import 'package:four_detailer/failures/failure.dart';

part 'categories_overview_event.dart';
part 'categories_overview_state.dart';

class CategoriesOverviewBloc extends Bloc<CategoriesOverviewEvent, CategoriesOverviewState> {
  final CategoryRepository _categoryRepository;

  CategoriesOverviewBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoriesOverviewState.initial()) {
    on<SetCategoriesStateToInitialEvent>(_onSetCategoriesStateToInitial);
    on<GetCategoriesEvent>(_onGetCategories);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<UpdateCategoryPositionsEvent>(_onUpdateCategoryPositions);
    on<ItemsPerPageChangedEvent>(_onItemsPerPageChanged);
  }

  void _onSetCategoriesStateToInitial(SetCategoriesStateToInitialEvent event, Emitter<CategoriesOverviewState> emit) {
    emit(CategoriesOverviewState.initial());
  }

  void _onGetCategories(GetCategoriesEvent event, Emitter<CategoriesOverviewState> emit) async {
    emit(state.copyWith(isLoadingCategoriesOnObserve: true));

    final fos = await _categoryRepository.getCategories();
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (categories) => emit(state.copyWith(
        listOfCategories: categories,
        totalQuantity: event.calcCount ? categories.length : state.totalQuantity,
        currentPage: event.currentPage,
        resetFailure: true,
      )),
    );

    emit(state.copyWith(isLoadingCategoriesOnObserve: false, fosCategoriesOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosCategoriesOnObserveOption: none()));
  }

  void _onCreateCategory(CreateCategoryEvent event, Emitter<CategoriesOverviewState> emit) async {
    emit(state.copyWith(isLoadingCategoriesOnCreate: true));

    final newCategory = event.category.copyWith(position: state.listOfCategories!.length + 1);

    final fos = await _categoryRepository.createCategory(newCategory);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (addedCategory) {
        emit(state.copyWith(listOfCategories: [...state.listOfCategories!, addedCategory], resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingCategoriesOnCreate: false, fosCategoriesOnCreateOption: optionOf(fos)));
    emit(state.copyWith(fosCategoriesOnCreateOption: none()));
  }

  void _onUpdateCategory(UpdateCategoryEvent event, Emitter<CategoriesOverviewState> emit) async {
    emit(state.copyWith(isLoadingCategoriesOnUpdate: true));

    final fos = await _categoryRepository.updateCategory(event.category);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (updatedCategory) {
        final List<Category> listOfCategories = List.from(state.listOfCategories!);
        final index = listOfCategories.indexWhere((category) => category.id == updatedCategory.id);
        listOfCategories[index] = updatedCategory;

        emit(state.copyWith(listOfCategories: listOfCategories, resetFailure: true));
      },
    );

    emit(state.copyWith(isLoadingCategoriesOnUpdate: false, fosCategoriesOnUpdateOption: optionOf(fos)));
    emit(state.copyWith(fosCategoriesOnUpdateOption: none()));
  }

  void _onDeleteCategory(DeleteCategoryEvent event, Emitter<CategoriesOverviewState> emit) async {
    emit(state.copyWith(isLoadingCategoiesOnDelete: true));

    final fos = await _categoryRepository.deleteCategory(event.categoryId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(resetFailure: true));
        add(GetCategoriesEvent(calcCount: true, currentPage: state.currentPage));
      },
    );

    emit(state.copyWith(isLoadingCategoiesOnDelete: false, fosCategoriesOnDeleteOption: optionOf(fos)));
    emit(state.copyWith(fosCategoriesOnDeleteOption: none()));
  }

  void _onUpdateCategoryPositions(UpdateCategoryPositionsEvent event, Emitter<CategoriesOverviewState> emit) async {
    List<Category> listOfCategories = List.from(state.listOfCategories!);

    int newIndex = event.newIndex;
    int oldIndex = event.oldIndex;

    if (newIndex > oldIndex) newIndex -= 1;

    final item = listOfCategories.removeAt(oldIndex);
    listOfCategories.insert(newIndex, item);

    for (int i = 0; i < listOfCategories.length; i++) {
      listOfCategories[i] = listOfCategories[i].copyWith(position: i + 1);
    }

    emit(state.copyWith(listOfCategories: listOfCategories, resetFailure: true));

    final fos = await _categoryRepository.updatePositionsOfCategories(listOfCategories);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) {
        emit(state.copyWith(listOfCategories: listOfCategories, resetFailure: true));
        // add(GetCategoriesEvent(calcCount: true, currentPage: state.currentPage));
      },
    );
  }

  void _onItemsPerPageChanged(ItemsPerPageChangedEvent event, Emitter<CategoriesOverviewState> emit) {
    emit(state.copyWith(itemsPerPage: event.value));
    add(GetCategoriesEvent(calcCount: false, currentPage: 1));
  }
}
