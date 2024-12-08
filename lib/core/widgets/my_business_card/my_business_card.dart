import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/core/core.dart';
import '../../../3_domain/models/models.dart';
import '../../../constants.dart';

class MyBusinessCard extends StatelessWidget {
  final bool showImageEditing;
  final MyImageButtons imageButtons;
  final MyAvatar avatar;
  final Address address;
  final String name;
  final String email;
  final List<Widget> iconButtons;

  const MyBusinessCard({
    required this.showImageEditing,
    required this.imageButtons,
    required this.avatar,
    required this.address,
    required this.name,
    required this.email,
    required this.iconButtons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.breakpoint.smallerOrEqualTo(MOBILE);

    return MyFormFieldContainer(
      padding: EdgeInsets.zero,
      borderColor: context.colorScheme.outlineVariant,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: isMobile ? 140 : 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  color: context.colorScheme.outlineVariant,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: isMobile ? 140 : 180, right: 20),
                  child: Image.asset(
                    context.brightness == Brightness.light ? 'assets/logo/logo_advertised_white.png' : 'assets/logo/logo_advertised_black.png',
                    width: 250,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 42, bottom: 20, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyAnimatedExpansionContainer(
                            isExpanded: showImageEditing,
                            child: MyImageButtons(
                              imageUrl: imageButtons.imageUrl,
                              onPickImage: imageButtons.onPickImage,
                              onRemoveImage: imageButtons.onRemoveImage,
                            ),
                          ),
                          Gaps.h12,
                          Text(name, style: context.textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Gaps.h4,
                          Text(email, style: context.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Gaps.h24,
                          MyAddressView(address: address),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8.0), child: Column(children: iconButtons))
                ],
              ),
            ],
          ),
          Positioned(top: isMobile ? 70 : 110, left: 20, child: avatar),
        ],
      ),
    );
  }
}
