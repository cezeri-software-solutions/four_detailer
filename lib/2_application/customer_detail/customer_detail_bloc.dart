import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/3_domain/repositories/customer_repository.dart';
import '/core/core.dart';
import '../../3_domain/models/models.dart';
import '../../3_domain/repositories/database_repository.dart';
import '../../failures/failures.dart';

part 'customer_detail_event.dart';
part 'customer_detail_state.dart';

class CustomerDetailBloc extends Bloc<CustomerDetailEvent, CustomerDetailState> {
  final CustomerRepository _customerRepository;

  CustomerDetailBloc({required CustomerRepository customerRepository})
      : _customerRepository = customerRepository,
        super(CustomerDetailState.initial()) {
    on<SetCustomerDetailStateToInitialEvnet>(_onSetCustomerDetailStateToInitial);
    on<SetEmptyCustomerOnCreateEvent>(_onSetEmptyCustomerOnCreate);
    on<GetCurrentCustomerEvent>(_onGetCurrentCustomer);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
    on<CreateCustomerEvent>(_onCreateCustomer);
    on<SaveCustomerEvent>(_onSaveCustomer);
    on<ShowAddEditVehicleContainerEvent>(_onShowAddEditVehicleContainer);
    on<AddNewVehicleEvent>(_onAddNewVehicle);
    on<EditVehicleEvent>(_onEditVehicle);
    on<RemoveVehicleEvent>(_onRemoveVehicle);
    // on<ShowImageEditingChangedEvent>(_onShowImageEditingChanged);
    // on<IsEditModeChangedEvent>(_onisInEditModeChanged);
    // on<IsPaymentEditModeChangedEvent>(_onisPaymentInEditModeChanged);
    // on<CustomerAddEditImageEvent>(_onCustomerAddEditImage);
    // on<CustomerRemoveImageEvent>(_onCustomerRemoveImage);
  }

  void _onSetCustomerDetailStateToInitial(SetCustomerDetailStateToInitialEvnet event, Emitter<CustomerDetailState> emit) {
    emit(CustomerDetailState.initial());
  }

  void _onSetEmptyCustomerOnCreate(SetEmptyCustomerOnCreateEvent event, Emitter<CustomerDetailState> emit) async {
    Customer emptyCustomer = Customer.empty();

    final countryCode = Localizations.localeOf(event.context).countryCode;
    if (countryCode == null) {
      emit(state.copyWith(customer: Customer.empty()));
      return;
    }

    final repo = GetIt.I<DatabaseRepository>();

    final fos = await repo.getCountyByIsoCode(countryCode);
    if (fos.isLeft() && event.context.mounted) return;
    final loadedCountry = fos.getRight();

    emit(state.copyWith(customer: emptyCustomer.copyWith(address: Address.empty().copyWith(country: loadedCountry))));
  }

