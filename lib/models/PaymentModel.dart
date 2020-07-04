import 'dart:convert';

import 'package:flutter/cupertino.dart';

Payment paymentFromJson(String str) => Payment.fromMap(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toMap());

class Payment {
  Payment({
    this.id,
    this.name,
    this.description,
    this.amount,
    this.createdDate,
    this.dueDate,
    this.recurring,
    this.frequency,
    this.units,
    this.color,
    this.icon,
    this.paymentMethod,
    this.interestPercentage,
    this.compoundedFrequency,
    this.notes,
    this.enabled,
    this.hidden,
  });

  int id;
  String name;
  String description;
  String amount;
  String createdDate;
  String dueDate;
  bool recurring;
  int frequency;
  String units;
  Color color;
  IconData icon;
  String paymentMethod;
  int interestPercentage;
  String compoundedFrequency;
  String notes;
  bool enabled;
  bool hidden;

  factory Payment.fromMap(Map<String, dynamic> json) => Payment(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    amount: json["amount"],
    createdDate: json["created_date"],
    dueDate: json["due_date"],
    recurring: json["recurring"],
    frequency: json["frequency"],
    units: json["units"],
    color: Color(int.parse(json["color"])),
    icon: IconData(int.parse(json["icon"]), fontFamily: 'MaterialIcons'),
    paymentMethod: json["payment_method"],
    interestPercentage: json["interest_percentage"],
    compoundedFrequency: json["compounded_frequency"],
    notes: json["notes"],
    enabled: json["enabled"],
    hidden: json["hidden"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "amount": amount,
    "created_date": createdDate,
    "due_date": dueDate,
    "recurring": recurring,
    "frequency": frequency,
    "units": units,
    "color": color.value,
    "icon": icon.codePoint,
    "payment_method": paymentMethod,
    "interest_percentage": interestPercentage,
    "compounded_frequency": compoundedFrequency,
    "notes": notes,
    "enabled": enabled,
    "hidden": hidden,
  };
}