part of 'template_services_bloc.dart';

@immutable
sealed class TemplateServicesEvent {}

class SetTemplateServicesStateToInitialEvent extends TemplateServicesEvent {}

class SetTemplateServiceTypeEvent extends TemplateServicesEvent {
  final TemplateServiceType templateServiceType;

  SetTemplateServiceTypeEvent({required this.templateServiceType});
}

class GetTemplateServicesEvent extends TemplateServicesEvent {
  final bool shouldRefresh;

  GetTemplateServicesEvent({this.shouldRefresh = true});
}

class CreateTemplateServiceEvent extends TemplateServicesEvent {
  final TemplateService templateService;

  CreateTemplateServiceEvent({required this.templateService});
}

class CreateTemplateServiceItemEvent extends TemplateServicesEvent {
  final TemplateService templateService;
  final TemplateServiceItem templateServiceItem;

  CreateTemplateServiceItemEvent({required this.templateService, required this.templateServiceItem});
}

class UpdateTemplateServiceEvent extends TemplateServicesEvent {
  final TemplateService templateService;

  UpdateTemplateServiceEvent({required this.templateService});
}

class UpdateTemplateServiceItemEvent extends TemplateServicesEvent {
  final TemplateService templateService;
  final TemplateServiceItem templateServiceItem;

  UpdateTemplateServiceItemEvent({required this.templateService, required this.templateServiceItem});
}

class UpdateTemplateServicePositionsEvent extends TemplateServicesEvent {
  final int newIndex;
  final int oldIndex;

  UpdateTemplateServicePositionsEvent({required this.newIndex, required this.oldIndex});
}

class UpdateTemplateServiceItemPositionsEvent extends TemplateServicesEvent {
  final TemplateService templateService;
  final int newIndex;
  final int oldIndex;

  UpdateTemplateServiceItemPositionsEvent({required this.templateService, required this.newIndex, required this.oldIndex});
}

class DeleteTemplateServiceEvent extends TemplateServicesEvent {
  final String templateServiceId;

  DeleteTemplateServiceEvent({required this.templateServiceId});
}

class DeleteTemplateServiceItemEvent extends TemplateServicesEvent {
  final String templateServiceItemId;

  DeleteTemplateServiceItemEvent({required this.templateServiceItemId});
}
