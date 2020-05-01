import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pkcomics/generated/i18n.dart';



class LanguageView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 26),
              margin: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                "Choose language",
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            buildSwitchListTileMenuItem(
                context: context,
                title: "English",
                subtitle: "English",
                locale:  Locale("en", "US")),
            buildDivider(),
            buildSwitchListTileMenuItem(
                context: context,
                title: "Urdu",
                subtitle: "Urdu",
                locale:  Locale("ur", "PK")),
            buildDivider(),
          ],
        ),
      ),
    );
  }

  Container buildDivider() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Divider(
          color: Colors.grey,
        ),
      );

  Container buildSwitchListTileMenuItem(
      {BuildContext context, String title, String subtitle, Locale locale}) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: ListTile(
          dense: true,
          // isThreeLine: true,
          title: Text(
            title,
          ),
          subtitle: Text(
            subtitle,
          ),
          onTap: () {
            log(locale.toString(), name: this.toString());
            
            Navigator.pop(context);
          }),
    );
  }
}

