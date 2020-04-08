import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pkcomics/app/app_color.dart';
import 'package:photo_view/photo_view.dart';

class ComicCoverImage extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  final BoxFit fit;

  ComicCoverImage(this.imgUrl, {this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: (context, url) =>
          SizedBox(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(AppColor.golden),
              strokeWidth: 5.0
            ),
            height: 30.0,
            width: 30.0,
          ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: fit == null ? BoxFit.cover : fit,
        width: width,
        height: height,
      ),
      decoration: BoxDecoration(border: Border.all(color: AppColor.paper, width: 0.1)),
    );
  }
}
