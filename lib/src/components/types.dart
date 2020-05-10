import 'package:meta/meta.dart';

typedef KeyValueCallback<T> = Future<void> Function({
  @required String key,
  @required T value,
});

typedef OnError = Future<void> Function({
  @required dynamic error,
  @required String name,
  StackTrace stack,
});
