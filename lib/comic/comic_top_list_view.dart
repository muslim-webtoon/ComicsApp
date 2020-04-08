import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'dart:async';

import 'package:pkcomics/public.dart';

import 'comic_list_item.dart';
import 'comic_top_item.dart';

class ComicTopListView extends StatefulWidget {
  final String action;
  final String title;

  const ComicTopListView({Key key, this.action, this.title})
      : super(key: key);

  @override
  _ComicTopListViewState createState() => _ComicTopListViewState();
}

class _ComicTopListViewState extends State<ComicTopListView> with RouteAware {
  List<ComicItem> topList;
  ComicRanking comicRanking;
  ScrollController scrollController = ScrollController();
  // navigation bar transparency
  double navAlpha = 0;

  // Default loading of 20 data
  int start = 0, count = 25;

  bool _loaded = false;
  bool isVisible = true;

  double coverWidth = Screen.width;
  double coverHeight = 218.0 + Screen.topSafeHeight;

  @override
  void initState() {
    super.initState();
    fetchData();

    // Monitor page scrolling to display navigation bar
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
          fetchData();
      }
      var offset = scrollController.offset;
      if (offset < 0) {
        if (navAlpha != 0) {
          setState(() {
            navAlpha = 0;
          });
        }
      } else if (offset < 50) {
        setState(() {
          navAlpha = 1 - (50 - offset) / 50;
        });
      } else if (navAlpha != 1) {
        setState(() {
          navAlpha = 1;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    // Set the status bar style again after 500 milliseconds interval.Otherwise the settings are invalid (will be overwritten by the building?)。
    Timer(Duration(milliseconds: 500), () {
      updateStatusBar();
    });
  }

  @override
  void didPopNext() {
    isVisible = true;
    updateStatusBar();
  }

  @override
  void didPop() {
    isVisible = false;
  }

  @override
  void didPushNext() {
    isVisible = false;
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    scrollController.dispose();
    super.dispose();
  }

  back() {
    Navigator.pop(context);
  }

  updateStatusBar() {
    if (navAlpha == 1) {
      Screen.updateStatusBarStyle(SystemUiOverlayStyle.dark);
    } else {
      Screen.updateStatusBarStyle(SystemUiOverlayStyle.light);
    }
  }

  Widget buildNavigationBar() {
    return Stack(
      children: <Widget>[
        Container(
          width: 44,
          height: Screen.navigationBarHeight,
          padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
          child: GestureDetector(
            onTap: back,
            child: Image.asset('img/icon_arrow_back_white.png'),
          ),
        ),
        Opacity(
          opacity: navAlpha,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.white,
            ),
            padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
            height: Screen.navigationBarHeight,
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  child: GestureDetector(
                    onTap: back,
                    child: Image.asset('img/icon_arrow_back_black.png'),
                  ),
                ),
                Expanded(
                  child: Text(
                    this.widget.title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(width: 44),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isVisible) {
      updateStatusBar();
    }

    if (this.topList == null) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: GestureDetector(
            onTap: back,
            child: Image.asset('img/icon_arrow_back_black.png'),
          ),
          ),
          body: Center(
            child: CupertinoActivityIndicator(
            ),
          ));
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 0),
                  children: <Widget>[
                    _buildHeader(),
                    _buildList(),
                  ],
                ),
              )
            ],
          ),
          buildNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildList() {
    // 排名
    int index = 1;
    List<Widget> children = [];
    for (var i = 0; i < topList.length; i++) {
      children.add(MovieTopItem(index: index++, item: ComicListItem(topList[i], this.widget.action),));
    }
    Widget loading = Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Offstage(
        offstage: _loaded,
        child: CupertinoActivityIndicator(),
      ),
    );
    children.add(loading);
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: children
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      width: coverWidth,
      height: coverHeight,
      child: Stack(
        children: <Widget>[
          /*
          Image(
            image: CachedNetworkImageProvider(movieList[0].images.large),
            fit: BoxFit.fitWidth,
            height: coverHeight,
            width: coverWidth,
          ),
          */
          Container(
              color: Color(0xbb000000), width: coverWidth, height: coverHeight),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
                width: coverWidth,
                height: coverHeight,
                padding:
                    EdgeInsets.fromLTRB(30, 54 + Screen.topSafeHeight, 10, 20),
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Top 10",
                      style: TextStyle(color: AppColor.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(this.widget.title,
                        style: TextStyle(
                            color: AppColor.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    if (_loaded) {
      return;
    }
    var data;
    String action = this.widget.action;
    switch (action) {
      case 'ranking':
        data = await Request.get(url: 'comic_ranking');
        break;
      default:
        break;
    }
    setState(() {
      if (topList == null) {
        topList = [];
      }
      comicRanking = ComicRanking.fromJson(data);
      if (comicRanking.rankingList.length == 0) {
        _loaded = true;
        return;
      }
      topList = comicRanking.rankingList;
      print(topList);
      start = start + count;
    });
  }

}
