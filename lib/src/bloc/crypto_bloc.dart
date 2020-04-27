import 'dart:convert';

import 'package:community_parade/src/crypto/crypto.dart';
import 'package:community_parade/src/models/hmac_keys.dart';
import 'package:flutter/services.dart';

class CryptoBloc {
  static const _k = '+sUTfJxaa0kJkWxZnhNW/vpzc8vRKMIkjb4XKkUOVEI=';

  Crypto _crypto;
  HmacKeys _hmacKeys;

  HmacKeys get hmacKeys => _hmacKeys;

  Future<void> initialize() async {
    _crypto = Crypto(base64Key: _k);

    var encrypted = await rootBundle.loadString('assets/secure/keys.txt');
    encrypted = encrypted.trim();

    _hmacKeys = HmacKeys.fromDynamic(json.decode(_crypto.decrypt(encrypted)));
  }

  void dispose() {
    _crypto = null;
  }

  String decrypt(String input) => _crypto.decrypt(input);
  String encrypt(String input) => _crypto.encrypt(input);
}
