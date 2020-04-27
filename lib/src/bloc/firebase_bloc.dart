import 'dart:async';

import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/types.dart';
import 'package:community_parade/src/config/firebase_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class FirebaseBloc {
  FirebaseBloc({
    @required ConfigBloc configBloc,
    @required UserBloc userBloc,
  })  : assert(configBloc != null),
        assert(userBloc != null),
        _configBloc = configBloc,
        _userBloc = userBloc;
  static final Logger _logger = Logger('FirebaseBloc');

  final List<StreamSubscription> _subscriptions = [];

  final ConfigBloc _configBloc;
  final UserBloc _userBloc;

  FirebaseApp _app;
  FirebaseDatabase _database;
  bool _initialized = false;

  Future<void> initialize() async {
    await _initialize();
    _initialized = true;
  }

  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _initialized = false;
  }

  void listen(
    List<String> children, {
    bool keep,
    @required OnError onError,
    @required ValueSetter<Event> onValue,
  }) {
    assert(onError != null);
    assert(onValue != null);

    _ref(
      children,
      keep: keep,
    ).onValue.handleError((error) {
      if (onError != null) {
        onError(
          error: error,
          name: 'FirebaseBloc.value',
        );
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          exception: error,
        ));
      }
      ;
    }).listen(
      (event) async {
        try {
          await onValue(event);
        } catch (e, stack) {
          if (onError != null) {
            await onError(
              error: e,
              name: 'FirebaseBloc.value',
              stack: stack,
            );
          } else {
            FlutterError.reportError(FlutterErrorDetails(
              exception: e,
              stack: stack,
            ));
          }
        }
      },
    );
  }

  Future<AuthResult> login(String token) async {
    await _database.goOnline();
    var auth = FirebaseAuth.fromApp(_app);
    var authResult = await auth.signInWithCustomToken(
      token: token,
    );

    return authResult;
  }

  Future<DataSnapshot> once(
    List<String> children, {
    bool keep,
    @required OnError onError,
    @required ValueSetter<Event> onValue,
  }) async {
    assert(onError != null);
    assert(onValue != null);

    DataSnapshot result;
    try {
      result = await _ref(
        children,
        keep: keep,
      ).once();
    } catch (e, stack) {
      if (onError != null) {
        await onError(
          error: e,
          name: 'FirebaseBloc.value',
          stack: stack,
        );
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: stack,
        ));
      }
    }

    return result;
  }

  Future<void> _initialize() async {
    if (_app != null) {
      await _database?.goOffline();
      await FirebaseAuth.fromApp(_app).signOut();
    }

    _app = await FirebaseApp.instance;
    _database = FirebaseDatabase(app: _app);
    await _database.goOnline();

    _subscriptions.add(_userBloc.userStream.listen((jwt) async {
      if (jwt?.token?.isNotEmpty == true) {
        await (login(jwt));
      }
    }));
    if (_userBloc.user?.token?.isNotEmpty == true) {
      await (login(_userBloc.user.token));
    }

    await _database.setPersistenceEnabled(true);

    _logger.fine('FirebaseApp initialized: ${_app?.name}');
  }

  DatabaseReference _ref(
    List<String> children, {
    bool keep,
  }) {
    assert(_initialized == true);
    assert(children?.isNotEmpty == true);

    var reference = _database.reference().child(
          _configBloc.value(
            FirebaseConfig.base_path,
          ),
        );
    children?.forEach((child) => reference = reference.child(child));

    if (keep != null) {
      reference.keepSynced(keep);
    }
    return reference;
  }
}
