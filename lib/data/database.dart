import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:log_book/services/index.dart';

class AppDatabase {
  // singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  // singleton accessor
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming sync to async functions
  Completer<Database> _dbOpenCompleter;

  // a private constructor. Allows us to create instances of AppDatabase
  AppDatabase._();

  // database object accessor
  Future<Database> get database async {
    // if completer is null, AppDatabaseClass is newly instantiated, so db is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // calling _openDatabase will also complete the completer with db instance
      _openDatabase();
    }

    // if db is already opened, awaiting the future will happen instantly
    // otherwise, awaiting the returned future will take some time - until complete() is called on the Completer in _openDatabase() below
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    // get a platform-specific directory where persistent app data can be stored
    final PathProviderWindows _provider = PathProviderWindows();

    final appDocumentDir = await _provider.getApplicationSupportPath();

    var currentDir = Directory.current;

    print(
        '[INFO] Windows application support path: $appDocumentDir | currentDir: ${currentDir.path}');

    // path with the form: //platform-specific-directory/logbook.db
    final dbPath = join(appDocumentDir, 'logbook.db');

    //TODO: database encryption
    //final _edc =  EncryptionDatabaseCodec(); // to check if encryption is enabled globally
    var codec = getEncryptSembastCodec(); // for internal database encryption
    //final database = await databaseFactoryIo.openDatabase(dbPath, codec: codec);
    //
    // TODO: consider database migration here
    final database = await databaseFactoryIo.openDatabase(
      dbPath,
      // codec: codec,
      onVersionChanged: (db, oldVersion, newVersion) async {
        // migrate old db to new db
        print('=== old version: $oldVersion | new version: $newVersion');
        print('=== passing ===');

        return db;
      },
    );

    //final database = await databaseFactoryIo.openDatabase(dbPath);

    // any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(database);
  }
}
