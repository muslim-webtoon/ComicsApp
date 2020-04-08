import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkcomics/comic/comic_detail/comic_detail_info.dart';
import 'package:pkcomics/comic/comic_detail/comic_detail_scene.dart';
import 'package:pkcomics/comic/comic_list_view.dart';
import 'package:pkcomics/comic/comic_top_list_view.dart';
import 'package:pkcomics/comic/reader/reader_comment.dart';
import 'package:pkcomics/comic/reader/reader_scene.dart';
import 'package:pkcomics/me/coin_scene.dart';
import 'package:pkcomics/me/lang_view.dart';
import 'package:pkcomics/me/open_source_info.dart';
import 'package:pkcomics/public.dart';

import 'package:pkcomics/me/login_scene.dart';

class AppNavigator {
  static push(BuildContext context, Widget scene) {
    Navigator.push(
      context, 
      /*
      CupertinoPageRoute(
        builder: (BuildContext context) => scene,
      ),
      */
      MaterialPageRoute(builder: (BuildContext context) => scene),

    );
  }

  static popup(BuildContext context, Widget scene) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => scene,
      ),
    );
  }

  static pushComicDetail(BuildContext context, int id) {
    AppNavigator.push(context, ComicDetailScene(comicId: id));
  }

  static pushComicReader(BuildContext context, int id) {
    //Navigator.pushNamed(context, '/users', arguments: id);
    AppNavigator.push(context, ReaderScene());
  }

  static pushComicComment(BuildContext context, String url) {
    AppNavigator.push(context, ReaderComment());
  }

  static pushComicList(BuildContext context, String title, String action) {
    AppNavigator.push(context, ComicListView(title: title, action: action));
  }

  static pushCoin(BuildContext context) {
    AppNavigator.push(context, CoinScene());
  }

  static pushComicTopList(BuildContext context, String title, String action) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return ComicTopListView(action: action, title: title,);
    }));
  }

  static pushLogin(BuildContext context, {auth, loginCallback}) {
    AppNavigator.push(context, LoginScene(
      auth: auth,
      loginCallback: loginCallback,
    ));
  }

  static pushWeb(BuildContext context, String url, String title) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return WebViewScene(url: url, title: title);
    }));
  }


  static popupComicInfo(BuildContext context, {description, author, genre}) {
    AppNavigator.popup(context, ComicDetailInfo(description: description, author: author, genre: genre));
  }

  static popupOpenSourceInfo(BuildContext context, {description, author, genre}) {
    AppNavigator.popup(context, OpenSourceInfo());
  }

  static popupLanguage(BuildContext context) {
    AppNavigator.popup(context, LanguageView());
  }

}

