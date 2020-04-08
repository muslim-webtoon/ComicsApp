import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pkcomics/public.dart';

import 'package:pkcomics/comic/comic_list_item.dart';

class ComicListView extends StatefulWidget {

  final String title;
  final String action;

  const ComicListView({Key key, this.title, this.action}) : super(key: key);

  @override
  _ComicListViewState createState() => _ComicListViewState(title, action);
}

class _ComicListViewState extends State<ComicListView> {

  String title;
  String action;
  List<ComicItem> comicList;
  ComicLatest comicLatest;


  bool _loaded = false;

  ScrollController _scrollController = ScrollController();

  _ComicListViewState(this.title, this.action);

  @override
  void initState() { 
    super.initState();
    fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
          fetchData();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text(title),
          backgroundColor: AppColor.white,
          leading: GestureDetector(
            onTap: back,
            child: Image.asset('img/icon_arrow_back_black.png'),
          ),
          elevation: 0,
        ),
        body: _buildBody()
      );
  }

  back() {
    Navigator.pop(context);
  }

  Widget _buildBody() {
    if (comicList == null) {
      return Center(
        child: const CupertinoActivityIndicator(),
      );
    }
    return Container(
        child: ListView.builder(
          itemCount: comicList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == comicList.length) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Offstage(
                    offstage: _loaded,
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              );
            }
            return  ComicListItem(comicList[index], action);
          },
          controller: _scrollController,
        ),
      );
  }


  Future<void> fetchData() async {
    if (_loaded) {
      return;
    }
    var data;
    switch (action) {
      case 'recent':
        data = await Request.get(url: 'comic_latest');
        break;
    }

    setState(() {
      if (comicList == null) {
        comicList = [];
      }
      comicLatest = ComicLatest.fromJson(data);
      if (comicLatest.latestList.length == 0) {  
        _loaded = true;
        return;
      }
      comicList = comicLatest.latestList;
      
    });
  }


   @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}