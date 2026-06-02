import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

Future<void> migrateV3toV4(Migrator m, DbRepository db) async {
  await m.addColumn(
    db.showers,
    db.showers.isReference as GeneratedColumn<Object>,
  );
  await m.addColumn(
    db.showers,
    db.showers.isIgnored as GeneratedColumn<Object>,
  );
}
