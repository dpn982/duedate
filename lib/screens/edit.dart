import 'package:duedate/models/PaymentModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EditScreen extends StatefulWidget {
  final Payment payment;

  EditScreen({Key key, @required this.payment}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _frequencyList = [];
  List<DropdownMenuItem<Color>> _colorList = [];
  List<DropdownMenuItem<IconData>> _iconList = [];

  void loadFrequencyUnits() {
    _frequencyList = [];
    _frequencyList.add(new DropdownMenuItem(child: Text("Seconds"), value: "SECONDS",));
    _frequencyList.add(new DropdownMenuItem(child: Text("Minutes"), value: "MINUTES",));
    _frequencyList.add(new DropdownMenuItem(child: Text("Hours"), value: "HOURS",));
    _frequencyList.add(new DropdownMenuItem(child: Text("Days"), value: "DAYS",));
    _frequencyList.add(new DropdownMenuItem(child: Text("Weeks"), value: "WEEKS",));
    _frequencyList.add(new DropdownMenuItem(child: Text("Months"), value: "MONTHS",));
    _frequencyList.add(new DropdownMenuItem(child: Text("Years"), value: "YEARS",));
  }

  void loadColorList() {
    _colorList = [];
    _colorList.add(generateColorMenuItem("Red", Colors.red));
    _colorList.add(generateColorMenuItem("Blue", Colors.blue));
    _colorList.add(generateColorMenuItem("Green", Colors.green));
    _colorList.add(generateColorMenuItem("Purple", Colors.purple));
    _colorList.add(generateColorMenuItem("Orange", Colors.orange));
    _colorList.add(generateColorMenuItem("Yellow", Colors.yellow));
    _colorList.add(generateColorMenuItem("Pink", Colors.pink));
    _colorList.add(generateColorMenuItem("Brown", Colors.brown));
    _colorList.add(generateColorMenuItem("Teal", Colors.teal));
    _colorList.add(generateColorMenuItem("Indigo", Colors.indigo));
    _colorList.add(generateColorMenuItem("Amber", Colors.amber));
  }

  void loadIconList() {
    _iconList = [];
    _iconList.add(generateIconMenuItem("Phone", Icons.phone_android));
    _iconList.add(generateIconMenuItem("Payment", Icons.payment));
    _iconList.add(generateIconMenuItem("Airplane", Icons.airplanemode_active));
    _iconList.add(generateIconMenuItem("Bank", Icons.account_balance));
    _iconList.add(generateIconMenuItem("House", Icons.home));
    _iconList.add(generateIconMenuItem("Money", Icons.attach_money));
    _iconList.add(generateIconMenuItem("Beach", Icons.beach_access));
    _iconList.add(generateIconMenuItem("Video Game", Icons.videogame_asset));
    _iconList.add(generateIconMenuItem("Book", Icons.book));
    _iconList.add(generateIconMenuItem("Membership", Icons.card_membership));
    _iconList.add(generateIconMenuItem("Travel", Icons.card_travel));
    _iconList.add(generateIconMenuItem("Gambling", Icons.casino));
    _iconList.add(generateIconMenuItem("Transit", Icons.directions_transit));
  }

  DropdownMenuItem<Color> generateColorMenuItem(String text, Color value) {
    return new DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Container(
            width: 15,
            height: 15,
            color: value,
          ),
          SizedBox(width: 10,),
          Text(text),
        ],
      ),
      value: value,
    );
  }

  DropdownMenuItem<IconData> generateIconMenuItem(String text, IconData value) {
    return new DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Icon(value),
          SizedBox(width: 10,),
          Text(text),
        ],
      ),
      value: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    loadFrequencyUnits();
    loadColorList();
    loadIconList();
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
          //backgroundColor: Colors.purple,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      Navigator.pop(context, widget.payment);
                    }
                  },
                  child: Icon(
                    Icons.save,
                    size: 26.0,
                  ),
                )
            ),
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        initialValue: widget.payment.name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name.';
                          }

                          return null;
                        },
                        onSaved: (val) => setState(() => widget.payment.name = val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        initialValue: widget.payment.description,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }

                          return null;
                        },
                        onSaved: (val) => setState(() => widget.payment.description = val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: widget.payment.amount,
                        decoration: InputDecoration(
                            prefixText: '\$',
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an amount.';
                          }

                          return null;
                        },
                        onSaved: (val) => setState(() => widget.payment.amount = val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: dueDateCtl,
                        decoration: InputDecoration(
                            labelText: 'Due Date',
                            border: OutlineInputBorder(),
                        ),
                        onTap: () => _selectDueDate(context),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a due date.';
                          }

                          return null;
                        },
                        onSaved: (val) => setState(() => widget.payment.dueDate = val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: SwitchListTile(
                          title: const Text('Recurring Payment'),
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: Colors.red,
                          value: widget.payment.recurring,
                          onChanged: (bool val) =>
                              setState(() => widget.payment.recurring = val)
                      ),
                    ),
                    Visibility(
                      visible: widget.payment.recurring == true,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: widget.payment.frequency.toString(),
                          decoration: InputDecoration(
                            labelText: 'Frequency',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty && widget.payment.recurring == true) {
                              return 'Please enter a frequency.';
                            }

                            return null;
                          },
                          onSaved: (val) => setState(() => widget.payment.frequency = int.parse(val)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.payment.recurring == true,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: DropdownButtonFormField(
                          hint: new Text('Select Frequency Units'),
                          items: _frequencyList,
                          decoration: InputDecoration(
                            labelText: 'Frequency Units',
                            border: OutlineInputBorder(),
                          ),
                          value: widget.payment.units,
                          onChanged: (value) {
                            setState(() {
                              widget.payment.units = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: DropdownButtonFormField(
                        hint: new Text('Select Color'),
                        items: _colorList,
                        decoration: InputDecoration(
                          labelText: 'Color',
                          border: OutlineInputBorder(),
                        ),
                        value: widget.payment.color,
                        onChanged: (value) {
                          setState(() {
                            widget.payment.color = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: DropdownButtonFormField(
                        hint: new Text('Select Icon'),
                        items: _iconList,
                        decoration: InputDecoration(
                          labelText: 'Icon',
                          border: OutlineInputBorder(),
                        ),
                        value: widget.payment.icon,
                        onChanged: (value) {
                          setState(() {
                            widget.payment.icon = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        initialValue: widget.payment.paymentMethod,
                        decoration: InputDecoration(
                          labelText: 'Payment Method',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a payment method.';
                          }

                          return null;
                        },
                        onSaved: (val) => setState(() => widget.payment.paymentMethod = val),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: SwitchListTile(
                          title: const Text('Enabled'),
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: Colors.red,
                          value: widget.payment.enabled,
                          onChanged: (bool val) =>
                              setState(() => widget.payment.enabled = val)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: SwitchListTile(
                          title: const Text('Hidden'),
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: Colors.red,
                          value: widget.payment.hidden,
                          onChanged: (bool val) =>
                              setState(() => widget.payment.hidden = val)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        initialValue: widget.payment.notes,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (val) => setState(() => widget.payment.notes = val),
                      ),
                    ),
                    // Add TextFormFields and RaisedButton here.
                  ]
              )
          ),
        ),
      )
    );
  }
}
