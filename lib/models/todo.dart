class Todo {
  String item;
  int id;

  Todo({required this.item, required this.id});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      item: json['item'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'id': id
    };
  }
}
