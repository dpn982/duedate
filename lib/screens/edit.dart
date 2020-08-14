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
        frequency: 0,
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

  void loadFrequencyUnits() async {
    _frequencyList = [];
    String unitsJson = await rootBundle.loadString('assets/frequency_units.json');
    List<Map> unitsList = (jsonDecode(unitsJson) as List<dynamic>).cast<Map>();

    setState(() {
      for (Map mapItem in unitsList) {
        _frequencyList.add(DropdownMenuItem(
          child: Text(mapItem["name"]),
          value: mapItem["value"],
        ));
      }
    });
  }

  void loadColorList() async {
    _colorList = [];
    String colorJson = await rootBundle.loadString('assets/colors.json');
    List<Map> colorList = (jsonDecode(colorJson) as List<dynamic>).cast<Map>();

    setState(
      () {
        for (Map mapItem in colorList) {
          _colorList.add(
            DropdownMenuItem(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 15,
                    height: 15,
                    color: Color(
                      int.parse(
                        mapItem["value"],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(mapItem["name"]),
                ],
              ),
              value: Color(
                int.parse(
                  mapItem["value"],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> loadIconList() async {
    _iconList = [];
    String iconJson = await rootBundle.loadString('assets/icons.json');
    List<Map> iconList = (jsonDecode(iconJson) as List<dynamic>).cast<Map>();

    setState(
      () {
        for (Map mapItem in iconList) {
          _iconList.add(
            DropdownMenuItem(
              child: Row(
                children: <Widget>[
                  Icon(
                    IconData(
                      mapItem["code"],
                      fontFamily: mapItem["font"],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(mapItem["name"]),
                ],
              ),
              value: IconData(
                mapItem["code"],
                fontFamily: mapItem["font"],
              ),
            ),
          );
        }
      },
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
