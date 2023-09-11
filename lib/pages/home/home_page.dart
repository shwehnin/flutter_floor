import '../../data/db/todo.dart';
import '../../data/db/todo_dao.dart';
import 'package:flutter/material.dart';
import '../../data/db/todo_database.dart';
import 'package:flutter_floor/pages/home/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController noteController = TextEditingController();
  final key = GlobalKey<FormState>();
  late final database;
  late TodoDao todoDao;
  int lastId = 1;

  @override
  void initState() {
    super.initState();
    connectDB();
  }

  connectDB() async {
    final database =
        await $FloorTodoDatabase.databaseBuilder('todo_database.db').build();
    setState(() {
      todoDao = database.todoDao;
    });
  }

  addNote(int id, String note) {
    todoDao.add(Todo(id, note));
  }

  getLastId() async {
    Todo? todo = await todoDao.findTodoLast();
    setState(() {
      if (todo != null) {
        lastId = todo.id + 1;
      }
    });
  }

  deleteNote(int id) {
    todoDao.delete(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Floor Note App'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: 'Enter your note',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
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
                if (key.currentState!.validate()) {
                  String note = noteController.text;
                  await getLastId();
                  addNote(lastId, note);
                  noteController.text = "";
                }
              },
              child: const Text(
                'Submit',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<List<Todo>>(
                  stream: todoDao.list(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (ctx, idx) {
                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            elevation: 5,
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .6,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Text(snapshot.data![idx].task),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (ctx) => EditPage(
                                    //             id: snapshot.data![idx].id)));
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      context: context,
                                      builder: (ctx) => EditPage(
                                        id: snapshot.data![idx].id,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_square,
                                    color: Colors.purple,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteNote(snapshot.data![idx].id);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            todoDao.deleteAll();
          });
        },
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
