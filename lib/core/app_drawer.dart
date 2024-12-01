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
  const AppDrawer({super.key});

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
      context.router.current.name == route.routeName ? context.router.maybePop() : context.router.replaceAll([route]);
    }

    return Drawer(
      child: SafeArea(
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
                          // isLoading: _conditioner == null,
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
                      leading: const Icon(Icons.home),
                      title: Text(context.l10n.app_drawer_homepage),
                      onTap: () => navigateToRoute(const HomeRoute()),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(context.l10n.app_drawer_homepage),
                      onTap: () => navigateToRoute(const SettingsRoute()),
                    ),
                    // ListTile(
                    //   leading: const Icon(Icons.dashboard),
                    //   title: const Text('Dashboard'),
                    //   onTap: () => navigateToRoute(const DashboardRoute()),
                    // ),
                    // ListTile(
                    //   leading: const Icon(Icons.warehouse),
                    //   title: const Text('Artikel'),
                    //   onTap: () => navigateToRoute(const ProductsOverviewRoute()),
                    // ),
                    // ListTile(
                    //   leading: const Icon(Icons.person),
                    //   title: const Text('Kunden'),
                    //   onTap: () => navigateToRoute(const CustomersOverviewRoute()),
                    // ),
                    // ExpansionTile(
                    //   title: const Text('Einkauf / Buchhaltung'),
                    //   leading: const Icon(Icons.account_balance),
                    //   childrenPadding: const EdgeInsets.only(left: 20),
                    //   children: [
                    //     ListTile(
                    //       leading: const Icon(Icons.person_4_outlined),
                    //       title: const Text('Lieferanten'),
                    //       onTap: () => navigateToRoute(const SuppliersOverviewRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.dashboard_customize_rounded),
                    //       title: const Text('Bestellungen'),
                    //       onTap: () => navigateToRoute(const ReordersOverviewRoute()),
                    //     ),
                    //   ],
                    // ),
                    // ExpansionTile(
                    //   title: const Text('Lager'),
                    //   leading: const Icon(Icons.warehouse),
                    //   childrenPadding: const EdgeInsets.only(left: 20),
                    //   children: [
                    //     ListTile(
                    //       leading: const Icon(Icons.subdirectory_arrow_right),
                    //       title: const Text('Warenausgang'),
                    //       onTap: () {}, // => navigateToRoute(const HomeRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.subdirectory_arrow_left),
                    //       title: const Text('Wareneingang'),
                    //       onTap: () => navigateToRoute(const ProductsBookingRoute()),
                    //     ),
                    //   ],
                    // ),
                    // ListTile(
                    //   leading: const Icon(Icons.delivery_dining),
                    //   title: const Text('Packstation'),
                    //   onTap: () => navigateToRoute(const PackingStationOverviewRoute()),
                    // ),
                    // ListTile(
                    //   leading: const Icon(Icons.shopping_cart),
                    //   title: const Text('POS'),
                    //   onTap: () => navigateToRoute(const PosOverviewRoute()),
                    // ),
                    // ExpansionTile(
                    //   title: const Text('Dokumente'),
                    //   leading: const Icon(Icons.receipt),
                    //   childrenPadding: const EdgeInsets.only(left: 20),
                    //   children: [
                    //     ListTile(
                    //       leading: const Icon(Icons.receipt),
                    //       title: const Text('Angebote'),
                    //       onTap: () => navigateToRoute(OffersOverviewRoute(receiptTyp: ReceiptType.offer)),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.receipt),
                    //       title: const Text('Aufträge'),
                    //       onTap: () => navigateToRoute(AppointmentsOverviewRoute(receiptTyp: ReceiptType.appointment)),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.receipt),
                    //       title: const Text('Lieferscheine'),
                    //       onTap: () => navigateToRoute(DeliveryNotesOverviewRoute(receiptTyp: ReceiptType.deliveryNote)),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.receipt),
                    //       title: const Text('Rechnungen'),
                    //       onTap: () => navigateToRoute(InvoicesOverviewRoute(receiptTyp: ReceiptType.invoice)),
                    //     ),
                    //   ],
                    // ),
                    // ListTile(
                    //   leading: const Icon(Icons.send),
                    //   title: const Text('Versandlabel'),
                    //   onTap: () => navigateToRoute(const ShippingLabelRoute()),
                    // ),
                    // ExpansionTile(
                    //   leading: const Icon(Icons.maps_home_work_rounded),
                    //   title: const Text('E-Commerce'),
                    //   childrenPadding: const EdgeInsets.only(left: 20),
                    //   children: [
                    //     ListTile(
                    //       leading: const Icon(Icons.import_export),
                    //       title: const Text('Artikel importieren'),
                    //       onTap: () => navigateToRoute(const ProductImportRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.import_export),
                    //       title: const Text('Artikel exportieren'),
                    //       onTap: () => navigateToRoute(const ProductExportRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.business),
                    //       title: const Text('Marktplätze'),
                    //       onTap: () => navigateToRoute(MarketplacesOverviewRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.mail),
                    //       title: const Text('E-Mail Automatisierungen'),
                    //       onTap: () => navigateToRoute(const EMailAutomationRoute()),
                    //     ),
                    //   ],
                    // ),
                    // ExpansionTile(
                    //   title: const Text('Buchhaltung'),
                    //   leading: const Icon(Icons.balance),
                    //   childrenPadding: const EdgeInsets.only(left: 20),
                    //   children: [
                    //     ListTile(
                    //       leading: const Icon(Icons.table_chart_outlined),
                    //       title: const Text('Sachkontos'),
                    //       onTap: () => navigateToRoute(const GeneralLedgerAccountRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.document_scanner),
                    //       title: const Text('Eingangsrechnungen'),
                    //       onTap: () => navigateToRoute(const IncomingInvoicesOverviewRoute()),
                    //     ),
                    //   ],
                    // ),
                    // ExpansionTile(
                    //   leading: const Icon(Icons.settings),
                    //   title: const Text('Einstellungen'),
                    //   childrenPadding: const EdgeInsets.only(left: 20),
                    //   children: [
                    //     ListTile(
                    //       leading: const Icon(Icons.percent),
                    //       title: const Text('Steuerregeln'),
                    //       onTap: () => navigateToRoute(const TaxRulesRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.payment),
                    //       title: const Text('Zahlungsarten'),
                    //       onTap: () => navigateToRoute(const PaymentMethodRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.local_shipping_outlined),
                    //       title: const Text('Versanddienstleister'),
                    //       onTap: () => navigateToRoute(const CarriersOverviewRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.archive),
                    //       title: const Text('Verpackungskartons'),
                    //       onTap: () => navigateToRoute(const PackagingBoxesRoute()),
                    //     ),
                    //     ListTile(
                    //       leading: const Icon(Icons.settings),
                    //       title: const Text('Grundeinstellungen'),
                    //       onTap: () => navigateToRoute(const MainSettingsRoute()),
                    //     ),
                    //   ],
                    // ),
                    // Gaps.h42,
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: context.colorScheme.error),
              title: const Text('Abmelden'),
              onTap: () async {
                final repo = GetIt.I<AuthRepository>();
                await repo.signOut();

                if (context.mounted) context.router.replaceAll([const SplashRoute()]);
              },
            ),
            Gaps.h16
          ],
        ),
      ),
    );
  }

  void _loadConditioner() async {
    final repo = GetIt.I<ConditionerRepository>();

    final fos = await repo.getCurConditioner();
    if (fos.isLeft()) return;

    setState(() => _conditioner = fos.getRight());
  }
}
