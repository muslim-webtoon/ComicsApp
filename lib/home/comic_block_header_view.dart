import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pkcomics/public.dart';


class ComicBlockHeaderView extends StatelessWidget {
  final String titleName;

  ComicBlockHeaderView(this.titleName);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
      child: buildHeader(context),
    );
  }

  Widget buildHeader(context) {
    Widget widget;
    var width = Screen.width;
    switch (titleName) {
      case Constant.comicBlock:
        widget = Row(
          children: <Widget>[
            Text(
              "Recently Read",
              style: TextStyle(fontSize: 20, color: AppColor.darkGray),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                //AppNavigator.push(context, ComicRecentView());
                //AppNavigator.pushMovieList(context, title, action);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "More",
                    style: TextStyle(fontSize: 15, color: AppColor.gray),
                  ),
                  SizedBox(width: 10),
                  Image.asset('img/arrow_right.png'),
                  SizedBox(width: 20),
                ],
              )
            ),
          ],
        );
        break;
      case Constant.recommendEveryDay:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Ranking',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 80,
                  height: 2,
                  color: Colors.black,
                )
              ],
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                AppNavigator.pushComicTopList(context, "Ranking", 'ranking',);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('More',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                  SizedBox(width: 3,),
                  Icon(CupertinoIcons.forward, size: 14,),
                  SizedBox(width: 20),
                ],
              )
            )
          ],
        );
        break;
      case Constant.updateToday:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Daily',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5,),
                Container(
                  width: 80,
                  height: 2,
                  color: Colors.black,
                )
              ],
            ),
            Expanded(child: Container()),
          ],
        );
        break;
    }
    return widget;
  }
}
