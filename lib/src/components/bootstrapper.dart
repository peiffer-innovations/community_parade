import 'package:community_parade/src/bloc/community_bloc.dart';
import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/crypto_bloc.dart';
import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/bloc/parade_bloc.dart';
import 'package:community_parade/src/bloc/rest_client_bloc.dart';
import 'package:community_parade/src/bloc/secure_store_bloc.dart';
import 'package:community_parade/src/bloc/sembast_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_client/rest_client.dart';

class Bootstrapper {
  Bootstrapper({
    GlobalKey<NavigatorState> navigatorKey,
  }) : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _navigatorKey;

  CommunityBloc _communityBloc;
  ConfigBloc _configBloc;
  CryptoBloc _cryptoBloc;
  FirebaseBloc _firebaseBloc;
  GpsBloc _gpsBloc;
  ParadeBloc _paradeBloc;
  RestClientBloc _restClientBloc;
  SecureStoreBloc _secureStoreBloc;
  SembastBloc _sembastBloc;
  TranslationsBloc _translationsBloc;
  UserBloc _userBloc;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  List<Provider> get providers => [
        Provider<CommunityBloc>.value(
          value: _communityBloc,
        ),
        Provider<ConfigBloc>.value(
          value: _configBloc,
        ),
        Provider<CryptoBloc>.value(
          value: _cryptoBloc,
        ),
        Provider<FirebaseBloc>.value(
          value: _firebaseBloc,
        ),
        Provider<GpsBloc>.value(
          value: _gpsBloc,
        ),
        Provider<ParadeBloc>.value(
          value: _paradeBloc,
        ),
        Provider<RestClientBloc>.value(
          value: _restClientBloc,
        ),
        Provider<SecureStoreBloc>.value(
          value: _secureStoreBloc,
        ),
        Provider<SembastBloc>.value(
          value: _sembastBloc,
        ),
        Provider<TranslationsBloc>.value(
          value: _translationsBloc,
        ),
        Provider<UserBloc>.value(
          value: _userBloc,
        ),
      ];

  Future<void> bootstrap() async {
    _cryptoBloc = CryptoBloc();
    await _cryptoBloc.initialize();

    _secureStoreBloc = SecureStoreBloc();
    await _secureStoreBloc.initialize();

    var client = Client();
    _restClientBloc = RestClientBloc(
      client: client,
      cryptoBloc: _cryptoBloc,
    );
    await _restClientBloc.initialize();

    _sembastBloc = SembastBloc();
    await _sembastBloc;

    _configBloc = ConfigBloc(
      restClientBloc: _restClientBloc,
    );
    await _configBloc.initialize();

    _userBloc = UserBloc(
      configBloc: _configBloc,
      restClientBloc: _restClientBloc,
      secureStoreBloc: _secureStoreBloc,
    );
    await _userBloc.initialize();

    _firebaseBloc = FirebaseBloc(
      configBloc: _configBloc,
      userBloc: _userBloc,
    );
    await _firebaseBloc.initialize();

    _communityBloc = CommunityBloc(
      firebaseBloc: _firebaseBloc,
    );
    await _communityBloc.initialize();

    _gpsBloc = GpsBloc();
    await _gpsBloc.initialize();

    _translationsBloc = TranslationsBloc();
    await _translationsBloc;

    _paradeBloc = ParadeBloc(
      firebaseBloc: _firebaseBloc,
      userBloc: _userBloc,
    );
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
