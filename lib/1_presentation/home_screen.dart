import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
