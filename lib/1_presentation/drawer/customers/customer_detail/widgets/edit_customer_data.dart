import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/2_application/customer_detail/customer_detail_bloc.dart';
import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';

class EditCustomerData extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final Customer customer;

  const EditCustomerData({super.key, required this.customerDetailBloc, required this.customer});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);
    final padding = isMobile ? const EdgeInsets.only(left: 12, right: 12, top: 12) : const EdgeInsets.only(left: 24, right: 12, top: 24);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.customer_detail_customerData, style: context.textTheme.titleLarge),
          Gaps.h24,
          if (isMobile)
            _EditCustomerDataContent(customerDetailBloc: customerDetailBloc, customer: customer, isMobile: isMobile)
          else
            Expanded(
              child: SingleChildScrollView(
                child: _EditCustomerDataContent(customerDetailBloc: customerDetailBloc, customer: customer, isMobile: isMobile),
              ),
            ),
        ],
      ),
    );
  }
}

void _onGenderChanged(BuildContext context, CustomerDetailBloc bloc, Customer customer, String? gender) {
  if (gender == null) return;

  if (gender == context.l10n.gender_male) {
    bloc.add(UpdateCustomerEvent(customer: customer.copyWith(gender: Gender.male)));
  } else if (gender == context.l10n.gender_female) {
    bloc.add(UpdateCustomerEvent(customer: customer.copyWith(gender: Gender.female)));
  } else {
    bloc.add(UpdateCustomerEvent(customer: customer.copyWith(gender: Gender.empty)));
  }
}

class _EditCustomerDataContent extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final Customer customer;
  final bool isMobile;

  const _EditCustomerDataContent({required this.customerDetailBloc, required this.customer, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 42),
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _CustomerStatusSegmentedButton(customerDetailBloc: customerDetailBloc, customer: customer),
              _CustomerTypeSegmentedButton(customerDetailBloc: customerDetailBloc, customer: customer),
            ],
          ),
          isMobile ? Gaps.h24 : Gaps.h32,
          Row(
            children: [
              Expanded(
                child: MyDropdownButton(
                  fieldTitle: context.l10n.gender,
                  value: customer.gender.convert(context),
                  onChanged: (value) => _onGenderChanged(context, customerDetailBloc, customer, value),
                  showSearch: false,
                  items: ['', context.l10n.gender_male, context.l10n.gender_female],
                ),
              ),
              Gaps.w12,
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          isMobile ? Gaps.h8 : Gaps.h12,
          MyAnimatedExpansionContainer(
            isExpanded: customer.customerType == CustomerType.business,
            child: Column(
              children: [
                MyTextFormField(
                  fieldTitle: context.l10n.company,
                  initialValue: customer.companyName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  isMandatory: customer.customerType == CustomerType.business,
                  onChanged: (value) => customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(companyName: value))),
                ),
                isMobile ? Gaps.h8 : Gaps.h12,
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: MyTextFormField(
                  fieldTitle: context.l10n.firstName,
                  initialValue: customer.firstName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) => customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(firstName: value))),
                ),
              ),
              Gaps.w12,
              Expanded(
                child: MyTextFormField(
                  fieldTitle: context.l10n.lastName,
                  initialValue: customer.lastName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  isMandatory: customer.customerType == CustomerType.private,
                  onChanged: (value) => customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(lastName: value))),
                ),
              ),
            ],
          ),
          isMobile ? Gaps.h8 : Gaps.h12,
          MyTextFormField(
            fieldTitle: context.l10n.taxNumber,
            initialValue: customer.taxNumber,
            textInputAction: TextInputAction.next,
            onChanged: (value) => customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(taxNumber: value))),
          ),
          isMobile ? Gaps.h24 : Gaps.h32,
          Text(context.l10n.customer_detail_contactData, style: context.textTheme.titleMedium),
          isMobile ? Gaps.h8 : Gaps.h12,
          MyTextFormField(
            fieldTitle: context.l10n.email,
            initialValue: customer.email,
            textInputAction: TextInputAction.next,
            inputType: FieldInputType.email,
            onChanged: (value) => customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(email: value))),
          ),
          isMobile ? Gaps.h8 : Gaps.h12,
          Row(
            children: [
              Expanded(
                child: MyTextFormField(
                  fieldTitle: context.l10n.tel1,
                  initialValue: customer.tel1,
                  textInputAction: TextInputAction.next,
                  inputType: FieldInputType.phone,
                  onChanged: (value) => customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(tel1: value))),
                ),
              ),
              Gaps.w12,
              Expanded(
                child: MyTextFormField(
                  fieldTitle: context.l10n.tel2,
                  initialValue: customer.tel2,
                  textInputAction: TextInputAction.next,
                  inputType: FieldInputType.phone,
                  onChanged: (value) => customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(tel2: value))),
                ),
              ),
            ],
          ),
          isMobile ? Gaps.h24 : Gaps.h32,
          Text(context.l10n.customer_detail_address, style: context.textTheme.titleMedium),
          isMobile ? Gaps.h8 : Gaps.h12,
          MyTextFormField(
            fieldTitle: context.l10n.street,
            initialValue: customer.address.street,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) =>
                customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(address: customer.address.copyWith(street: value)))),
          ),
          isMobile ? Gaps.h8 : Gaps.h12,
          Row(
            children: [
              Expanded(
                flex: 10,
                child: MyTextFormField(
                  fieldTitle: context.l10n.zip,
                  initialValue: customer.address.postalCode,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) =>
                      customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(address: customer.address.copyWith(postalCode: value)))),
                ),
              ),
              Gaps.w12,
              Expanded(
                flex: 25,
                child: MyTextFormField(
                  fieldTitle: context.l10n.city,
                  initialValue: customer.address.city,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) =>
                      customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(address: customer.address.copyWith(city: value)))),
                ),
              ),
            ],
          ),
          isMobile ? Gaps.h8 : Gaps.h12,
          MyTextFormField(
            fieldTitle: context.l10n.state,
            initialValue: customer.address.state,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) =>
                customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(address: customer.address.copyWith(state: value)))),
          ),
          isMobile ? Gaps.h8 : Gaps.h12,
          MyCountryFieldButton(
            onTap: (country) {
              if (country == null) return;
              customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(address: customer.address.copyWith(country: country))));
            },
            country: customer.address.country,
          ),
        ],
      ),
    );
  }
}

