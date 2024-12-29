import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/auth/auth_bloc.dart';
import '../../../../2_application/template_services/template_services_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../core/core.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import 'template_services_overview_page.dart';
import 'widgets/add_edit_template_service.dart';

class TemplateServicesOverviewScreen extends StatefulWidget {
  final String templateServiceType;

  const TemplateServicesOverviewScreen({super.key, @PathParam('templateServiceType') required this.templateServiceType});

  @override
  State<TemplateServicesOverviewScreen> createState() => _TemplateServicesOverviewScreenState();
}

class _TemplateServicesOverviewScreenState extends State<TemplateServicesOverviewScreen> with AutomaticKeepAliveClientMixin {
  late final TemplateServicesBloc _templateServicesBloc;

  @override
  void initState() {
    super.initState();

    _templateServicesBloc = sl<TemplateServicesBloc>();
    _templateServicesBloc.add(SetTemplateServiceTypeEvent(templateServiceType: widget.templateServiceType.toEnum()));
    _templateServicesBloc.add(GetTemplateServicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _templateServicesBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<TemplateServicesBloc, TemplateServicesState>(
            listenWhen: (p, c) => p.fosTemplateServicesOnObserveOption != c.fosTemplateServicesOnObserveOption,
            listener: (context, state) {
              state.fosTemplateServicesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<TemplateServicesBloc, TemplateServicesState>(
            listenWhen: (p, c) => p.fosTemplateServicesOnCreateOption != c.fosTemplateServicesOnCreateOption,
            listener: (context, state) {
              state.fosTemplateServicesOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: 'Vorlage erfolgreich erstellt'),
                ),
              );
            },
          ),
          BlocListener<TemplateServicesBloc, TemplateServicesState>(
            listenWhen: (p, c) => p.fosTemplateServicesOnUpdateOption != c.fosTemplateServicesOnUpdateOption,
            listener: (context, state) {
              context.router.popUntilRouteWithName(switch (widget.templateServiceType.toEnum()) {
                TemplateServiceType.vehicleSize => TSVehicleSizesOverviewRoute.name,
                TemplateServiceType.contaminationLevel => TSContaminationLevelsOverviewRoute.name,
                TemplateServiceType.todo => TSTodosOverviewRoute.name,
              });

              state.fosTemplateServicesOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: 'Vorlage erfolgreich aktualisiert'),
                ),
              );
            },
          ),
          BlocListener<TemplateServicesBloc, TemplateServicesState>(
            listenWhen: (p, c) => p.fosTemplateServicesOnDeleteOption != c.fosTemplateServicesOnDeleteOption,
            listener: (context, state) {
              state.fosTemplateServicesOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: 'Vorlage erfolgreich gelöscht'),
                ),
              );
            },
          ),
          BlocListener<TemplateServicesBloc, TemplateServicesState>(
            listenWhen: (p, c) => p.fosTemplateServicesOnDeleteOption != c.fosTemplateServicesOnDeleteOption,
            listener: (context, state) {
              context.router.popUntilRouteWithName(switch (widget.templateServiceType.toEnum()) {
                TemplateServiceType.vehicleSize => TSVehicleSizesOverviewRoute.name,
                TemplateServiceType.contaminationLevel => TSContaminationLevelsOverviewRoute.name,
                TemplateServiceType.todo => TSTodosOverviewRoute.name,
              });

              state.fosTemplateServicesOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => showSuccessSnackBar(context: context, text: 'Vorlage erfolgreich gelöscht'),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<TemplateServicesBloc, TemplateServicesState>(
          builder: (context, state) {
            return Scaffold(
              drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
              appBar: AppBar(
                title: MyAppBarTitle(title: context.l10n.template_services_overview_title(widget.templateServiceType.toEnum().name)),
                actions: [
                  IconButton(
                    onPressed: () => _templateServicesBloc.add(GetTemplateServicesEvent()),
                    icon: const Icon(Icons.refresh),
                  ),
                  MyAppBarActionAddButton(
                    onPressed: () => showAddEditTemplateServiceSheet(
                      context: context,
                      templateServicesBloc: _templateServicesBloc,
                      templateServiceType: widget.templateServiceType.toEnum(),
                      infoText: context.l10n.template_services_overview_createTemplateServiceInfoText(widget.templateServiceType),
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: TemplateServicesOverviewPage(templateServicesBloc: _templateServicesBloc, templateServiceType: state.templateServiceType),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
