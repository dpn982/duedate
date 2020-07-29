import 'package:duedate/db/due_date_bloc.dart';
import 'package:flutter/material.dart';

class InheritedData extends InheritedWidget {
  final DueDateBloc dueDateBloc;
  final String title;

  InheritedData(this.title, this.dueDateBloc, child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedData old) =>
      title != old.title || dueDateBloc != old.dueDateBloc;

  static InheritedData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedData>();
  }
}
