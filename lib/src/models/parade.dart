import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class Parade extends Jsonable {
  Parade({
    @required this.rallyPoint,
    @required this.startDateTime,
  }) : assert(startDateTime != null);

  final LatLng rallyPoint;
  final DateTime startDateTime;

  static Parade fromDynamic(dynamic map) {
    Parade result;

    if (map != null) {
      var rallyPoint = map['rallyPoint'];

      result = Parade(
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
        'rallyPoint': {
          'latitude': rallyPoint.latitude,
          'longitude': rallyPoint.longitude,
        },
        'startDateTime': startDateTime.millisecondsSinceEpoch,
      };
}
