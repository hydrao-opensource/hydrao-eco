import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

Future<void> migrateV6toV7(Migrator m, DbRepository db) async {
  await m.addColumn(
    db.showerheads,
    db.showerheads.lastRssi as GeneratedColumn<Object>,
  );
}
