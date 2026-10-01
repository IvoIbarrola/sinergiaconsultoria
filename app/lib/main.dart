import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TaskyApp());
}

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasky',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const TaskListPage(),
    );
  }
}

class Task {
  final String title;
  bool completed;

  Task({
    required this.title,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      completed: map['completed'] ?? false,
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final preferences = await SharedPreferences.getInstance();

    final savedTasks = preferences.getString('tasks');

    if (savedTasks == null) {
      return;
    }

    final List<dynamic> decodedTasks = jsonDecode(savedTasks);

    setState(() {
      tasks = decodedTasks
          .map(
            (task) => Task.fromMap(task),
          )
          .toList();
    });
  }

  Future<void> _saveTasks() async {
    final preferences = await SharedPreferences.getInstance();

    final encodedTasks = jsonEncode(
      tasks.map((task) => task.toMap()).toList(),
    );

    await preferences.setString(
      'tasks',
      encodedTasks,
    );
  }

  void _addTask() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva tarea'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Escribí una tarea',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final title = controller.text.trim();

                if (title.isEmpty) {
                  return;
                }

                setState(() {
                  tasks.add(
                    Task(title: title),
                  );
                });

                _saveTasks();

                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTask(Task task, bool? value) {
    setState(() {
      task.completed = value ?? false;
    });

    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasky'),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No hay tareas',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return ListTile(
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (value) {
                      _toggleTask(task, value);
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteTask(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}