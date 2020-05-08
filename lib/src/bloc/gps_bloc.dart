import 'dart:async';

import 'package:geolocator/geolocator.dart' show Geolocator, Position;
import 'package:location/location.dart';
import 'package:logging/logging.dart';

class GpsBloc {
  static final Logger _logger = Logger('GpsBloc');

  StreamController<LocationData> _geoStreamController =
      StreamController<LocationData>.broadcast();
  StreamSubscription<LocationData> _geoSubscription;

  Stream<LocationData> get stream => _geoStreamController?.stream;

  Future<void> initialize() async {
    var location = Location();
    await location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0.0,
      interval: 1000,
    );
  }

  void dispose() {
    _geoStreamController?.close();
    _geoStreamController = null;
  }

  Future<LocationData> getCurrentPosition() async {
    LocationData position;

    var enabled = await _bootstrap();
    if (enabled == true) {
      var location = Location();

      position = await location.getLocation();
    }

    return position;
  }

  Future<Position> geoPointsForAddress(String address) async {
    var geolocator = Geolocator();
    var placemarks = await geolocator?.placemarkFromAddress(address);
    var position = placemarks?.first?.position;
    return position;
  }

  void startListening() async {
    await stopListening();

    var enabled = await _bootstrap();
    if (enabled == true) {
      await _startListening();
    }
  }

  Future<void> stopListening() async {
    await _geoSubscription?.cancel();
    _geoSubscription = null;
  }

  Future<bool> _bootstrap() async {
    var location = Location();
    var result = false;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    if (_serviceEnabled == true) {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
      }
      if (_permissionGranted == PermissionStatus.granted) {
        try {
          await location.getLocation();
          result = true;
        } catch (e, stack) {
          _logger.severe('Error getting location', e, stack);
        }
      }
    }

    return result;
  }

  Future<void> _startListening() async {
    var location = Location();
    _geoSubscription = location.onLocationChanged.listen(
      (event) => _geoStreamController.add(event),
    );
  }
}
