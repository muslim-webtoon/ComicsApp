import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pkcomics/app/route_generator.dart';
import 'package:pkcomics/generated/i18n.dart';
import 'package:pkcomics/states/account_state.dart';

import 'package:pkcomics/public.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppScene extends StatelessWidget {
  
  final accountState = AccountState();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => accountState),
      ],
      child: MaterialApp(
        title: 'PKComics',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
          dividerColor: Color(0xffeeeeee),
          scaffoldBackgroundColor: AppColor.paper,
          textTheme: TextTheme(body1: TextStyle(color: AppColor.darkGray)),
        ),
        localizationsDelegates: [
          I18n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: I18n.delegate.supportedLocales,
        localeResolutionCallback:
          I18n.delegate.resolution(fallback: new Locale("en", "US")),
        navigatorObservers: [routeObserver],
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

}
