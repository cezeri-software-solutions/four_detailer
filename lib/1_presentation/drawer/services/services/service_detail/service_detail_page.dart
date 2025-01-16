import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/2_application/service_detail/service_detail_bloc.dart';
import '/core/core.dart';
import 'widgets/service_data_tab_one.dart';
import 'widgets/service_data_tab_two.dart';

class ServiceDetailPage extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;

  const ServiceDetailPage({required this.serviceDetailBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailBloc, ServiceDetailState>(
      builder: (context, state) {
        if (state.isLoadingServiceOnObserve) return const Center(child: MyLoadingIndicator());
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.service == null) return const Center(child: MyLoadingIndicator());

        return _ServiceDetailContent(serviceDetailBloc: serviceDetailBloc, state: state);
      },
    );
  }
}

class _ServiceDetailContent extends StatelessWidget {
  final ServiceDetailBloc serviceDetailBloc;
  final ServiceDetailState state;

  const _ServiceDetailContent({required this.serviceDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    if (isMobile) {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Allgemein'),
                Tab(text: 'Checkliste'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(child: ServiceDataTabOne(serviceDetailBloc: serviceDetailBloc, service: state.service!)),
                  SingleChildScrollView(child: ServiceDataTabTwo(serviceDetailBloc: serviceDetailBloc, service: state.service!)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        AlignedScrollableContent(child: ServiceDataTabOne(serviceDetailBloc: serviceDetailBloc, service: state.service!)),
        AlignedScrollableContent(child: ServiceDataTabTwo(serviceDetailBloc: serviceDetailBloc, service: state.service!)),
      ],
    );
  }
}

class AlignedScrollableContent extends StatelessWidget {
  final Widget child;

  const AlignedScrollableContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Align(alignment: Alignment.topCenter, child: SingleChildScrollView(child: child)));
  }
}
