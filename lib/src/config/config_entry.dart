import 'package:meta/meta.dart';

class ConfigEntry<T> {
  const ConfigEntry({
    @required this.key,
    @required this.prefix,
    this.value,
  })  : assert(key != null),
        assert(prefix != null);

  final String key;
  final String prefix;
  final T value;
}
