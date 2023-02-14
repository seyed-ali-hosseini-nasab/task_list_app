import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_list_app/data/data.dart';
import 'package:task_list_app/data/repo/repository.dart';
import 'package:task_list_app/main.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: themeData.colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeData.colorScheme.surface,
          foregroundColor: themeData.colorScheme.onSurface,
          title: const Text('Edit Task'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.task.name = _controller.text;
            final repository =
                Provider.of<Repository<Task>>(context, listen: false);
            repository.createOrUpdate(widget.task);
            Navigator.of(context).pop();
          },
          label: Row(
            children: const [
              Text('Save Change'),
              Icon(
                CupertinoIcons.check_mark,
                size: 18,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      label: 'High',
                      color: primaryColor,
                      isSelected: widget.task.priority == Priority.high,
                      onTab: () {
                        setState(() {
                          widget.task.priority = Priority.high;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      label: 'Normal',
                      color: priorityColors['normal']!,
                      isSelected: widget.task.priority == Priority.normal,
                      onTab: () {
                        setState(() {
                          widget.task.priority = Priority.normal;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      label: 'Low',
                      color: priorityColors['low']!,
                      isSelected: widget.task.priority == Priority.low,
                      onTab: () {
                        setState(() {
                          widget.task.priority = Priority.low;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  label: Text(
                    'Add a task for today',
                    style: themeData.textTheme.bodyText1!.apply(
                      fontSizeFactor: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTab;

  const PriorityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: PriorityCheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const PriorityCheckBoxShape({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: value
            ? null
            : Border.all(
                color: secondaryTextColor,
                width: 2,
              ),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
