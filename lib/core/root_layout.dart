import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

import 'app_drawer.dart';

class RootLayout extends StatelessWidget {
  final Widget child;
  final double breakpoint;

  const RootLayout({
    super.key,
    required this.child,
    this.breakpoint = 800,
  });

  @override
  Widget build(BuildContext context) {
    final customBreakpoint = Breakpoint(beginWidth: breakpoint);

    return AdaptiveLayout(
      primaryNavigation: SlotLayout(
        config: {
          customBreakpoint: SlotLayout.from(
            key: const Key('Primary Navigation'),
            builder: (_) => const Material(
              elevation: 1,
              child: SizedBox(
                width: 280,
                child: AppDrawer(isPersistent: true),
              ),
            ),
          ),
        },
      ),
      body: SlotLayout(
        config: {
          Breakpoints.standard: SlotLayout.from(
            key: const Key('Body'),
            builder: (_) => child,
          ),
        },
      ),
    );
  }
}
