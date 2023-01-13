import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_list_app/data.dart';
import 'package:task_list_app/edit.dart';

const String taskBoxName = 'tasks';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
    ),
  );
  await Hive.openBox<Task>(taskBoxName);

  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5c0aff);
const secondaryTextColor = Color(0xffafbed0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1d2830);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: secondaryTextColor,
          ),
          border: InputBorder.none,
          iconColor: secondaryTextColor,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryVariant: primaryVariantColor,
          onPrimary: Colors.white,
          background: Color(0xfff3f5f8),
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
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
    final themData = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(task: Task()),
            ),
          );
        },
        label: Row(
          children: const [
            Text('Add New Task'),
            Icon(CupertinoIcons.add),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themData.colorScheme.primary,
                    themData.colorScheme.primaryVariant,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do List',
                          style: themData.textTheme.headline6!.apply(
                            color: themData.colorScheme.onPrimary,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: themData.colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks...'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<Task>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                    itemCount: box.values.length + 1,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: themData.textTheme.headline6!.apply(
                                    fontSizeFactor: 0.9,
                                  ),
                                ),
                                Container(
                                  height: 3,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(1.5),
                                  ),
                                  margin: const EdgeInsets.only(top: 4),
                                ),
                              ],
                            ),
                            MaterialButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Text('Delete All'),
                                  const SizedBox(width: 4),
                                  const Icon(CupertinoIcons.delete_solid),
                                ],
                              ),
                              color: const Color(0xffeaeff5),
                              textColor: secondaryTextColor,
                              elevation: 0,
                            ),
                          ],
                        );
                      }
                      final Task task = box.values.toList()[index - 1];
                      return TaskItem(task: task);
                    },
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

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        margin: const EdgeInsets.only(top: 8),
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themData.colorScheme.surface,
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;

  const MyCheckBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: value
            ? null
            : Border.all(
                color: secondaryTextColor,
                width: 2,
              ),
        color: value ? primaryColor : null,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themData.colorScheme.onPrimary,
              size: 16,
            )
          : null,
    );
  }
}
