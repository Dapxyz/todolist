
class Todo {
  int? id;
  String nama;
  String deskripsi;
  bool done;

  Todo(this.nama, this.deskripsi, {this.done = false, this.id});

  static List<Todo> dummyData = [
    Todo("Belajar Flutter", "Belajar Python"),
    Todo("Belajar Dart", "Belajar Ruby", done: true),
    Todo("Belajar C++", "Belajar Golang"),
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'done': done ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      map['nama'] as String,
      map['deskripsi'] as String,
      done: map['done'] == 1,
      id: map['id'] as int?,
    );
  }
}
