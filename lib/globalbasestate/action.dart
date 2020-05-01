import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';

enum GlobalAction { changeLocale, setUser }

class GlobalActionCreator {
  static Action changeLocale(Locale l) {
    return Action(GlobalAction.changeLocale, payload: l);
  }

  static Action setUser(FirebaseUser user) {
    return Action(GlobalAction.setUser, payload: user);
  }
}
