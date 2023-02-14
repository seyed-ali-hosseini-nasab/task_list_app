import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_list_app/main.dart';

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
