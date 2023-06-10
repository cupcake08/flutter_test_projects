import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({
    super.key,
    required this.imageUrl,
    required this.id,
  });
  final String imageUrl;
  final Id id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Image View'),
      ),
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: "pet$id",
            child: CachedNetworkImage(
              imageUrl: imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
