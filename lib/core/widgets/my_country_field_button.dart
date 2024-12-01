import 'package:flutter/material.dart';

import '../../3_domain/models/models.dart';
import '../../constants.dart';
import '../core.dart';

class MyCountryFieldButton extends StatefulWidget {
  final Country country;
  final void Function(Country?) onTap;

  const MyCountryFieldButton({super.key, required this.onTap, required this.country});

  @override
  State<MyCountryFieldButton> createState() => _MyCountryFieldButtonState();
}

class _MyCountryFieldButtonState extends State<MyCountryFieldButton> {
  @override
  Widget build(BuildContext context) {
    return MyFieldButton(
      onTap: () async {
        final country = await showSelectCountrySheet(context);
        widget.onTap(country);
      },
      fieldTitle: context.l10n.country,
      child: Row(
        children: [
          MyCountryFlag(country: widget.country, size: 14),
          Gaps.w8,
          Text(widget.country.name, style: context.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
