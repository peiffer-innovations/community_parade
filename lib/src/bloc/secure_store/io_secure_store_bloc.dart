import 'package:community_parade/src/bloc/secure_store/secure_store_bloc_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

SecureStoreBlocInterface createSecureStore() => _IoSecureStoreBloc();

class _IoSecureStoreBloc implements SecureStoreBlocInterface {
  FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {
    _storage = FlutterSecureStorage();
  }

  @override
  void dispose() {
    _storage = null;
  }

  @override
  Future<void> delete({String key}) => _storage?.delete(key: key);

  @override
  Future<void> deleteAll() => _storage?.deleteAll();

  @override
  Future<String> read({String key}) => _storage?.read(key: key);

  @override
  Future<void> write({
    String key,
    String value,
  }) =>
      value == null
          ? _storage.delete(key: key)
          : _storage?.write(
              key: key,
              value: value,
            );
}
