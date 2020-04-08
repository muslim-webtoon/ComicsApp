import 'package:flutter/material.dart';
import 'package:pkcomics/home/comic_block_header_view.dart';
import 'package:pkcomics/public.dart';

class HomeUpdateTodayView extends StatelessWidget {
  final UpdateToday updateToday;

  HomeUpdateTodayView(this.updateToday);

  @override
  Widget build(BuildContext context) {
    if (updateToday == null) {
      return Container();
    }
    var width = Screen.width;
    var height = width / 2;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          ComicBlockHeaderView(Constant.updateToday),
          SizedBox(height: 5),
          Container(
            color: AppColor.white,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: GestureDetector(
              onTap: () {
                AppNavigator.pushComicDetail(context, updateToday.id);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ComicCoverImage(
                    updateToday.cover,
                    width: width,
                    height: height,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 15),
                      Text(
                        updateToday.title,
                        style: TextStyle(fontSize: 17, fontWeight:FontWeight.w600,color: Color(0xff535252)),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(child: Container()),
                      Text(updateToday.author,
                          style:
                          TextStyle(fontSize: 14, color: Color(0xffC5C5C5))),
                      SizedBox(width: 15),
                    ],
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ),
          Container(
            height: 10,
          )
        ],
      ),
    );
  }
}
