import 'package:flutter/material.dart';

import 'package:pkcomics/public.dart';

class RankingCell extends StatelessWidget {
  final item;

  RankingCell(this.item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.pushComicDetail(context, item.id);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ComicCoverImage(item.cover,
                width: 70, height: 93),
            SizedBox(width: 15),
            Expanded(
              child: buildRight(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          item.title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          item.author,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: AppColor.gray,
          ),
        ),
        SizedBox(height: 5),
        /*
        Row(
          children: <Widget>[
            Text(
              't',
              style: TextStyle(fontSize: 14, color: AppColor.gray),
            ),
            Expanded(child: Container()),
            buildTag(novel.status, novel.statusColor()),
            SizedBox(width: 5),
            buildTag(novel.type, TYColor.gray),
          ],
        )
        */
      ],
    );
  }

  Widget buildTag(String title, Color color) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 2, 5, 3),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(99, color.red, color.green, color.blue), width: 0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 11, color: color),
      ),
    );
  }
}
