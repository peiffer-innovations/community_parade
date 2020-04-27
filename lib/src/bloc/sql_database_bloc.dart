import 'dart:io';

import 'package:community_parade/src/components/types.dart';
import 'package:community_parade/src/sql/sql_statements.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const _kDatabaseName = 'community_parade.db';
const _kDatabaseVersion = 1;

class SqlDatabaseBloc {
  static final Logger _logger = Logger('SqlDatabaseBloc');

  final SqlStatements _stmts = SqlStatements();

  Database _database;

  Future<void> initialize() async {}

  void dispose() {
    _database?.close();
    _database = null;
  }

  Future<void> clearTables() async {
    var rs = await _database
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    rs.forEach((Map<String, dynamic> row) async {
      String name = row['name'];
      if (name != 'android_metadata' && name != 'ios_metadata') {
        await _database.execute('DELETE FROM $name');
      }
    });
  }

  Future<void> executeDelete(
    String sql, {
    List<dynamic> arguments,
    OnError onError,
  }) async {
    try {
      await _database.rawDelete(sql, arguments);
    } catch (e, stack) {
      await _handleError(
        error: e,
        onError: onError,
        name: 'SqlDatabaseBloc.executeDelete',
        stack: stack,
      );
    }
  }

  Future<List<Map<String, dynamic>>> executeQuery(
    String sql, {
    List<dynamic> arguments,
    OnError onError,
  }) async {
    try {
      return _database.rawQuery(sql, arguments);
    } catch (e, stack) {
      await _handleError(
        error: e,
        onError: onError,
        name: 'SqlDatabaseBloc.executeQuery',
        stack: stack,
      );
      rethrow;
    }
  }

  Future<void> executeTransaction<T>(
    Future<T> Function(Transaction txn) transaction, {
    OnError onError,
  }) async {
    try {
      await _database.transaction(transaction);
    } catch (e, stack) {
      await _handleError(
        error: e,
        onError: onError,
        name: 'SqlDatabaseBloc.executeTransaction',
        stack: stack,
      );
    }
  }

  /// Performs a full DB reset by dropping all tables and indicies and
  /// rebuilding from the create scripts.
  Future<void> reset() async {
    await _deleteTables(_database);
    await _createTables(_database);
  }

  Future<void> _handleError({
    @required dynamic error,
    @required String name,
    OnError onError,
    StackTrace stack,
  }) async {
    if (onError != null) {
      await onError(
        error: error,
        name: name,
        stack: stack,
      );
    } else {
      FlutterError.onError(
        FlutterErrorDetails(
          exception: error,
          library: 'database_common',
          stack: stack,
        ),
      );
    }
  }

  Future<void> _initializeDatabase({OnError onError}) async {
    try {
      var databasePath = join(await _getDatabasePath(), _kDatabaseName);

      _database = await openDatabase(
        databasePath,
        version: _kDatabaseVersion,
        onCreate: (
          Database db,
          int version,
        ) async {
          await _createTables(db);
        },
        onUpgrade: (
          Database db,
          int oldVersion,
          int newVersion,
        ) async {
          await _deleteTables(db);
          await _createTables(db);
        },
      );
    } catch (e, stack) {
      _logger.severe('Error initializing database', e, stack);
      await _handleError(
        error: e,
        name: 'SqlDatabaseBloc._initializeDatabase',
        onError: onError,
        stack: stack,
      );
    }
  }

  Future<void> _createTables(Database db) async {
    var statements = <String>[];
    statements.addAll(_stmts.createScripts);

    for (var stmt in statements) {
      if (stmt?.isNotEmpty == true) {
        await db.execute(stmt);
      }
    }
  }

  Future<void> _deleteTables(Database db) async {
    var rs =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
    rs.forEach((Map<String, dynamic> row) async {
      String name = row['name'];
      if (name != 'android_metadata' && name != 'ios_metadata') {
        await db.execute('DROP TABLE $name');
      }
    });
  }

  Future<String> _getDatabasePath() async {
    String path;
    if (Platform.isIOS) {
      path = (await getApplicationSupportDirectory()).path;
    } else if (Platform.isAndroid) {
      try {
        var externalPath = (await getExternalStorageDirectory())?.path;

        assert(() {
          path = externalPath;
          return true;
        }());

        if (path != null) {
          var dir = Directory(path);
          dir.createSync();
        }
      } catch (e, stack) {
        assert(() {
          _logger.severe('Unable to get external storage directory', e, stack);
          return true;
        }());
      }
    }
    path ??= await getDatabasesPath();

    assert(() {
      _logger.fine('DB path: $path');

      return true;
    }());

    return path;
  }
}
