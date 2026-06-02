class FormState<T> {
  final T? changes;
  final Map<String, String>? errors;

  const FormState({this.changes, this.errors});

  FormState<T> copyWith({
    T? changes,
    Map<String, String>? errors,
    bool resetChanges = false,
  }) {
    return FormState<T>(
      changes: resetChanges ? null : changes ?? this.changes,
      errors: errors ?? this.errors,
    );
  }

  bool hasChanges() {
    return changes != null;
  }

  bool isValid() {
    return errors == null || errors!.isEmpty;
  }

  @override
  String toString() =>
      'FormState(isValid: ${isValid()}, hasChanges: ${hasChanges()})';
}
