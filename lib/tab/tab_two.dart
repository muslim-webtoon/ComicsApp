import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';
import 'package:pkcomics/home/comic_block_item_view.dart';
import 'package:pkcomics/generated/i18n.dart';

class ComicTabTwo extends StatefulWidget {
  final ComicGenre comicGenre;

  ComicTabTwo(this.comicGenre);

  @override
  State<StatefulWidget> createState() => ComicTabTwoState();
}

class ComicTabTwoState extends State<ComicTabTwo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final int _tabCount = 5;
  String _currentGenre = 'romance';

   @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabCount);
    _tabController.addListener(onTabChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void onTabChanged() {

    if (_tabController.indexIsChanging) {
      final int index = _tabController.index;
      switch(index) { 
        case 0: {  
          setState(() {
            _currentGenre = "romance";
          });
        } 
        break;
        case 1: {
          setState(() {
            _currentGenre = "drama";
          });
        }
        break; 
        case 2: {  
           setState(() {
            _currentGenre = "fantasy";
          }); 
        } 
        break; 
        case 3: {  
          setState(() {
            _currentGenre = "action";
          });
        } 
        break; 
        case 4: {  
          setState(() {
            _currentGenre = "slice_of_life";
          });
        } 
        break; 
        default: { 
          setState(() {
            _currentGenre = "";
          });
         } 
        break; 
      }
    }

  }

  @override
  Widget build(BuildContext context) {
        
    var children = widget.comicGenre.genreList
        .where((item) => item.genres[0] == _currentGenre)
        .map((comicItem) => ComicBlockItemView(comicItem, Color(0xFFF5F5EE), 'UP'),)
        .toList();

    return DefaultTabController(
      length: _tabCount,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: TabBar(
            tabs: [
              Tab(text: I18n.of(context).romance),
              Tab(text: I18n.of(context).drama),
              Tab(text: I18n.of(context).fantasy),
              Tab(text: I18n.of(context).action),
              Tab(text: I18n.of(context).sliceOfLife),
            ],
            controller: _tabController,
            labelPadding: EdgeInsets.symmetric(horizontal: 14),
            isScrollable: true,
            indicatorColor: AppColor.primary,
            labelColor: AppColor.primary,
            labelStyle: TextStyle(
                fontSize: 18,
                color: AppColor.primary,
                fontWeight: FontWeight.w500),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle:
                TextStyle(fontSize: 15, color: Colors.black),
            indicatorSize: TabBarIndicatorSize.label
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: List<Widget>.generate(_tabCount, (int i) { 
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: Wrap(spacing: 15, runSpacing: 15, children: children),
              )
            );
          }),
        )
      ),

    );
  }
}