import 'package:flutter/material.dart';

import 'app_drawer.dart';

class AdaptiveLayout extends StatefulWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showDrawer;
  final double breakpoint;

  const AdaptiveLayout({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showDrawer = true,
    this.breakpoint = 800,
  });

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= widget.breakpoint;

    if (!widget.showDrawer) {
      return Scaffold(
        appBar: AppBar(
          title: widget.title != null ? Text(widget.title!) : null,
          actions: widget.actions,
        ),
        body: widget.child,
      );
    }

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            const SizedBox(
              width: 280,
              child: AppDrawer(isPersistent: true),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: widget.title != null ? Text(widget.title!) : null,
                  actions: widget.actions,
                ),
                body: widget.child,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: const AppDrawer(isPersistent: false),
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title!) : null,
        actions: widget.actions,
      ),
      body: widget.child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
