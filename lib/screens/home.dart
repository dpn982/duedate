import 'package:duedate/models/enums.dart';
import 'package:duedate/models/payment.dart';
import 'package:duedate/models/payment_event.dart';
import 'package:duedate/screens/settings.dart';
import 'package:duedate/widgets/DueDateSearch.dart';
import 'package:duedate/widgets/dd_inheritedwidget.dart';
import 'package:flutter/material.dart';
import 'package:duedate/screens/edit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SlidableController slidableController = SlidableController();
  FilterType _selectedView;

  @override
  void initState() {
    super.initState();
    _selectedView = FilterType.UnCompleted;
  }

  CheckedPopupMenuItem<FilterType> _getPopupMenuItem(
      String text, FilterType type) {
    return CheckedPopupMenuItem<FilterType>(
      checked: _selectedView == type,
      value: type,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void _showSnackBar(BuildContext context,
      {String text, String actionText, Function actionOnPressed}) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: actionText,
        onPressed: () => actionOnPressed(),
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  _showDeleteConfirmation(BuildContext context,
      {Function cancelPressed, Function continuePressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => cancelPressed(),
            ),
            FlatButton(
              child: Text("Continue"),
              onPressed: () => continuePressed(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.calendar_today),
        title: Text('Due Date'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Payment>>(
        stream: InheritedData.of(context).payments,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
          if (snapshot.hasData) {
            return mainListView(context, snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            PopupMenuButton<FilterType>(
              onSelected: (value) {
                _selectedView = value;
                InheritedData.of(context).filterType.add(value);
              },
              icon: Icon(Icons.filter_list),
              itemBuilder: (_) => [
                _getPopupMenuItem("Completed", FilterType.Completed),
                _getPopupMenuItem("Uncompleted", FilterType.UnCompleted),
                _getPopupMenuItem("All", FilterType.All),
                _getPopupMenuItem("Hidden", FilterType.Hidden),
                _getPopupMenuItem("Recurring", FilterType.Recurring),
              ],
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DueDateSearch(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final payment = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditScreen(payment: null),
            ),
          );

          if (payment != null) {
            InheritedData.of(context).crud.add(PaymentEvent(
                  operation: BlocOperation.Insert,
                  payment: payment,
                ));
          }
        },
        tooltip: 'Do Action',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget mainListView(BuildContext context, List<Payment> _payments) {
    return ListView.builder(
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.25,
          controller: slidableController,
          child: Container(
            //color: _payments[index].color,
            child: Card(
              //                           <-- Card widget
              color: _payments[index].color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                leading: Icon(_payments[index].icon),
                title: Text(_payments[index].name),
                subtitle: Text("Due: ${_payments[index].formatDueDate()}"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  final payment = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditScreen(payment: _payments[index]),
                    ),
                  );

                  if (payment != null) {
                    InheritedData.of(context).crud.add(PaymentEvent(
                          operation: BlocOperation.Update,
                          payment: payment,
                        ));
                  }
                },
              ),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                Payment currentPayment = _payments[index];
                _showDeleteConfirmation(context, cancelPressed: () {
                  Navigator.pop(context);
                }, continuePressed: () {
                  InheritedData.of(context).crud.add(PaymentEvent(
                        operation: BlocOperation.Delete,
                        payment: _payments[index],
                      ));
                  Navigator.pop(context);
                  _showSnackBar(
                    context,
                    text: "Delete ${currentPayment.name}",
                    actionText: "Undo",
                    actionOnPressed: () {
                      InheritedData.of(context).crud.add(PaymentEvent(
                            operation: BlocOperation.Insert,
                            payment: currentPayment,
                          ));
                    },
                  );
                });
              },
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Share',
              color: Colors.blueGrey,
              icon: Icons.share,
              onTap: () => _showSnackBar(
                context,
                text: 'Archive',
                actionText: "Undo",
                actionOnPressed: () {},
              ),
            ),
            IconSlideAction(
              caption: 'Complete',
              color: Colors.green,
              icon: Icons.check,
              onTap: () => _showSnackBar(
                context,
                text: 'Archive',
                actionText: "Undo",
                actionOnPressed: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}
