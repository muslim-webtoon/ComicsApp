import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pkcomics/home/home_three_grid_view.dart';
import 'package:pkcomics/home/home_update_today_view.dart';
import 'package:pkcomics/public.dart';

import 'package:pkcomics/home/home_banner.dart';
import 'package:pkcomics/home/home_recommend_everyday_view.dart';
import 'package:pkcomics/widget/loading_indicator.dart';

import 'package:pkcomics/generated/i18n.dart';

import 'package:geolocation/geolocation.dart';

class HomeScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomeScene> with AutomaticKeepAliveClientMixin {
  List<String> banner = [];

  List<ComicItem> blockList = [];

  List<RecommendEveryDay> recommendEveryDayList = [];

  UpdateToday updateToday;


  ScrollController scrollController = ScrollController();
  double navAlpha = 0;

  bool isDataReady = false;

  PageState pageState = PageState.Loading;

  @override
  void initState() {
    super.initState();

    // If Geolocation is unable to get location in emulator, uncomment this and then restart the program.
    // This tends to fix the error and you can see if the GPS is actually getting the location.
    var x = Geolocation.locationUpdates(
        accuracy: LocationAccuracy.best, inBackground: false);
    x.listen((d) => print(d.isSuccessful));

    fetchData();
    scrollController.addListener(() {
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
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> fetchData() async {
    try {
      await Future.delayed(Duration(milliseconds: 2000), () {
        pageState = PageState.Content;
      });

      var responseJson = await Request.get(url: 'home_comic');
      banner.clear();
      responseJson["banner"].forEach((data) {
        banner.add(data);
      });
      blockList.clear();
      responseJson["blockList"].forEach((data) {
        blockList.add(ComicItem.fromJson(data));
      });
      recommendEveryDayList.clear();
      responseJson["recommendEveryDayList"].forEach((data) {
        recommendEveryDayList.add(RecommendEveryDay.fromJson(data));
      });
      updateToday =
          UpdateToday.fromJson(responseJson["updateToday"]);
      
      setState(() {
        isDataReady = true;
      });
    } catch (e) {
      print(e.toString());
      Toast.show(e.toString());
    }
  }

  _retry() {
    pageState = PageState.Loading;
    setState(() {});
    fetchData();
  }

  Widget menu(BuildContext context) {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            //color: Colors.green.shade100,
            color: AppColor.golden,
          ),
          accountEmail: Text("example@email.com"),
          accountName: Text("Here4You"), 
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('img/placeholder_avatar.png'),
          ),
        ),
        ListTile(
          leading: Icon(Icons.inbox),
          title: Text("Inbox"),
          trailing: Chip(
            label: Text("11", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.blue.shade100,
          ),
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Draft"),
        ),
        ListTile(
          leading: Icon(Icons.archive),
          title: Text("Archive"),
        ),
        ListTile(
          leading: Icon(Icons.account_balance_wallet),
          title: Text("Coin"),
          onTap: () {
            AppNavigator.pushCoin(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.send),
          title: Text("Sent"),
        ),
        Divider(),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings")
            )
          )
        )
      ],
    );
  }

  Widget buildModule(BuildContext context, int index) {
    Widget widget;
    switch (index) {
      case 0:
        widget = HomeBanner(banner);
        break;
      case 1:
        widget = HomeThreeGridView(blockList, 'Recently', 'recent');
        break;
      case 2:
        widget = HomeRecommendEveryDayView(recommendEveryDayList);
        break;
      case 3:
        widget = HomeUpdateTodayView(updateToday);
        break;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    if (blockList == null || blockList.length == 0) {
      return LoadingIndicator(
        pageState,
        retry: _retry,
      );
    }
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
                I18n.of(context).appname,
                style: TextStyle(color: AppColor.white),
              )),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchBarDelegate());
              //Todo
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              print("This is a notifiction");
            },
          ),
        ],
        backgroundColor: AppColor.golden,
        elevation: 0,
      ),
      drawer: Drawer(
        child: menu(context),
      ),
      body: Stack(children: [
        RefreshIndicator(
          onRefresh: fetchData,
          color: AppColor.primary,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 0),
            controller: scrollController,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return buildModule(context, index);
            },
          ),
        )
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

