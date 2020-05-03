import 'package:community_parade/src/config/config_entry.dart';

class FirebaseConfig {
  static const base_path = ConfigEntry(
    key: 'base_path',
    prefix: _prefix,
    value: '/production/data/v1',
  );

  static const _prefix = 'firebase';
}
