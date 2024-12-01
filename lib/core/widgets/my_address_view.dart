import 'package:flutter/widgets.dart';

import '../../3_domain/models/models.dart';
import '../../constants.dart';
import '../core.dart';

class MyAddressView extends StatelessWidget {
  final Address address;

  const MyAddressView({required this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.street),
        Text.rich(TextSpan(children: [
          TextSpan(text: address.postalCode),
          const TextSpan(text: ' '),
          TextSpan(text: address.city),
          if (address.state.isNotEmpty) ...[
            const TextSpan(text: ' '),
            const TextSpan(text: '('),
            TextSpan(text: address.state),
            const TextSpan(text: ')'),
          ]
        ])),
        Row(
          children: [
            MyCountryFlag(country: address.country, size: 14),
            Gaps.w8,
            Text(address.country.name),
          ],
        ),
      ],
    );
  }
}
