import 'dart:async';
import 'dart:convert';

import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/rest_client_bloc.dart';
import 'package:community_parade/src/bloc/secure_store_bloc.dart';
import 'package:community_parade/src/config/api_config.dart';
import 'package:community_parade/src/models/firebase_login_token.dart';
import 'package:community_parade/src/models/pass_fail_response.dart';
import 'package:community_parade/src/models/user_login_response.dart';
import 'package:community_parade/src/models/user_token.dart';
import 'package:community_parade/src/translations/app_translations.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

const _kCommunityId = 'communityId';
const _kFirebaseKey = 'firebase';
const _kUserKey = 'user';

class UserBloc {
  UserBloc({
    @required ConfigBloc configBloc,
    @required RestClientBloc restClientBloc,
    @required SecureStoreBloc secureStoreBloc,
  })  : assert(configBloc != null),
        assert(restClientBloc != null),
        assert(secureStoreBloc != null),
        _configBloc = configBloc,
        _restClientBloc = restClientBloc,
        _secureStoreBloc = secureStoreBloc;

  static final Logger _logger = Logger('UserBloc');

  final ConfigBloc _configBloc;
  final RestClientBloc _restClientBloc;
  final SecureStoreBloc _secureStoreBloc;

  String _communityId;
  FirebaseLoginToken _firebaseLoginToken;
  StreamController<FirebaseLoginToken> _firebaseLoginTokenStreamController =
      StreamController<FirebaseLoginToken>.broadcast();
  UserToken _user;
  StreamController<UserToken> _userStreamController =
      StreamController<UserToken>.broadcast();

  String get communityId => _communityId;

  FirebaseLoginToken get firebaseLoginToken => _firebaseLoginToken;

  Stream<FirebaseLoginToken> get firebaseLoginTokenStream =>
      _firebaseLoginTokenStreamController?.stream;

  UserToken get user => _user;

  Stream<UserToken> get userStream => _userStreamController?.stream;

  Future<void> initialize() async {
    var userInfoStr = await _secureStoreBloc.read(key: _kUserKey);
    if (userInfoStr?.isNotEmpty == true) {
      try {
        var user = UserToken.fromDynamic(json.decode(userInfoStr));
        FirebaseLoginToken fbToken;

        var fbTokenStr = await _secureStoreBloc.read(key: _kFirebaseKey);
        if (fbTokenStr?.isNotEmpty == true) {
          fbToken = FirebaseLoginToken.fromDynamic(json.decode(fbTokenStr));
          if (fbToken?.valid != true) {
            fbToken = await requestFirebaseLoginToken(user);
          }
        }

        _user = user;
        _firebaseLoginToken = fbToken;

        _communityId = await _secureStoreBloc.read(key: _kCommunityId);
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

  Future<bool> attachToCommunity(String communityId) async {
    assert(communityId?.isNotEmpty == true);

    var valid = false;

    var request = Request(
      body: json.encode({
        'communityId': communityId,
        'userToken': _user.toJson(),
      }),
      method: RequestMethod.post,
      url: _configBloc.value(ApiConfig.attachCommunity),
    );

    var response = await _restClientBloc.execute(request: request);
    if (response?.statusCode == 200) {
      var result = PassFailResponse.fromDynamic(response.body);

      valid = result.success == true;
      if (valid == true) {
        await setCommunityId(communityId);
      } else {
        _logger.severe('Error in attaching $communityId: ${result.error}');
      }
    }

    return valid;
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

    var userLoginResponse = UserLoginResponse.fromDynamic(response.body);

    await setUser(userLoginResponse);

    return userLoginResponse.userToken;
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

    var userLoginResponse = UserLoginResponse.fromDynamic(response.body);

    await setUser(userLoginResponse);

    return userLoginResponse?.userToken;
  }

  Future<void> logout() async => setUser(null);

  Future<FirebaseLoginToken> requestFirebaseLoginToken(
    UserToken userToken, {
    bool save = true,
  }) async {
    var request = Request(
      body: userToken.toString(),
      method: RequestMethod.post,
      url: _configBloc.value(ApiConfig.firebaseToken),
    );

    var response = await _restClientBloc.execute(
      request: request,
      retryCount: 5,
    );
    if (response.statusCode != 200) {
      throw AppTranslations.error_default_message;
    }
    var firebaseLoginToken = FirebaseLoginToken.fromDynamic(response.body);

    if (save == true) {
      await setFirebaseLoginToken(firebaseLoginToken);
    }

    return firebaseLoginToken;
  }

  Future<void> setCommunityId(String communityId) async {
    _communityId = communityId;

    await _secureStoreBloc.write(
      key: _kCommunityId,
      value: communityId,
    );
  }

  Future<void> setFirebaseLoginToken(
      FirebaseLoginToken firebaseLoginToken) async {
    _firebaseLoginToken = firebaseLoginToken;
    _firebaseLoginTokenStreamController?.add(firebaseLoginToken);

    await _secureStoreBloc.write(
      key: _kFirebaseKey,
      value: _firebaseLoginToken?.toString(),
    );
  }

  Future<void> setUser(UserLoginResponse loginResponse) async {
    _user = loginResponse?.userToken;
    _firebaseLoginToken = loginResponse?.firebaseLoginToken;

    _userStreamController?.add(_user);
    _firebaseLoginTokenStreamController?.add(_firebaseLoginToken);

    await _secureStoreBloc.delete(key: _kCommunityId);
    await _secureStoreBloc.write(
      key: _kFirebaseKey,
      value: _firebaseLoginToken?.toString(),
    );
    await _secureStoreBloc.write(
      key: _kUserKey,
      value: _user?.toString(),
    );
  }
}
