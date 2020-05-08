import 'dart:async';

import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/firebase/firebase_bloc_interface.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/types.dart';
import 'package:community_parade/src/config/firebase_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

FirebaseBlocInterface createFirebaseInstance({
  @required ConfigBloc configBloc,
  @required UserBloc userBloc,
}) =>
    _IoFirebaseBloc(
      configBloc: configBloc,
      userBloc: userBloc,
    );

class _IoFirebaseBloc implements FirebaseBlocInterface {
  _IoFirebaseBloc({
    @required ConfigBloc configBloc,
    @required UserBloc userBloc,
  })  : assert(configBloc != null),
        assert(userBloc != null),
        _configBloc = configBloc,
        _userBloc = userBloc;
  static final Logger _logger = Logger('_IoFirebaseBloc');

  final List<StreamSubscription> _subscriptions = [];

  final ConfigBloc _configBloc;
  final UserBloc _userBloc;

  FirebaseApp _app;
  FirebaseDatabase _database;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    await _initialize();
    _initialized = true;
  }

  @override
  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _initialized = false;
  }

  @override
  StreamSubscription<dynamic> listen(
    List<String> children, {
    bool keep,
    @required OnError onError,
    @required ValueSetter<dynamic> onValue,
  }) {
    assert(onValue != null);

    var subscription = _ref(
      children,
      keep: keep,
    ).onValue.handleError((error) {
      if (onError != null) {
        onError(
          error: error,
          name: '_IoFirebaseApp.listen: ${children.join('/')}',
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
          await onValue(event?.snapshot?.value);
        } catch (e, stack) {
          if (onError != null) {
            await onError(
              error: e,
              name: '_IoFirebaseApp.listen: ${children.join('/')}',
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

    return subscription;
  }

  @override
  Future<String> login(String token) async {
    String uid;
    var auth = FirebaseAuth.fromApp(_app);
    if (token?.isNotEmpty == true) {
      await _database.goOnline();
      var authResult = await auth.signInWithCustomToken(
        token: token,
      );

      uid = authResult?.user?.uid;
    } else {
      await auth.signOut();
    }

    return uid;
  }

  @override
  Future<void> logout() async => await FirebaseAuth.instance.signOut();

  @override
  Future<dynamic> once(
    List<String> children, {
    bool keep,
    String minKey,
    OnError onError,
  }) async {
    DataSnapshot result;
    try {
      dynamic ref = _ref(
        children,
        keep: keep,
      );

      if (minKey?.isNotEmpty == true) {
        ref = ref.orderByKey();
        ref = ref.startAt(minKey);
      }

      result = await ref.once();
    } catch (e, stack) {
      if (onError != null) {
        await onError(
          error: e,
          name: '_IoFirebaseApp.value: ${children.join('/')}',
          stack: stack,
        );
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: stack,
        ));
      }
    }

    return result?.value;
  }

  Future<void> _initialize() async {
    if (_app != null) {
      await _database?.goOffline();
      await FirebaseAuth.fromApp(_app).signOut();
    }

    _app = await FirebaseApp.instance;
    _database = FirebaseDatabase(app: _app);
    await _database.goOnline();

    _subscriptions.add(_userBloc.firebaseLoginTokenStream.listen((jwt) async {
      await (login(jwt?.token));
    }));
    if (_userBloc.firebaseLoginToken?.token?.isNotEmpty == true) {
      await (login(_userBloc.firebaseLoginToken.token));
    }

    await _database.setPersistenceEnabled(true);

    _logger.fine('_IoFirebaseApp initialized: ${_app?.name}');
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
