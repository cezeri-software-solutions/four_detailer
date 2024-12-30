import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:redacted/redacted.dart';

import '/core/core.dart';
import '../3_domain/models/models.dart';
import '../3_domain/repositories/auth_repository.dart';
import '../3_domain/repositories/conditioner_repository.dart';
import '../constants.dart';
import '../routes/router.gr.dart';

class AppDrawer extends StatefulWidget {
  final bool isPersistent;

  const AppDrawer({
    super.key,
    this.isPersistent = false,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Conditioner? _conditioner;

  @override
  void initState() {
    super.initState();
    
    _loadConditioner();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPersistent) {
      return Container(
        decoration: BoxDecoration(border: Border(right: BorderSide(color: context.colorScheme.surfaceContainerHighest))),
        child: _AppDrawerContent(navigateToRoute: navigateToRoute, conditioner: _conditioner),
      );
    }

    return Drawer(child: _AppDrawerContent(navigateToRoute: navigateToRoute, conditioner: _conditioner));
  }

  void navigateToRoute(PageRouteInfo route) {
    if (widget.isPersistent) {
      context.router.current.name == route.routeName ? null : context.router.replaceAll([route]);
      setState(() {});
    } else {
      if (context.router.current.name != route.routeName) context.router.replaceAll([route]);
      context.pop(); // Schließt den Drawer
    }
  }

  void _loadConditioner() async {
    final repo = GetIt.I<ConditionerRepository>();
    final fos = await repo.getCurConditioner();
    if (fos.isLeft()) return;
    setState(() => _conditioner = fos.getRight());
  }
}

class _AppDrawerContent extends StatelessWidget {
  final void Function(PageRouteInfo route) navigateToRoute;
  final Conditioner? conditioner;

  const _AppDrawerContent({required this.navigateToRoute, required this.conditioner});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Gaps.h16,
          Column(
            children: [
              MyAvatar(
                name: conditioner != null ? conditioner!.name : '',
                imageUrl: conditioner?.imageUrl,
                radius: 50,
                fontSize: 32,
                onTap: () => navigateToRoute(ConditionerDetailRoute(conditionerId: conditioner!.id)),
              ),
              Gaps.h12,
              Text(
                conditioner != null ? conditioner!.name : '',
                style: context.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Gaps.h4,
              Text(
                conditioner != null ? conditioner!.email : '',
                style: context.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).redacted(context: context, redact: conditioner == null, configuration: RedactedConfiguration(autoFillText: 'Vorname Nachname')),
          Gaps.h12,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    selected: context.router.isRouteActive(HomeRoute.name),
                    selectedTileColor: context.colorScheme.surfaceContainerHigh,
                    leading: const Icon(Icons.home),
                    title: Text(context.l10n.app_drawer_homepage),
                    onTap: () => navigateToRoute(const HomeRoute()),
                  ),
                  ListTile(
                    selected: context.router.isRouteActive(CustomersOverviewRoute.name),
                    selectedTileColor: context.colorScheme.surfaceContainerHigh,
                    leading: const Icon(Icons.people),
                    title: Text(context.l10n.app_drawer_customers),
                    onTap: () => navigateToRoute(const CustomersOverviewRoute()),
                  ),
                  ListTile(
                    selected: context.router.isRouteActive(ConditionersOverviewRoute.name),
                    selectedTileColor: context.colorScheme.surfaceContainerHigh,
                    leading: const Icon(Icons.badge),
                    title: Text(context.l10n.app_drawer_employees),
                    onTap: () => navigateToRoute(const ConditionersOverviewRoute()),
                  ),
                  ListTile(
                    selected: context.router.isRouteActive(BranchesOverviewRoute.name),
                    selectedTileColor: context.colorScheme.surfaceContainerHigh,
                    leading: const Icon(Icons.store),
                    title: Text(context.l10n.app_drawer_branches),
                    onTap: () => navigateToRoute(const BranchesOverviewRoute()),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: context.colorScheme.surfaceContainerHighest),
                    child: ExpansionTile(
                      title: const Text('Leistungen'),
                      leading: const Icon(Icons.handyman_outlined), // Wrench/tools icon for services
                      childrenPadding: const EdgeInsets.only(left: 20),
                      children: [
                        const ListTile(
                          leading: Icon(Icons.cleaning_services_outlined), // Keep cleaning icon
                          title: Text('Dienstleistungen'),
                          // onTap: () => navigateToRoute(const SuppliersOverviewRoute()),
                        ),
                        ListTile(
                          selected: context.router.isRouteActive(CategoriesOverviewRoute.name),
                          selectedTileColor: context.colorScheme.surfaceContainerHigh,
                          leading: const Icon(Icons.category_outlined), // Keep category icon
                          title: const Text('Kategorien'),
                          onTap: () => navigateToRoute(const CategoriesOverviewRoute()),
                        ),
                        ListTile(
                          selected: context.router.isRouteActive(TSVehicleSizesOverviewRoute.name),
                          selectedTileColor: context.colorScheme.surfaceContainerHigh,
                          leading: const Icon(Icons.directions_car_outlined), // Car icon for vehicle sizes
                          title: const Text('Fahrzeugrößen Vorlagen'),
                          onTap: () => navigateToRoute(const TSVehicleSizesOverviewRoute()),
                        ),
                        ListTile(
                          selected: context.router.isRouteActive(TSContaminationLevelsOverviewRoute.name),
                          selectedTileColor: context.colorScheme.surfaceContainerHigh,
                          leading: const Icon(Icons.wash_outlined), // Cleaning/dirt icon for contamination levels
                          title: const Text('Verschmutzungsgrade Vorlagen'),
                          onTap: () => navigateToRoute(const TSContaminationLevelsOverviewRoute()),
                        ),
                        ListTile(
                          selected: context.router.isRouteActive(TSTodosOverviewRoute.name),
                          selectedTileColor: context.colorScheme.surfaceContainerHigh,
                          leading: const Icon(Icons.checklist_rtl_outlined), // Checklist icon for todos
                          title: const Text('Todo`s Vorlagen'),
                          onTap: () => navigateToRoute(const TSTodosOverviewRoute()),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    selected: context.router.isRouteActive(SettingsRoute.name),
                    selectedTileColor: context.colorScheme.surfaceContainerHigh,
                    leading: const Icon(Icons.settings),
                    title: Text(context.l10n.app_drawer_settings),
                    onTap: () => navigateToRoute(const SettingsRoute()),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: context.colorScheme.error),
            title: Text(context.l10n.app_drawer_signOut),
            onTap: () async {
              final repo = GetIt.I<AuthRepository>();
              await repo.signOut();

              if (context.mounted) context.router.replaceAll([const SplashRoute()]);
            },
          ),
        ],
      ),
    );
  }
}
