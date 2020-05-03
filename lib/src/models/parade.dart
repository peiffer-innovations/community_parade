import 'package:community_parade/src/models/birthday_person.dart';
import 'package:community_parade/src/models/parade_participant.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class Parade extends Jsonable {
  Parade({
    @required this.active,
    @required this.birthdays,
    @required this.location,
    @required this.participants,
    @required this.rallyPoint,
    @required this.startDateTime,
  }) : assert(startDateTime != null);

  final bool active;
  final List<BirthdayPerson> birthdays;
  final LatLng location;
  final Map<String, ParadeParticipant> participants;
  final LatLng rallyPoint;
  final DateTime startDateTime;

  static Parade fromDynamic(dynamic map) {
    Parade result;

    if (map != null) {
      var location = map['location'];
      var rallyPoint = map['rallyPoint'];

      result = Parade(
        active: Jsonable.parseBool('active'),
        birthdays: BirthdayPerson.fromDynamicList(map['birthdays']),
        location: rallyPoint?.isNotEmpty == true
            ? LatLng(
                Jsonable.parseDouble(location['latitude']),
                Jsonable.parseDouble(location['longitude']),
              )
            : null,
        participants: ParadeParticipant.fromDynamicMap(map['participants']),
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
        'location': location == null
            ? null
            : {
                'latitude': location.latitude,
                'longitude': location.longitude,
              },
        'rallyPoint': rallyPoint == null
            ? null
            : {
                'latitude': rallyPoint.latitude,
                'longitude': rallyPoint.longitude,
              },
        'startDateTime': startDateTime.millisecondsSinceEpoch,
      };
}
