import 'package:duedate/models/PaymentModel.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final Payment payment;

  EditScreen({Key key, @required this.payment}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.parse(widget.payment.dueDate);
    TextEditingController dueDateCtl = TextEditingController(text: selectedDate.toIso8601String().split('T')[0]);

    Future<Null> _selectDueDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now().add(Duration(days: 365)));
      if (picked != null && picked != selectedDate) {
          dueDateCtl.text = picked.toLocal().toIso8601String().split('T')[0];
      }
    }

    return Scaffold(
        appBar: AppBar(
        title: Text(widget.payment.name),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: widget.payment.name,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a name.';
                      }

                      return '';
                    },
                    onSaved: (val) => setState(() => widget.payment.name = val),
                  ),
                  TextFormField(
                    initialValue: widget.payment.description,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description.';
                      }

                      return '';
                    },
                    onSaved: (val) => setState(() => widget.payment.description = val),
                  ),
                  TextFormField(
                    initialValue: widget.payment.amount,
                    decoration: InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an amount.';
                      }

                      return '';
                    },
                    onSaved: (val) => setState(() => widget.payment.amount = val),
                  ),
                  TextFormField(
                    controller: dueDateCtl,
                    decoration: InputDecoration(labelText: 'Due Date'),
                    onTap: () => _selectDueDate(context),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a due date.';
                      }

                      return '';
                    },
                    onSaved: (val) => setState(() => widget.payment.dueDate = val),
                  ),
                  // Add TextFormFields and RaisedButton here.
                ]
            )
        ),
      )
    );
  }
}
