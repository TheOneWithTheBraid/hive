import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';
import 'dart:js' as js;
import 'package:hive/hive.dart';
import 'package:hive/src/backend/js/native/storage_backend_js.dart';
import 'package:hive/src/backend/storage_backend.dart';

/// Opens IndexedDB databases
class BackendManager implements BackendManagerInterface {
  IdbFactory? get indexedDB => js.context.hasProperty('window')
      ? window.indexedDB
      : WorkerGlobalScope.instance.indexedDB;

  static Map<String?, Database> databases = {};

  @override
  Future<StorageBackend> open(String name, String? path, bool crashRecovery,
      HiveCipher? cipher, String? collection) async {
    Database db;

    // compatibility for old store format
    final databaseName = collection ?? name;
    final objectStoreName = collection == null ? 'box' : name;

    if (databases.containsKey(databaseName)) {
      db = databases[databaseName]!;
      if (!db.objectStoreNames!.contains(objectStoreName)) {
        db.createObjectStore(objectStoreName);
      }
    } else {
      db =
          await indexedDB!.open(databaseName, version: 1, onUpgradeNeeded: (e) {
        var db = e.target.result as Database;
        if (!db.objectStoreNames!.contains(objectStoreName)) {
          db.createObjectStore(objectStoreName);
        }
      });
      databases[databaseName] = db;
    }

    return StorageBackendJs(db, cipher, objectStoreName);
  }

  @override
  Future<void> deleteBox(String name, String? path, String? collection) async {
    // compatibility for old store format
    final databaseName = collection ?? name;
    final objectStoreName = collection == null ? 'box' : name;

    Database db;

    if (databases.containsKey(databaseName)) {
      db = databases[databaseName]!;
      if (db.objectStoreNames!.contains(objectStoreName)) {
        db.deleteObjectStore(objectStoreName);
      }
    } else {
      db =
          await indexedDB!.open(databaseName, version: 1, onUpgradeNeeded: (e) {
        var db = e.target.result as Database;
        if (db.objectStoreNames!.contains(objectStoreName)) {
          db.deleteObjectStore(objectStoreName);
        }
      });
      databases[databaseName] = db;
    }
    if (db.objectStoreNames!.isEmpty) {
      indexedDB!.deleteDatabase(databaseName);
    }
  }

  @override
  Future<bool> boxExists(String name, String? path, String? collection) async {
    // https://stackoverflow.com/a/17473952
    try {
      var _exists = true;
      if (collection == null) {
        await indexedDB!.open(name, version: 1, onUpgradeNeeded: (e) {
          e.target.transaction!.abort();
          _exists = false;
        });
      } else {
        if (databases.containsKey(collection)) {
          _exists =
              databases[collection]!.objectStoreNames?.contains(name) ?? false;
        } else {
          final db = await indexedDB!.open(collection, version: 1,
              onUpgradeNeeded: (e) {
            var db = e.target.result as Database;
            _exists = db.objectStoreNames!.contains(name);
          });
          // caching db for later use
          databases[collection] = db;
        }
      }
      return _exists;
    } catch (error) {
      return false;
    }
  }
}