  void _onGetCurrentCustomer(GetCurrentCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnObserve: true));

    final fos = await _customerRepository.getCustomerById(event.customerId);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (customer) => emit(state.copyWith(customer: customer, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingCustomerOnObserve: false, fosCustomerOnObserveOption: optionOf(fos)));
    emit(state.copyWith(fosCustomerOnObserveOption: none()));
  }

  void _onUpdateCustomer(UpdateCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(customer: event.customer));
  }

  void _onCreateCustomer(CreateCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnCreate: true));

    final fos = await _customerRepository.createCustomer(state.customer!);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (customer) => emit(state.copyWith(customer: customer, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingCustomerOnCreate: false, fosCustomerOnCreateOption: optionOf(fos)));
    emit(state.copyWith(fosCustomerOnCreateOption: none()));
  }

  void _onSaveCustomer(SaveCustomerEvent event, Emitter<CustomerDetailState> emit) async {
    emit(state.copyWith(isLoadingCustomerOnUpdate: true));

    final fos = await _customerRepository.updateCustomer(state.customer!);
    fos.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (customer) => emit(state.copyWith(customer: customer, resetFailure: true)),
    );

    emit(state.copyWith(isLoadingCustomerOnUpdate: false, fosCustomerOnUpdateOption: optionOf(fos), isInEditMode: false));
    emit(state.copyWith(fosCustomerOnUpdateOption: none()));
  }

  void _onShowAddEditVehicleContainer(ShowAddEditVehicleContainerEvent event, Emitter<CustomerDetailState> emit) {
    emit(state.copyWith(showAddEditVehicleContainer: event.value));
  }

  void _onAddNewVehicle(AddNewVehicleEvent event, Emitter<CustomerDetailState> emit) {
    final currentVehicles = state.customer!.vehicles ?? [];
    final newVehicle = event.vehicle.copyWith(customerId: state.customer!.id, entityState: EntityState.created);

    currentVehicles.add(newVehicle);

    emit(state.copyWith(
      customer: state.customer!.copyWith(vehicles: currentVehicles),
      resetEditVehicle: true,
      showAddEditVehicleContainer: false,
    ));
  }

  void _onEditVehicle(EditVehicleEvent event, Emitter<CustomerDetailState> emit) {
    final listOfVehicles = state.customer!.vehicles ?? [];

    if (listOfVehicles[event.index].id.isEmpty) {
      listOfVehicles[event.index] = event.vehicle;
    } else {
      listOfVehicles[event.index] = event.vehicle.copyWith(entityState: EntityState.edited);
    }

    emit(state.copyWith(
      customer: state.customer!.copyWith(vehicles: listOfVehicles),
      resetEditVehicle: true,
      showAddEditVehicleContainer: false,
    ));
  }

  void _onRemoveVehicle(RemoveVehicleEvent event, Emitter<CustomerDetailState> emit) {
    final listOfVehicles = state.customer!.vehicles ?? [];

    if (listOfVehicles[event.index].id.isEmpty) {
      listOfVehicles.removeAt(event.index);
    } else {
      listOfVehicles[event.index] = listOfVehicles[event.index].copyWith(
        isDeleted: true,
        entityState: EntityState.deleted,
      );
    }

    print(listOfVehicles.length);

    emit(state.copyWith(
      customer: state.customer!.copyWith(vehicles: listOfVehicles),
      resetEditVehicle: true,
      showAddEditVehicleContainer: false,
    ));
  }

  // void _onShowImageEditingChanged(ShowImageEditingChangedEvent event, Emitter<CustomerDetailState> emit) {
  //   emit(state.copyWith(showImageEditing: !state.showImageEditing));
  // }

  // void _onisInEditModeChanged(IsEditModeChangedEvent event, Emitter<CustomerDetailState> emit) {
  //   emit(state.copyWith(isInEditMode: !state.isInEditMode));
  // }

  // void _onisPaymentInEditModeChanged(IsPaymentEditModeChangedEvent event, Emitter<CustomerDetailState> emit) {
  //   emit(state.copyWith(isInPaymentEditMode: !state.isInPaymentEditMode));
  // }

  // void _onCustomerAddEditImage(CustomerAddEditImageEvent event, Emitter<CustomerDetailState> emit) async {
  //   //   MyFile? phMyFile;
  //   //   MyFile? myFile;

  //   //   try {
  //   //     if (event.source == MyImageSource.file) {
  //   //       final pickedFile = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);
  //   //       if (pickedFile == null) return;

  //   //       phMyFile = MyFile(
  //   //         fileName: pickedFile.files.first.name,
  //   //         fileBytes: pickedFile.files.first.bytes!,
  //   //         mimeType: lookupMimeType(pickedFile.files.first.name, headerBytes: pickedFile.files.first.bytes),
  //   //       );
  //   //     } else {
  //   //       final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  //   //       if (pickedFile == null) return;

  //   //       final bytes = await pickedFile.readAsBytes();

  //   //       phMyFile = MyFile(
  //   //         fileName: pickedFile.name,
  //   //         fileBytes: bytes,
  //   //         mimeType: lookupMimeType(pickedFile.name, headerBytes: bytes),
  //   //       );
  //   //     }

  //   //     final croppedImage = await Croppy.crop(
  //   //       image: phMyFile.fileBytes,
  //   //       aspectRatio: const CroppyAspectRatio(ratioX: 1, ratioY: 1),
  //   //       loadingWidget: const Center(child: CircularProgressIndicator.adaptive()),
  //   //     );
  //   //     if (croppedImage == null) return;

  //   //     final bytes = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
  //   //     if (bytes == null) return;

  //   //     final image = img.decodeImage(bytes.buffer.asUint8List());
  //   //     if (image == null) return;

  //   //     final resizedImage = img.copyResize(image, width: 512, height: 512);
  //   //     final resizedBytes = img.encodePng(resizedImage);

  //   //     myFile = phMyFile.copyWith(fileBytes: resizedBytes, mimeType: lookupMimeType('', headerBytes: resizedBytes));
  //   //   } on PlatformException catch (e) {
  //   //     logger.e(e);
  //   //   }

  //   //   if (myFile == null) return;

  //   //   final fos = await _customerRepository.uploadCustomerImage(
  //   //     customerId: state.customer!.id,
  //   //     myFile: myFile,
  //   //     imageUrl: state.customer!.imageUrl.isNotEmpty ? state.customer!.imageUrl : null,
  //   //   );

  //   //   emit(state.copyWith(
  //   //     fosCustomerOnUpdateOption: optionOf(fos),
  //   //     showImageEditing: false,
  //   //     customer: fos.isRight() ? fos.getRight() : state.customer,
  //   //   ));
  //   //   emit(state.copyWith(fosCustomerOnUpdateOption: none()));
  // }

  // void _onCustomerRemoveImage(CustomerRemoveImageEvent event, Emitter<CustomerDetailState> emit) async {
  //   // final fos = await _customerRepository.deleteCustomerImage(state.customer!.id, state.customer!.imageUrl);

  //   // emit(state.copyWith(
  //   //   fosCustomerOnUpdateOption: optionOf(fos),
  //   //   showImageEditing: false,
  //   //   customer: fos.isRight() ? fos.getRight() : state.customer,
  //   // ));
  //   // emit(state.copyWith(fosCustomerOnUpdateOption: none()));
  // }
}
