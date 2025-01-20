import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/data/todo.dart';
import 'package:to_do_app/todo_bloc/todo_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void addTodo() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      context.read<TodoBloc>().add(AddTodo(Todo(
            title: title,
            subtitle: description,
          )));
      _titleController.clear();
      _descriptionController.clear();
      Navigator.pop(context);
    }
  }

  void removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  void alertTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      decoration: InputDecoration(
                        hintText: 'Task Title',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      decoration: InputDecoration(
                        hintText: 'Task Description...',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: addTodo,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Icon(
                          CupertinoIcons.check_mark,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'My Todo',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).colorScheme.onPrimary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slidable(
                      key: ValueKey(state.todos[index].isDone),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => removeTodo(state.todos[index]),
                            backgroundColor: Colors.red,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            label: 'Delete',
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          state.todos[index].title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          state.todos[index].subtitle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        trailing: Checkbox(
                          value: state.todos[index].isDone,
                          activeColor: Theme.of(context).colorScheme.primary,
                          checkColor: Theme.of(context).colorScheme.onPrimary,
                          side: BorderSide(
                            width: 1.5,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          onChanged: (value) => alertTodo(index),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TodoStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text('Failed to fetch todos'),
              );
            }
          },
        ),
      ),
    );
  }
}
