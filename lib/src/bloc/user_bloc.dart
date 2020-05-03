import 'dart:async';
import 'dart:convert';

import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/firebase/firebase_bloc_interface.dart';
import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/rest_client_bloc.dart';
import 'package:community_parade/src/bloc/secure_store_bloc.dart';
import 'package:community_parade/src/config/api_config.dart';
import 'package:community_parade/src/models/firebase_login_token.dart';
import 'package:community_parade/src/models/user_token.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

const _kFirebaseKey = 'firebase';
const _kUserKey = 'user';

class UserBloc {
  UserBloc({
    @required ConfigBloc configBloc,
    @required FirebaseBloc firebaseBloc,
    @required RestClientBloc restClientBloc,
    @required SecureStoreBloc secureStoreBloc,
  })  : assert(configBloc != null),
        assert(firebaseBloc != null),
        assert(restClientBloc != null),
        assert(secureStoreBloc != null),
        _configBloc = configBloc,
        _firebaseBloc = firebaseBloc,
        _restClientBloc = restClientBloc,
        _secureStoreBloc = secureStoreBloc;

  final ConfigBloc _configBloc;
  final FirebaseBloc _firebaseBloc;
  final RestClientBloc _restClientBloc;
  final SecureStoreBloc _secureStoreBloc;

  FirebaseLoginToken _firebaseLoginToken;
  StreamController<FirebaseLoginToken> _firebaseLoginTokenStreamController =
      StreamController<FirebaseLoginToken>.broadcast();

  UserToken _user;
  StreamController<UserToken> _userStreamController =
      StreamController<UserToken>.broadcast();

  FirebaseLoginToken get firebaseLoginToken => _firebaseLoginToken;
  UserToken get user => _user;

  Stream<FirebaseLoginToken> get firebaseLoginTokenStream =>
      _firebaseLoginTokenStreamController?.stream;
  Stream<UserToken> get userStream => _userStreamController?.stream;

  Future<void> initialize() async {
    var userInfoStr = await _secureStoreBloc.read(key: _kUserKey);
    if (userInfoStr?.isNotEmpty == true) {
      try {
        var user = UserToken.fromDynamic(json.decode(userInfoStr));
        await setUser(user);
      } catch (e) {
        await _secureStoreBloc.deleteAll();
      }
    }
  }

  void dispose() {
    _firebaseLoginTokenStreamController?.close();
    _firebaseLoginTokenStreamController = null;

    _userStreamController?.close();
    _userStreamController = null;
  }

  Future<UserToken> createAccount({
    @required String firstName,
    @required String lastName,
    @required String password,
    @required String username,
  }) async {
    assert(firstName?.isNotEmpty == true);
    assert(lastName?.isNotEmpty == true);
    assert(password?.isNotEmpty == true);
    assert(username?.isNotEmpty == true);

    var request = Request(
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
        'username': username,
      }),
      method: RequestMethod.post,
      url: _configBloc.value(ApiConfig.createAccount),
    );

    var response = await _restClientBloc.execute(request: request);

    if (response?.statusCode == 403) {
      throw AppTranslations.create_account_duplicate;
    } else if (response?.statusCode != 200) {
      throw AppTranslations.error_default_message;
    }

    var userToken = UserToken.fromDynamic(response.body);
    var firebaseLoginToken = await requestFirebaseLoginToken(
      userToken,
      save: false,
    );

    await setUser(userToken);
    await setFirebaseLoginToken(firebaseLoginToken);

    return userToken;
  }

  Future<UserToken> login({
    @required String password,
    @required String username,
  }) async {
    assert(password?.isNotEmpty == true);
    assert(username?.isNotEmpty == true);

    var request = Request(
      body: json.encode({
        'password': password,
        'username': username,
      }),
      method: RequestMethod.post,
      url: _configBloc.value(ApiConfig.login),
    );

    var response = await _restClientBloc.execute(request: request);

    if (response?.statusCode != 200) {
      throw AppTranslations.error_login;
    }

    var userToken = UserToken.fromDynamic(response.body);
    var firebaseLoginToken = await requestFirebaseLoginToken(
      userToken,
      save: false,
    );

    await setUser(userToken);
    await setFirebaseLoginToken(firebaseLoginToken);

    return userToken;
  }

  Future<FirebaseLoginToken> requestFirebaseLoginToken(
    UserToken userToken, {
    bool save = true,
  }) async {
    var request = Request(
      body: userToken.toString(),
      method: RequestMethod.post,
      url: _configBloc.value(ApiConfig.firebaseToken),
    );

    var response = await _restClientBloc.execute(request: request);
    if (response.statusCode != 200) {
      throw AppTranslations.error_default_message;
    }
    var firebaseLoginToken = FirebaseLoginToken.fromDynamic(response.body);

    if (save == true) {
      await setFirebaseLoginToken(firebaseLoginToken);
    }

    return firebaseLoginToken;
  }

  Future<void> setFirebaseLoginToken(
      FirebaseLoginToken firebaseLoginToken) async {
    _firebaseLoginToken = firebaseLoginToken;
    _firebaseLoginTokenStreamController?.add(null);

    await _secureStoreBloc.write(
      key: _kFirebaseKey,
      value: _firebaseLoginToken?.toString(),
    );
  }

  Future<void> setUser(UserToken user) async {
    _user = user;
    _firebaseLoginToken = null;
    _firebaseLoginTokenStreamController?.add(null);
    _userStreamController?.add(_user);

    await _secureStoreBloc.delete(key: _kFirebaseKey);
    await _secureStoreBloc.write(
      key: _kUserKey,
      value: _user?.toString(),
    );
  }
}
