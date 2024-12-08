import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted/redacted.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/2_application/branch_detail/branch_detail_bloc.dart';
import '/constants.dart';
import '/core/core.dart';
import 'widgets/widgets.dart';

class BranchDetailPage extends StatelessWidget {
  final BranchDetailBloc branchDetailBloc;

  const BranchDetailPage({required this.branchDetailBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchDetailBloc, BranchDetailState>(
      builder: (context, state) {
        if (state.isLoadingBranchOnObserve) return const Center(child: MyLoadingIndicator());
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.branch == null) return const Center(child: MyLoadingIndicator());

        return _BranchDetailContent(branchDetailBloc: branchDetailBloc, state: state);
      },
    );
  }
}

class _BranchDetailContent extends StatelessWidget {
  final BranchDetailBloc branchDetailBloc;
  final BranchDetailState state;

  const _BranchDetailContent({required this.branchDetailBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            MyBusinessCard(
              showImageEditing: state.showImageEditing,
              imageButtons: MyImageButtons(
                imageUrl: state.branch!.branchLogo,
                onPickImage: (source) => branchDetailBloc.add(BranchAddEditImageEvent(context: context, source: source)),
                onRemoveImage: () => branchDetailBloc.add(BranchRemoveImageEvent(context: context)),
              ),
              avatar: MyAvatar(
                name: state.branch!.branchName,
                imageUrl: state.branch!.branchLogo,
                radius: isMobile ? 50 : 65,
                fontSize: isMobile ? 32 : 42,
                borderColor: context.colorScheme.outlineVariant,
                onTap: () => branchDetailBloc.add(ShowBranchImageEditingChangedEvent()),
              ),
              address: state.branch!.address,
              name: state.branch!.branchName,
              email: state.branch!.email,
              iconButtons: [
                IconButton(
                  onPressed: () => branchDetailBloc.add(IsEditModeChangedEvent()),
                  icon: Icon(state.isInEditMode ? Icons.edit_off : Icons.edit),
                )
              ],
            ),
            Gaps.h32,
            MyAnimatedExpansionContainer(
              isExpanded: state.isInEditMode,
              duration: const Duration(milliseconds: 400),
              reverseDuration: const Duration(milliseconds: 400),
              child: BranchDetailEdit(
                branchDetailBloc: branchDetailBloc,
                branch: state.branch!,
                isLoading: state.isLoadingBranchOnUpdate,
              ),
            ),
          ],
        ).redacted(
          context: context,
          redact: state.isLoadingBranchOnObserve || state.branch == null,
        ),
      ),
    );
  }
}
