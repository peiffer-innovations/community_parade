import 'package:community_parade/src/models/birthday_person.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class ParadeLocation extends Jsonable {
  ParadeLocation({
    @required this.address,
    @required this.latitude,
    @required this.longitude,
    @required this.people,
  })  : assert(address?.isNotEmpty == true),
        assert(longitude != null),
        assert(latitude != null),
        assert(people?.isNotEmpty == true);

  final String address;
  final double latitude;
  final double longitude;
  final List<BirthdayPerson> people;

  static ParadeLocation fromDynamic(dynamic map) {
    ParadeLocation result;

    if (map != null) {
      result = ParadeLocation(
        address: map['address'],
        latitude: Jsonable.parseDouble(map['latitude']),
        longitude: Jsonable.parseDouble(map['longitude']),
        people: BirthdayPerson.fromDynamicList(map['people']),
      );
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'people': Jsonable.toJsonList(people),
      };
}
