import 'dart:async';
import 'package:hive/hive.dart';
import 'package:hive/src/backend/js/web_worker/storage_backend_web_worker.dart';
import 'package:hive/src/backend/storage_backend.dart';

import 'indexed_db_interface.dart';

/// Opens IndexedDB databases
class BackendManager implements BackendManagerInterface {
  static Map<String, IndexedDbWebWorkerInterface> databaseInterfaces = {};

  @override
  Future<StorageBackend> open(String name, String? path, bool crashRecovery,
      HiveCipher? cipher, String? collection) async {
    IndexedDbWebWorkerInterface db;

    // compatibility for old store format
    final databaseName = collection ?? name;
    final objectStoreName = collection == null ? 'box' : name;

    if (databaseInterfaces.containsKey(databaseName)) {
      db = databaseInterfaces[databaseName]!;
    } else {
      db = IndexedDbWebWorkerInterface(cipher, objectStoreName);

      databaseInterfaces[databaseName] = db;
    }

    final store = await db.open(name);
    return StorageBackendWebWorker(store);
  }

  @override
  Future<void> deleteBox(String name, String? path, String? collection) {

    // compatibility for old store format
    final databaseName = collection ?? name;
    final objectStoreName = collection == null ? 'box' : name;

    return databaseInterfaces!.deleteDatabase(name);
  }

  @override
  Future<bool> boxExists(String name, String? path, String? collection) async {
    // https://stackoverflow.com/a/17473952
    try {
      // compatibility for old store format
      final databaseName = collection ?? name;
      final objectStoreName = collection == null ? 'box' : name;
      IndexedDbWebWorkerInterface db;

      if (databaseInterfaces.containsKey(databaseName)) {
        db = databaseInterfaces[databaseName]!;
      } else {
        db = IndexedDbWebWorkerInterface(null, objectStoreName);

        databaseInterfaces[databaseName] = db;
      }

      return db.hasObjectStore(objectStoreName);
    } catch (error) {
      return false;
    }
  }
}
