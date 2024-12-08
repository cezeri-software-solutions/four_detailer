import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/core/core.dart';
import '../../../../routes/router.gr.dart';
import '../../../3_domain/models/models.dart';

class MyImageButtons extends StatelessWidget {
  final String? imageUrl;
  final void Function(MyImageSource) onPickImage;
  final VoidCallback onRemoveImage;

  const MyImageButtons({
    super.key,
    required this.imageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imageUrl != null && imageUrl!.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.router.push(MyPhotoRoute(urls: [imageUrl!])),
              icon: const Icon(Icons.open_in_full_rounded),
              label: Text(context.l10n.my_image_source_display),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _showSelectImageSourceSheet(context, onPickImage),
            icon: const Icon(Icons.image_search),
            label: Text(context.l10n.my_image_source_edit),
          ),
        ),
        if (imageUrl != null && imageUrl!.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => showMyDialogDelete(context: context, content: context.l10n.my_image_source_delete, onConfirm: onRemoveImage),
              icon: const Icon(Icons.image_not_supported),
              label: Text(context.l10n.conditioner_detail_deleteProfileImage),
              style: TextButton.styleFrom(iconColor: context.colorScheme.error, foregroundColor: context.colorScheme.error),
            ),
          ),
      ],
    );
  }
}

Future<void> _showSelectImageSourceSheet(BuildContext context, void Function(MyImageSource) onPickImage) async {
  WoltModalSheet.show<MyImageSource>(
    context: context,
    barrierDismissible: true,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        hasTopBarLayer: false,
        child: _SelectImageSource(onPickImage: onPickImage),
      ),
    ],
  );
}

class _SelectImageSource extends StatelessWidget {
  final void Function(MyImageSource) onPickImage;

  const _SelectImageSource({required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt_outlined, color: context.colorScheme.primary),
            title: Text(context.l10n.my_image_source_camera),
            onTap: () => onPickImage(MyImageSource.camera),
          ),
          ListTile(
            leading: Icon(Icons.image_search, color: context.colorScheme.primary),
            title: Text(context.l10n.my_image_source_gallery),
            onTap: () => onPickImage(MyImageSource.gallery),
          ),
          ListTile(
            leading: Icon(Icons.file_copy_outlined, color: context.colorScheme.primary),
            title: Text(context.l10n.my_image_source_file),
            onTap: () => onPickImage(MyImageSource.file),
          ),
        ],
      ),
    );
  }
}
