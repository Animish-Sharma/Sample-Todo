import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: library_prefixes
import 'package:todo/data/models/user.dart' as Models;

class UserRepo {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection("Users");

  Future<DocumentReference> saveUser(Models.User user) async {
    return await _ref.add(user.toMap());
  }

  Future<Models.User?> getUser() async {
    QuerySnapshot<Object?> snapshot = await _ref
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    QueryDocumentSnapshot<Object?> doc = snapshot.docs[0];
    return Models.User(
        id: doc.id,
        name: doc["name"],
        email: doc["email"],
        username: doc["username"]);
  }
}
