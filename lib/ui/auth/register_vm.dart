import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:todo/net/auth_state.dart';
import 'package:todo/net/authentication_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService;

  RegisterViewModel({required AuthService authService})
      : _authService = authService;
  AuthState? _state;
  AuthState? get state {
    return _state;
  }

  void resetState() {
    _state = AuthState(AuthStatus.unauthed, null);
  }

  Future<bool> register(
      {required String name,
      required String email,
      required String password,
      required String rePassword}) async {
    if (!EmailValidator.validate(email)) {
      _state = AuthState(AuthStatus.error, "Please enter a valid email.");
      notifyListeners();
      return false;
    }

    if (password != rePassword) {
      _state = AuthState(AuthStatus.error, "Passwords need to match.");
      notifyListeners();
      return false;
    }
    _state = await _authService.signUp(name, email, password);
    if (_state == AuthState(AuthStatus.authed, null)) {
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }
}
