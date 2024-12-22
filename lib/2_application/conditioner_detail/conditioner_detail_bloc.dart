import 'dart:ui' as ui;

import 'package:croppy/croppy.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_detailer/3_domain/repositories/conditioner_repository.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../3_domain/models/models.dart';
import '../../constants.dart';
import '../../core/core.dart';
import '../../failures/failures.dart';

part 'conditioner_detail_event.dart';
part 'conditioner_detail_state.dart';

class ConditionerDetailBloc extends Bloc<ConditionerDetailEvent, ConditionerDetailState> {
  final ConditionerRepository _conditionerRepository;

  ConditionerDetailBloc({required ConditionerRepository conditionerRepository})
      : _conditionerRepository = conditionerRepository,
        super(ConditionerDetailState.initial()) {
    on<SetConditionerStateToInitialEvnet>(_onSetConditionerStateToInitial);
    on<GetCurrentConditionerEvent>(_onGetCurrentConditioner);
    on<UpdatetConditionerEvent>(_onUpdatetConditioner);
    on<ShowImageEditingChangedEvent>(_onShowImageEditingChanged);
    on<IsEditModeChangedEvent>(_onisInEditModeChanged);
    on<IsPaymentEditModeChangedEvent>(_onisPaymentInEditModeChanged);
    on<ConditionerAddEditImageEvent>(_onConditionerAddEditImage);
    on<ConditionerRemoveImageEvent>(_onConditionerRemoveImage);
  }

  void _onSetConditionerStateToInitial(SetConditionerStateToInitialEvnet event, Emitter<ConditionerDetailState> emit) {
    emit(ConditionerDetailState.initial());
  }

  void _onGetCurrentConditioner(GetCurrentConditionerEvent event, Emitter<ConditionerDetailState> emit) async {
    emit(state.copyWith(isLoadingConditionerOnObserve: true));

    final fos = await _conditionerRepository.getCurConditioner();
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (conditioner) => emit(state.copyWith(conditioner: conditioner, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingConditionerOnObserve: false, fosConditionerOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosConditionerOnObserveOption: none()));
  }

  void _onUpdatetConditioner(UpdatetConditionerEvent event, Emitter<ConditionerDetailState> emit) async {
    emit(state.copyWith(isLoadingConditionerOnUpdate: true));

    final fos = await _conditionerRepository.updateConditioner(event.conditioner);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (conditioner) => emit(state.copyWith(conditioner: conditioner, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingConditionerOnUpdate: false, fosConditionerOnUpdateOption: optionOf(fos), isInEditMode: false));
    emit(state.copyWith(fosConditionerOnUpdateOption: none()));
  }

  void _onShowImageEditingChanged(ShowImageEditingChangedEvent event, Emitter<ConditionerDetailState> emit) {
    emit(state.copyWith(showImageEditing: !state.showImageEditing));
  }

  void _onisInEditModeChanged(IsEditModeChangedEvent event, Emitter<ConditionerDetailState> emit) {
    emit(state.copyWith(isInEditMode: !state.isInEditMode));
  }

  void _onisPaymentInEditModeChanged(IsPaymentEditModeChangedEvent event, Emitter<ConditionerDetailState> emit) {
    emit(state.copyWith(isInPaymentEditMode: !state.isInPaymentEditMode));
  }

  void _onConditionerAddEditImage(ConditionerAddEditImageEvent event, Emitter<ConditionerDetailState> emit) async {
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
        cropPathFn: aabbCropShapeFn,
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

    final fos = await _conditionerRepository.uploadConditionerImage(
      conditionerId: state.conditioner!.id,
      myFile: myFile,
      imageUrl: state.conditioner!.imageUrl.isNotEmpty ? state.conditioner!.imageUrl : null,
    );

    emit(state.copyWith(
      fosConditionerOnUpdateOption: optionOf(fos),
      showImageEditing: false,
      conditioner: fos.isRight() ? fos.getRight() : state.conditioner,
    ));
    emit(state.copyWith(fosConditionerOnUpdateOption: none()));
  }

  void _onConditionerRemoveImage(ConditionerRemoveImageEvent event, Emitter<ConditionerDetailState> emit) async {
    final fos = await _conditionerRepository.deleteConditionerImage(state.conditioner!.id, state.conditioner!.imageUrl);

    emit(state.copyWith(
      fosConditionerOnUpdateOption: optionOf(fos),
      showImageEditing: false,
      conditioner: fos.isRight() ? fos.getRight() : state.conditioner,
    ));
    emit(state.copyWith(fosConditionerOnUpdateOption: none()));
  }
}
