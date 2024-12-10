import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:four_detailer/3_domain/models/conditioner.dart';
import 'package:get_it/get_it.dart';
import 'package:redacted/redacted.dart';

import '/core/core.dart';
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
    void navigateToRoute(PageRouteInfo route) {
      if (widget.isPersistent) {
        context.router.current.name == route.routeName ? null : context.router.replaceAll([route]);
        setState(() {});
      } else {
        if (context.router.current.name != route.routeName) context.router.replaceAll([route]);
        context.pop(); // Schließt den Drawer
      }
    }

    final drawerContent = Scaffold(
      backgroundColor: context.colorScheme.surfaceContainer,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gaps.h16,
                    Column(
                      children: [
                        MyAvatar(
                          name: _conditioner != null ? _conditioner!.name : '',
                          imageUrl: _conditioner?.imageUrl,
                          radius: 50,
                          fontSize: 32,
                          onTap: () => navigateToRoute(const ConditionerDetailRoute()),
                        ),
                        Gaps.h12,
                        Text(
                          _conditioner != null ? _conditioner!.name : '',
                          style: context.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gaps.h4,
                        Text(
                          _conditioner != null ? _conditioner!.email : '',
                          style: context.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ).redacted(
                        context: context, redact: _conditioner == null, configuration: RedactedConfiguration(autoFillText: 'Vorname Nachname')),
                    Gaps.h12,
                    ListTile(
                      selected: context.router.isRouteActive(HomeRoute.name),
                      selectedTileColor: context.colorScheme.surfaceContainerHigh,
                      leading: const Icon(Icons.home),
                      title: Text(context.l10n.app_drawer_homepage),
                      onTap: () => navigateToRoute(const HomeRoute()),
                    ),
                    ListTile(
                      selected: context.router.isRouteActive(BranchesOverviewRoute.name),
                      selectedTileColor: context.colorScheme.surfaceContainerHigh,
                      leading: const Icon(Icons.store),
                      title: Text(context.l10n.app_drawer_branches),
                      onTap: () => navigateToRoute(const BranchesOverviewRoute()),
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
      ),
    );

    if (widget.isPersistent) {
      return Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: context.colorScheme.surfaceContainerHighest)),
        ),
        child: drawerContent,
      );
    }

    return Drawer(child: drawerContent);
  }

  void _loadConditioner() async {
    final repo = GetIt.I<ConditionerRepository>();
    final fos = await repo.getCurConditioner();
    if (fos.isLeft()) return;
    setState(() => _conditioner = fos.getRight());
  }
}
