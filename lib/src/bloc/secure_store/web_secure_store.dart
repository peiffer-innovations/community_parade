import 'package:community_parade/src/bloc/secure_store/secure_store_bloc_interface.dart';

SecureStoreBlocInterface createSecureStore() => _WebSecureStoreBloc();

class _WebSecureStoreBloc implements SecureStoreBlocInterface {
  Map<String, String> _data;

  @override
  Future<void> initialize() async {
    _data = <String, String>{};
  }

  @override
  void dispose() {
    _data = null;
  }

  @override
  Future<void> delete({String key}) async => _data?.remove(key);

  @override
  Future<void> deleteAll() async => _data?.clear();

  @override
  Future<String> read({String key}) async => _data == null ? null : _data[key];

  @override
  Future<void> write({
    String key,
    String value,
  }) async =>
      _data == null ? null : _data[key] = value;
}
