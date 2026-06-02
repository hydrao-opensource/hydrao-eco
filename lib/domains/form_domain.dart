import 'package:flutter_riverpod/legacy.dart';
import 'package:hydrao_flutter_offline/domains/form_state.dart';

class FormDomain<T> extends StateNotifier<FormState<T>> {
  FormDomain() : super(FormState<T>(changes: null));

  void setChanges(T? changes) {
    if (changes != null) {
      state = state.copyWith(changes: changes);
    } else if (state.changes != null) {
      state = state.copyWith(resetChanges: true);
    }
  }

  T? getChanges() {
    return state.changes;
  }

  bool canSave() {
    return state.errors == null || state.errors!.isEmpty;
  }

  bool needConfirmBeforeQuit() {
    return state.changes != null;
  }

  void updateErrors(Map<String, String> errors) {
    state = state.copyWith(errors: errors);
  }

  String? getFieldError(String fieldKey) {
    return state.errors == null ? null : state.errors![fieldKey];
  }

  void resetChanges() {
    state = state.copyWith(resetChanges: true);
  }

  void reset() {
    state = FormState<T>();
  }
}
