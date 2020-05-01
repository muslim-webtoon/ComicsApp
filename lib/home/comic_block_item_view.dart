import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';
import 'package:badges/badges.dart';

class ComicBlockItemView extends StatelessWidget {
  final ComicItem comicItem;
  final Color bgColor;
  final String update;

  ComicBlockItemView(this.comicItem, this.bgColor, this.update);

  @override
  Widget build(BuildContext context) {
    var width = (Screen.width - 15 * 2 - 15 * 2) / 3;
    return GestureDetector(
      onTap: () {
        AppNavigator.pushComicDetail(context, comicItem.id);
      },
      child: Container(
        color: bgColor,
        width: width,
        child: Column(
          children: <Widget>[
            Badge(
              badgeColor: Colors.orange,
              badgeContent: 
                Text(update, style: TextStyle(color: Colors.white)),
              child: ComicCoverImage(comicItem.cover,
                width: width, height: width / 0.75),
            ),
            Text(
              comicItem.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
              maxLines: 1,
            ),
            Text(
              comicItem.author,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  color: AppColor.gray,
                  decoration: TextDecoration.none),
              maxLines: 1,
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
