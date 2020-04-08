import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pkcomics/app/app_scene.dart';
import 'package:easy_localization/easy_localization.dart';

void main() {
  runApp(EasyLocalization(
    child: AppScene(),
    supportedLocales: [
      Locale('en', 'US'),
      Locale('hi', 'PK')
    ],
    path: 'assets/i18n',
  ));

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }  
} 
