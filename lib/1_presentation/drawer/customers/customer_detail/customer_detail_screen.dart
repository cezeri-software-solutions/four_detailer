import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/auth/auth_bloc.dart';
import '/core/core.dart';
import '/injection.dart';
import '/routes/router.gr.dart';
import '../../../../2_application/customer_detail/customer_detail_bloc.dart';
import '../../../../3_domain/models/models.dart';
import 'customer_detail_page.dart';

@RoutePage()
class CustomerDetailScreen extends StatefulWidget {
  final String? customerId;

  const CustomerDetailScreen({super.key, @PathParam('customerId') required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> with AutomaticKeepAliveClientMixin {
  late final CustomerDetailBloc _customerDetailBloc;

  @override
  void initState() {
    super.initState();

    _customerDetailBloc = sl<CustomerDetailBloc>();
    widget.customerId == null
        ? _customerDetailBloc.add(SetEmptyCustomerOnCreateEvent(context: context))
        : _customerDetailBloc.add(GetCurrentCustomerEvent(customerId: widget.customerId!));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: _customerDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: (context, state) {
            if (state is AuthStateUnauthenticated) context.router.replaceAll([const SplashRoute()]);
          }),
          BlocListener<CustomerDetailBloc, CustomerDetailState>(
            listenWhen: (p, c) => p.fosCustomerOnCreateOption != c.fosCustomerOnCreateOption,
            listener: (context, state) {
              state.fosCustomerOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (createdCustomer) {
                    showSuccessSnackBar(context: context, text: 'Kunde erfolgreich erstellt');
                    context.router.popUntilRouteWithName(CustomersOverviewRoute.name);
                    context.router.push(CustomerDetailRoute(customerId: createdCustomer.id));
                  },
                ),
              );
            },
          ),
          BlocListener<CustomerDetailBloc, CustomerDetailState>(
            listenWhen: (p, c) => p.fosCustomerOnObserveOption != c.fosCustomerOnObserveOption,
            listener: (context, state) {
              state.fosCustomerOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) => null,
                ),
              );
            },
          ),
          BlocListener<CustomerDetailBloc, CustomerDetailState>(
            listenWhen: (p, c) => p.fosCustomerOnUpdateOption != c.fosCustomerOnUpdateOption,
            listener: (context, state) {
              state.fosCustomerOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => showErrorSnackbar(context: context, text: failure.message ?? failure.toString()),
                  (_) {
                    showSuccessSnackBar(context: context, text: 'Kunde erfolgreich aktualisiert');
                    context.router.popUntilRouteWithName(CustomerDetailRoute.name);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(_getTitle(state.customer)),
                actions: [
                  if (widget.customerId != null)
                    IconButton(
                      onPressed: () => _customerDetailBloc.add(GetCurrentCustomerEvent(customerId: widget.customerId!)),
                      icon: const Icon(Icons.refresh),
                    ),
                  widget.customerId != null && state.customer != null
                      ? MyAppBarActionSaveButton(
                          isLoading: _customerDetailBloc.state.isLoadingCustomerOnUpdate,
                          onPressed: () {
                            _onSavePressed(
                              state.customer!.customerType,
                              state.customer!.companyName,
                              state.customer!.lastName,
                              () => _customerDetailBloc.add(SaveCustomerEvent()),
                            );
                          },
                        )
                      : MyAppBarActionSaveButton(
                          isLoading: _customerDetailBloc.state.isLoadingCustomerOnCreate,
                          onPressed: () {
                            _onSavePressed(
                              state.customer!.customerType,
                              state.customer!.companyName,
                              state.customer!.lastName,
                              () => _customerDetailBloc.add(CreateCustomerEvent()),
                            );
                          },
                        ),
                ],
              ),
              body: SafeArea(child: CustomerDetailPage(customerDetailBloc: _customerDetailBloc)),
            );
          },
        ),
      ),
    );
  }

  String _getTitle(Customer? customer) {
    if (widget.customerId == null) return context.l10n.customer_detail_title;
    if (customer == null) return '';
    if (customer.companyName.isNotEmpty) return customer.companyName;

    return customer.name;
  }

  void _onSavePressed(CustomerType customerType, String companyName, String lastName, VoidCallback onSuccess) {
    if (customerType == CustomerType.business && companyName.isEmpty) {
      showMyDialogAlertWolt(
        context: context,
        title: context.l10n.danger,
        content: context.l10n.customer_detail_companyNameIsMandatory,
      );
    } else if (customerType == CustomerType.private && lastName.isEmpty) {
      showMyDialogAlertWolt(
        context: context,
        title: context.l10n.danger,
        content: context.l10n.customer_detail_lastNameIsMandatory,
      );
    } else {
      onSuccess();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
