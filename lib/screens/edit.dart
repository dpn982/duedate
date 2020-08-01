import 'dart:convert';

import 'package:duedate/models/payment.dart';
import 'package:duedate/widgets/dd_dropdownformfield.dart';
import 'package:duedate/widgets/dd_switchformfield.dart';
import 'package:duedate/widgets/dd_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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
  OutlineInputBorder outlineBorder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 1.0,
      color: Colors.black,
    ),
  );
  static const EdgeInsetsGeometry fieldPadding = EdgeInsets.only(bottom: 15.0);

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
        completed: false,
        completedDate: null,
      );
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

  Future<void> loadIconList() async {
    _iconList = [];
    String iconJson = await rootBundle.loadString('assets/icons.json');
    List<Map> iconList = (jsonDecode(iconJson) as List<dynamic>).cast<Map>();
    iconList.map((Map map) {
      _iconList.add(generateIconMenuItem(map["name"], IconData(map["code"], fontFamily: map["font"])));
    });

    print(iconList.toString());

//    _iconList.add(generateIconMenuItem("Phone", Icons.phone_android));
//    _iconList.add(generateIconMenuItem("Payment", Icons.payment));
//    _iconList.add(generateIconMenuItem("Airplane", Icons.airplanemode_active));
//    _iconList.add(generateIconMenuItem("Bank", Icons.account_balance));
//    _iconList.add(generateIconMenuItem("House", Icons.home));
//    _iconList.add(generateIconMenuItem("Money", Icons.attach_money));
//    _iconList.add(generateIconMenuItem("Beach", Icons.beach_access));
//    _iconList.add(generateIconMenuItem("Video Game", Icons.videogame_asset));
//    _iconList.add(generateIconMenuItem("Book", Icons.book));
//    _iconList.add(generateIconMenuItem("Membership", Icons.card_membership));
//    _iconList.add(generateIconMenuItem("Travel", Icons.card_travel));
//    _iconList.add(generateIconMenuItem("Gambling", Icons.casino));
//    _iconList.add(generateIconMenuItem("Transit", Icons.directions_transit));
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
    DateTime selectedCompletedDate = (_dirtyPayment.completedDate == null)
        ? DateTime.now()
        : _dirtyPayment.completedDate;
    TextEditingController dueDateCtl = TextEditingController(
        text: selectedDate.toIso8601String().split('T')[0]);
    TextEditingController completedDateCtl = TextEditingController(
        text: selectedCompletedDate.toIso8601String().split('T')[0]);

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

    Future<Null> _selectCompletedDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedCompletedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now().add(Duration(days: 365)));
      if (picked != null && picked != selectedDate) {
        completedDateCtl.text =
            picked.toLocal().toIso8601String().split('T')[0];
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
              SizedBox(height: 8.0),
              CustomTextFormField(
                label: "Name",
                initialValue: _dirtyPayment.name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name.';
                  }

                  return null;
                },
                onSaved: (val) => setState(() => _dirtyPayment.name = val),
              ),
              CustomTextFormField(
                label: "Description",
                initialValue: _dirtyPayment.description,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }

                  return null;
                },
                onSaved: (val) =>
                    setState(() => _dirtyPayment.description = val),
              ),
              CustomTextFormField(
                label: "Amount",
                initialValue: _dirtyPayment.amount.toString(),
                prefixText: _simpleCurrencyFormat.currencySymbol,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an amount.';
                  }

                  return null;
                },
                onSaved: (val) =>
                    setState(() => _dirtyPayment.amount = double.parse(val)),
              ),
              CustomTextFormField(
                label: "Due Date",
                inputType: TextInputType.datetime,
                controller: dueDateCtl,
                onTap: () => _selectDueDate(context),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a due date.';
                  }

                  return null;
                },
                onSaved: (val) =>
                    setState(() => _dirtyPayment.dueDate = DateTime.parse(val)),
              ),
              CustomSwitchFormField(
                label: "Recurring Payment",
                value: _dirtyPayment.recurring,
                onChanged: (bool val) =>
                    setState(() => _dirtyPayment.recurring = val),
              ),
              CustomTextFormField(
                label: "Frequency",
                visible: _dirtyPayment.recurring == true,
                inputType: TextInputType.number,
                initialValue: _dirtyPayment.frequency.toString(),
                validator: (value) {
                  if (value.isEmpty && _dirtyPayment.recurring == true) {
                    return 'Please enter a frequency.';
                  }

                  return null;
                },
                onSaved: (val) =>
                    setState(() => _dirtyPayment.frequency = int.parse(val)),
              ),
              CustomDropdownFormField<String>(
                label: "Frequency Unis",
                visible: _dirtyPayment.recurring == true,
                hint: "Select Frequency Units",
                items: _frequencyList,
                value: _dirtyPayment.frequencyUnits,
                onChanged: (value) {
                  setState(() {
                    _dirtyPayment.frequencyUnits = value;
                  });
                },
              ),
              CustomDropdownFormField<Color>(
                label: "Color",
                hint: "Select Color",
                value: _dirtyPayment.color,
                items: _colorList,
                onChanged: (value) {
                  setState(() {
                    _dirtyPayment.color = value;
                  });
                },
              ),
              CustomDropdownFormField<IconData>(
                label: "Icon",
                hint: "Select Icon",
                items: _iconList,
                value: _dirtyPayment.icon,
                onChanged: (value) {
                  setState(() {
                    _dirtyPayment.icon = value;
                  });
                },
              ),
              CustomTextFormField(
                label: "Payment Method",
                initialValue: _dirtyPayment.paymentMethod,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a payment method.';
                  }

                  return null;
                },
                onSaved: (val) =>
                    setState(() => _dirtyPayment.paymentMethod = val),
              ),
              CustomSwitchFormField(
                label: "Hidden",
                value: _dirtyPayment.hidden,
                onChanged: (bool val) =>
                    setState(() => _dirtyPayment.hidden = val),
              ),
              CustomSwitchFormField(
                label: "Completed",
                value: _dirtyPayment.completed,
                onChanged: (bool val) =>
                    setState(() => _dirtyPayment.completed = val),
              ),
              CustomTextFormField(
                label: "Completed Date",
                visible: _dirtyPayment.completed == true,
                inputType: TextInputType.datetime,
                controller: completedDateCtl,
                onTap: () => _selectCompletedDate(context),
                validator: (value) {
                  if (value.isEmpty && _dirtyPayment.completed) {
                    return 'Please enter a due date.';
                  }

                  return null;
                },
                onSaved: (val) => setState(
                    () => _dirtyPayment.completedDate = DateTime.parse(val)),
              ),
              CustomTextFormField(
                label: "Notes",
                inputType: TextInputType.multiline,
                maxLines: 10,
                initialValue: _dirtyPayment.notes,
                onSaved: (val) => setState(() => _dirtyPayment.notes = val),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
