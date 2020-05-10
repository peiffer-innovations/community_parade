import 'package:community_parade/src/models/birthday_person.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class Parade extends Jsonable {
  Parade({
    @required this.active,
    @required this.birthdays,
    @required this.id,
    @required this.rallyPoint,
    @required this.startDateTime,
  })  : assert(id?.isNotEmpty == true),
        assert(startDateTime != null);

  final bool active;
  final List<BirthdayPerson> birthdays;
  final String id;
  final LatLng rallyPoint;
  final DateTime startDateTime;

  static Parade fromDynamic(
    dynamic map, {
    String id,
  }) {
    Parade result;

    if (map != null) {
      var rallyPoint = map['rallyPoint'];

      result = Parade(
        active: Jsonable.parseBool(map['active']),
        birthdays: BirthdayPerson.fromDynamicList(map['birthdays']),
        id: id ?? map['id'],
        rallyPoint: rallyPoint?.isNotEmpty == true
            ? LatLng(
                Jsonable.parseDouble(rallyPoint['latitude']),
                Jsonable.parseDouble(rallyPoint['longitude']),
              )
            : null,
        startDateTime: Jsonable.parseUtcMillis(map['startDateTime']),
      );
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'active': active,
        'birthdays': Jsonable.toJsonList(birthdays),
        'id': id,
        'rallyPoint': rallyPoint == null
            ? null
            : {
                'latitude': rallyPoint.latitude,
                'longitude': rallyPoint.longitude,
              },
        'startDateTime': startDateTime.millisecondsSinceEpoch,
      };
}
