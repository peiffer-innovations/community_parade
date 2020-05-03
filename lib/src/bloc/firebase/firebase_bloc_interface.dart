import 'dart:async';

import 'package:community_parade/src/components/types.dart';
import 'package:flutter/material.dart';

abstract class FirebaseBlocInterface {
  Future<void> initialize();

  void dispose();

  StreamSubscription<dynamic> listen(
    List<String> children, {
    bool keep,
    @required OnError onError,
    @required ValueSetter<dynamic> onValue,
  });

  Future<String> login(String token);
  Future<void> logout();

  Future<dynamic> once(
    List<String> children, {
    bool keep,
    @required OnError onError,
  });
}
