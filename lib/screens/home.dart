import 'package:duedate/db/Payment_DAO.dart';
import 'package:duedate/models/PaymentModel.dart';
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

  @override
  void initState() {
      super.initState();
      _paymentsFuture = _paymentDAO.getAllPayments();
  }

  void _showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _showDeleteConfirmation(BuildContext context, {Function cancelPressed, Function continuePressed}) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () => cancelPressed(),
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () => continuePressed(),
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
              )
          ),
        ],
      ),
      body: FutureBuilder<List<Payment>> (
        future: _paymentsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Payment>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // data loaded:
              final _paymentsList = snapshot.data;
              return mainListView(context, _paymentsList);
            }
            else if (snapshot.hasError) {
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
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {

              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {

              },
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
            print("inserting payment");
            _paymentDAO.insert(payment);
            await new Future.delayed(const Duration(seconds : 5));
            final result = _paymentDAO.getAllPayments();

            setState(() {
              _paymentsFuture = result;
            });
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
        final result = _paymentDAO.getAllPayments();

        setState(() {
          _paymentsFuture = result;
        });
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
              child: Card( //                           <-- Card widget
                color: _payments[index].color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
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
                        builder: (context) => EditScreen(payment: _payments[index]),
                      ),
                    );

                    if (payment != null) {
                      _paymentDAO.update(payment);
                    }
                    await new Future.delayed(const Duration(seconds : 20));
                    final result = _paymentDAO.getAllPayments();

                    setState(() {
                      _paymentsFuture = result;
                    });
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
                  _showDeleteConfirmation(context,
                      cancelPressed: () {
                        Navigator.pop(context);
                      },
                      continuePressed: () {
                        _paymentDAO.delete(_payments[index]);

                        _showSnackBar(context, "Delete ${_payments[index].name}");
                        final result = _paymentDAO.getAllPayments();

                        setState(() {
                          _paymentsFuture = result;
                        });
                        Navigator.pop(context);
                      });
                },
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blue,
                icon: Icons.archive,
                onTap: () => _showSnackBar(context, 'Archive'),
              ),
            ],
          );
        },
      ),
    );
  }
}
