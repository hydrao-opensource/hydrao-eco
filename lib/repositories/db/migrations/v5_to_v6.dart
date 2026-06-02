import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

Future<void> migrateV5toV6(Migrator m, DbRepository db) async {
  await m.addColumn(
    db.showerheads,
    db.showerheads.needResetVolume as GeneratedColumn<Object>,
  );
}
