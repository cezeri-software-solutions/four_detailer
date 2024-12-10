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

  const _ConditionerDetailContent({required this.conditionerBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: context.breakpoint.isMobile ? 12 : 48),
        child: Column(
          children: [
            MyBusinessCard(
              showImageEditing: state.showImageEditing,
              imageButtons: MyImageButtons(
                imageUrl: state.conditioner?.imageUrl,
                onPickImage: (source) => conditionerBloc.add(ConditionerAddEditImageEvent(context: context, source: source)),
                onRemoveImage: () => conditionerBloc.add(ConditionerRemoveImageEvent(context: context)),
              ),
              avatar: MyAvatar(
                name: state.conditioner!.name,
                imageUrl: state.conditioner?.imageUrl,
                radius: isMobile ? 50 : 65,
                fontSize: isMobile ? 32 : 42,
                borderColor: context.colorScheme.outlineVariant,
                onTap: () => conditionerBloc.add(ShowImageEditingChangedEvent()),
              ),
              address: state.conditioner!.address,
              name: state.conditioner!.name,
              email: state.conditioner!.email,
              iconButtons: [
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
