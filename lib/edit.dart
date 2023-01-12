import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_list_app/data.dart';
import 'package:task_list_app/main.dart';

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
