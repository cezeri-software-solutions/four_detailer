import 'dart:ui' as ui;

import 'package:croppy/croppy.dart';
import 'package:dartz/dartz.dart';
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

part 'conditioner_event.dart';
part 'conditioner_state.dart';

class ConditionerBloc extends Bloc<ConditionerEvent, ConditionerState> {
  final ConditionerRepository _conditionerRepository;

  ConditionerBloc({required ConditionerRepository conditionerRepository})
      : _conditionerRepository = conditionerRepository,
        super(ConditionerState.initial()) {
    on<SetConditionerStateToInitialEvnet>(_onSetConditionerStateToInitial);
    on<GetCurrentConditionerEvent>(_onGetCurrentConditioner);
    on<UpdatetConditionerEvent>(_onUpdatetConditioner);
    on<ShowImageEditingChangedEvent>(_onShowImageEditingChanged);
    on<IsEditModeChangedEvent>(_onisInEditModeChanged);
    on<IsPaymentEditModeChangedEvent>(_onisPaymentInEditModeChanged);
    on<AddEditImageEvent>(_onAddEditImage);
    on<RemoveImageEvent>(_onRemoveImage);
  }

  void _onSetConditionerStateToInitial(SetConditionerStateToInitialEvnet event, Emitter<ConditionerState> emit) {
    emit(ConditionerState.initial());
  }

  void _onGetCurrentConditioner(GetCurrentConditionerEvent event, Emitter<ConditionerState> emit) async {
    emit(state.copyWith(isLoadingConditionerOnObserve: true));

    final fos = await _conditionerRepository.getCurConditioner();
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (conditioner) => emit(state.copyWith(conditioner: conditioner, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingConditionerOnObserve: false, fosConditionerOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosConditionerOnObserveOption: none()));
  }

  void _onUpdatetConditioner(UpdatetConditionerEvent event, Emitter<ConditionerState> emit) async {
    emit(state.copyWith(isLoadingConditionerOnUpdate: true));

    final fos = await _conditionerRepository.updateConditioner(event.conditioner);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (conditioner) => emit(state.copyWith(conditioner: conditioner, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingConditionerOnUpdate: false, fosConditionerOnUpdateOption: optionOf(fos), isInEditMode: false));
    emit(state.copyWith(fosConditionerOnUpdateOption: none()));
  }

  void _onShowImageEditingChanged(ShowImageEditingChangedEvent event, Emitter<ConditionerState> emit) {
    emit(state.copyWith(showImageEditing: !state.showImageEditing));
  }

  void _onisInEditModeChanged(IsEditModeChangedEvent event, Emitter<ConditionerState> emit) {
    emit(state.copyWith(isInEditMode: !state.isInEditMode));
  }

  void _onisPaymentInEditModeChanged(IsPaymentEditModeChangedEvent event, Emitter<ConditionerState> emit) {
    emit(state.copyWith(isInPaymentEditMode: !state.isInPaymentEditMode));
  }

  void _onAddEditImage(AddEditImageEvent event, Emitter<ConditionerState> emit) async {
    MyFile? myFile;

    try {
      final pickedImage = await ImagePicker().pickImage(source: event.source);
      if (pickedImage == null) return;

      if (!event.context.mounted) return;

      final myFileFromXFile = await convertXFileToMyFile(pickedImage);

      if (!event.context.mounted) return;

      final result = await showMaterialImageCropper(
        event.context,
        imageProvider: MemoryImage(myFileFromXFile.fileBytes),
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

      myFile = myFileFromXFile.copyWith(fileBytes: bytes, mimeType: lookupMimeType('', headerBytes: bytes));
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

  void _onRemoveImage(RemoveImageEvent event, Emitter<ConditionerState> emit) async {
    final fos = await _conditionerRepository.deleteConditionerImage(state.conditioner!.id, state.conditioner!.imageUrl);

    emit(state.copyWith(
      fosConditionerOnUpdateOption: optionOf(fos),
      showImageEditing: false,
      conditioner: fos.isRight() ? fos.getRight() : state.conditioner,
    ));
    emit(state.copyWith(fosConditionerOnUpdateOption: none()));
  }
}
