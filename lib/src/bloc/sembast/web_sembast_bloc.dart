import 'package:community_parade/src/bloc/sembast/sembast_bloc_interface.dart';
import 'package:community_parade/src/models/data_store.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';

SembastBlocInterface createSembastBloc({
  @required String name,
  @required int version,
}) =>
    _WebSembastBlocInterface(
      name: name,
      version: version,
    );

class _WebSembastBlocInterface implements SembastBlocInterface {
  _WebSembastBlocInterface({
    @required this.name,
    @required this.version,
  })  : assert(name?.isNotEmpty == true),
        assert(version != null),
        assert(version >= 1);

  final String name;
  final int version;

  Database _database;

  @override
  Database get database => _database;

  @override
  Future<void> initialize() async {
    _database = await databaseFactoryWeb.openDatabase(
      name,
      version: version,
      onVersionChanged: (database, _, __) async {
        for (var dbStore in DataStore.all) {
          await store(dbStore).delete(database);
        }
      },
    );
  }

  @override
  void dispose() {
    _database?.close();
    _database = null;
  }

  @override
  Future<void> clear() async {
    for (var dataStore in DataStore.all) {
      await store(dataStore).delete(database);
    }
  }

  @override
  StoreRef store(DataStore dataStore) =>
      dataStore.storeFactory.store(dataStore.name);
}
