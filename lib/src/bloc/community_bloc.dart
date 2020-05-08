import 'package:community_parade/src/bloc/firebase_bloc.dart';
import 'package:community_parade/src/models/community.dart';
import 'package:meta/meta.dart';

class CommunityBloc {
  CommunityBloc({
    @required FirebaseBloc firebaseBloc,
  })  : assert(firebaseBloc != null),
        _firebaseBloc = firebaseBloc;

  final FirebaseBloc _firebaseBloc;

  Map<String, Community> _cache;

  Future<void> initialize() async {
    _cache = {};
  }

  void dispose() {
    _cache = null;
  }

  Future<Community> getCommunity(String communityId) async {
    var community = _cache[communityId];

    if (community == null) {
      var value = await _firebaseBloc.once(
        [
          'data',
          'community_metadata',
          'communities',
          communityId,
        ],
        onError: null,
      );

      community = Community.fromDynamic(
        value,
        id: communityId,
      );
      if (community != null) {
        _cache[communityId] = community;
      }
    }
    return community;
  }
}
