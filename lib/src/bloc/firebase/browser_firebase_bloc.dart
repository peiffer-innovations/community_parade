import 'dart:async';

import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/firebase/firebase_bloc_interface.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/components/types.dart';
import 'package:community_parade/src/config/firebase_config.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

FirebaseBlocInterface createFirebaseInstance({
  @required ConfigBloc configBloc,
  @required UserBloc userBloc,
}) =>
    _BrowserFirebaseBloc(
      configBloc: configBloc,
      userBloc: userBloc,
    );

class _BrowserFirebaseBloc implements FirebaseBlocInterface {
  _BrowserFirebaseBloc({
    @required ConfigBloc configBloc,
    @required UserBloc userBloc,
  })  : assert(configBloc != null),
        assert(userBloc != null),
        _configBloc = configBloc,
        _userBloc = userBloc;
  static final Logger _logger = Logger('_BrowserFirebaseBloc');

  final List<StreamSubscription> _subscriptions = [];

  final ConfigBloc _configBloc;
  final UserBloc _userBloc;

  App _app;
  String _basePath;
  Database _database;
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
    OnError onError,
    @required KeyValueCallback<dynamic> onValue,
  }) {
    assert(onValue != null);

    var subscription = _ref(
      children,
      keep: keep,
    ).onValue.handleError((error) {
      if (onError != null) {
        onError(
          error: error,
          name: '_BrowserFirebaseBloc.value',
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
          await onValue(
            key: event?.snapshot?.key,
            value: event?.snapshot?.val(),
          );
        } catch (e, stack) {
          if (onError != null) {
            await onError(
              error: e,
              name: '_BrowserFirebaseBloc.value',
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
    if (token?.isNotEmpty == true) {
      await _database.goOnline();
      var authResult = await _app.auth().signInWithCustomToken(token);

      uid = authResult?.user?.uid;
    } else {
      await _app.auth().signOut();
    }

    return uid;
  }

  @override
  Future<void> logout() async => await _app?.auth()?.signOut();

  @override
  StreamSubscription<dynamic> onChildChanged(
    List<String> children, {
    bool keep,
    OnError onError,
    @required KeyValueCallback<dynamic> onValue,
  }) {
    dynamic ref = _ref(
      children,
      keep: keep,
    );

    return ref.onChildChanged.handleError((error) {
      if (onError != null) {
        onError(
          error: error,
          name: '_BrowserFirebaseBloc.onChildChanged',
        );
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          exception: error,
        ));
      }
      ;
    }).listen((event) {
      (event) async {
        try {
          await onValue(
            key: event?.snapshot?.key,
            value: event?.snapshot?.val(),
          );
        } catch (e, stack) {
          if (onError != null) {
            await onError(
              error: e,
              name: '_BrowserFirebaseApp.onChildChanged: ${children.join('/')}',
              stack: stack,
            );
          } else {
            FlutterError.reportError(FlutterErrorDetails(
              exception: e,
              stack: stack,
            ));
          }
        }
      };
    });
  }

  @override
  Future<dynamic> once(
    List<String> children, {
    bool keep,
    String minKey,
    OnError onError,
  }) async {
    QueryEvent result;
    try {
      dynamic ref = _ref(
        children,
        keep: keep,
      );

      if (minKey?.isNotEmpty == true) {
        ref = ref.orderByKey();
        ref = ref.startAt(minKey);
      }

      result = await ref.once('value');
    } catch (e, stack) {
      if (onError != null) {
        await onError(
          error: e,
          name: '_BrowserFirebaseBloc.once',
          stack: stack,
        );
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: stack,
        ));
      }
    }

    return result?.snapshot?.val();
  }

  @override
  Future<void> set(
    List<String> children, {
    OnError onError,
    dynamic value,
  }) async {
    try {
      var ref = _ref(children);
      await ref.set(value);
    } catch (e, stack) {
      if (onError != null) {
        await onError(
          error: e,
          name: '_BrowserFirebaseApp.set: ${children.join('/')}',
          stack: stack,
        );
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: stack,
        ));
      }
    }
  }

  Future<void> _initialize() async {
    if (_app != null) {
      await _database?.goOffline();
      await _app.auth().signOut();
    }

    _basePath = _configBloc.value(FirebaseConfig.base_path);

    // Initialize Firebase
    _app = initializeApp(
        apiKey: 'AIzaSyDWGYbLC7VFe5S_23upPl_sU8afSzpKdxQ',
        authDomain: 'community-parade.firebaseapp.com',
        databaseURL: 'https://community-parade.firebaseio.com',
        projectId: 'community-parade',
        storageBucket: 'community-parade.appspot.com',
        messagingSenderId: '841222898584',
        appId: '1:841222898584:web:a6012eeadfa2bbc1be21ed',
        measurementId: 'G-53H6ZLCKV0');

    _database = _app.database();
    await _database.goOnline();

    _subscriptions.add(_userBloc.firebaseLoginTokenStream.listen((jwt) async {
      await (login(jwt?.token));
    }));
    if (_userBloc.firebaseLoginToken?.token?.isNotEmpty == true) {
      await (login(_userBloc.firebaseLoginToken.token));
    }

    _logger.fine('_BrowserFirebaseBloc initialized: ${_app?.name}');
  }

  DatabaseReference _ref(
    List<String> children, {
    bool keep,
  }) {
    assert(_initialized == true);
    assert(children?.isNotEmpty == true);

    var reference = _database.ref(_basePath).child(
          _configBloc.value(
            FirebaseConfig.base_path,
          ),
        );

    children?.forEach((child) => reference = reference.child(child));

    return reference;
  }
}
