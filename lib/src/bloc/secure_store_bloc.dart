import 'package:community_parade/src/bloc/secure_store/secure_store_bloc_interface.dart';
import 'package:meta/meta.dart';

// ignore: uri_does_not_exist
import 'secure_store/stub_secure_store_bloc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'secure_store/web_secure_store_bloc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'secure_store/io_secure_store_bloc.dart';

class SecureStoreBloc implements SecureStoreBlocInterface {
  SecureStoreBloc() : _secureStore = createSecureStore();

  final SecureStoreBlocInterface _secureStore;

  @override
  Future<void> initialize() => _secureStore.initialize();

  @override
  void dispose() => _secureStore.dispose();

  @override
  Future<void> delete({@required String key}) => _secureStore.delete(key: key);

  @override
  Future<void> deleteAll() => _secureStore.deleteAll();

  @override
  Future<String> read({@required String key}) => _secureStore.read(key: key);

  @override
  Future<void> write({@required String key, String value}) =>
      _secureStore.write(
        key: key,
        value: value,
      );
}
