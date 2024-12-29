import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../3_domain/models/models.dart';
import 'template_services_overview_screen.dart';

@RoutePage()
class TSVehicleSizesOverviewScreen extends StatelessWidget {
  const TSVehicleSizesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateServicesOverviewScreen(templateServiceType: TemplateServiceType.vehicleSize.name);
  }
}
