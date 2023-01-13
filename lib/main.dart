import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
const Map<String, Color> priorityColors = {
  'high': primaryColor,
  'normal': Color(0xfff09819),
  'low': Color(0xff3be1f1),
};

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
          floatingLabelBehavior: FloatingLabelBehavior.never,
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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

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
                      child: TextField(
                        onChanged: (value) {
                          searchKeywordNotifier.value = controller.text;
                        },
                        controller: controller,
                        decoration: const InputDecoration(
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
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Box<Task>>(
                    valueListenable: box.listenable(),
                    builder: (context, box, child) {
                      final List<Task> items;
                      if (value.isEmpty) {
                        items = box.values.toList();
                      } else {
                        items = box.values
                            .where((element) => element.name.contains(value))
                            .toList();
                      }
                      if (items.isNotEmpty) {
                        return ListView.builder(
                          itemCount: box.values.length + 1,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Today',
                                        style:
                                            themData.textTheme.headline6!.apply(
                                          fontSizeFactor: 0.9,
                                        ),
                                      ),
                                      Container(
                                        height: 3,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(1.5),
                                        ),
                                        margin: const EdgeInsets.only(top: 4),
                                      ),
                                    ],
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      box.clear();
                                    },
                                    color: const Color(0xffeaeff5),
                                    textColor: secondaryTextColor,
                                    elevation: 0,
                                    child: Row(
                                      children: const [
                                        Text('Delete All'),
                                        SizedBox(width: 4),
                                        Icon(CupertinoIcons.delete_solid),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            final Task task = items[index - 1];
                            return TaskItem(task: task);
                          },
                        );
                      } else {
                        return const EmptyState();
                      }
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
  static const double height = 74;
  static const double borderRadius = 8;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    final Color priorityColor =
        priorityColors[widget.task.priority.name.toString()]!;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: widget.task),
          ),
        );
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
        ),
        margin: const EdgeInsets.only(top: 8),
        height: TaskItem.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TaskItem.borderRadius),
          color: themData.colorScheme.surface,
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted,
              onTab: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: TaskItem.height,
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(TaskItem.borderRadius),
                  bottomRight: Radius.circular(TaskItem.borderRadius),
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
  final GestureTapCallback onTab;

  const MyCheckBox({super.key, required this.value, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    return InkWell(
      onTap: onTab,
      child: Container(
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
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/empty_state.svg', width: 120),
        const SizedBox(height: 12),
        const Text('Your task list is empty'),
      ],
    );
  }
}
