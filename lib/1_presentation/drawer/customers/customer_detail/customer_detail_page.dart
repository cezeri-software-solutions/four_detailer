import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/core/core.dart';
import '../../../../2_application/customer_detail/customer_detail_bloc.dart';
import 'widgets/widgets.dart';

class CustomerDetailPage extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;

  const CustomerDetailPage({required this.customerDetailBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
      builder: (context, state) {
        if (state.isLoadingCustomerOnObserve) return const Center(child: MyLoadingIndicator());
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.customer == null) return const Center(child: MyLoadingIndicator());

        return _CustomerDetailContent(customerDetailBloc: customerDetailBloc, state: state);
      },
    );
  }
}

class _CustomerDetailContent extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final CustomerDetailState state;

  const _CustomerDetailContent({required this.customerDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    if (isMobile) {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: context.l10n.customer_detail_customerData),
                Tab(text: context.l10n.customer_detail_vehicles),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(child: EditCustomerData(customerDetailBloc: customerDetailBloc, customer: state.customer!)),
                  SingleChildScrollView(
                    child: CustomerDetailVehicles(customerDetailBloc: customerDetailBloc, vehicles: state.customer!.vehicles ?? []),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: EditCustomerData(customerDetailBloc: customerDetailBloc, customer: state.customer!)),
        Expanded(child: CustomerDetailVehicles(customerDetailBloc: customerDetailBloc, vehicles: state.customer!.vehicles ?? [])),
      ],
    );
  }
}
