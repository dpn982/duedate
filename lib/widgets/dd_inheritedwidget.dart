import 'package:duedate/db/due_date_bloc.dart';
import 'package:flutter/material.dart';

class InheritedData extends InheritedWidget {
  final DueDateBloc dueDateBloc;

  InheritedData(this.dueDateBloc, child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedData old) =>
      dueDateBloc != old.dueDateBloc;

  static DueDateBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedData>().dueDateBloc;
  }
}