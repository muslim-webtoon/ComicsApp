import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';

class RecommendEveryDayItemView extends StatelessWidget {
  final RecommendEveryDay comicItem;

  RecommendEveryDayItemView(this.comicItem);

  @override
  Widget build(BuildContext context) {
    var itemWidth = Screen.width;
    var imgWidth = Screen.width * 0.21;
    return GestureDetector(
      onTap: () {
        AppNavigator.pushComicDetail(context, comicItem.id);
      },
      child: Container(
        color: AppColor.white,
        width: itemWidth,
        child: Row(
          children: <Widget>[
            ComicCoverImage(comicItem.cover,
                width: imgWidth, height: imgWidth * 1.32),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  comicItem.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                Text(
                  comicItem.author,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: Color(0xff969696)),
                  maxLines: 1,
                ),
                SizedBox(height: 3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new StaticRatingBar(size: 13.0,rate: comicItem.rating/2,),
                    //new StaticRatingBar(size: 13.0,rate: 5),
                    SizedBox(width: 5,),  
                    Text(comicItem.rating.toString(),style: TextStyle(color: AppColor.gray, fontSize: 12.0),)
                    //Text("5",style: TextStyle(color: AppColor.gray, fontSize: 12.0),)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}