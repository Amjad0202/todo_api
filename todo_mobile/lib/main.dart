import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// Main widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoPage(),
    );
  }
}

// Main page of the app
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> tasks = [];

  // Replace with your local server IP (for Android Emulator use 10.0.2.2)
  final String apiUrl = 'http://10.0.2.2:3000/api/todos';

  @override
  void initState() {
    super.initState();
    fetchTasks(); // load tasks on app start
  }

  // Fetch tasks from backend
  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        tasks = data.map((item) => item['task'].toString()).toList();
      });
    }
  }

  // Send new task to backend
  Future<void> addTask(String task) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'task': task}),
    );

    if (response.statusCode == 201) {
      _controller.clear();
      fetchTasks(); // refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter a task'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  addTask(_controller.text);
                }
              },
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 20),
            const Text('Tasks:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(tasks[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
