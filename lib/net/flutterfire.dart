import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/repo/todo_repo.dart';
import 'package:todo/net/request_state.dart';
import 'package:todo/net/todo_creation.dart';

class TodoService {
  final TodoCreationService _todoCreationService;
  TodoService(this._todoCreationService);
  final TodoRepo _todoRepo = TodoRepo();

  Future<RequestState> createTodo(
      {String title = "", String description = ""}) async {
    try {
      await _todoCreationService.createTodo(
          title: title, description: description);
      return RequestState(RequestStatus.success, null);
    } catch (e) {
      return RequestState(RequestStatus.error, e.toString());
    }
  }

  Future<RequestState> deleteTodo({required String id}) async {
    try {
      await FirebaseFirestore.instance.collection("Todo").doc(id).delete();
      return RequestState(RequestStatus.success, null);
    } catch (e) {
      return RequestState(RequestStatus.error, e.toString());
    }
  }

  Future<RequestState> completed({required String id}) async {
    try {
      final todo = await _todoRepo.getTodo(id);
      todo.completed = true;
      await FirebaseFirestore.instance
          .collection("Todo")
          .doc(id)
          .set(todo.toMap());
      return RequestState(RequestStatus.success, null);
    } catch (e) {
      return RequestState(RequestStatus.error, e.toString());
    }
  }

  Future<RequestState> revert({required String id}) async {
    try {
      final todo = await _todoRepo.getTodo(id);
      todo.completed = false;
      await FirebaseFirestore.instance
          .collection("Todo")
          .doc(id)
          .set(todo.toMap());
      return RequestState(RequestStatus.success, null);
    } catch (e) {
      return RequestState(RequestStatus.error, e.toString());
    }
  }

  Future<RequestState> edit(
      {String title = "", String description = "", String id = ""}) async {
    try {
      final todo = await _todoRepo.getTodo(id);
      todo.title = title;
      todo.description = description;
      await FirebaseFirestore.instance
          .collection("Todo")
          .doc(id)
          .set(todo.toMap());
      return RequestState(RequestStatus.success, null);
    } catch (e) {
      return RequestState(RequestStatus.error, e.toString());
    }
  }
}
