import 'package:community_parade/src/config/config_entry.dart';
import 'package:meta/meta.dart';

class ApiConfig<T> extends ConfigEntry<T> {
  const ApiConfig._({
    @required String key,
    T value,
  }) : super(
          key: key,
          prefix: 'api',
          value: value,
        );

  static const attachCommunity = ApiConfig<String>._(
    key: 'attachCommunity',
  );

  static const communityFromCoordinates = ApiConfig<String>._(
    key: 'communityFromCoordinates',
  );

  static const communityFromUuid = ApiConfig<String>._(
    key: 'communityFromUuid',
  );

  static const config = ApiConfig<String>._(
    key: 'config',
    value: 'http://localhost:8080/api/config',
  );

  static const createAccount = ApiConfig<String>._(
    key: 'createAccount',
  );

  static const firebaseToken = ApiConfig<String>._(
    key: 'firebaseToken',
  );

  static const login = ApiConfig<String>._(
    key: 'login',
  );
}
