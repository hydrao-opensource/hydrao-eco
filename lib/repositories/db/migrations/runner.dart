// lib/db/migrations/runner.dart
import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

import 'types.dart';
import 'v1_to_v2.dart';
import 'v2_to_v3.dart';
import 'v3_to_v4.dart';
import 'v4_to_v5.dart';
import 'v5_to_v6.dart';
import 'v6_to_v7.dart';

final Map<int, MigrationFn> _migrations = {
  1: migrateV1toV2, // de 1 -> 2
  2: migrateV2toV3, // de 2 -> 3
  3: migrateV3toV4, // de 3 -> 4
  4: migrateV4toV5, // de 4 -> 5
  5: migrateV5toV6, // de 4 -> 5
  6: migrateV6toV7, // de 4 -> 5
  // ...
};

Future<void> runMigrations(
  Migrator m,
  DbRepository db,
  int from,
  int to,
) async {
  for (var v = from; v < to; v++) {
    final step = _migrations[v];
    if (step == null) {
      // À toi de voir: soit throw, soit no-op
      // throw StateError('No migration defined for $v -> ${v + 1}');
      continue;
    }
    await step(m, db);
  }
}
