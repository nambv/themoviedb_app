import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieDbImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool useLogo;

  const MovieDbImage(
    this.imageUrl, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.useLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    final placeHolder = Container(
      color: Colors.grey,
      width: width,
      height: height,
    );

    if (!_isValidUrl(imageUrl)) {
      return placeHolder;
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) => placeHolder,
      errorWidget: (context, url, error) {
        return placeHolder;
      },
    );
  }

  bool _isValidUrl(String input) {
    if (input.isNotEmpty == true) {
      return Uri.parse(input).host.isNotEmpty;
    } else {
      return false;
    }
  }
}
