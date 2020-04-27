import 'package:community_parade/src/config/config_entry.dart';

class ApiConfig {
  ApiConfig._();

  static const config = ConfigEntry<String>(
    key: 'config',
    prefix: _prefix,
  );

  static const _prefix = 'api';
}
