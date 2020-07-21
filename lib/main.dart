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
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: InheritedData(
        dueDateBloc,
        HomeScreen(),
      ),
    );
  }
}
