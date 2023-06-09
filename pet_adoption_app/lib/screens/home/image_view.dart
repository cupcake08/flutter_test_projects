import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.imageUrl, required this.index});
  final String imageUrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Image View'),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: "pet$index",
            child: CachedNetworkImage(
              imageUrl: imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
