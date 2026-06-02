import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

Future<void> migrateV2toV3(Migrator m, DbRepository db) async {
  // change showers PK from (id) to (id, device_id) without loose data

  await db.customStatement('PRAGMA foreign_keys=OFF');

  await db.customStatement('''
    CREATE TABLE IF NOT EXISTS showers_new (
      id INTEGER NOT NULL,
      device_id TEXT NOT NULL,
      is_empty INTEGER NOT NULL DEFAULT 0,
      volume INTEGER NOT NULL,
      temperature REAL,
      flow REAL,
      duration REAL,
      date INTEGER NOT NULL,
      soaping_time INTEGER,
      threshold TEXT,
      PRIMARY KEY (id, device_id)
    );
  ''');

  await db.customStatement('''
    INSERT INTO showers_new (
      id, device_id, is_empty, volume, temperature, flow,
      duration, date, soaping_time, threshold
    )
    SELECT
      id, device_id, is_empty, volume, temperature, flow,
      duration, date, soaping_time, threshold
    FROM showers;
  ''');

  await db.customStatement('DROP TABLE showers;');
  await db.customStatement('ALTER TABLE showers_new RENAME TO showers;');

  await db.customStatement('PRAGMA foreign_keys=ON');
}
