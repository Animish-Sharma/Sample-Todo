import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/data/models/todo.dart';
import 'package:todo/data/repo/todo_repo.dart';

class TodoCreationService {
  final TodoRepo _todoRepo;
  final FirebaseAuth _firebaseAuth;
  TodoCreationService(this._todoRepo, this._firebaseAuth);
  Future<void> createTodo(
      {required String title, required String description}) async {
    await _todoRepo.saveTodo(
      Todo(
        description: description,
        completed: false,
        title: title,
        owner: _firebaseAuth.currentUser!.uid,
        timestamp: DateTime.now().microsecondsSinceEpoch,
      ),
    );
  }
}
