enum AuthStatus { authed, unauthed, loading, error }

class AuthState {
  final AuthStatus authStatus;
  final String? error;
  AuthState(this.authStatus, this.error);
}
