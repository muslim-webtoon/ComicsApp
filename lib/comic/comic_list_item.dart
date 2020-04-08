import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pkcomics/public.dart';

class ComicListItem extends StatelessWidget {
  final ComicItem comic;
  final String actionStr;

  const ComicListItem(this.comic, this.actionStr);

  
  @override
  Widget build(BuildContext context) {
    double imgWidth = 100;
    double height = imgWidth / 0.7;
    double spaceWidth = 15;
    double actionWidth = 60;

    return GestureDetector(
      onTap: () {
        AppNavigator.pushComicDetail(context, comic.id);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(spaceWidth, spaceWidth, 0, spaceWidth),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColor.lightGray, width: 0.5)),
            color: AppColor.white),
        child: Row(
          children: <Widget>[
            ComicCoverImage(
              comic.cover,
              width: imgWidth,
              height: height,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(spaceWidth, 0, spaceWidth, 0),
              height: height,
              width: Screen.width - imgWidth - spaceWidth * 2 - actionWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    comic.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${comic.author}',
                    style: TextStyle(color: AppColor.gray, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}
