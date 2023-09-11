import 'package:flutter/material.dart';
import 'package:flutter_floor/data/db/todo.dart';
import 'package:flutter_floor/data/db/todo_dao.dart';
import 'package:flutter_floor/data/db/todo_database.dart';

class EditPage extends StatefulWidget {
  final int id;
  const EditPage({super.key, required this.id});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final database;
  late TodoDao todoDao;
  final key = GlobalKey<FormState>();

  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    connectDB();
  }

  connectDB() async {
    final database =
        await $FloorTodoDatabase.databaseBuilder('todo_database.db').build();
    todoDao = database.todoDao;
    Todo? todo = await todoDao.findId(widget.id);
    setState(() {
      noteController = TextEditingController(text: todo!.task);
    });
    // print(todo!.task);
  }

  updateTodo(int id, String task) {
    setState(() {
      todoDao.updateId(id, task);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(20),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Edit Note',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Enter your note',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "note is not empty";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
              ),
            ),
            onPressed: () async {
              setState(() {
                todoDao.updateId(widget.id, noteController.text);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Update',
            ),
          ),
        ],
      ),
    );
  }
}
