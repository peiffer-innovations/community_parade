import 'package:community_parade/src/bloc/config_bloc.dart';
import 'package:community_parade/src/bloc/firebase/firebase_bloc_interface.dart';
import 'package:community_parade/src/bloc/user_bloc.dart';
import 'package:meta/meta.dart';

FirebaseBlocInterface createFirebaseInstance({
  @required ConfigBloc configBloc,
  @required UserBloc userBloc,
}) =>
    throw UnimplementedError();
