import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

Future<void> migrateV1toV2(Migrator m, DbRepository db) async {
  await m.addColumn(db.showers, db.showers.isEmpty as GeneratedColumn<Object>);
  await m.addColumn(
    db.showerheads,
    db.showerheads.indexCycleCount as GeneratedColumn<Object>,
  );
}
