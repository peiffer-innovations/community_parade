import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class SqlStatements {
  factory SqlStatements() => _singleton;
  SqlStatements._internal();
  static final SqlStatements _singleton = SqlStatements._internal();

  final List<String> _createScripts = [];
  final Map<String, String> _statements = {};

  bool _initialized = false;

  Iterable<String> get createScripts => _createScripts
      .map((key) => _statements[key])
      .where((item) => item?.isNotEmpty == true);

  Future<void> initialize({
    List<String> all,
    List<String> create,
  }) async {
    _initialized = true;

    if (all != null) {
      for (var file in all) {
        await loadStatement(file: file);
      }
    }

    if (create != null) {
      for (var file in create) {
        addCreateTableScript(file: file);
      }
    }
  }

  String statement({@required String file}) {
    assert(_initialized == true);

    var stmt = _statements[_getKey(file: file)];

    assert(stmt?.isNotEmpty == true);

    return stmt;
  }

  List<String> statements({@required String file}) => statement(file: file)
      .split(';')
      .where((value) => value?.trim()?.isNotEmpty == true)
      .toList();

  void addCreateTableScript({
    @required String file,
    String package,
  }) =>
      _createScripts.add(_getKey(file: file));

  Future<void> loadStatement({@required String file}) async {
    assert(file?.isNotEmpty == true);

    var key = _getKey(file: file);

    if (_statements[key] == null) {
      _statements[key] = await rootBundle.loadString(
        key,
      );
      assert(_statements[key]?.isNotEmpty == true);
    }
  }

  String _getKey({@required String file}) => '/assets/sql/$file';
}
