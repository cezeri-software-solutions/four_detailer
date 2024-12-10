import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/branches_overview/branches_overview_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../../../../core/core.dart';
import '../../../../routes/router.gr.dart';

class BranchesOverviewPage extends StatelessWidget {
  final BranchesOverviewBloc branchesOverviewBloc;

  const BranchesOverviewPage({super.key, required this.branchesOverviewBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesOverviewBloc, BranchesOverviewState>(
      builder: (context, state) {
        if (state.isLoadingBranches) return const Center(child: MyLoadingIndicator());
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.listOfBranches == null) return const Center(child: MyLoadingIndicator());

        return _BranchesOverviewContent(branchesOverviewBloc: branchesOverviewBloc, state: state);
      },
    );
  }
}

class _BranchesOverviewContent extends StatelessWidget {
  final BranchesOverviewBloc branchesOverviewBloc;
  final BranchesOverviewState state;

  const _BranchesOverviewContent({required this.branchesOverviewBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      itemCount: state.listOfBranches!.length,
      itemBuilder: (context, index) {
        final branch = state.listOfBranches![index];
        return _BranchTile(branch: branch);
      },
    );
  }
}

class _BranchTile extends StatelessWidget {
  final Branch branch;

  const _BranchTile({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.router.push(BranchDetailRoute(branchId: branch.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              MyAvatar(name: branch.branchName, imageUrl: branch.branchLogo, radius: 32, fontSize: 24),
              Gaps.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.branchName, 
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    Gaps.h4,
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16),
                        Gaps.w4,
                        Expanded(
                          child: Text(
                            '${branch.address.street}, ${branch.address.postalCode} ${branch.address.city}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (branch.tel1.isNotEmpty) ...[
                      Gaps.h4,
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 16),
                          Gaps.w4,
                          Text(branch.tel1),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
