import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pkcomics/comic/reader/reader_menu.dart';
import 'package:pkcomics/public.dart';
import 'package:pkcomics/widget/loading_indicator.dart';

import 'episode_provider.dart';

class ReaderScene extends StatefulWidget {

  final int episodeId;

  const ReaderScene({Key key, this.episodeId}) : super(key: key);

  @override
  ReaderState createState() => ReaderState();
}

class ReaderState extends State<ReaderScene> with RouteAware {

  bool isDataReady = false;
  bool isMenuVisiable = true;
  List<String> imageList = [];

  ScrollController _controller;
  Reader currentEpisode;
  PageState pageState = PageState.Loading;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    setup();
  }

  _scrollListener() {
        if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        isMenuVisiable = true;
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        isMenuVisiable = true;
      });
    }
  }

  @override
  void didPopNext() {

  }

    @override
  void didPush() {

  }

  @override
  void dispose() {
    super.dispose();
  }

  void setup() async {
    await Future.delayed(Duration(milliseconds: 3000), () {
      pageState = PageState.Content;
    });
    await resetContent(this.widget.episodeId);
  }

  _retry() {
    pageState = PageState.Loading;
    setState(() {});
    setup();
  }

  resetContent(int episodeId) async {
    currentEpisode = await fetchEpisode(episodeId);
    imageList.clear();
    currentEpisode.comicPictureList.forEach((data) {
      imageList.add(data);
    });

    setState(() {
      isDataReady = true;
    });
  }

  Future<Reader> fetchEpisode(int episodeId) async {
    var episode = await EpisodeProvider.fetchEpisode(episodeId);
    return episode;
  }

  onTap(Offset position) async {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
      setState(() {
        isMenuVisiable = true;
    });
  }

  Widget buildWidget(int index) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        onTap(details.globalPosition);
      },
      child: ComicCoverImage(imageList[index], fit: BoxFit.fitWidth),
    );
  }

  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }
    return ReaderMenu(
      episodeIndex: currentEpisode.index,
      nextId: currentEpisode.nextEpisodeId,
      onTap: hideMenu,
      onPreviousEpisode: () {
        //AppNavigator.pushComicReader(context, currentEpisode.preEpisodeId);
        Navigator.of(context).pushReplacementNamed(
          '/reader',
          arguments: currentEpisode.preEpisodeId);
        
      },
      onNextEpisode: () {
        //AppNavigator.pushComicReader(context, currentEpisode.nextEpisodeId);        
        Navigator.of(context).pushReplacementNamed(
          '/reader',
          arguments: currentEpisode.nextEpisodeId);
        
      },
    );
  }

  hideMenu() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      this.isMenuVisiable = false;
    });
  }

  viewScrollView() {
    return Scrollbar(
      child: ListView.builder(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 1.0),
        itemCount: CollectionsUtils.size(imageList),
        itemBuilder: (BuildContext context, int index) {
          return buildWidget(index);
        },
        cacheExtent: 10,
      ),
    );

  }
  
  @override
  Widget build(BuildContext context) {
    if(!isDataReady) {
      return LoadingIndicator(
        pageState,
        retry: _retry,
      );
    }
    return Container(
      color: AppColor.white,
      child: new Stack(
        children: <Widget>[
          viewScrollView(),
          buildMenu(),
        ],
      )
    );
  }
}