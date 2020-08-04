import 'package:duedate/db/due_date_bloc.dart';
import 'package:duedate/screens/home.dart';
import 'package:duedate/widgets/dd_inheritedwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIOverlays([]);
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
        primaryColor: Color(0xFFF9AA33),
        scaffoldBackgroundColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(
          shape: const CircularNotchedRectangle(),
          elevation: 0.0,
          color: Color(0xFF232F34),
        ),
        cardTheme: CardTheme(
          elevation: 0.0,
          color: Colors.transparent,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF9AA33),
          foregroundColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        primaryIconTheme: IconThemeData(color: Colors.white),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Color(0xFF344955),
        bottomAppBarTheme: BottomAppBarTheme(
          shape: const CircularNotchedRectangle(),
          elevation: 0.0,
          color: Color(0xFF232F34),
        ),
        cardTheme: CardTheme(
          elevation: 0.0,
          color: Colors.transparent,
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