class _CustomerStatusSegmentedButton extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final Customer customer;

  const _CustomerStatusSegmentedButton({required this.customerDetailBloc, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldTitle(fieldTitle: context.l10n.customer_detail_customerStatus, isMandatory: false),
        SegmentedButton<CustomerStatus>(
          segments: [
            ButtonSegment(
              value: CustomerStatus.customer,
              label: Text(context.l10n.enum_customerStatus_customer),
            ),
            ButtonSegment(
              value: CustomerStatus.prospect,
              label: Text(context.l10n.enum_customerStatus_prospect),
            ),
          ],
          selected: {customer.customerStatus},
          onSelectionChanged: (Set<CustomerStatus> newSelection) {
            customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(customerStatus: newSelection.first)));
          },
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            visualDensity: VisualDensity.comfortable, // Reduziert die vertikale Höhe
            // tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimiert den Tap-Bereich
          ),
        ),
      ],
    );
  }
}

class _CustomerTypeSegmentedButton extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;
  final Customer customer;

  const _CustomerTypeSegmentedButton({required this.customerDetailBloc, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldTitle(fieldTitle: context.l10n.customer_detail_customerType, isMandatory: false),
        SegmentedButton<CustomerType>(
          segments: [
            ButtonSegment(
              value: CustomerType.private,
              label: Text(context.l10n.enum_customerType_private),
            ),
            ButtonSegment(
              value: CustomerType.business,
              label: Text(context.l10n.enum_customerType_business),
            ),
          ],
          selected: {customer.customerType},
          onSelectionChanged: (Set<CustomerType> newSelection) {
            customerDetailBloc.add(UpdateCustomerEvent(customer: customer.copyWith(customerType: newSelection.first)));
          },
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            visualDensity: VisualDensity.comfortable, // Reduziert die vertikale Höhe
            // tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Minimiert den Tap-Bereich
          ),
        ),
      ],
    );
  }
}
