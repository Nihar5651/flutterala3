import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  void loadData() async {
    final data = await DatabaseHelper.instance.queryAll();
    setState(() {
      tasks = data;
    });
  }

  void addTask() async {
    if (controller.text.isEmpty) return;
    await DatabaseHelper.instance.insert({
      'title': controller.text,
    });
    controller.clear();
    loadData();
  }

  void deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQLite Demo')),
      body: Column(
        children: [
          TextField(controller: controller, decoration: InputDecoration(hintText: "Enter Task")),
          ElevatedButton(onPressed: addTask, child: Text('Add')),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]['title']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTask(tasks[index]['id']),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
