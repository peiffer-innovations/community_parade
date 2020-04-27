import 'dart:async';

import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/models/parade.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/rest_client.dart';

class ParadeBloc {
  ParadeBloc({
    @required FirebaseBloc firebaseBloc,
  })  : assert(firebaseBloc != null),
        _firebaseBloc = firebaseBloc;

  final List<StreamSubscription> _subscriptions = [];

  FirebaseBloc _firebaseBloc;

  Future<void> initialize() async {}

  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions.clear();
  }

  Stream<LatLng> subscribeToCurrentLocation(
    String communityId,
  ) {
    var controller = StreamController<LatLng>();
    controller.onCancel = () {
      if (controller.hasListener != true) {
        controller.close();
      }
    };

    _firebaseBloc.listen(
      [
        'communities',
        communityId,
        'parades',
        'current',
        'location',
      ],
      onError: null,
      onValue: (event) {
        LatLng latLng;
        try {
          var data = event.snapshot.value;

          latLng = LatLng(
            Jsonable.parseDouble(data['latitude']),
            Jsonable.parseDouble(data['longitude']),
          );
        } catch (e) {
          // no-op; ignore
        }

        if (latLng != null) {
          controller.add(latLng);
        }
      },
    );

    return controller.stream;
  }

  Stream<Parade> subscribeToDate(
    String communityId,
    DateTime dateTime,
  ) {
    var controller = StreamController<Parade>();
    controller.onCancel = () {
      if (controller.hasListener != true) {
        controller.close();
      }
    };

    var local = dateTime.toLocal();
    var format = 'yyyy-MM-dd';

    var dateFormat = DateFormat(format);

    var formatted = dateFormat.format(local);

    _firebaseBloc.listen(
      [
        'communities',
        communityId,
        'parades',
        formatted,
      ],
      onError: null,
      onValue: (event) {
        var parade = Parade.fromDynamic(event.snapshot.value);
        if (parade != null) {
          controller.add(parade);
        }
      },
    );

    return controller.stream;
  }
}
