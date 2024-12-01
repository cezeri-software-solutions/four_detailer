import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/core/core.dart';
import '../../routes/router.gr.dart';

class MyAvatar extends StatelessWidget {
  final String name;
  final double? radius;
  final String? imageUrl;
  final File? file;
  final Uint8List? imageBytes;
  final double? fontSize;
  // Wenn der User erst geladen werden muss aus welchen Gründen auch immer
  final bool? isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final BoxFit? fit;
  final BoxShape? shape;
  final Color? borderColor;

  const MyAvatar({
    super.key,
    required this.name,
    this.radius = 25,
    this.imageUrl,
    this.file,
    this.imageBytes,
    this.fontSize = 18,
    this.isLoading,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.circle,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading != null && isLoading!) {
      return _MyCircularAvatarOnLoading(radius: radius!, onTap: onTap, onDoubleTap: onDoubleTap, onLongPress: onLongPress);
    }

    if (file != null) return _MyCircularFileImage(radius: radius!, file: file!, onTap: onTap, onDoubleTap: onDoubleTap, onLongPress: onLongPress);

    if (imageBytes != null) {
      return _MyCircularImageBytes(
        radius: radius!,
        imageBytes: imageBytes!,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
      );
    }

    if (imageUrl == null || imageUrl == '') {
      return _MyCircularAvatarInitials(
        name: name,
        radius: radius!,
        fontSize: fontSize!,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
      );
    }

    return InkWell(
      onTap: onTap ?? () => context.router.push(MyPhotoRoute(urls: [imageUrl!], initialIndex: 0)),
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => Container(
          width: shape == BoxShape.rectangle ? null : radius! * 2,
          height: radius! * 2,
          decoration: BoxDecoration(
            shape: shape!,
            border: Border.all(color: borderColor!),
            image: DecorationImage(image: imageProvider, fit: fit),
          ),
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),
        errorWidget: (context, url, error) {
          return _MyCircularAvatarInitials(
            name: name,
            radius: radius!,
            fontSize: fontSize!,
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
          );
        },
      ),
    );
  }
}

class _MyCircularAvatarInitials extends StatelessWidget {
  final String name;
  final double radius;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const _MyCircularAvatarInitials({
    required this.name,
    required this.radius,
    required this.fontSize,
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: context.colorScheme.secondaryContainer,
        child: Text(
          name.length > 3 ? _getInitials(name) : name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: Colors.white),
        ),
      ),
    );
  }

  String _getInitials(String name) => name.split(' ').where((str) => str.isNotEmpty).take(2).map((str) => str[0].toUpperCase()).join(' ');
}

class _MyCircularAvatarOnLoading extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const _MyCircularAvatarOnLoading({required this.radius, required this.onTap, required this.onDoubleTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: CircleAvatar(radius: radius, backgroundColor: Colors.grey, child: const CircularProgressIndicator.adaptive()),
    );
  }
}

class _MyCircularFileImage extends StatelessWidget {
  final double radius;
  final File file;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const _MyCircularFileImage({required this.radius, required this.file, required this.onTap, required this.onDoubleTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: CircleAvatar(radius: radius, backgroundImage: FileImage(file)),
    );
  }
}

class _MyCircularImageBytes extends StatelessWidget {
  final double radius;
  final Uint8List imageBytes;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const _MyCircularImageBytes(
      {required this.radius, required this.imageBytes, required this.onTap, required this.onDoubleTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: CircleAvatar(radius: radius, backgroundImage: MemoryImage(imageBytes)),
    );
  }
}
