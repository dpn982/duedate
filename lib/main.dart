import 'package:duedate/db/due_date_bloc.dart';
import 'package:duedate/screens/home.dart';
import 'package:duedate/widgets/dd_inheritedwidget.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    dueDateBloc: DueDateBloc(),
  ));
}

class MyApp extends StatelessWidget {
  final DueDateBloc dueDateBloc;

  const MyApp({Key key, this.dueDateBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF045D56),
        scaffoldBackgroundColor: Color(0xFF045D56),
        bottomAppBarTheme: BottomAppBarTheme(
          shape: const CircularNotchedRectangle(),
          elevation: 0.0,
          color: Color(0xFF344955),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF9AA33),
          foregroundColor: Colors.black,
        ),
      ),
      home: InheritedData(
        "Due Date",
        dueDateBloc,
        HomeScreen(),
      ),
    );
  }
}
