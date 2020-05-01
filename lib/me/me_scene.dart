import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pkcomics/public.dart';

import 'package:pkcomics/me/me_cell.dart';
import 'package:pkcomics/services/authentication.dart';

import 'package:package_info/package_info.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class MeScene extends StatefulWidget {
  MeScene({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _MeSceneState();
}

class _MeSceneState extends State<MeScene> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  bool visibilityLogout = false;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    return version;
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "logout"){
        visibilityLogout = visibility;
      }
    });
  }

  _openGithub() {
    AppNavigator.push(context, WebViewScene(url: 'https://github.com/',title: 'Github',));
  }

  _copyText() {
    Clipboard.setData(ClipboardData(text:'copyText'));
    Toast.show('');
  }

  signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Widget meHeader() {
    return GestureDetector(
      onTap: () {
        //AppNavigator.pushLogin(context);
        Navigator.of(context).pushNamed('/login');
      },
      child: Container(
        color: AppColor.white,
        padding: EdgeInsets.fromLTRB(20, 30, 15, 15),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('img/placeholder_avatar.png'),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildItem('0.0', 'Balance'),
                      buildItem('0', 'Series'),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
  
  Widget buildItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: AppColor.gray),
        ),
      ],
    );
  }

  Widget buildCells(BuildContext context) {
    Screen.updateStatusBarStyle(SystemUiOverlayStyle.dark);
    return Container(
      child: Column(
        children: <Widget>[
          MeCell(
            title: 'My Library',
            iconName: 'img/me_wallet.png',
            onPressed: () {
              _openGithub();
            },
          ),
          MeCell(
            title: 'Usage Details',
            iconName: 'img/me_buy.png',
            onPressed: () {
              _copyText();
            },
          ),
          MeCell(
            title: 'Coupon Box',
            iconName: 'img/me_vip.png',
            onPressed: () {
              _copyText();
            },
          ),
          MeCell(
            title: 'Open Source License',
            iconName: 'img/me_coupon.png',
            onPressed: () {
              AppNavigator.popupOpenSourceInfo(context);
            },
          ),
          MeCell(
            title: 'Language',
            iconName: 'img/me_setting.png',
            onPressed: () {
              AppNavigator.popupLanguage(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(color: AppColor.white),
        preferredSize:  Size(Screen.width, 0),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            meHeader(),
            SizedBox(height: 10),
            buildCells(context),
            SizedBox(height: 50),
            Visibility(
              child: FlatButton(
                onPressed: signOut,
                child: Text(
                  'Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.black)),
              ),
              visible: visibilityLogout,
            ),
            ListTile(
              enabled: false,
              title: Text("Version"),
              trailing: FutureBuilder(
                future: getVersionNumber(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                    Text(
                  snapshot.hasData ? snapshot.data : "Loading ...",
                  style: TextStyle(color: Colors.black38),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );

  }
}

  