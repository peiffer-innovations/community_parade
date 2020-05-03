import 'package:community_parade/src/models/data_store.dart';
import 'package:sembast/sembast.dart';

abstract class SembastBlocInterface {
  Database get database;

  Future<void> initialize();
  void dispose();

  Future<void> clear();

  StoreRef store(DataStore dataStore);
}
