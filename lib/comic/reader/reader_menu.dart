import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pkcomics/public.dart';

class ReaderMenu extends StatefulWidget {
  final int episodeIndex;
  final int nextId;
  final VoidCallback onTap;
  final VoidCallback onPreviousEpisode;
  final VoidCallback onNextEpisode;

  ReaderMenu({this.episodeIndex, this.nextId, this.onTap, this.onPreviousEpisode, this.onNextEpisode});

  @override
  _ReaderMenuState createState() => _ReaderMenuState();
}

class _ReaderMenuState extends State<ReaderMenu> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  double progressValue;
  bool isTipVisible = true;

  @override
  initState() {
    super.initState();

    progressValue = 0;

    animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() { });
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  hide() {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTap();
    });
    /*
    setState(() {
      isTipVisible = false;
    });
    */
  }

  previousEpisode() {
    if (this.widget.episodeIndex == 1) {
      Toast.show('No previous episode');
      return;
    }
    this.widget.onPreviousEpisode();
  }

  nextEpisode() {
    if (this.widget.nextId == 0) {
      Toast.show('No next episode');
      return;
    }
    this.widget.onNextEpisode();
  }

  buildTipView() {
    if (!isTipVisible) {
      return Container();
    }
    return Container(
      width: 120,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.0,
          )
        ],
      ),
      margin: EdgeInsets.fromLTRB(150, 200, 15, 10),
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Icon(Icons.keyboard_arrow_up),
          Icon(Icons.keyboard_arrow_down),
          Text(
            "Scroll",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16
            ),
          )
        ],
      )

      /*
      child: Center(
        child: Text(
          "Scroll",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
        ),
      ),
      */
      
    );
  }

  buildTopView(BuildContext context) {
    return Positioned(
      top: -Screen.navigationBarHeight * (1 - animation.value),
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(color: AppColor.paper, boxShadow: Styles.borderShadow),
        height: Screen.navigationBarHeight,
        padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 5, 0),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset('img/pub_back_gray.png'),
              ),
            ),
            Expanded(child: Container(
              child: new Center(
                child: new Text(
                  'Episode${this.widget.episodeIndex}', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
            Container(
              width: 44,
              child: Image.asset('img/read_icon_more.png'),
            ),
          ],
        ),
      ),
    );
  }

  buildProgressView() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoSlider(
              min: 0,
              max: 100,
              value: progressValue,
              onChanged: (double value) {
                setState(() {
                  progressValue = value;
                });
              },
              onChangeEnd: (double value) {

              },
              activeColor: AppColor.primary,
            ),
          ),
          SizedBox(height: 5),
          Text("11 / 14", style: TextStyle(fontSize: fixedFontSize(12), color: AppColor.darkGray)),
        ],
      ),
    );
  }

  buildBottomView() {
    return Positioned(
      bottom: -(Screen.bottomSafeHeight + 110) * (1 - animation.value),
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(color: AppColor.paper, boxShadow: Styles.borderShadow),
        padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
        child: Column(
          children: <Widget>[
            buildProgressView(),
            buildBottomMenus(),
          ],
        ),
      ),
    );
  }

  buildBottomMenus() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              AppNavigator.pushComicComment(context, "");
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: new Stack(
                children: <Widget>[
                  new Icon(Icons.chat),
                  new Positioned(
                    right: 0,
                    top: 0,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '9',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
              ],)
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: previousEpisode,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  Image.asset('img/read_icon_chapter_previous.png'),
                  Text(
                    "Prev",
                    style: TextStyle(fontSize: 12, color: AppColor.gray),
                  ),
                ],
              ),     
            ),
          ),
          SizedBox(width: 30),
          GestureDetector(
            onTap: nextEpisode,
            child: Container(
              padding: EdgeInsets.all(20),
              child: new Row(
                children: <Widget>[
                  Text(
                    "Next",
                    style: TextStyle(fontSize: 12, color: AppColor.gray),
                  ),
                  Image.asset('img/read_icon_chapter_next.png'),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
                Navigator.pop(context);
            },
            child: Container(
              child: Icon(Icons.list),
            ),
          ),
          
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_) {
              hide();
            },
            child: Container(color: Colors.transparent),
          ),
          buildTopView(context),
          buildTipView(),
          buildBottomView(),
        ],
      ),
    );
  }
}

