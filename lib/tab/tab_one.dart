import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';
import 'package:pkcomics/home/comic_block_item_view.dart';

import 'package:pkcomics/generated/i18n.dart';

class ComicTabOne extends StatefulWidget {
  final ComicWeekly comicWeekly;

  ComicTabOne(this.comicWeekly);

  @override
  State<StatefulWidget> createState() => ComicTabOneState();
}

class ComicTabOneState extends State<ComicTabOne>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final int _tabCount = 7;
  DateTime date = DateTime.now();
  int _currentIndex = 0;
  int _total = 0;

  String _value = 'one';
  
  @override
  void initState() {
    super.initState();
    
    setState(() {
      _currentIndex = date.weekday-1;


      _total = widget.comicWeekly.weeklyList
      .where((item) => (
        item.day == _currentIndex+1
        )).length;

    });
    print("weekday is ${date.weekday}");
    _tabController = TabController(vsync: this, length: _tabCount, initialIndex: _currentIndex);
    _tabController.addListener(onTabChanged);

  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;

        _total = widget.comicWeekly.weeklyList
        .where((item) => (
          item.day == _currentIndex+1
          )).length;

      });
    }
  }

  Widget selectBar() {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Total $_total'),
        SizedBox(width: 200),
        //Spacer(),
        DropdownButton<String>(
          items: [
            DropdownMenuItem<String>(
              child: Text('Popular'),
              value: 'one',
            ),
            DropdownMenuItem<String>(
              child: Text('New'),
              value: 'two',
            ),
            DropdownMenuItem<String>(
              child: Text('Update'),
              value: 'three',
            ),
          ],
          onChanged: (String value) {
            setState(() {
              _value = value;
            });
          },
          hint: Text('Select'),
          value: _value,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    var children = widget.comicWeekly.weeklyList
        .where((item) => (
          item.day == _currentIndex+1
          ))
        .map((comicItem) => ComicBlockItemView(comicItem, Color(0xFFF5F5EE), 'UP')
        )
        .toList();
        
    return DefaultTabController(
      length: _tabCount,
      child:Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: TabBar(
            tabs: [
              Tab(text: I18n.of(context).mon),
              Tab(text: I18n.of(context).tue),
              Tab(text: I18n.of(context).wen),
              Tab(text: I18n.of(context).thu),
              Tab(text: I18n.of(context).fri),
              Tab(text: I18n.of(context).sat),
              Tab(text: I18n.of(context).sun),
            ],
            controller: _tabController,
            labelPadding: EdgeInsets.symmetric(horizontal: 14),
            isScrollable: true,
            labelColor: AppColor.primary,
            labelStyle: TextStyle(
                fontSize: 18,
                color: AppColor.primary,
                fontWeight: FontWeight.w500),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle:
                TextStyle(fontSize: 14, color: Colors.black),
            indicatorSize: TabBarIndicatorSize.label
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: List<Widget>.generate(_tabCount, (int i) { 
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                selectBar(),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    child: Wrap(spacing: 15, runSpacing: 15, children: children),
                  )
                ),
              ],
            );
            /*
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: Wrap(spacing: 15, runSpacing: 15, children: children),
        
              )
            );
            */
            //return Text('weekly $i');
          }),
        )
      ),
    );
  }
}