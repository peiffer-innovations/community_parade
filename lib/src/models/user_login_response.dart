import 'package:community_parade/src/models/firebase_login_token.dart';
import 'package:community_parade/src/models/user_token.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class UserLoginResponse extends Jsonable {
  UserLoginResponse({
    @required this.firebaseLoginToken,
    @required this.userToken,
  })  : assert(firebaseLoginToken != null),
        assert(userToken != null);

  final FirebaseLoginToken firebaseLoginToken;
  final UserToken userToken;

  static UserLoginResponse fromDynamic(dynamic map) {
    UserLoginResponse result;

    if (map != null) {
      result = UserLoginResponse(
        firebaseLoginToken: FirebaseLoginToken.fromDynamic(
          map['firebaseToken'],
        ),
        userToken: UserToken.fromDynamic(
          map['userToken'],
        ),
      );
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'firebaseLoginToken': firebaseLoginToken?.toJson(),
        'userToken': userToken?.toJson(),
      };
}
