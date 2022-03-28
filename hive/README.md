Easy to use but powerful storage for Flutter and web.

## Motivation

Hive lacks performance on web and the IndexedDB API does not fit that well to the Hive API.
FluffyBox acts as a wrapper over IndexedDB and Hive, has a API which is similar to Hive but
supports lazy loading keys, uses ObjectStores instead of databases for boxes, creating
ObjectStores at start time and supports transactions.

## Features

- Simple API with Boxes highly inspired by Hive
- Just uses native **indexedDB** on web and **Hive** on native
- **Nothing** is loaded to memory until it is needed
- You have **BoxCollections** (Databases in Hive and IndexedDB) and **Boxes** (tables in Hive and ObjectStores in IndexedDB)
- **Transactions** to speed up dozens of write actions
^
## Getting started

Add FluffyBox to your pubspec.yaml:

```yaml
  fluffybox: <latest-version>
```

## Usage

```dart
  // Create a box collection
  final collection = await BoxCollection.open(
    'MyFirstFluffyBox', // Name of your database
    {'cats', 'dogs'}, // Names of your boxes
    path: './', // Path where to store your boxes (Only used in Flutter / Dart IO)
    key: HiveCipher(), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
  );

  // Open your boxes. Optional: Give it a type.
  final catsBox = collection.openBox<Map>('cats');

  // Put something in
  await catsBox.put('fluffy', {'name': 'Fluffy', 'age': 4});
  await catsBox.put('loki', {'name': 'Loki', 'age': 2});

  // Get values of type (immutable) Map?
  final loki = await catsBox.get('loki');
  print('Loki is ${loki?['age']} years old.');

  // Returns a List of values
  final cats = await catsBox.getAll(['loki', 'fluffy']);
  print(cats);

  // Returns a List<String> of all keys
  final allCatKeys = await catsBox.getAllKeys();
  print(allCatKeys);

  // Returns a Map<String, Map> with all keys and entries
  final catMap = await catsBox.getAllValues();
  print(catMap);

  // delete one or more entries
  await catsBox.delete('loki');
  await catsBox.deleteAll(['loki', 'fluffy']);

  // ...or clear the whole box at once
  await catsBox.clear();

  // Speed up write actions with transactions
  await collection.transaction(
    () async {
      await catsBox.put('fluffy', {'name': 'Fluffy', 'age': 4});
      await catsBox.put('loki', {'name': 'Loki', 'age': 2});
      // ...
    },
    boxNames: ['cats'], // By default all boxes become blocked.
    readOnly: false,
  );
```

## Credits

Special thanks to [Hive](https://pub.dev/packages/hive) and its [contributors](https://github.com/hivedb/hive/graphs/contributors)
for making this package possible.

We included hive ourself to already include https://github.com/hivedb/hive/pull/852 and thus
be able to prevent database corruptions from happening.
