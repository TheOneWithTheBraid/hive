# 0.4.3
- fix: Port patch from Hive to prevent corruption

# 0.4.2
- fix: actually delete idb in deleteFromDisk method

# 0.4.1
- fix: Export hive better

# 0.4.0
- fix: Fix random database corruptions by absorbing and modifying hive

# 0.3.5
- fix: Mark deleted keys in cache

# 0.3.4
- fix: Allow keys longer than 255 chars

# 0.3.3
- fix: Remove !. operators everywhere

# 0.3.2
- fix: Put with null value triggers delete now

# 0.3.1
- feat: Close all boxes

# 0.3.0
- refactor: Rename close() to deleteFromDisk()

# 0.2.7
- fix: Clear native boxes by removing them from disk

# 0.2.6
- fix: Decode keys in findAllValues

# 0.2.5
- feat: Encode hive keys

# 0.2.4
- refactor: Pass HiveCipher directly

# 0.2.3
- fix: Missing await

# 0.2.2
- feat: Implement BoxCollection.close and cache boxes
- fix: Disable transactions in Hive for now

## 0.2.1
- fix: Transactions on native in wrong sort order

## 0.2.0
- feat: Use Hive instead of SQFlite for dart io

## 0.1.7
- fix: Do use sqflite batches instead of transactions

## 0.1.6
- feat: Create indexes if not exists

## 0.1.5
- refactor: Move pragmas outside of creation

## 0.1.4
- fix: Dont set pragmas in transactions

## 0.1.3
- feat: Speed up sqflite by setting Pragmas:
```sql
PRAGMA page_size = 8192
PRAGMA cache_size = 16384
PRAGMA temp_store = MEMORY
PRAGMA journal_mode = WAL
```

## 0.1.2
- feat: Use batches to speed up transactions in sqflite

## 0.1.1
- fix: Lower Dart dependency to 2.12

## 0.1.0

- Initial version.
