import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '/core/core.dart';

@RoutePage()
class MyPhotoScreen extends StatelessWidget {
  final List<String> urls;
  final int initialIndex;

  const MyPhotoScreen({required this.urls, this.initialIndex = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: PhotoView(
                imageProvider: NetworkImage(urls.first),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton.filled(onPressed: () => context.pop(), icon: const Icon(Icons.close)),
            )
          ],
        ),
      ),
    );
  }
}
