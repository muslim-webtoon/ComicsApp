import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';

abstract class GlobalBaseState {
  Locale get locale;
  set locale(Locale locale);

  FirebaseUser get user;
  set user(FirebaseUser u);
}

class GlobalState implements GlobalBaseState, Cloneable<GlobalState> {

  @override
  Locale locale;
  @override
  FirebaseUser user;

  @override
  GlobalState clone() {
    return GlobalState()
      ..locale = locale;
  }

}