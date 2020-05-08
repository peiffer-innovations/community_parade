import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class BirthdayPerson extends Jsonable {
  BirthdayPerson({
    @required this.address,
    this.age,
    @required this.latLng,
    @required this.name,
  })  : assert(address?.isNotEmpty),
        assert(latLng != null),
        assert(name?.isNotEmpty == true);

  final String address;
  final int age;
  final LatLng latLng;
  final String name;

  static BirthdayPerson fromDynamic(dynamic map) {
    BirthdayPerson result;

    if (map != null) {
      result = BirthdayPerson(
        address: map['address'],
        age: Jsonable.parseInt(map['age']),
        latLng: LatLng(
          Jsonable.parseDouble(map['latitude']),
          Jsonable.parseDouble(map['longitude']),
        ),
        name: map['name'],
      );
    }

    return result;
  }

  static List<BirthdayPerson> fromDynamicList(dynamic list) {
    List<BirthdayPerson> results;

    if (list != null) {
      results = [];

      for (dynamic map in list) {
        results.add(fromDynamic(map));
      }
    }

    return results;
  }

  @override
  Map<String, dynamic> toJson() => {
        'address': address,
        'age': age,
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
        'name': name,
      };
}
