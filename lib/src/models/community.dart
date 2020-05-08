import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

@immutable
class Community extends Jsonable {
  Community({
    @required this.bounds,
    @required this.id,
    @required this.location,
    @required this.name,
  })  : assert(bounds != null),
        assert(id?.isNotEmpty == true),
        assert(location?.isNotEmpty == true),
        assert(name?.isNotEmpty == true);

  final LatLngBounds bounds;
  final String id;
  final String location;
  final String name;

  static Community fromDynamic(
    dynamic map, {
    String id,
  }) {
    Community result;

    if (map != null) {
      var northEast = LatLng(
        Jsonable.parseDouble(map['bounds']['northEast']['latitude']),
        Jsonable.parseDouble(map['bounds']['northEast']['longitude']),
      );
      var southWest = LatLng(
        Jsonable.parseDouble(map['bounds']['southWest']['latitude']),
        Jsonable.parseDouble(map['bounds']['southWest']['longitude']),
      );

      result = Community(
        bounds: LatLngBounds(
          northEast,
          southWest,
        ),
        id: id ?? map['id'],
        location: map['location'],
        name: map['name'],
      );
    }

    return result;
  }

  static List<Community> fromDynamicList(dynamic list) {
    List<Community> results;

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
        'bounds': {
          'northEast': {
            'latitude': bounds.northEast.latitude,
            'longitude': bounds.northEast.longitude,
          },
          'southWest': {
            'latitude': bounds.southWest.latitude,
            'longitude': bounds.southWest.longitude,
          }
        },
        'id': id,
        'location': location,
        'name': name,
      };
}
