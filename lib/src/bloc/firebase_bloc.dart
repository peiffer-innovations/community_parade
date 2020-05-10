import 'dart:async';

import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/firebase/firebase_bloc_interface.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/types.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// ignore: uri_does_not_exist
import 'firebase/stub_firebase_bloc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'firebase/web_firebase_bloc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'firebase/io_firebase_bloc.dart';

class FirebaseBloc implements FirebaseBlocInterface {
  FirebaseBloc({
    @required ConfigBloc configBloc,
    @required UserBloc userBloc,
  }) : _fb = createFirebaseInstance(
          configBloc: configBloc,
          userBloc: userBloc,
        );

  final FirebaseBlocInterface _fb;

  @override
  Future<void> initialize() => _fb.initialize();

  @override
  void dispose() => _fb.dispose();

  @override
  StreamSubscription<dynamic> listen(
    List<String> children, {
    bool keep,
    OnError onError,
    @required KeyValueCallback<dynamic> onValue,
  }) =>
      _fb.listen(
        children,
        keep: keep,
        onError: onError,
        onValue: onValue,
      );

  @override
  Future<String> login(String token) => _fb.login(token);

  @override
  Future<void> logout() => _fb.logout();

  @override
  StreamSubscription<dynamic> onChildChanged(
    List<String> children, {
    bool keep,
    OnError onError,
    @required KeyValueCallback<dynamic> onValue,
  }) =>
      _fb.onChildChanged(
        children,
        keep: keep,
        onError: onError,
        onValue: onValue,
      );

  @override
  Future<dynamic> once(
    List<String> children, {
    bool keep,
    String minKey,
    OnError onError,
  }) =>
      _fb.once(
        children,
        keep: keep,
        minKey: minKey,
        onError: onError,
      );

  @override
  Future<void> set(
    List<String> children, {
    OnError onError,
    dynamic value,
  }) =>
      _fb.set(
        children,
        onError: onError,
        value: value,
      );
}
