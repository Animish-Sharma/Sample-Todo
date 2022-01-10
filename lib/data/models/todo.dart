class Todo {
  String? id;
  String title;
  String description;
  bool completed;
  int timestamp;
  String owner;

  Todo(
      {this.id,
      required this.description,
      required this.completed,
      required this.title,
      required this.owner,
      required this.timestamp});
  Map<String, dynamic> toMap() {
    if (id == null) {
      return {
        'description': description,
        'completed': completed,
        "title": title,
        "owner": owner,
        "timestamp": timestamp
      };
    }
    return {
      'id': id,
      'description': description,
      'completed': completed,
      "title": title,
      "owner": owner,
      "timestamp": timestamp
    };
  }
}
