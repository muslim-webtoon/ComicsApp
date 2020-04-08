import 'package:flutter/material.dart';

import 'package:pkcomics/public.dart';
import 'package:flutter_linkify/flutter_linkify.dart';


class OpenSourceInfo extends StatefulWidget {
  OpenSourceInfo();
  @override
  State<StatefulWidget> createState() => new _MeSceneState();
}

class _MeSceneState extends State<OpenSourceInfo> {
  
  Future<void> _onOpen(LinkableElement link) async {
    AppNavigator.push(context, WebViewScene(url: '${link.url}',title: ''));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Open Source License")),
      ),
      body: SafeArea(
        child: Container(
          padding: new EdgeInsets.only(top: 16.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Linkify(
                  onOpen: _onOpen,
                  text: "● Flutter https://flutter.dev",
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Container(
                            width: 250,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: Text(
                              "Copyright 2014 The Flutter Authors. All rights reserved.\n\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND\nANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED\nWARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE\nDISCLAIMED.", 
                              style: TextStyle(fontSize: 15))
                          ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}