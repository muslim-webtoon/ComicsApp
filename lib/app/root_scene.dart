import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pkcomics/public.dart';

import 'package:pkcomics/home/home_scene.dart';
import 'package:pkcomics/tab/tab_scene.dart';
import 'package:pkcomics/me/me_scene.dart';

import 'package:pkcomics/widget/loading_indicator.dart';
import 'package:pkcomics/services/authentication.dart';

import 'package:connectivity/connectivity.dart';

class RootScene extends StatefulWidget {  
  @override
  State<StatefulWidget> createState() => RootSceneState();
}

class RootSceneState extends State<RootScene> {
  int _tabIndex = 0;
  bool isFinishSetup = false;
  PageState pageState = PageState.Loading;
  List<Image> _tabImages = [
    Image.asset('img/tab_comic_home_n.png'),
    Image.asset('img/tab_book_home_n.png'),
    Image.asset('img/tab_mine_n.png'),
  ];
  List<Image> _tabSelectedImages = [
    Image.asset('img/tab_home_comic_p.png'),
    Image.asset('img/tab_book_home_p.png'),
    Image.asset('img/tab_mine_p.png'),
  ];

  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();    
    setupApp();

  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();        
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        if (deepLink != null) {
          Navigator.pushNamed(context, deepLink.path);
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
  }

  setupApp() async {
    preferences = await SharedPreferences.getInstance();

    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        setState(() {
          isFinishSetup = true;
        }); 
      } else {
        Toast.show('You are not connected to Internet. Please try again after establishing an Internet connection.');
      }
    });
    /*
    await Future.delayed(Duration(milliseconds: 2000), () {
      pageState = PageState.Content;
    });
    setState(() {
      isFinishSetup = true;
    });
    */
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Quit'),
        content: new Text('Confirm exit app?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Cancle'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    /*
    if (!isFinishSetup) {
      return LoadingIndicator(
        pageState,
      );
    }
    */
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          children: <Widget>[
            HomeScene(),
            TabScene(),
            MeScene(auth: new Auth()),
          ],
          index: _tabIndex,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          activeColor: AppColor.primary,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: getTabIcon(0)),
            BottomNavigationBarItem(icon: getTabIcon(1)),
            BottomNavigationBarItem(icon: getTabIcon(2)),
          ],
          currentIndex: _tabIndex,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
      )
    );

  }

  Image getTabIcon(int index) {
    if (index == _tabIndex) {
      return _tabSelectedImages[index];
    } else {
      return _tabImages[index];
    }
  }
  /*
  void _showDialog() { 
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) { 
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
          ),
          title: new Text("No Internet Connection Detected"),
          content: SingleChildScrollView(child:new Text("A connection to the Internet is required.\nPlease try again after establishing an Internet connection.")),
          actions: <Widget>[ 
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  */

}