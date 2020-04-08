import 'package:flutter/material.dart';
import 'package:pkcomics/home/comic_block_header_view.dart';
import 'package:pkcomics/home/recommend_everyday_item_view.dart';

import 'package:pkcomics/public.dart';

class HomeRecommendEveryDayView extends StatelessWidget {

  final List<RecommendEveryDay> recommendEveryDayList;

  HomeRecommendEveryDayView(this.recommendEveryDayList);

  @override
  Widget build(BuildContext context) {
    if (recommendEveryDayList == null || recommendEveryDayList.length == 0) {
      return Container();
    }
    var children = recommendEveryDayList
        .map((comicItem) => RecommendEveryDayItemView(comicItem))
        .toList();
    return Container(
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ComicBlockHeaderView(Constant.recommendEveryDay),
          Container(
            padding: new EdgeInsets.only(top: 16.0),
            child: Wrap(
                spacing: 15,
                runSpacing: 0,
                direction: Axis.vertical,
                children: children),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}