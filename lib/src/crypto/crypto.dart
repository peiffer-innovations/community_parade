import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' show FlutterError, FlutterErrorDetails;
import 'package:meta/meta.dart';

class Crypto {
  Crypto({
    @required String base64Key,
  })  : assert(base64Key != null),
        _encrypter = Encrypter(
          AES(
            Key.fromBase64(base64Key),
            mode: AESMode.cbc,
          ),
        );

  final Encrypter _encrypter;
  final Random _random = Random.secure();

  String decrypt(String base64Encrypted) {
    var result = base64Encrypted;
    try {
      if (base64Encrypted != null) {
        var pipe = base64Encrypted.indexOf('|');
        if (pipe < 0) {
          result = base64Encrypted;
        } else {
          result = _encrypter.decrypt64(
            base64Encrypted.substring(pipe + 1),
            iv: IV.fromBase64(
              base64Encrypted.substring(0, pipe),
            ),
          );
        }
      }
    } catch (e, stack) {
      FlutterError.onError(FlutterErrorDetails(
        exception: e,
        stack: stack,
      ));
    }

    return result;
  }

  String encrypt(
    String data, {
    @visibleForTesting String iv,
  }) {
    String result;
    if (data != null) {
      var realIv = iv ?? _createIv();
      var encrypted = _encrypter
          .encrypt(
            data,
            iv: IV.fromBase64(realIv),
          )
          .base64;

      result = '$realIv|$encrypted';
    }

    return result;
  }

  String _createIv() {
    var iv = <int>[];
    for (var i = 0; i < 16; i++) {
      iv.add(_random.nextInt(256));
    }

    return base64Encode(iv);
  }
}
