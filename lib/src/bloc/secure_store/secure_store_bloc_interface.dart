import 'package:meta/meta.dart';

abstract class SecureStoreBlocInterface {
  Future<void> initialize();
  void dispose();

  Future<void> delete({@required String key});
  Future<void> deleteAll();
  Future<String> read({@required String key});
  Future<void> write({@required String key, String value});
}
