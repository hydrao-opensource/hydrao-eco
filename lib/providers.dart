import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/domains/app_state.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/domains/form_state.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_domain.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_state.dart';
import 'package:hydrao_flutter_offline/domains/user_domain.dart';
import 'package:hydrao_flutter_offline/domains/user_state.dart';
import 'package:hydrao_flutter_offline/models/authentication.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/models/shower_filters.dart';
import 'package:hydrao_flutter_offline/models/support_message.dart';
import 'package:hydrao_flutter_offline/repositories/api/api_repository.dart';
import 'package:hydrao_flutter_offline/repositories/api/auth_repository.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_repository.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

final bleRepositoryProvider = Provider((ref) => BleRepository());

final dbRepositoryProvider = Provider((ref) => DbRepository());

final authRepositoryProvider = Provider((ref) => AuthRepository());

final apiRepositoryProvider = Provider(
  (ref) => ApiRepository(ref.watch(authRepositoryProvider)),
);

final showerheadDomainProvider =
    StateNotifierProvider<ShowerheadDomain, ShowerheadState>((ref) {
      return ShowerheadDomain(
        ref.watch(bleRepositoryProvider),
        ref.watch(dbRepositoryProvider),
      );
    });

final appDomainProvider = StateNotifierProvider<AppDomain, AppState>((ref) {
  return AppDomain(ref.watch(dbRepositoryProvider));
});

final userDomainProvider = StateNotifierProvider<UserDomain, UserState>((ref) {
  return UserDomain(
    ref.watch(authRepositoryProvider),
    ref.watch(apiRepositoryProvider),
  );
});

final settingsFormStateProvider =
    StateNotifierProvider<
      FormDomain<AppSettingsCompanion>,
      FormState<AppSettingsCompanion>
    >((ref) => FormDomain());

final shFormStateProvider =
    StateNotifierProvider<
      FormDomain<ShowerheadsCompanion>,
      FormState<ShowerheadsCompanion>
    >((ref) => FormDomain());

final shLearningPeriodFormStateProvider =
    StateNotifierProvider<
      FormDomain<LearningPeriod>,
      FormState<LearningPeriod>
    >((ref) => FormDomain());

final backupFormStateProvider =
    StateNotifierProvider<FormDomain<HydraoBackup>, FormState<HydraoBackup>>(
      (ref) => FormDomain(),
    );

final loginFormStateProvider =
    StateNotifierProvider<
      FormDomain<Authentication>,
      FormState<Authentication>
    >((ref) => FormDomain());

final showerheadTabSelectedProvider = StateProvider<int>((ref) => 0);

final contactUsFormStateProvider =
    StateNotifierProvider<
      FormDomain<SupportMessage>,
      FormState<SupportMessage>
    >((ref) => FormDomain());

final showerFiltersStateProvider =
    StateNotifierProvider<FormDomain<ShowerFilters>, FormState<ShowerFilters>>(
      (ref) => FormDomain(),
    );

final statisticsShSelectedProvider = StateProvider<String?>((ref) => null);
