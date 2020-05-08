import 'package:community_parade/src/config/config_entry.dart';

class FirebaseConfig {
  static const base_path = ConfigEntry(
    key: 'basePath',
    prefix: _prefix,
    value: '/production',
  );

  static const _prefix = 'firebase';
}
