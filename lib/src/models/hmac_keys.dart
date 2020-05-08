import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class HmacKeys extends Jsonable {
  HmacKeys({
    @required this.clientId,
    @required this.message,
  })  : assert(clientId?.isNotEmpty == true),
        assert(message?.isNotEmpty == true);

  final String clientId;
  final String message;

  static HmacKeys fromDynamic(dynamic map) {
    HmacKeys result;

    if (map != null) {
      result = HmacKeys(
        clientId: map['clientId'],
        message: map['message'],
      );
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'clientId': clientId,
        'message': message,
      };
}
