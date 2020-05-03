import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class UserToken extends Jsonable {
  UserToken({
    this.firstName,
    this.lastName,
    this.signature,
    this.userId,
  })  : assert(firstName?.isNotEmpty == true),
        assert(lastName?.isNotEmpty == true),
        assert(signature?.isNotEmpty == true),
        assert(userId?.isNotEmpty == true);

  final String firstName;
  final String lastName;
  final String signature;
  final String userId;

  static UserToken fromDynamic(dynamic map) {
    UserToken result;

    if (map != null) {
      result = UserToken(
        firstName: map['firstName'],
        lastName: map['lastName'],
        signature: map['signature'],
        userId: map['userId'],
      );
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'signature': signature,
        'userId': userId,
      };
}
