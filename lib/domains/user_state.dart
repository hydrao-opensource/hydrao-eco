enum AuthStatus { logged, unlogged, logging, expired }

class UserState {
  final AuthStatus authStatus;
  final String? email; // Utile pour pré-remplir le login
  final bool authFailed;

  const UserState({
    this.authStatus = AuthStatus.unlogged,
    this.email,
    this.authFailed = false,
  });

  UserState copyWith({
    AuthStatus? authStatus,
    String? email,
    bool? authFailed,
  }) {
    return UserState(
      authStatus: authStatus ?? this.authStatus,
      email: email ?? this.email,
      authFailed: authFailed ?? this.authFailed,
    );
  }
}
