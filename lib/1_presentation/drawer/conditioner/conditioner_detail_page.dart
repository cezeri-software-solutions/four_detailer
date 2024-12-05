import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/2_application/conditioner/conditioner_bloc.dart';
import '/constants.dart';
import '/core/core.dart';
import 'widgets/widgets.dart';

class ConditionerDetailPage extends StatelessWidget {
  final ConditionerBloc conditionerBloc;

  const ConditionerDetailPage({required this.conditionerBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConditionerBloc, ConditionerState>(
      builder: (context, state) {
        if (state.isLoadingConditionerOnObserve) return const Center(child: MyLoadingIndicator());
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.conditioner == null) return const Center(child: MyLoadingIndicator());

        return _ConditionerDetailContent(conditionerBloc: conditionerBloc, state: state);
      },
    );
  }
}

class _ConditionerDetailContent extends StatelessWidget {
  final ConditionerBloc conditionerBloc;
  final ConditionerState state;

  const _ConditionerDetailContent({required this.conditionerBloc, required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            MyFormFieldContainer(
              padding: EdgeInsets.zero,
              borderColor: context.colorScheme.outlineVariant,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: isMobile ? 140 : 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          color: context.colorScheme.outlineVariant,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: isMobile ? 140 : 180, right: 20),
                          child: Image.asset(
                            context.brightness == Brightness.light
                                ? 'assets/logo/logo_advertised_white.png'
                                : 'assets/logo/logo_advertised_black.png',
                            width: 250,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 42, bottom: 20, left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyAnimatedExpansionContainer(
                                    isExpanded: state.showImageEditing,
                                    child: ConditionerDetailImageButtons(bloc: conditionerBloc, conditioner: state.conditioner!),
                                  ),
                                  Gaps.h12,
                                  Text(
                                    state.conditioner!.name,
                                    style: context.textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gaps.h4,
                                  Text(
                                    state.conditioner!.email,
                                    style: context.textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gaps.h24,
                                  MyAddressView(address: state.conditioner!.address),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () => conditionerBloc.add(IsPaymentEditModeChangedEvent()),
                                  icon: Icon(state.isInPaymentEditMode ? Icons.payments_outlined : Icons.payments),
                                ),
                                IconButton(
                                  onPressed: () => conditionerBloc.add(IsEditModeChangedEvent()),
                                  icon: Icon(state.isInEditMode ? Icons.edit_off : Icons.edit),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: isMobile ? 70 : 110,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyAvatar(
                          name: state.conditioner!.name,
                          imageUrl: state.conditioner?.imageUrl,
                          radius: isMobile ? 50 : 65,
                          fontSize: isMobile ? 32 : 42,
                          borderColor: context.colorScheme.outlineVariant,
                          onTap: () => conditionerBloc.add(ShowImageEditingChangedEvent()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gaps.h32,
            MyAnimatedExpansionContainer(
              isExpanded: state.isInEditMode,
              duration: const Duration(milliseconds: 400),
              reverseDuration: const Duration(milliseconds: 400),
              child: ConditionerDetailEdit(
                conditionerBloc: conditionerBloc,
                conditioner: state.conditioner!,
                isLoading: state.isLoadingConditionerOnUpdate,
              ),
            ),
          ],
        ).redacted(context: context, redact: state.isLoadingConditionerOnObserve || state.conditioner == null),
      ),
    );
  }
}
