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
              padding: EdgeInsets.symmetric(vertical: context.breakpoint.isMobile ? 12 : 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.listOfCategories.length,
              itemBuilder: (context, index) {
                final category = state.listOfCategories[index];
                final services = state.listOfServices!.where((e) => e.category?.id == category.id).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategoryTitleContainer(title: category.title),
                    _ServicesListView(servicesOverviewBloc: servicesOverviewBloc, listOfServices: services),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.h12,
            ),
            _CategoryTitleContainer(title: context.l10n.services_overview_noCategoryTitle),
            _ServicesListView(
              servicesOverviewBloc: servicesOverviewBloc,
              listOfServices: state.listOfServices!.where((e) => e.category == null).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTitleContainer extends StatelessWidget {
  final String title;

  const _CategoryTitleContainer({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.breakpoint.isMobile ? 12 : 24, vertical: 4),
      width: double.infinity,
      color: context.colorScheme.surfaceContainerHighest,
      child: Text(title, style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.onSurfaceVariant)),
    );
  }
}

class _ServicesListView extends StatelessWidget {
  final ServicesOverviewBloc servicesOverviewBloc;
  final List<Service> listOfServices;

  const _ServicesListView({required this.servicesOverviewBloc, required this.listOfServices});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(context.breakpoint.isMobile ? 12 : 24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listOfServices.length,
      itemBuilder: (context, index) => _ServiceTile(servicesOverviewBloc: servicesOverviewBloc, service: listOfServices[index]),
      separatorBuilder: (context, index) => Gaps.h12,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.number, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(service.name),
                ],
              ),
              Icon(Icons.chevron_right_rounded, color: context.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
