import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'loader.dart';

class MyNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width, height;

  const MyNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: fit,
      height: height,
      width: width,
      errorWidget: (context, url, error) {
        return Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.black,
        );
      },
      placeholder: (context, url) => Center(child: loader(color: Colors.black)),
      imageUrl: url,
    );
  }
}
