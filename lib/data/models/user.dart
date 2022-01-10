class User {
  String? id;
  String name;
  String email;
  String username;

  User(
      {this.id,
      required this.email,
      required this.username,
      required this.name});
  Map<String, dynamic> toMap() {
    if (id == null) {
      return {'email': email, 'username': username, "name": name};
    }
    return {'id': id, 'email': email, 'username': username, "name": name};
  }
}
