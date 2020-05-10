import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class ParadeGeoPoint extends Jsonable {
  ParadeGeoPoint({
    @required this.latitude,
    @required this.longitude,
    @required this.userId,
  })  : assert(latitude != null),
        assert(longitude != null),
        assert(userId?.isNotEmpty == true);

  final double latitude;
  final double longitude;
  final String userId;

  static ParadeGeoPoint fromDynamic(
    dynamic map, {
    String userId,
  }) {
    ParadeGeoPoint result;

    if (map != null) {
      // This is odd but for some reason the Web version of Firebase will return
      // the map as an object with direct latitude and longitude properties but
      // the native interface will return the object as a proper map.  This
      // mechanism abstracts this oddity from the rest of the app.
      var latLng = <String, double>{};
      try {
        latLng['latitude'] = Jsonable.parseDouble(map?.latitude);
        latLng['longitude'] = Jsonable.parseDouble(map?.longitude);
      } catch (e) {
        // no-op
      }

      result = ParadeGeoPoint(
        latitude: latLng['latitude'] ?? Jsonable.parseDouble(map['latitude']),
        longitude:
            latLng['longitude'] ?? Jsonable.parseDouble(map['longitude']),
        userId: userId ?? map['userId'],
      );
    }

    return result;
  }

  static Map<String, ParadeGeoPoint> fromDynamicMap(dynamic dMap) {
    Map<String, ParadeGeoPoint> results;

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
      Map<String, ParadeGeoPoint> participants) {
    Map<String, dynamic> result;

    if (participants != null) {
      result = <String, dynamic>{};

      participants.forEach((key, value) => result[key] = value.toJson());
    }

    return result;
  }

  LatLng get latLng => LatLng(latitude, longitude);

  @override
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'userId': userId,
      };
}
