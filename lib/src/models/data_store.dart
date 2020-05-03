import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

@immutable
class DataStore {
  DataStore._(
    this.name,
    StoreFactory storeFactory,
  )   : assert(name?.isNotEmpty == true),
        storeFactory = storeFactory ?? stringMapStoreFactory;

  static final _all = <DataStore>[];

  final String name;
  final StoreFactory storeFactory;

  static List<DataStore> get all => List.unmodifiable(_all);
}
