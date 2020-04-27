import 'package:meta/meta.dart';

@immutable
class TranslationEntry {
  const TranslationEntry({@required this.key, @required this.value})
      : assert(key != null),
        assert(value != null);

  final String key;
  final String value;
}
