import 'dart:async';

import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:community_parade/src/models/parade.dart';
import 'package:intl/intl.dart';
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

  Stream<Parade> subscribe() {
    assert(_paradeId != null);

    var communityId = _userBloc.communityId;
    var controller = StreamController<Parade>();
    controller.onCancel = () {
      if (controller.hasListener != true) {
        controller.close();
      }
    };

    _firebaseBloc.listen(
      [
        'data',
        'parades',
        communityId,
        _paradeId,
      ],
      onError: null,
      onValue: (value) {
        var parade = Parade.fromDynamic(
          value,
          id: _paradeId,
        );
        if (parade != null) {
          controller.add(parade);
        }
      },
    );

    return controller.stream;
  }
}
