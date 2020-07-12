import 'package:duedate/db/Payment_DAO.dart';
import 'package:duedate/models/PaymentModel.dart';
import 'package:duedate/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:duedate/screens/edit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum FilterType {All, Completed, UnCompleted, Hidden, Recurring}

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
    Future<List<Payment>> result;

    switch (_selectedView) {
      case FilterType.All: {
        result = _paymentDAO.getAllPayments();
      }
      break;
      case FilterType.UnCompleted: {
        result = _paymentDAO.getUnCompletedPayments();
      }
      break;
      case FilterType.Completed: {
        result = _paymentDAO.getCompletedPayments();
      }
      break;
      case FilterType.Hidden: {
        result = _paymentDAO.getHiddenPayments();
      }
      break;
      case FilterType.Recurring: {
        result = _paymentDAO.getRecurringPayments();
      }
      break;
    }

    return result;
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

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.calendar_today),
        title: Text('Due Date'),
        //backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.settings,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: FutureBuilder<List<Payment>>(
        future: _paymentsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // data loaded:
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
        //color: Colors.deepOrange,
        shape: const CircularNotchedRectangle(),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new PopupMenuButton<FilterType>(
              onSelected: (value){
                setState(() => _selectedView = value);
                _paymentsFuture = _getPayments();
                },
              icon: Icon(Icons.filter_list),
              itemBuilder: (_) => [
                new CheckedPopupMenuItem<FilterType>(
                  checked: _selectedView == FilterType.Completed,
                  value: FilterType.Completed,
                  child: new Text('Completed', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                new CheckedPopupMenuItem<FilterType>(
                  checked: _selectedView == FilterType.UnCompleted,
                  value: FilterType.UnCompleted,
                  child: new Text('Uncompleted', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                new CheckedPopupMenuItem<FilterType>(
                  checked: _selectedView == FilterType.All,
                  value: FilterType.All,
                  child: new Text('All', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                new CheckedPopupMenuItem<FilterType>(
                  checked: _selectedView == FilterType.Hidden,
                  value: FilterType.Hidden,
                  child: new Text('Hidden', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                new CheckedPopupMenuItem<FilterType>(
                  checked: _selectedView == FilterType.Recurring,
                  value: FilterType.Recurring,
                  child: new Text('Recurring', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
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
        //backgroundColor: Colors.deepPurple,
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

  void _insertPayment(Payment payment) {
    _paymentDAO.insert(payment).then((result) {
      setState(() {
        _paymentsFuture = _getPayments();
      });
    });
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
                  actionOnPressed: () {

                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
