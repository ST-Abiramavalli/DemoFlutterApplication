class Todo {
  String item;

  Todo({required this.item});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      item: json['item'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
    };
  }
}
