import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

class FirebaseLoginToken extends Jsonable {
  FirebaseLoginToken({
    @required this.expires,
    @required String token,
  })  : assert(expires != null),
        assert(token?.isNotEmpty == true),
        _token = token;
  final DateTime expires;
  final String _token;

  String get token => valid == true ? _token : null;
  bool get valid => expires.compareTo(DateTime.now()) >= 0;

  static FirebaseLoginToken fromDynamic(dynamic map) {
    FirebaseLoginToken result;

    if (map != null) {
      result = FirebaseLoginToken(
        expires: Jsonable.parseUtcMillis(map['expires']),
        token: map['token'],
      );
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'expires': expires?.millisecondsSinceEpoch,
        'token': token,
        'valid': valid,
      };
}
