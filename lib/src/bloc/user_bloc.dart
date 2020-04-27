import 'dart:async';
import 'dart:convert';

import 'package:community_parade/src/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserBloc {
  static const _kUserKey = 'user';

  FlutterSecureStorage _storage;
  User _user;
  StreamController<User> _userStreamController =
      StreamController<User>.broadcast();

  User get user => _user;
  Stream get userStream => _userStreamController.stream;

  Future<void> initialize() async {
    _storage = FlutterSecureStorage();

    var userInfoStr = await _storage.read(key: _kUserKey);
    if (userInfoStr?.isNotEmpty == true) {
      try {
        var user = User.fromDynamic(json.decode(userInfoStr));
        setUser(user);
      } catch (e) {
        await _storage.deleteAll();
      }
    }
  }

  void dispose() {
    _userStreamController?.close();
    _userStreamController = null;
  }

  void setUser(User user) {
    _user = user;
    _userStreamController.add(_user);
  }
}
