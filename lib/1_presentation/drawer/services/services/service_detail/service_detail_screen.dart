import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/auth/auth_bloc.dart';
import '/2_application/service_detail/service_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/core/core.dart';
import '/injection.dart';
import '/routes/router.gr.dart';
import 'service_detail_page.dart';
import 'sheets/service_validation_dialog.dart';

@RoutePage()
class ServiceDetailScreen extends StatefulWidget {
  final String? serviceId;

  const ServiceDetailScreen({super.key, @PathParam('serviceId') required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> with AutomaticKeepAliveClientMixin {
  late final ServiceDetailBloc _serviceDetailBloc;

  @override
  void initState() {
    super.initState();

    _serviceDetailBloc = sl<ServiceDetailBloc>();
    widget.serviceId == null
        ? _serviceDetailBloc.add(SetEmptyServiceOnCreateEvent(context: context))
        : _serviceDetailBloc.add(GetCurrentServiceEvent(serviceId: widget.serviceId!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _serviceDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<ServiceDetailBloc, ServiceDetailState>(
            listenWhen: (p, c) => p.fosServiceOnCreateOption != c.fosServiceOnCreateOption,
            listener: (context, state) {
              state.fosServiceOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (createdService) {
                    showSuccessSnackBar(context: context, text: 'Service erfolgreich erstellt');
                    context.router.popUntilRouteWithName(ServicesOverviewRoute.name);
                    context.router.push(ServiceDetailRoute(serviceId: createdService.id));
                  },
                ),
              );
            },
          ),
          BlocListener<ServiceDetailBloc, ServiceDetailState>(
            listenWhen: (p, c) => p.fosServiceOnObserveOption != c.fosServiceOnObserveOption,
            listener: (context, state) {
              state.fosServiceOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<ServiceDetailBloc, ServiceDetailState>(
            listenWhen: (p, c) => p.fosServiceOnUpdateOption != c.fosServiceOnUpdateOption,
            listener: (context, state) {
              state.fosServiceOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) {
                    showSuccessSnackBar(context: context, text: 'Service erfolgreich aktualisiert');
                    context.router.popUntilRouteWithName(ServiceDetailRoute.name);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(_getTitle(state.service)),
                actions: [
                  if (widget.serviceId != null)
                    IconButton(
                      onPressed: () => _serviceDetailBloc.add(GetCurrentServiceEvent(serviceId: widget.serviceId!)),
                      icon: const Icon(Icons.refresh),
                    ),
                  widget.serviceId != null && state.service != null
                      ? MyAppBarActionSaveButton(
                          isLoading: _serviceDetailBloc.state.isLoadingServiceOnUpdate,
                          onPressed: () => _onSavePressed(state, () => _serviceDetailBloc.add(SaveServiceEvent())),
                        )
                      : MyAppBarActionSaveButton(
                          isLoading: _serviceDetailBloc.state.isLoadingServiceOnCreate,
                          onPressed: () => _onSavePressed(state, () => _serviceDetailBloc.add(CreateServiceEvent())),
                        ),
                ],
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    ServiceDetailPage(serviceDetailBloc: _serviceDetailBloc),
                    if (state.isLoadingServiceOnUpdate) const Center(child: MyLoadingDialog()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getTitle(Service? service) {
    if (widget.serviceId == null) return context.l10n.service_detail_title;
    if (service == null) return '';
    if (service.name.isNotEmpty) return service.name;

    return service.name;
  }

  void _onSavePressed(ServiceDetailState state, VoidCallback onSuccess) {
    if (state.service!.number.isEmpty || state.service!.name.isEmpty) {
      showServiceValidationDialog(context: context, articleNumber: state.service!.number, articleName: state.service!.name);
    } else {
      onSuccess();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
