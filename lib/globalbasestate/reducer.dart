import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:pkcomics/generated/i18n.dart';

import 'action.dart';
import 'state.dart';

Reducer<GlobalState> buildReducer() {
  return asReducer(
    <Object, Reducer<GlobalState>>{
      GlobalAction.changeLocale: _onChangeLocale,
      GlobalAction.setUser: _onSetUser,
    }
  );
}

GlobalState _onChangeLocale(GlobalState state, Action action) {
  final Locale l = action.payload;
  I18n.locale = l;
  return state.clone()..locale = l;
}

GlobalState _onSetUser(GlobalState state, Action action) {
  final FirebaseUser user = action.payload;
  return state.clone()..user = user;

}
