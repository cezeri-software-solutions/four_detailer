import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/services_overview/services_overview_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';
import '/routes/router.gr.dart';

class ServicesOverviewPage extends StatelessWidget {
  final ServicesOverviewBloc servicesOverviewBloc;

  const ServicesOverviewPage({super.key, required this.servicesOverviewBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesOverviewBloc, ServicesOverviewState>(
      builder: (context, state) {
        const loadingWidget = Expanded(child: Center(child: MyLoadingIndicator()));

        if (state.isLoadingServicesOnObserve) return loadingWidget;
        if (state.failure != null) return Expanded(child: Center(child: Text(state.failure!.message ?? state.failure!.toString())));
        if (state.listOfServices == null) return loadingWidget;
        if (state.listOfServices!.isEmpty) return Expanded(child: Center(child: MyEmptyList(title: context.l10n.services_overview_emptyTitle)));

        return _ServicesOverviewContent(servicesOverviewBloc: servicesOverviewBloc, state: state);
      },
    );
  }
}

class _ServicesOverviewContent extends StatelessWidget {
  final ServicesOverviewBloc servicesOverviewBloc;
  final ServicesOverviewState state;

  const _ServicesOverviewContent({required this.servicesOverviewBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator.adaptive(
        onRefresh: () async => servicesOverviewBloc.add(GetServicesEvent(calcCount: true, currentPage: state.currentPage)),
        child: ListView(
          children: [
            ListView.separated(
              padding: EdgeInsets.all(context.breakpoint.isMobile ? 12 : 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.listOfServices!.length,
              itemBuilder: (context, index) => _ServiceTile(servicesOverviewBloc: servicesOverviewBloc, service: state.listOfServices![index]),
              separatorBuilder: (context, index) => Gaps.h12,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServicesOverviewBloc servicesOverviewBloc;
  final Service service;

  const _ServiceTile({required this.servicesOverviewBloc, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await context.router.push(ServiceDetailRoute(serviceId: service.id));
          servicesOverviewBloc.add(GetServiceByIdEvent(serviceId: service.id));
        },
        onLongPress: () => showMyDialogDeleteWolt(
          context: context,
          content: context.l10n.services_overview_delete_services_title(service.name),
          onConfirm: () => servicesOverviewBloc.add(DeleteServiceEvent(serviceId: service.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(service.name),
        ),
      ),
    );
  }
}
