import 'package:duedate/db/payment_dao.dart';
import 'package:duedate/models/filter_type.dart';
import 'package:duedate/models/payment.dart';
import 'package:duedate/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:duedate/screens/edit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PaymentDAO _paymentDAO = PaymentDAO();
  final SlidableController slidableController = SlidableController();
  Future<List<Payment>> _paymentsFuture;
  FilterType _selectedView;

  @override
  void initState() {
    super.initState();
    _selectedView = FilterType.UnCompleted;
    _paymentsFuture = _getPayments();
  }

  Future<List<Payment>> _getPayments() async {
    return _paymentDAO.getPayments(filterType: _selectedView);
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

  void _insertPayment(Payment payment) {
    _paymentDAO.insert(payment).then((result) {
      setState(() {
        _paymentsFuture = _getPayments();
      });
    });
  }

  _showDeleteConfirmation(BuildContext context,
      {Function cancelPressed, Function continuePressed}) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () => cancelPressed(),
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () => continuePressed(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Confirmation"),
      content: Text("Are you sure you want to delete this item?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
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
      body: FutureBuilder<List<Payment>>(
        future: _paymentsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final _paymentsList = snapshot.data;
              return mainListView(context, _paymentsList);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
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
                setState(() => _selectedView = value);
                _paymentsFuture = _getPayments();
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
              onPressed: () {},
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
            _insertPayment(payment);
          }
        },
        tooltip: 'Do Action',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget mainListView(BuildContext context, List<Payment> _payments) {
    return RefreshIndicator(
      onRefresh: () async {
        _paymentsFuture = _getPayments();
      },
      child: ListView.builder(
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: 0.25,
            controller: slidableController,
            child: Container(
              color: _payments[index].color,
              child: Card(
                //                           <-- Card widget
                color: _payments[index].color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
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
                      _paymentDAO.update(payment).then((result) {
                        setState(() {
                          _paymentsFuture = _getPayments();
                        });
                      });
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
                    _paymentDAO.delete(_payments[index]).then((result) {
                      Navigator.pop(context);
                      setState(() {
                        _paymentsFuture = _getPayments();
                      });
                    });
                    _showSnackBar(
                      context,
                      text: "Delete ${currentPayment.name}",
                      actionText: "Undo",
                      actionOnPressed: () {
                        _insertPayment(currentPayment);
                      },
                    );
                  });
                },
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blue,
                icon: Icons.archive,
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
      ),
    );
  }
}
