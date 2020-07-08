import 'package:duedate/db/Payment_DAO.dart';
import 'package:duedate/models/PaymentModel.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.calendar_today),
        title: Text('Due Date'),
        //backgroundColor: Colors.deepOrange,
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
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditScreen(payment: null),
            ),
          );

          setState(() {
            _paymentsFuture = _paymentDAO.getAllPayments();
          });
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
            color: Colors.white,
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

                  setState(() {
                    if (payment != null) {
                      _paymentDAO.update(payment);
                      _paymentsFuture = _paymentDAO.getAllPayments();
                    }
                  });
                },
              ),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Archive',
              color: Colors.blue,
              icon: Icons.archive,
              onTap: () => _showSnackBar(context, 'Archive'),
            ),
            IconSlideAction(
              caption: 'Share',
              color: Colors.indigo,
              icon: Icons.share,
              onTap: () => _showSnackBar(context, 'Share'),
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'More',
              color: Colors.black45,
              icon: Icons.more_horiz,
              onTap: () => _showSnackBar(context, 'More'),
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => _showSnackBar(context, 'Delete'),
            ),
          ],
        );
      },
    );
  }
}
