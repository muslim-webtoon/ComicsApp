import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';

import 'ranking_cell.dart';

class ComicTabThree extends StatelessWidget {
  final ComicRanking comicRanking;

  ComicTabThree(this.comicRanking);

  @override
  Widget build(BuildContext context) {
    if (comicRanking == null ||
        CollectionsUtils.isEmpty(comicRanking.rankingList)) {
      return Container();
    }
    var items = comicRanking.rankingList;
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Text(comicRanking.updateTime),
      ),
    ];
    for (var i =0; i < items.length; i++) {
      var item = items[i];
      children.add(RankingCell(item));
      children.add(Divider(height: 1));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children),
    );

  }

}
