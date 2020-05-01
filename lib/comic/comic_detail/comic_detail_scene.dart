import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:share/share.dart';

import 'package:pkcomics/public.dart';
import 'package:pkcomics/widget/loading_indicator.dart';

class ComicDetailScene extends StatefulWidget {
  
  final int comicId;

  const ComicDetailScene({Key key, this.comicId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ComicDetailState();

}

class ComicDetailState extends State<ComicDetailScene> {

  PageState pageState = PageState.Loading;

  ComicDetail detail;

  ScrollController _scrollController = ScrollController();

  bool isUnfold = false;

  bool isDataReady = false;
  bool isMarkPressed = false;
  bool isNewest = true;

  @override
  void initState() {
    super.initState();

    /*
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeOut
    );
    */
    
    Timer(Duration(milliseconds: 1000), () {
      Screen.updateStatusBarStyle(SystemUiOverlayStyle.dark);
    });
    _fetchData();
  }
  
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _fetchData() async {
    try {
      var responseJson = await Request.get(url: 'comic_detail_${this.widget.comicId}');
      detail = ComicDetail.fromJson(responseJson);
      await Future.delayed(Duration(milliseconds: 2000), () {
        pageState = PageState.Content;
      });
      setState(() {
        isDataReady = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _retry() {
    pageState = PageState.Loading;
    setState(() {});
    _fetchData();
  }

  Widget renderCount(IconData icon, String text) {
    return FlatButton.icon(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      ),
      onPressed: null,
    );
  }

  Widget episodeList() {
    var items = detail.episodeList;
    
    if(isNewest) {
      items = items.reversed.toList();
    }
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/reader',
                  arguments: items[itemIndex].id);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 2.0),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 15,
                  runSpacing: 15,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 8.0),
                          width: 90.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  NetworkImage(items[itemIndex].imgurl),
                            ),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: 200.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${items[itemIndex].episode}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(0, 0, 0, 0.8),
                                ),
                              ),
                              Text(
                                '${items[itemIndex].date}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color.fromRGBO(0, 0, 0, 0.3),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 120.0,
                          width: 50.0,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('#${items[itemIndex].index}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            
          }
          return Divider(height: 0, color: Colors.grey);
        },
        childCount: math.max(0, items.length * 2 - 1),        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    if (this.detail == null) {
      return LoadingIndicator(
        pageState,
        retry: _retry,
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            primary:  true,
            pinned: true,
            //floating: true,
            //forceElevated: false,
            expandedHeight: 330.0,
            backgroundColor: AppColor.golden,
            titleSpacing: 20.0,
            iconTheme: IconThemeData(
              color: AppColor.white,
            ),
            title: Title(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon:(isMarkPressed)? Icon(
                        Icons.bookmark,
                      ) : Icon(
                        Icons.bookmark_border,
                      ),
                      onPressed: () {
                        setState((){
                          isMarkPressed= !isMarkPressed;
                        });                    
                      },
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.share,
                      ),
                      onPressed: () {
                        final RenderBox box = context.findRenderObject();
                        /*
                        Share.share(detail.title,
                            sharePositionOrigin:
                            box.localToGlobal(Offset.zero) &
                            box.size);
                        */
                        Share.share("https://pkcomics.page.link/oN6u",
                            sharePositionOrigin:
                            box.localToGlobal(Offset.zero) &
                            box.size);
                        
                      },
                  ),
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                child: Stack(
                  fit:StackFit.loose,
                  children: <Widget>[
                    Container(
                      width: screenSize.width,
                      height: 250,
                      decoration: BoxDecoration(                        
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.srcOver),
                          image: NetworkImage(
                            detail.cover,
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    //Image.network(detail.cover, fit: BoxFit.cover),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          stops: [0.1, 1],
                          colors: [
                            Colors.black12,
                            Colors.black26
                          ],
                        ),
                      ),
                      child: Container(
                        height: 250.0,
                        width: screenSize.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 50.0),
                              child: Container(
                                height: 20.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: Text(
                                  detail.genre,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 15.0),
                              child: Text(
                                detail.title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  height: 0.65,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 15.0),
                              child: Text(
                                detail.author,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  height: 0.65,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                renderCount(Icons.visibility, detail.view),
                                renderCount(Icons.star, detail.favorite),
                              ],
                            ),
                          ]
                        )
                      )
                    ),
                    Positioned(
                      top: 240,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        width: screenSize.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Info',
                                      style: TextStyle(
                                          fontSize: fixedFontSize(16),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70)
                                          //color: Color.fromRGBO(105, 105, 105, 0.8))
                                  ),
                                  SizedBox(height: 10,),
                                  InkWell(
                                    onTap: () =>  AppNavigator.popupComicInfo(context, description: detail.description, author: detail.author, genre: detail.genre),
                                    child: Text(
                                      detail.description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        //color: Color.fromRGBO(105, 105, 105, 0.8),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              /*
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Info',
                                      style: TextStyle(
                                          fontSize: fixedFontSize(16),
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(105, 105, 105, 0.8))
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    detail.description,
                                    overflow: TextOverflow.clip,
                                    maxLines: isUnfold ? null : 3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color.fromRGBO(105, 105, 105, 0.8),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isUnfold = !isUnfold;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(isUnfold ? 'fold' : 'show all', style:TextStyle(fontSize:fixedFontSize(14), color: AppColor.blue),),
                                        Icon(isUnfold ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColor.blue,)
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              */
                              
                            ),

                          ]
                        )
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0)),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/reader',
                        arguments: detail.episodeList[0].id);                      
                    },
                    textColor: Colors.white,
                    color: Colors.orange,
                    child: Text("Read Ep. 1"),
                  ),
                ),
                Container(
                  margin: new EdgeInsets.only(right: 25.0, top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        child: Center(child: Text("Newest",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        )),
                        onTap: () {
                          setState(() {
                            isNewest = true;
                          });
                        }
                      ),
                      Text(
                        " | ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                      InkWell(
                        child: Center(child: Text("Oldest",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        )),
                        onTap: () {
                          setState(() {
                            isNewest = false;
                          });
                        }
                      ),
                    ],
                  )
                ),
                Divider(height: 15, color: Colors.black),
              ],
            ),
          ),
          episodeList(),
        ],
      ),
    );
  }
}
