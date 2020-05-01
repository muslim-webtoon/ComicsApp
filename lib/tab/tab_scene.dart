import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';

import 'package:pkcomics/tab/tab_one.dart';
import 'package:pkcomics/tab/tab_two.dart';
import 'package:pkcomics/tab/tab_three.dart';
import 'package:pkcomics/tab/tab_four.dart';

import 'package:pkcomics/generated/i18n.dart';

class TabScene extends StatefulWidget {

  TabScene();

  @override
  State<StatefulWidget> createState() => TabSceneState();
}

class TabSceneState extends State<TabScene> 
    with SingleTickerProviderStateMixin {
  ComicRanking comicRanking;
  ComicLatest comicLatest;
  ComicWeekly comicWeekly;
  ComicGenre comicGenre;

  bool _comicWeeklyReady = false;
  bool _comicGenreReady = false;
  bool _comicRankingReady = false;
  bool _comicLatestReady = false;

  int _currentIndex = 0;

  TabController _tabController;

  List<Widget> tabList = [];

  var titleList = ['Weekly', 'Genres', 'Ranking', 'Latest'];

  @override
  void initState() {
    super.initState();

    fetchWeeklyData();
    fetchGenreData();
    fetchRankingData();
    fetchLatestData();

    tabList = _getTabList();
    _tabController = TabController(
        vsync: this, initialIndex: _currentIndex, length: tabList.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<void> fetchWeeklyData() async {
    try {
      var responseJson = await Request.get(url: 'comic_weekly');
      comicWeekly = ComicWeekly.fromJson(responseJson);
      setState(() {
        _comicWeeklyReady = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchGenreData() async {
    try {
      var responseJson = await Request.get(url: 'comic_genre');
      comicGenre = ComicGenre.fromJson(responseJson);
      setState(() {
        _comicGenreReady = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchRankingData() async {
    try {
      var responseJson = await Request.get(url: 'comic_ranking');
      comicRanking = ComicRanking.fromJson(responseJson);
      setState(() {
        _comicRankingReady = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchLatestData() async {
    try {
      var responseJson = await Request.get(url: 'comic_latest');
      comicLatest = ComicLatest.fromJson(responseJson);
      setState(() {
        _comicLatestReady = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> _getTabList() {
    return titleList
        .map((item) => Text(
              '$item',
            ))
        .toList();
  }

  Widget _buildTabBar() {
    return TabBar(
        tabs: tabList,
        controller: _tabController,
        labelPadding: EdgeInsets.symmetric(horizontal: 18),
        isScrollable: true,
        indicatorColor: AppColor.primary,
        labelColor: AppColor.primary,
        labelStyle: TextStyle(
            fontSize: 18,
            color: AppColor.primary,
            fontWeight: FontWeight.w500),
        unselectedLabelColor: Colors.black,
        unselectedLabelStyle:
            TextStyle(fontSize: 14, color: Colors.black),
        indicatorSize: TabBarIndicatorSize.label);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: DefaultTabController(
        length: titleList.length,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            title: Container(
                height: 40,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: _buildTabBar()),
            backgroundColor: AppColor.white,
            elevation: 0,
          ),
          body: TabBarView(
            children: [
              ComicTabOne(comicWeekly),
              ComicTabTwo(comicGenre),
              ComicTabThree(comicRanking),
              ComicTabFour(comicLatest),
            ],
            controller: _tabController,
          ),
        ),
      ),
    );
  }
}