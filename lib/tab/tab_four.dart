import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';

class ComicTabFour extends StatelessWidget {
  final ComicLatest comicLatest;

  ComicTabFour(this.comicLatest);

  Widget buildLatestItem(BuildContext context, item) {
    var width = (Screen.width - 10 * 2) / 2;
    return GestureDetector(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: AppColor.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  item.cover, 
                  fit: BoxFit.cover,
                  width: width,
                  height: width/1.5,
                ),
                SizedBox(height: 4),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.face,
                        color: AppColor.gray,
                        size: 14.0,
                      ),
                      Text(
                        item.author,
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColor.gray,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ],
            ))),
      onTap: () {
        AppNavigator.pushComicDetail(context, item.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (comicLatest == null ||
        CollectionsUtils.isEmpty(comicLatest.latestList)) {
      return Container();
    }
    var children = comicLatest.latestList
        .map((comicItem) => buildLatestItem(context, comicItem)).toList();
    
    return GridView(
      padding: EdgeInsets.fromLTRB(10, Screen.topSafeHeight, 10, 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.03,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10),
      children: children,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
    );
  }
}