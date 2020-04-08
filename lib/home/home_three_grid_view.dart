import 'package:flutter/material.dart';
import 'package:pkcomics/home/home_recent_view.dart';
import 'package:pkcomics/home/home_section_view.dart';
import 'package:pkcomics/public.dart';

class HomeThreeGridView extends StatelessWidget {
  final List<ComicItem> comics;
  final String title;
  final String action;

  HomeThreeGridView(this.comics, this.title, this.action);

  @override
  Widget build(BuildContext context) {

    var children = comics.map((comic) => 
        HomeRecentView(comic)).toList();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HomeSectionView(title,action),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
            child: Wrap(spacing: 15, runSpacing: 20, children: children,),
          ),
          Container(
            height: 10,
            color: Color(0xFFF5F5F5),
          )
        ],
      ),
    );
  }
}