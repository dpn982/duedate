import 'package:duedate/models/PaymentModel.dart';
import 'package:flutter/material.dart';
import 'package:duedate/screens/edit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final payments = [Payment(id: 1, name: "mobile", description: "mobile bill", amount: 100.00, createdDate: DateTime.parse("2020/06/25"), dueDate: DateTime.parse("2020/07/03"), recurring: true, frequency: 1, frequencyUnits: "MONTHS", color: Colors.green, icon: Icons.phone_android, paymentMethod: "visa", interestPercentage: 0, compoundedFrequency: "0", notes: "", enabled: true, hidden: false)];

  final SlidableController slidableController = SlidableController();

  void _doAction() {
    setState(() {
      
    });
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
      body: mainListView(context),
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
        onPressed: _doAction,
        tooltip: 'Do Action',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget mainListView(BuildContext context) {
    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.25,
          controller: slidableController,
          child: Container(
            color: Colors.white,
            child: Card( //                           <-- Card widget
              color: payments[index].color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Icon(payments[index].icon),
                title: Text(payments[index].name),
                subtitle: Text("Due: ${payments[index].dueDate}"),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  final payment = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(payment: payments[index]),
                    ),
                  );

                  setState(() {
                    if (payment != null) {
                      payments[index] = payment;
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
