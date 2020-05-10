import 'dart:async';

import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/models/parade.dart';
import 'package:community_parade/src/models/parade_geo_point.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

class ParadeBloc {
  ParadeBloc({
    @required FirebaseBloc firebaseBloc,
    @required UserBloc userBloc,
  })  : assert(firebaseBloc != null),
        assert(userBloc != null),
        _firebaseBloc = firebaseBloc,
        _userBloc = userBloc;

  final FirebaseBloc _firebaseBloc;
  final List<StreamSubscription> _subscriptions = [];
  final UserBloc _userBloc;

  Parade _parade;
  String _paradeId;
  StreamController<Parade> _streamController =
      StreamController<Parade>.broadcast();

  String get paradeId => _paradeId;
  Stream<Parade> get stream => _streamController?.stream;

  Future<void> initialize() async {}

  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions.clear();

    _streamController?.close();
    _streamController = null;
  }

  Future<List<Parade>> getParades() async {
    var communityId = _userBloc.communityId;
    var result = <Parade>[];
    var local = DateTime.now().toLocal();
    var format = 'yyyy-MM-dd';

    var dateFormat = DateFormat(format);

    var formatted = dateFormat.format(local);

    var value = await _firebaseBloc.once(
      [
        'data',
        'parades',
        communityId,
      ],
      keep: true,
      minKey: formatted,
    );

    if (value != null) {
      value.forEach(
        (key, value) => result.add(
          Parade.fromDynamic(
            value,
            id: key,
          ),
        ),
      );
    }

    return result;
  }

  void setParadeId(String paradeId) => _paradeId = paradeId;

  Stream<Parade> subscribe({
    StreamController<ParadeGeoPoint> participantStreamController,
  }) {
    assert(_paradeId != null);

    var communityId = _userBloc.communityId;
    var controller = StreamController<Parade>();
    var paradeSubscription = _firebaseBloc.listen(
      [
        'data',
        'parades',
        communityId,
        _paradeId,
      ],
      onError: null,
      onValue: ({key, value}) async {
        var parade = Parade.fromDynamic(
          value,
          id: _paradeId,
        );
        _parade = parade;
        if (parade != null) {
          controller.add(parade);
        }
      },
    );

    controller.onCancel = () {
      if (controller.hasListener != true) {
        paradeSubscription?.cancel();
        controller.close();
      }
    };

    if (participantStreamController != null) {
      var children = [
        'data',
        'parade_participants',
        communityId,
        _paradeId,
      ];
      _firebaseBloc.once(children).then((value) {
        value?.forEach((key, value) {
          var position = ParadeGeoPoint.fromDynamic(
            value,
            userId: key,
          );
          if (position != null) {
            participantStreamController.add(position);
          }
        });
      });

      var participantSubscription =
          _firebaseBloc.onChildChanged(children, onValue: ({key, value}) async {
        var position = ParadeGeoPoint.fromDynamic(
          value,
          userId: key,
        );
        if (position != null) {
          participantStreamController.add(position);
        }
      });
      participantStreamController.onCancel = () {
        participantSubscription?.cancel();
      };
    }

    return controller.stream;
  }

  Future<void> updatePosition(LocationData position) async {
    if (_parade?.active == true) {
      var communityId = _userBloc.communityId;
      var userId = _userBloc.user.userId;
      await _firebaseBloc.set(
        [
          'data',
          'parade_participants',
          communityId,
          _paradeId,
          userId,
        ],
        value: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );
    }
  }
}
