import 'package:meta/meta.dart';

typedef OnError = Future<void> Function({
  @required dynamic error,
  @required String name,
  StackTrace stack,
});
