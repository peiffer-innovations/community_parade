import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/crypto_bloc.dart';
import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/bloc/parade_bloc.dart';
import 'package:community_parade/src/bloc/rest_client_bloc.dart';
import 'package:community_parade/src/bloc/sql_database_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rest_client/rest_client.dart';

class Bootstrapper {
  Bootstrapper({
    GlobalKey<NavigatorState> navigatorKey,
  }) : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _navigatorKey;

  ConfigBloc _configBloc;
  CryptoBloc _cryptoBloc;
  FirebaseBloc _firebaseBloc;
  GpsBloc _gpsBloc;
  ParadeBloc _paradeBloc;
  RestClientBloc _restClientBloc;
  SqlDatabaseBloc _sqlDatabaseBloc;
  TranslationsBloc _translationsBloc;
  UserBloc _userBloc;

  ConfigBloc get configBloc => _configBloc;
  CryptoBloc get cryptoBloc => _cryptoBloc;
  FirebaseBloc get firebaseBloc => _firebaseBloc;
  GpsBloc get gpsBloc => _gpsBloc;
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  ParadeBloc get paradeBloc => _paradeBloc;
  RestClientBloc get restClientBloc => _restClientBloc;
  SqlDatabaseBloc get sqlDatabaseBloc => _sqlDatabaseBloc;
  TranslationsBloc get translationsBloc => _translationsBloc;
  UserBloc get userBloc => _userBloc;

  Future<void> bootstrap() async {
    _cryptoBloc = CryptoBloc();
    await _cryptoBloc.initialize();

    _userBloc = UserBloc();
    await _userBloc.initialize();

    var client = Client();
    _restClientBloc = RestClientBloc(
      client: client,
      cryptoBloc: _cryptoBloc,
    );
    await _restClientBloc.initialize();

    _sqlDatabaseBloc = SqlDatabaseBloc();
    await _sqlDatabaseBloc;

    _firebaseBloc = FirebaseBloc(
      configBloc: configBloc,
      userBloc: userBloc,
    );
    await _firebaseBloc.initialize();

    _configBloc = ConfigBloc(
      restClientBloc: _restClientBloc,
    );
    await _configBloc;

    _gpsBloc = GpsBloc();
    await _gpsBloc.initialize();

    _translationsBloc = TranslationsBloc();
    await _translationsBloc;

    _paradeBloc = ParadeBloc();
    await _paradeBloc;
  }

  void dispose() {
    _firebaseBloc?.dispose();
    _gpsBloc?.dispose();
  }

  Bootstrapper reinitialize() => Bootstrapper(
        navigatorKey: _navigatorKey,
      );
}
