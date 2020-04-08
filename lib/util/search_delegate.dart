
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pkcomics/public.dart';


class SearchBarDelegate extends SearchDelegate<String> {

  final cartoons = [
    "Lore Olympus",
    "SubZero",
    "unTouchable",
    "Super Secret",
    "Oh! Holy"
  ];

  final recentCartoons = [
    "Lore Olympus",
    "SubZero",
    "unTouchable",
    "Super Secret",
    "Oh! Holy"
  ];

  int id = 0;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (id == 0) {
      return Center(
        child: Text(
          '"$query"\n is not a valid query.\nTry again.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListTile(
      onTap: (){
        AppNavigator.pushComicDetail(context, id);
      },
      leading: Icon(Icons.book),
      title: Text(
        preferences.getString('query'),
        style: TextStyle(color: Colors.grey),
        ),
      );
  
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty 
        ? recentCartoons 
        : cartoons.where((p) => p.toLowerCase().contains(query.toLowerCase())).toList();
        //: cartoons.where((p) => p.toLowerCase().startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
          switch (suggestionList[index]) {
            case "Lore Olympus":
              id = 1;
              break;
            case "SubZero":
              id = 2;
              break;
            case "unTouchable":
              id = 3;
              break;
            case "Super Secret":
              id = 4;
              break;
            case "Oh! Holy":
              id = 5;
              break;
            default:
              break;
          }
          if(id != 0) {
            preferences.setString('query', suggestionList[index]);
            AppNavigator.pushComicDetail(context, id);
          }

          showResults(context);
        },
        leading: Icon(Icons.book),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.length),
            style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey))
            ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
