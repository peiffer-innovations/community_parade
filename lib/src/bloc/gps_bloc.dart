import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GpsBloc {
  StreamController<Position> _geoStreamController =
      StreamController<Position>.broadcast();
  Geolocator _geolocator;
  StreamSubscription _geoSubscription;

  Future<void> initialize() async {
    _geolocator = Geolocator();
  }

  void dispose() {
    _geolocator = null;

    _geoStreamController?.close();
    _geoStreamController = null;
  }

  Future<Position> geoPointsForAddress(String address) async {
    var placemarks = await _geolocator?.placemarkFromAddress(address);
    var position = placemarks?.first?.position;
    return position;
  }

  void startListening() async {
    await stopListening();

    var status = await _geolocator?.checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.granted) {
      await _startListening();
    } else {
      await _geolocator.getCurrentPosition();
      status = await _geolocator?.checkGeolocationPermissionStatus();
      if (status == GeolocationStatus.granted) {
        await _startListening();
      }
    }
  }

  Future<void> stopListening() async {
    await _geoSubscription?.cancel();
    _geoSubscription = null;
  }

  Future<void> _startListening() async {
    _geoSubscription = _geolocator
        .getPositionStream(
          LocationOptions(
            accuracy: LocationAccuracy.best,
          ),
        )
        .listen(
          (event) => _geoStreamController.add(event),
        );
  }
}
