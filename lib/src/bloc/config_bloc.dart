import 'dart:async';
import 'dart:convert';

import 'package:community_parade/src/bloc/rest_client_bloc.dart';
import 'package:community_parade/src/config/api_config.dart';
import 'package:community_parade/src/config/config_entry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

class ConfigBloc {
  ConfigBloc({
    @required RestClientBloc restClientBloc,
  })  : assert(restClientBloc != null),
        _restClientBloc = restClientBloc;

  static const _configEtagKey = 'configuration_etag';
  static const _configStorageKey = 'configuration';

  final RestClientBloc _restClientBloc;
  final Map<String, Map<String, dynamic>> _values = {};

  StreamController<void> _valuesController = StreamController<void>.broadcast();

  Stream<void> get valuesStream => _valuesController.stream;

  Future<void> initialize() async {
    await _load();
  }

  void dispose() {
    _valuesController?.close();
    _valuesController = null;
  }

  T value<T>(ConfigEntry<T> entry) {
    dynamic result;

    var section = _values[entry.prefix];
    if (section != null) {
      result = section[entry.key];
    }

    result ??= entry.value;

    if (result != null) {
      if (entry is ConfigEntry<String>) {
        // optimization; most are strings so this prevents the other checks
      } else if (entry is ConfigEntry<bool>) {
        result = Jsonable.parseBool(result);
      } else if (entry is ConfigEntry<int>) {
        result = Jsonable.parseInt(result);
      } else if (entry is ConfigEntry<double>) {
        result = Jsonable.parseDouble(result);
      }
    }

    return result;
  }

  void setConfigValues(dynamic values) {
    for (var entry in values.entries) {
      var section = _values[entry.key];
      if (section == null) {
        section = <String, dynamic>{};
        _values[entry.key] = section;
      } else {
        section = Map<String, dynamic>.from(section);
      }

      section.addAll(entry.value);
    }

    _valuesController.add(null);
  }

  void _backgroundRestClientLoad() => _restClientLoad();

  Future<void> _restClientLoad() async {
    var storage = FlutterSecureStorage();
    var etag = await storage.read(key: _configEtagKey);

    var request = Request(
      headers: {
        if (etag?.isNotEmpty == true) 'if-none-match': etag,
      },
      method: RequestMethod.get,
      url: value(ApiConfig.config),
    );

    var response = await _restClientBloc.execute(
      request: request,
    );

    if (response.statusCode == 200) {
      setConfigValues(response.body);
    }
  }

  Future<void> _load() async {
    var storage = FlutterSecureStorage();
    var data = await storage.read(key: _configStorageKey);
    Map<String, dynamic> values;
    if (data?.isNotEmpty == true) {
      try {
        values = json.decode(data);
        setConfigValues(values);
      } catch (e) {
        // no-op; fall back to the server values
      }
    }

    if (values == null) {
      await _restClientLoad();
    } else {
      _backgroundRestClientLoad();
    }
  }
}
