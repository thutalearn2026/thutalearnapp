import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class TtNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const TtNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return TtShimmer(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          child: Center(
            child: Icon(
              Icons.info,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
