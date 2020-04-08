import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pkcomics/app/root_scene.dart';
import 'package:pkcomics/public.dart';

class SplashScene extends StatefulWidget {
  SplashScene({Key key}) : super(key: key);

  @override
  SplashSceneState createState() {
    return new SplashSceneState();
  }
}

class SplashSceneState extends State<SplashScene> {
  @override
  void initState() {
    super.initState();
    delayedGoHomePage();
  }

  delayedGoHomePage() {
    Future.delayed(new Duration(seconds: 2), () {
      goHomePage();
    });
  }

  goHomePage() {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (BuildContext context) => RootScene()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image : AssetImage("img/guide2.png"),
          //image: AssetImage("img/bookshelf_bg.png"),        
        ),
      ),
    );
    /*
    return Container(
      child: Image.asset(
        'img/bookshelf_bg.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
      alignment: Alignment.center,
      color: Color(0xFFFFFFFF),
    );
    */
  }

}
