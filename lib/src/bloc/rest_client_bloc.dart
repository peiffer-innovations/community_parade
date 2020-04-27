import 'dart:async';
import 'dart:convert';

import 'package:community_parade/src/bloc/crypto_bloc.dart';
import 'package:community_parade/src/components/types.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

class RestClientBloc {
  RestClientBloc({
    @required Client client,
    @required CryptoBloc cryptoBloc,
  })  : assert(client != null),
        assert(cryptoBloc != null),
        _client = client,
        _cryptoBloc = cryptoBloc;

  final CryptoBloc _cryptoBloc;

  Client _client;

  Client get client => _client;

  Future<void> initialize() async {}

  void dispose() {
    _client = null;
  }

  Future<Response> execute({
    StreamController<Response> emitter,
    OnError onError,
    @required Request request,
    int retryCount = 0,
    Duration retryDelay = const Duration(seconds: 1),
    DelayStrategy retryDelayStrategy,
    Duration timeout,
  }) async {
    Response response;
    try {
      response = await _client.execute(
        authorizer: _HmacAuthorizor(
          clientId: _cryptoBloc.hmacKeys.clientId,
          secretKey: _cryptoBloc.hmacKeys.message,
        ),
        emitter: emitter,
        request: request,
        retryCount: retryCount,
        retryDelayStrategy: retryDelayStrategy,
        timeout: timeout,
      );
    } catch (e, stack) {
      if (onError != null) {
        await onError(
          error: e,
          name: 'RestClientBloc.execute',
          stack: stack,
        );
      } else {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: stack,
        ));
      }
    }

    return response;
  }
}

@immutable
class _HmacAuthorizor extends Authorizer {
  _HmacAuthorizor({
    this.clientId,
    this.secretKey,
    @visibleForTesting this.timestamp,
  })  : assert(clientId?.isNotEmpty == true),
        assert(secretKey?.isNotEmpty == true);

  final String clientId;
  final String secretKey;
  final DateTime timestamp;

  @override
  void secure(http.Request httpRequest) {
    assert(httpRequest != null);

    var timestamp = (this.timestamp ?? DateTime.now())
        .toUtc()
        .millisecondsSinceEpoch
        .toString();
    httpRequest.headers['x-timestamp'] = timestamp;

    var body = httpRequest.body ?? '';
    var path = httpRequest.url.path;

    var message = '$timestamp|$path|$body';
    var key = utf8.encode(secretKey);
    var bytes = utf8.encode(message);

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    var signature = digest.toString();
    httpRequest.headers['authorization'] = 'HMAC $clientId:$signature';
  }
}
