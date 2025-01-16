import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyReorderableListView extends StatelessWidget {
  final int itemCount;
  final void Function(int, int) onReorder;
  final Widget Function(BuildContext, int) itemBuilder;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  const MyReorderableListView({
    required this.itemCount,
    required this.onReorder,
    required this.itemBuilder,
    this.padding,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: !kIsWeb,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      proxyDecorator: (child, index, animation) => Material(
        elevation: 8,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
      itemCount: itemCount,
      onReorder: onReorder,
      itemBuilder: itemBuilder,
    );
  }
}

class MyReorderableItem extends StatelessWidget {
  final Widget child;
  final int index;

  const MyReorderableItem({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ReorderableDragStartListener(
        key: key,
        index: index,
        child: child,
      );
    }

    return child;
  }
}
