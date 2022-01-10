// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:todo/net/auth_state.dart';
import 'package:todo/net/authentication_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  LoginViewModel({required AuthService authService})
      : _authService = authService;
  AuthState? _state;

  AuthState? get state {
    return _state;
  }

  void resetState() {
    _state = AuthState(AuthStatus.unauthed, null);
  }

  void login({String email = "", String password = ""}) async {
    this._state = await _authService.signIn(email, password);

    notifyListeners();
  }
}
