import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/data/models/todo.dart';

class TodoRepo {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("Todo");

  Future<DocumentReference> saveTodo(Todo todo) async {
    return await _ref.add(todo.toMap());
  }

  Future<Todo> getTodo(String id) async {
    final snapshot = await _ref.doc(id).get();

    dynamic doc = snapshot.data() as dynamic;
    return Todo(
        title: doc["title"],
        description: doc["description"],
        completed: doc["completed"],
        owner: doc["owner"],
        timestamp: doc["timestamp"]);
  }
}
