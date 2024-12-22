import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../2_application/customers_overview/customers_overview_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../../../../core/core.dart';
import '../../../../routes/router.gr.dart';

class CustomersOverviewPage extends StatelessWidget {
  final CustomersOverviewBloc customersOverviewBloc;

  const CustomersOverviewPage({super.key, required this.customersOverviewBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersOverviewBloc, CustomersOverviewState>(
      builder: (context, state) {
        const loadingWidget = Expanded(child: Center(child: MyLoadingIndicator()));

        if (state.isLoadingCustomers) return loadingWidget;
        if (state.failure != null) return Expanded(child: Center(child: Text(state.failure!.message ?? state.failure!.toString())));
        if (state.listOfCustomers == null) return loadingWidget;
        if (state.listOfCustomers!.isEmpty) return Expanded(child: Center(child: MyEmptyList(title: context.l10n.customers_overview_emptyTitle)));

        return _CustomersOverviewContent(customersOverviewBloc: customersOverviewBloc, state: state);
      },
    );
  }
}

class _CustomersOverviewContent extends StatelessWidget {
  final CustomersOverviewBloc customersOverviewBloc;
  final CustomersOverviewState state;

  const _CustomersOverviewContent({required this.customersOverviewBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator.adaptive(
        onRefresh: () async => customersOverviewBloc.add(GetCustomersEvent(calcCount: true, currentPage: state.currentPage)),
        child: ListView(
          children: [
            ListView.separated(
              padding: EdgeInsets.all(context.breakpoint.isMobile ? 12 : 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.listOfCustomers!.length,
              itemBuilder: (context, index) => _CustomerTile(customersOverviewBloc: customersOverviewBloc, customer: state.listOfCustomers![index]),
              separatorBuilder: (context, index) => Gaps.h12,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  final CustomersOverviewBloc customersOverviewBloc;
  final Customer customer;

  const _CustomerTile({required this.customersOverviewBloc, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await context.router.push(CustomerDetailRoute(customerId: customer.id));
          customersOverviewBloc.add(GetCustomerByIdEvent(customerId: customer.id));
        },
        onLongPress: () => showMyDialogDeleteWolt(
          context: context,
          content: context.l10n.customers_overview_delete_customers_title(
            customer.customerType == CustomerType.private ? customer.name : customer.companyName,
          ),
          onConfirm: () => customersOverviewBloc.add(DeleteCustomersEvent(customerIds: [customer.id])),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              MyAvatar(name: customer.name, imageUrl: customer.imageUrl, radius: 32, fontSize: 24),
              Gaps.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CustomerTitle(customer: customer),
                    Gaps.h4,
                    _CustomerAddressRow(customer: customer),
                    Gaps.h4,
                    _CustomerContactRow(customer: customer),
                  ],
                ),
              ),
              if (!context.breakpoint.isMobile) const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerTitle extends StatelessWidget {
  final Customer customer;

  const _CustomerTitle({required this.customer});

  @override
  Widget build(BuildContext context) {
    if (customer.customerType == CustomerType.business) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customer.companyName,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (customer.name.isNotEmpty) ...[
            Gaps.h2,
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                Gaps.w4,
                Text(customer.name, style: TextStyle(color: context.colorScheme.outline), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        ],
      );
    }

    return Text(
      customer.name,
      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CustomerAddressRow extends StatelessWidget {
  const _CustomerAddressRow({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 16),
        Gaps.w4,
        Expanded(
          child: Text(
            [
              if (customer.address.street.isNotEmpty) customer.address.street,
              if (customer.address.postalCode.isNotEmpty) customer.address.postalCode,
              if (customer.address.city.isNotEmpty) customer.address.city,
              customer.address.country.name,
            ].where((e) => e.isNotEmpty).join(', '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colorScheme.outline),
          ),
        ),
      ],
    );
  }
}

class _CustomerContactRow extends StatelessWidget {
  final Customer customer;

  const _CustomerContactRow({required this.customer});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: context.colorScheme.outline);

    return Row(
      children: [
        if (customer.tel1.isNotEmpty)
          Expanded(
            flex: context.breakpoint.isMobile ? 3 : 1,
            child: Row(
              children: [
                const Icon(Icons.phone_outlined, size: 16),
                Gaps.w4,
                Text(customer.tel1, style: textStyle),
              ],
            ),
          ),
        if (customer.vehicles != null && customer.vehicles!.isNotEmpty)
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(MdiIcons.car, size: 16),
                Gaps.w4,
                Text(customer.vehicles!.length.toString(), style: textStyle),
              ],
            ),
          )
      ],
    );
  }
}
