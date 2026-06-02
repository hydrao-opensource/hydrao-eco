import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

Future<void> migrateV4toV5(Migrator m, DbRepository db) async {
  await m.addColumn(
    db.showerheads,
    db.showerheads.baselineBeginIndex as GeneratedColumn<Object>,
  );
  await m.addColumn(
    db.showerheads,
    db.showerheads.baselineEndIndex as GeneratedColumn<Object>,
  );
  await m.addColumn(
    db.showerheads,
    db.showerheads.baselineStatus as GeneratedColumn<Object>,
  );
  await m.addColumn(
    db.showerheads,
    db.showerheads.baselineBeginDate as GeneratedColumn<Object>,
  );
  await m.addColumn(
    db.showerheads,
    db.showerheads.baselineEndDate as GeneratedColumn<Object>,
  );
}
