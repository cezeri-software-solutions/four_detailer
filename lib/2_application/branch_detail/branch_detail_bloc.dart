import 'dart:ui' as ui;

import 'package:croppy/croppy.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/branch_repository.dart';
import '../../constants.dart';
import '../../core/core.dart';
import '../../failures/failures.dart';

part 'branch_detail_event.dart';
part 'branch_detail_state.dart';

class BranchDetailBloc extends Bloc<BranchDetailEvent, BranchDetailState> {
  final BranchRepository _branchRepository;

  BranchDetailBloc({required BranchRepository branchRepository})
      : _branchRepository = branchRepository,
        super(BranchDetailState.initial()) {
    on<SetBranchDetailStateToInitialEvent>(_onSetBranchDetailStateToInitial);
    on<GetBranchEvent>(_onGetBranch);
    on<UpdateBranchEvent>(_onUpdateBranch);
    on<ShowBranchImageEditingChangedEvent>(_onShowBranchImageEditingChanged);
    on<IsEditModeChangedEvent>(_onIsEditModeChanged);
    on<BranchAddEditImageEvent>(_onBranchAddEditImage);
    on<BranchRemoveImageEvent>(_onBranchRemoveImage);
  }

  void _onSetBranchDetailStateToInitial(SetBranchDetailStateToInitialEvent event, Emitter<BranchDetailState> emit) {
    emit(BranchDetailState.initial());
  }

  void _onGetBranch(GetBranchEvent event, Emitter<BranchDetailState> emit) async {
    emit(state.copyWith(isLoadingBranchOnObserve: true));

    final fos = await _branchRepository.getBranchById(event.branchId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (branch) => emit(state.copyWith(branch: branch, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingBranchOnObserve: false, fosBranchOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosBranchOnObserveOption: none()));
  }

  void _onUpdateBranch(UpdateBranchEvent event, Emitter<BranchDetailState> emit) async {
    emit(state.copyWith(isLoadingBranchOnUpdate: true));

    final fos = await _branchRepository.updateBranch(event.branch);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (branch) => emit(state.copyWith(branch: branch, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingBranchOnUpdate: false, fosBranchOnUpdateOption: optionOf(fos), isInEditMode: false));
    emit(state.copyWith(fosBranchOnUpdateOption: none()));
  }

  void _onShowBranchImageEditingChanged(ShowBranchImageEditingChangedEvent event, Emitter<BranchDetailState> emit) {
    emit(state.copyWith(showImageEditing: !state.showImageEditing));
  }

  void _onIsEditModeChanged(IsEditModeChangedEvent event, Emitter<BranchDetailState> emit) {
    emit(state.copyWith(isInEditMode: !state.isInEditMode));
  }

  void _onBranchAddEditImage(BranchAddEditImageEvent event, Emitter<BranchDetailState> emit) async {
    MyFile? phMyFile;
    MyFile? myFile;

    try {
      if (event.source == MyImageSource.file) {
        final pickedFile = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);
        if (pickedFile == null) return;

        phMyFile = await convertPlatfomFileToMyFile(pickedFile.files.first);
      } else {
        final pickedImage = await ImagePicker().pickImage(source: event.source == MyImageSource.camera ? ImageSource.camera : ImageSource.gallery);
        if (pickedImage == null) return;

        if (!event.context.mounted) return;

        phMyFile = await convertXFileToMyFile(pickedImage);
      }

      if (!event.context.mounted) return;

      final result = await showMaterialImageCropper(
        event.context,
        imageProvider: MemoryImage(phMyFile.fileBytes),
        allowedAspectRatios: [const CropAspectRatio(width: 1, height: 1)],
        cropPathFn: ellipseCropShapeFn,
      );
      if (result == null) return;

      if (event.context.mounted) showMyDialogLoading(context: event.context);

      final uiImage = result.uiImage;
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final baseSizeImage = img.decodeImage(byteData.buffer.asUint8List())!;
      const size = 1024;
      final resizedImage = img.copyResize(baseSizeImage, height: size, width: size);
      final bytes = img.encodePng(resizedImage);

      myFile = phMyFile.copyWith(fileBytes: bytes, mimeType: lookupMimeType('', headerBytes: bytes));
    } on PlatformException catch (e) {
      logger.e(e);
    }

    if (myFile == null) return;

    final fos = await _branchRepository.uploadBranchLogo(
      branchId: state.branch!.id,
      myFile: myFile,
      imageUrl: state.branch!.branchLogo != null && state.branch!.branchLogo!.isNotEmpty ? state.branch!.branchLogo : null,
    );

    emit(state.copyWith(
      fosBranchOnUpdateOption: optionOf(fos),
      showImageEditing: false,
      branch: fos.isRight() ? fos.getRight() : state.branch,
    ));
    emit(state.copyWith(fosBranchOnUpdateOption: none()));
  }

  void _onBranchRemoveImage(BranchRemoveImageEvent event, Emitter<BranchDetailState> emit) async {
    final fos = await _branchRepository.deleteBranchLogo(state.branch!.id, state.branch!.branchLogo!);

    emit(state.copyWith(
      fosBranchOnUpdateOption: optionOf(fos),
      showImageEditing: false,
      branch: fos.isRight() ? fos.getRight() : state.branch,
    ));
    emit(state.copyWith(fosBranchOnUpdateOption: none()));
  }
}
