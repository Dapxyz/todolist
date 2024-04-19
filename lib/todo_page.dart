import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'todo.dart';

class Todopage extends StatelessWidget {
  const Todopage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          TodoList(dbHelper: DatabaseHelper()), // Membuat objek DatabaseHelper
    );
  }
}

class TodoList extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const TodoList({super.key, required this.dbHelper});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _namaCtrl = TextEditingController();
  final TextEditingController _deskripsiCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  List<Todo> todoList = [];

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 3), () {
    //   // pindah halaman.
    // });
    // todoList = [];
    widget.dbHelper.getAllTodos().then((e) {
      setState(() {
        todoList = e;
      });
    });
    refreshList();
  }

  Future<void> refreshList() async {
    final todos = await widget.dbHelper.getAllTodos();
    setState(() {
      todoList = todos;
    });
  }

  Future<void> addTodo() async {
    await widget.dbHelper.addTodo(Todo(
      _namaCtrl.text,
      _deskripsiCtrl.text,
    ));

    // Perbarui daftar todoList dengan mengambil ulang data dari database
    await refreshList();

    // Bersihkan teks pada TextField setelah menambahkan todo
    setState(() {
      _namaCtrl.text = '';
      _deskripsiCtrl.text = '';
    });
  }

  Future<void> update(int index, bool done) async {
    // final updatedTodo = todoList[index].copyWith(done: done);
    // await widget.dbHelper.updateTodo(updatedTodo);
    refreshList();
  }

  Future<void> delete(int id) async {
    await widget.dbHelper.deleteTodo(id);
    refreshList();
  }

  void tampilForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(20),
        title: const Text("Tambah Todo"),
        content: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _deskripsiCtrl,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addTodo();
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog on cancel
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Todo List'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_box),
        onPressed: () {
          tampilForm();
        },
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (_) {
                cariTodo();
              },
              controller: _searchCtrl,
              decoration: const InputDecoration(
                  hintText: 'Cari Todo',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    icon: Icon(
                      todoList[index].done
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                    ),
                    onPressed: () {
                      update(index, !todoList[index].done);
                    },
                  ),
                  title: Text(todoList[index].nama),
                  subtitle: Text(todoList[index].deskripsi),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      delete(todoList[index].id ?? 0);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  void cariTodo() async {
    String teks = _searchCtrl.text.trim();
    List<Todo> todos = [];
    if (teks.isEmpty) {
      todos = await widget.dbHelper.getAllTodos();
    } else {
      // Implementasi untuk mencari Todo sesuai dengan teks
    }
    setState(() {
      todoList = todos;
    });
  }
}
