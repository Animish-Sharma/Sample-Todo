// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:todo/net/flutterfire.dart';
import 'package:todo/net/request_state.dart';

class HomeViewModel extends ChangeNotifier {
  final TodoService _todoService;
  HomeViewModel({required todoService}) : _todoService = todoService;
  RequestState? _state;
  RequestState? get state {
    return _state;
  }

  void resetState() {
    _state = RequestState(RequestStatus.none, null);
  }

  Future<bool> delete(String id) async {
    this._state = await _todoService.deleteTodo(id: id);
    if (this._state!.requestStatus == RequestStatus.success) {
      notifyListeners();
      return true;
    }
    notifyListeners();

    return false;
  }

  Future<bool> complete(String id) async {
    this._state = await _todoService.completed(id: id);
    if (this._state!.requestStatus == RequestStatus.success) {
      notifyListeners();
      return true;
    }
    notifyListeners();

    return false;
  }
}
