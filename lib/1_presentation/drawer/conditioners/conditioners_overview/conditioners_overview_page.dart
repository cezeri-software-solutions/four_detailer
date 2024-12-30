import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/conditioners_overview/conditioners_overview_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../constants.dart';
import '../../../../core/core.dart';
import '../../../../routes/router.gr.dart';

class ConditionersOverviewPage extends StatelessWidget {
  final ConditionersOverviewBloc conditionersOverviewBloc;

  const ConditionersOverviewPage({super.key, required this.conditionersOverviewBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConditionersOverviewBloc, ConditionersOverviewState>(
      builder: (context, state) {
        if (state.isLoadingConditioners) return const Center(child: MyLoadingIndicator());
        if (state.failure != null) return Center(child: Text(state.failure!.message ?? state.failure!.toString()));
        if (state.listOfConditioners == null) return const Center(child: MyLoadingIndicator());

        return _ConditionersOverviewContent(conditionersOverviewBloc: conditionersOverviewBloc, state: state);
      },
    );
  }
}

class _ConditionersOverviewContent extends StatelessWidget {
  final ConditionersOverviewBloc conditionersOverviewBloc;
  final ConditionersOverviewState state;

  const _ConditionersOverviewContent({required this.conditionersOverviewBloc, required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => conditionersOverviewBloc.add(GetConditionersEvent()),
      child: ListView(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(context.breakpoint.isMobile ? 12 : 24),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.listOfConditioners!.length,
            itemBuilder: (context, index) => _ConditionerTile(conditioner: state.listOfConditioners![index]),
          ),
        ],
      ),
    );
  }
}

class _ConditionerTile extends StatelessWidget {
  final Conditioner conditioner;

  const _ConditionerTile({required this.conditioner});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.router.push(ConditionerDetailRoute(conditionerId: conditioner.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              MyAvatar(name: conditioner.firstName, imageUrl: conditioner.imageUrl, radius: 32, fontSize: 24),
              Gaps.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conditioner.firstName, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Gaps.h4,
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16),
                        Gaps.w4,
                        Expanded(
                          child: Text(
                            '${conditioner.address.street}, ${conditioner.address.postalCode} ${conditioner.address.city}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.colorScheme.outline),
                          ),
                        ),
                      ],
                    ),
                    if (conditioner.tel1.isNotEmpty) ...[
                      Gaps.h4,
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 16),
                          Gaps.w4,
                          Text(conditioner.tel1, style: TextStyle(color: context.colorScheme.outline)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
