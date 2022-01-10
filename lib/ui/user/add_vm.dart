// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:todo/net/flutterfire.dart';
import 'package:todo/net/request_state.dart';

class AddViewModel extends ChangeNotifier {
  final TodoService _todoService;
  AddViewModel({required todoService}) : _todoService = todoService;
  RequestState? _state;
  RequestState? get state {
    return _state;
  }

  void resetState() {
    _state = RequestState(RequestStatus.none, null);
  }

  Future<bool> create(String title, String description) async {
    this._state =
        await _todoService.createTodo(title: title, description: description);
    if (this._state!.requestStatus == RequestStatus.success) {
      return true;
    }
    notifyListeners();

    return false;
  }
}
