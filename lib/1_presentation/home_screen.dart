import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
      appBar: AppBar(),
      body: Center(child: Text('Home Screen: width: ${width.toString()}')),
    );
  }
}
