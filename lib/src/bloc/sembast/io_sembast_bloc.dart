import 'package:community_parade/src/bloc/sembast/sembast_bloc_interface.dart';
import 'package:community_parade/src/models/data_store.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

SembastBlocInterface createSembastBloc({
  @required String name,
  @required int version,
}) =>
    _IoSembastBlocInterface(
      name: name,
      version: version,
    );

class _IoSembastBlocInterface implements SembastBlocInterface {
  _IoSembastBlocInterface({
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
    var path = join((await getApplicationDocumentsDirectory()).path, name);
    _database = await databaseFactoryIo.openDatabase(
      '$path/$name',
      version: version,
      onVersionChanged: (database, _, __) async {
        for (var dataStore in DataStore.all) {
          await store(dataStore).delete(database);
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
