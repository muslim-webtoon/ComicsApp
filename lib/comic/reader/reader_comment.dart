import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';

import 'episode_comment_cell.dart';
class ReaderComment extends StatefulWidget {

  ReaderComment();

  @override
  ReaderCommentState createState() => ReaderCommentState();
}

class ReaderCommentState extends State<ReaderComment> {
  
  List<EpisodeComment> comments = [];

  var width = Screen.width;

  @override
  void initState() {
    super.initState();
    _fetchCommentData();
  }

  Future<void> _fetchCommentData() async {
    try {
      var commentsResponse =
          await Request.post(url: 'episode_comment', params: {'id': 1});
      commentsResponse.forEach((data) {
        comments.add(EpisodeComment.fromJson(data));
      });
      setState(() {});
    } catch(e) {
      print(e.toString());
    }
  }

  Widget _buildTextComposer() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          Flexible(
            child: new TextField(
              autofocus: false,
              maxLines: 1,
              decoration:
                  new InputDecoration.collapsed(hintText: "Send a comment"),
            ),
          ),
           new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: new Icon(Icons.send),
              ),
            ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comments (${CollectionsUtils.size(comments)})'), elevation: 0.0),
      
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: 
                    comments.map((comment) => EpisodeCommentCell(comment)).toList(),
                ),
                Divider(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      'View all comments (333)',
                      style: TextStyle(fontSize: 14, color: AppColor.gray),
                    ),
                  ),
                ),
                Divider(height: 50),
              ],
            )
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration:
                  new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ),
          
        ],
      )
    );

  }
}