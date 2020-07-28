import 'package:duedate/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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
  Payment _dirtyPayment;
  Locale _locale;
  NumberFormat _simpleCurrencyFormat;

  @override
  void initState() {
    super.initState();
    _dirtyPayment = widget.payment;
    if (_dirtyPayment == null) {
      _dirtyPayment = Payment(
          name: "",
          description: "",
          amount: 0.00,
          dueDate: DateTime.now(),
          recurring: false,
          frequency: null,
          frequencyUnits: "SECONDS",
          color: Colors.blue[500],
          icon: Icons.payment,
          paymentMethod: "",
          interestPercentage: 0,
          compoundedFrequency: "",
          notes: "",
          hidden: false,
          completed: false);
    }
    loadFrequencyUnits();
    loadColorList();
    loadIconList();
  }

  void loadFrequencyUnits() {
    _frequencyList = [];
    _frequencyList.add(DropdownMenuItem(
      child: Text("Seconds"),
      value: "SECONDS",
    ));
    _frequencyList.add(DropdownMenuItem(
      child: Text("Minutes"),
      value: "MINUTES",
    ));
    _frequencyList.add(DropdownMenuItem(
      child: Text("Hours"),
      value: "HOURS",
    ));
    _frequencyList.add(DropdownMenuItem(
      child: Text("Days"),
      value: "DAYS",
    ));
    _frequencyList.add(DropdownMenuItem(
      child: Text("Weeks"),
      value: "WEEKS",
    ));
    _frequencyList.add(DropdownMenuItem(
      child: Text("Months"),
      value: "MONTHS",
    ));
    _frequencyList.add(DropdownMenuItem(
      child: Text("Years"),
      value: "YEARS",
    ));
  }

  void loadColorList() {
    _colorList = [];
    _colorList.add(generateColorMenuItem("Red", Colors.red[500]));
    _colorList.add(generateColorMenuItem("Blue", Colors.blue[500]));
    _colorList.add(generateColorMenuItem("Green", Colors.green[500]));
    _colorList.add(generateColorMenuItem("Purple", Colors.purple[500]));
    _colorList.add(generateColorMenuItem("Orange", Colors.orange[500]));
    _colorList.add(generateColorMenuItem("Yellow", Colors.yellow[500]));
    _colorList.add(generateColorMenuItem("Pink", Colors.pink[500]));
    _colorList.add(generateColorMenuItem("Brown", Colors.brown[500]));
    _colorList.add(generateColorMenuItem("Teal", Colors.teal[500]));
    _colorList.add(generateColorMenuItem("Indigo", Colors.indigo[500]));
    _colorList.add(generateColorMenuItem("Amber", Colors.amber[500]));
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
    return DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Container(
            width: 15,
            height: 15,
            color: value,
          ),
          SizedBox(
            width: 10,
          ),
          Text(text),
        ],
      ),
      value: value,
    );
  }

  DropdownMenuItem<IconData> generateIconMenuItem(String text, IconData value) {
    return DropdownMenuItem(
      child: Row(
        children: <Widget>[
          Icon(value),
          SizedBox(
            width: 10,
          ),
          Text(text),
        ],
      ),
      value: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    _locale = Localizations.localeOf(context);
    _simpleCurrencyFormat =
        NumberFormat.simpleCurrency(locale: _locale.toString());
    DateTime selectedDate = _dirtyPayment.dueDate;
    TextEditingController dueDateCtl = TextEditingController(
        text: selectedDate.toIso8601String().split('T')[0]);

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
        title: Text(_dirtyPayment.name),
        elevation: 0.0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    Navigator.pop(context, _dirtyPayment);
                  }
                },
                child: Icon(
                  Icons.save,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: _dirtyPayment.name,
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
                  onSaved: (val) => setState(() => _dirtyPayment.name = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: _dirtyPayment.description,
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
                  onSaved: (val) =>
                      setState(() => _dirtyPayment.description = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: _dirtyPayment.amount.toString(),
                  decoration: InputDecoration(
                    prefixText: _simpleCurrencyFormat.currencySymbol,
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an amount.';
                    }

                    return null;
                  },
                  onSaved: (val) =>
                      setState(() => _dirtyPayment.amount = double.parse(val)),
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
                  onSaved: (val) => setState(
                      () => _dirtyPayment.dueDate = DateTime.parse(val)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SwitchListTile(
                    title: const Text('Recurring Payment'),
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    value: _dirtyPayment.recurring,
                    onChanged: (bool val) =>
                        setState(() => _dirtyPayment.recurring = val)),
              ),
              Visibility(
                visible: _dirtyPayment.recurring == true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _dirtyPayment.frequency.toString(),
                    decoration: InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value.isEmpty && _dirtyPayment.recurring == true) {
                        return 'Please enter a frequency.';
                      }

                      return null;
                    },
                    onSaved: (val) => setState(
                        () => _dirtyPayment.frequency = int.parse(val)),
                  ),
                ),
              ),
              Visibility(
                visible: _dirtyPayment.recurring == true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: DropdownButtonFormField(
                    hint: Text('Select Frequency Units'),
                    items: _frequencyList,
                    decoration: InputDecoration(
                      labelText: 'Frequency Units',
                      border: OutlineInputBorder(),
                    ),
                    value: _dirtyPayment.frequencyUnits,
                    onChanged: (value) {
                      setState(() {
                        _dirtyPayment.frequencyUnits = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: DropdownButtonFormField(
                  hint: Text('Select Color'),
                  items: _colorList,
                  decoration: InputDecoration(
                    labelText: 'Color',
                    border: OutlineInputBorder(),
                  ),
                  value: _dirtyPayment.color,
                  onChanged: (value) {
                    setState(() {
                      _dirtyPayment.color = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: DropdownButtonFormField(
                  hint: Text('Select Icon'),
                  items: _iconList,
                  decoration: InputDecoration(
                    labelText: 'Icon',
                    border: OutlineInputBorder(),
                  ),
                  value: _dirtyPayment.icon,
                  onChanged: (value) {
                    setState(() {
                      _dirtyPayment.icon = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  initialValue: _dirtyPayment.paymentMethod,
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
                  onSaved: (val) =>
                      setState(() => _dirtyPayment.paymentMethod = val),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SwitchListTile(
                    title: const Text('Hidden'),
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    value: _dirtyPayment.hidden,
                    onChanged: (bool val) =>
                        setState(() => _dirtyPayment.hidden = val)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SwitchListTile(
                    title: const Text('Completed'),
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    value: _dirtyPayment.completed,
                    onChanged: (bool val) =>
                        setState(() => _dirtyPayment.completed = val)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  initialValue: _dirtyPayment.notes,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (val) => setState(() => _dirtyPayment.notes = val),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
