import 'dart:async';

import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/models/parade.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class ParadeBloc {
  ParadeBloc({
    @required FirebaseBloc firebaseBloc,
  })  : assert(firebaseBloc != null),
        _firebaseBloc = firebaseBloc;

  final FirebaseBloc _firebaseBloc;
  final List<StreamSubscription> _subscriptions = [];

  Future<void> initialize() async {}

  void dispose() {
    _subscriptions.forEach((sub) => sub.cancel());
    _subscriptions.clear();
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
      onValue: (value) {
        var parade = Parade.fromDynamic(value);
        if (parade != null) {
          controller.add(parade);
        }
      },
    );

    return controller.stream;
  }
}
