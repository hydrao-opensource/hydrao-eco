import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

typedef MigrationFn = Future<void> Function(Migrator m, DbRepository db);
