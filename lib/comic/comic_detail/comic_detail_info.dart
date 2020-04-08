import 'package:flutter/material.dart';

import 'package:pkcomics/public.dart';

class ComicDetailInfo extends StatelessWidget {
  String description;
  String author;
  String genre;

  ComicDetailInfo({this.description, this.author, this.genre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Info")),
      ),
      body: SafeArea(
        child: Container(
          padding: new EdgeInsets.only(top: 16.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Description"), 
                subtitle: Text(this.description),
              ),
              Divider(),
              ListTile(
                title: Text('Creator'),
                subtitle: Text(this.author),
              ),
              Divider(),
              ListTile(
                title: Text('Genres'),
                subtitle: Text(this.genre),
              ),
            ],
          ),
        ),
      ),
    );
  }
}