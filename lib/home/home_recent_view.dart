import 'package:flutter/material.dart';

import 'package:pkcomics/public.dart';

class HomeRecentView extends StatelessWidget {
  final ComicItem comic;

  HomeRecentView(this.comic);


  @override
  Widget build(BuildContext context) {
    // three in a row
    var width = (Screen.width - 15 * 4) / 3;

    return GestureDetector(
      onTap: () {
        AppNavigator.pushComicDetail(context, comic.id);
      },
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ComicCoverImage(comic.cover, width: width, height: width / 0.75,),
            SizedBox(height: 5,),
            Text(
              comic.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            Text(
              comic.author,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  color: AppColor.gray,
                  decoration: TextDecoration.none),
              maxLines: 1,
            ),
            SizedBox(height: 3,),
          ],
        ),
      ),
    );
  }
}