import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class ParadeParticipant extends Jsonable {
  ParadeParticipant({
    @required this.latitude,
    @required this.lead,
    @required this.longitude,
    @required this.userId,
  })  : assert(latitude != null),
        assert(lead != null),
        assert(longitude != null),
        assert(userId != null);

  final double latitude;
  final bool lead;
  final double longitude;
  final String userId;

  static ParadeParticipant fromDynamic(
    dynamic map, {
    String userId,
  }) {
    ParadeParticipant result;

    if (map != null) {
      result = ParadeParticipant(
        latitude: Jsonable.parseDouble(map['latitude']),
        lead: Jsonable.parseBool(map['lead']),
        longitude: Jsonable.parseDouble(map['longitude']),
        userId: userId ?? map['userId'],
      );
    }

    return result;
  }

  static Map<String, ParadeParticipant> fromDynamicMap(dynamic dMap) {
    Map<String, ParadeParticipant> results;

    if (dMap != null) {
      results = {};

      dMap.forEach(
        (key, value) => results[key] = fromDynamic(
          value,
          userId: key,
        ),
      );
    }

    return results;
  }

  static Map<String, dynamic> toDynamicMap(
      Map<String, ParadeParticipant> participants) {
    Map<String, dynamic> result;

    if (participants != null) {
      result = <String, dynamic>{};

      participants.forEach((key, value) => result[key] = value.toJson());
    }

    return result;
  }

  LatLng toLatLng() => LatLng(latitude, longitude);

  @override
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'lead': lead,
        'longitude': longitude,
        'userId': userId,
      };
}
