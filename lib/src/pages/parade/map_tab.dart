import 'dart:async';

import 'package:community_parade/src/bloc/community_bloc.dart';
import 'package:community_parade/src/bloc/gps_bloc.dart';
import 'package:community_parade/src/bloc/parade_bloc.dart';
import 'package:community_parade/src/bloc/translations_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/models/community.dart';
import 'package:community_parade/src/models/parade.dart';
import 'package:community_parade/src/theme/app_color.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

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

  Community _community;
  CommunityBloc _communityBloc;
  LocationData _currentPosition;
  GpsBloc _gpsBloc;
  Parade _parade;
  ParadeBloc _paradeBloc;
  TranslationsBloc _translationsBloc;
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();

    _communityBloc = Provider.of<CommunityBloc>(
      context,
      listen: false,
    );

    _paradeBloc = Provider.of<ParadeBloc>(
      context,
      listen: false,
    );

    _gpsBloc = Provider.of<GpsBloc>(
      context,
      listen: false,
    );
    var throttle = Throttle<LocationData>(Duration(seconds: 1));

    _subscriptions.add(_gpsBloc.stream.listen(throttle.setValue));
    _subscriptions.add(
      throttle.values.listen(
        (position) {
          _currentPosition = position;
          if (mounted == true) {
            setState(() {});
          }
        },
      ),
    );

    _translationsBloc = Provider.of<TranslationsBloc>(
      context,
      listen: false,
    );

    _userBloc = Provider.of<UserBloc>(
      context,
      listen: false,
    );

    _subscriptions.add(_paradeBloc.subscribe().listen((parade) {
      _parade = parade;
      if (mounted == true) {
        setState(() {});
      }
    }));

    _initialize();
  }

  @override
  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    super.dispose();
  }

  Future<void> _initialize() async {
    _community = await _communityBloc.getCommunity(_userBloc.communityId);

    if (mounted == true) {
      setState(() {});
    }
  }

  List<CircleMarker> _buildCircleMarkers() {
    var markers = <CircleMarker>[];

    if (_currentPosition != null) {
      var latLng = LatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );

      const radius = 6.0;
      markers.add(CircleMarker(
        color: AppColor.primaryColor.withAlpha(50),
        point: latLng,
        radius: _currentPosition.accuracy,
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

  List<Marker> _buildMarkers() {
    var markers = <Marker>[];
    var size = 40.0;

    markers.add(
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.bottom),
        builder: (BuildContext context) => Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 2.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: size,
              width: size,
              child: Icon(
                FlutterIcons.flag_checkered_faw5s,
                size: 24.0,
              ),
            ),
          ),
        ),
        height: size,
        point: _parade.rallyPoint,
        width: size,
      ),
    );

    for (var birthday in _parade.birthdays) {
      markers.add(
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.bottom),
          builder: (BuildContext context) => Material(
            borderRadius: BorderRadius.circular(20.0),
            elevation: 2.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: size,
                width: size,
                child: Icon(
                  Icons.cake,
                  color: Colors.pink,
                  size: 24.0,
                ),
              ),
            ),
          ),
          height: size,
          point: birthday.latLng,
          width: size,
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return _parade == null || _community == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : FlutterMap(
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: [
                  'a',
                  'b',
                  'c',
                ],
              ),
              MarkerLayerOptions(
                markers: _buildMarkers(),
              ),
              CircleLayerOptions(
                circles: _buildCircleMarkers(),
              )
            ],
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(
                  (_community.bounds.northEast.latitude +
                          _community.bounds.southWest.latitude) /
                      2.0,
                  (_community.bounds.northEast.longitude +
                          _community.bounds.southWest.longitude) /
                      2.0),
              interactive: true,
              zoom: 14.0,
            ),
          );
  }
}
