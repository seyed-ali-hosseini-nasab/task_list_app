import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:task_list_app/data/data.dart';
import 'package:task_list_app/data/repo/repository.dart';
import 'package:task_list_app/data/source/hive_task_source.dart';
import 'package:task_list_app/screens/home/home.dart';

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

  runApp(
    ChangeNotifierProvider<Repository<Task>>(
      create: (context) =>
          Repository(HiveTaskDataSource(Hive.box(taskBoxName))),
      child: const MyApp(),
    ),
  );
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
