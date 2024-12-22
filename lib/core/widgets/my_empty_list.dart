import 'package:flutter/widgets.dart';

import '/core/core.dart';
import '../../constants.dart';

class MyEmptyList extends StatelessWidget {
  final String title;

  const MyEmptyList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('[ ]', style: context.textTheme.displayLarge),
        Gaps.h12,
        Text(title),
      ],
    );
  }
}
