import 'dart:async';

import 'package:community_parade/src/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

class ParadeTab extends StatefulWidget {
  ParadeTab({
    Key key,
  }) : super(key: key);

  @override
  _ParadeTabState createState() => _ParadeTabState();
}

class _ParadeTabState extends State<ParadeTab> {
  final MapController _mapController = MapController();
  final List<StreamSubscription> _subscriptions = [];
  LocationData _currentLocationData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<CircleMarker> _buildCircleMarkers() {
    var markers = <CircleMarker>[];

    if (_currentLocationData != null) {
      var latLng = LatLng(
        _currentLocationData.latitude,
        _currentLocationData.longitude,
      );

      const radius = 6.0;
      markers.add(CircleMarker(
        color: AppColor.primaryColor.withAlpha(50),
        point: latLng,
        radius: _currentLocationData.accuracy,
        useRadiusInMeter: true,
      ));
      markers.add(CircleMarker(
        color: Colors.white,
        point: latLng,
        radius: radius + 2,
      ));
      markers.add(CircleMarker(
        color: AppColor.primaryColor,
        point: latLng,
        radius: radius,
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: [
            'a',
            'b',
            'c',
          ],
        ),
        CircleLayerOptions(
          circles: _buildCircleMarkers(),
        )
      ],
      mapController: _mapController,
    );
  }
}
