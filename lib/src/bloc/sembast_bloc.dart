import 'package:community_parade/src/bloc/sembast/sembast_bloc_interface.dart';
import 'package:community_parade/src/models/data_store.dart';
import 'package:sembast/sembast.dart';

// ignore: uri_does_not_exist
import 'sembast/stub_sembast_bloc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'sembast/web_sembast_bloc.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'sembast/io_sembast_bloc.dart';

const _kDbVersion = 1;

class SembastBloc implements SembastBlocInterface {
  SembastBloc({
    String name = 'parade.db',
  }) : _sb = createSembastBloc(
          name: name,
          version: _kDbVersion,
        );

  final SembastBlocInterface _sb;

  @override
  Future<void> initialize() => _sb.initialize();

  @override
  void dispose() => _sb.dispose();

  @override
  Database get database => _sb.database;

  @override
  Future<void> clear() => _sb.clear();

  @override
  StoreRef store(DataStore dataStore) => _sb.store(dataStore);
}
