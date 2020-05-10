import 'dart:async';

import 'package:community_parade/src/components/types.dart';
import 'package:flutter/material.dart';

abstract class FirebaseBlocInterface {
  Future<void> initialize();

  void dispose();

  StreamSubscription<dynamic> listen(
    List<String> children, {
    bool keep,
    OnError onError,
    @required KeyValueCallback<dynamic> onValue,
  });

  Future<String> login(String token);
  Future<void> logout();

  StreamSubscription<dynamic> onChildChanged(
    List<String> children, {
    bool keep,
    OnError onError,
    @required KeyValueCallback<dynamic> onValue,
  });

  Future<dynamic> once(
    List<String> children, {
    bool keep,
    String minKey,
    OnError onError,
  });

  Future<void> set(
    List<String> children, {
    OnError onError,
    dynamic value,
  });
}
