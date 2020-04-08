import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pkcomics/app/route_generator.dart';
import 'package:pkcomics/public.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();



class AppScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log(EasyLocalization.of(context).locale.toString(),
        name: this.toString() + "# locale");
    return MaterialApp(
      title: 'PKComics',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        dividerColor: Color(0xffeeeeee),
        scaffoldBackgroundColor: AppColor.paper,
        textTheme: TextTheme(body1: TextStyle(color: AppColor.darkGray)),
      ),
      initialRoute: '/splash',
      onGenerateRoute: RouteGenerator.generateRoute,
      //home: RootScene(),
      //home: SplashScene(),

    );
  }

}
