import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_list_app/data.dart';

const String taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Task> box = Hive.box(taskBoxName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(),
            ),
          );
        },
        label: const Text('Add New Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final Task task = box.values.toList()[index];
              return Container(
                child: Text(
                  task.name,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Task> box = Hive.box(taskBoxName);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Task'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final Task task = Task();
            task.name = _controller.text;
            task.priority = Priority.low;
            if (task.isInBox) {
              task.save();
            } else {
              box.add(task);
            }

            Navigator.of(context).pop();
          },
          label: const Text('Save Change'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                label: Text('Add a task for today'),
              ),
            ),
          ],
        ));
  }
}
