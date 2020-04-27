import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class User extends Jsonable {
  User({
    this.firstName,
    this.lastName,
    this.token,
    this.userId,
  })  : assert(firstName?.isNotEmpty == true),
        assert(lastName?.isNotEmpty == true),
        assert(token?.isNotEmpty == true),
        assert(userId?.isNotEmpty == true);

  final String firstName;
  final String lastName;
  final String token;
  final String userId;

  static User fromDynamic(dynamic map) {
    User result;

    if (map != null) {
      result = User(
        firstName: map['firstName'],
        lastName: map['lastName'],
        token: map['token'],
        userId: map['userId'],
      );
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'token': token,
        'userId': userId,
      };
}
