import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key, required this.imageUrl, required this.heroTag});
  final String imageUrl; final String heroTag;
  @override Widget build(BuildContext context) => CupertinoPageScaffold(
    navigationBar: const CupertinoNavigationBar(middle: Text('عرض الصورة')),
    child: SafeArea(child: Center(child: InteractiveViewer(minScale: .7, maxScale: 5, child: Hero(tag: heroTag, child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain, placeholder: (_, __) => const CupertinoActivityIndicator(), errorWidget: (_, __, ___) => const Icon(CupertinoIcons.photo, size: 64)))))));
}
