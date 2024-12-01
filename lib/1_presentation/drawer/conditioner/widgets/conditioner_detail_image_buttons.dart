import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/core/core.dart';
import '../../../../2_application/conditioner/conditioner_bloc.dart';
import '../../../../3_domain/models/models.dart';
import '../../../../routes/router.gr.dart';

class ConditionerDetailImageButtons extends StatelessWidget {
  final ConditionerBloc bloc;
  final Conditioner conditioner;

  const ConditionerDetailImageButtons({super.key, required this.bloc, required this.conditioner});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (conditioner.imageUrl.isNotEmpty)
          TextButton.icon(
            onPressed: () => context.router.push(MyPhotoRoute(urls: [conditioner.imageUrl])),
            icon: const Icon(Icons.open_in_full_rounded),
            label:  Text(context.l10n.conditioner_detail_showProfile),
          ),
        Row(
          children: [
            IconButton(
                onPressed: () => bloc.add(AddEditImageEvent(context: context, source: ImageSource.camera)),
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: context.colorScheme.primary,
                )),
            IconButton(
                onPressed: () => bloc.add(AddEditImageEvent(context: context, source: ImageSource.gallery)),
                icon: Icon(
                  Icons.image_search,
                  color: context.colorScheme.primary,
                )),
            Text(
              context.l10n.conditioner_detail_editProfileImage,
              style: context.textTheme.bodyMedium!.copyWith(color: context.colorScheme.primary),
            ),
          ],
        ),
        if (conditioner.imageUrl.isNotEmpty)
          TextButton.icon(
            onPressed: () {
              showMyDialogDelete(
                context: context,
                content: context.l10n.conditioner_detail_removeProfileImageMessage,
                onConfirm: () => bloc.add(RemoveImageEvent(context: context)),
              );
            },
            icon: const Icon(Icons.image_not_supported),
            label:  Text(context.l10n.conditioner_detail_deleteProfileImage),
            style: TextButton.styleFrom(
              iconColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.error,
            ),
          ),
      ],
    );
  }
}
