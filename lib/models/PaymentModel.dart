import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

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
    this.frequencyUnits,
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
  double amount;
  DateTime createdDate;
  DateTime dueDate;
  bool recurring;
  int frequency;
  String frequencyUnits;
  Color color;
  IconData icon;
  String paymentMethod;
  int interestPercentage;
  String compoundedFrequency;
  String notes;
  bool enabled;
  bool hidden;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    amount: json["amount"].toDouble(),
    createdDate: DateTime.parse(json["createdDate"]),
    dueDate: DateTime.parse(json["dueDate"]),
    recurring: json["recurring"],
    frequency: json["frequency"] == null ? null : json["frequency"],
    frequencyUnits: json["frequencyUnits"] == null ? null : json["frequencyUnits"],
    color: Color(int.parse(json["color"])),
    icon: IconData(int.parse(json["icon"]), fontFamily: 'MaterialIcons'),
    paymentMethod: json["payment_method"],
    interestPercentage: json["interestPercentage"] == null ? null : json["interestPercentage"],
    compoundedFrequency: json["compoundedFrequency"] == null ? null : json["compoundedFrequency"],
    notes: json["notes"] == null ? null : json["notes"],
    enabled: json["enabled"],
    hidden: json["hidden"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "amount": amount,
    "createdDate": createdDate.toIso8601String(),
    "dueDate": dueDate.toIso8601String(),
    "recurring": recurring,
    "frequency": frequency == null ? null : frequency,
    "frequencyUnits": frequencyUnits == null ? null : frequencyUnits,
    "color": color.value,
    "icon": icon.codePoint,
    "payment_method": paymentMethod,
    "interestPercentage": interestPercentage == null ? null : interestPercentage,
    "compoundedFrequency": compoundedFrequency == null ? null : compoundedFrequency,
    "notes": notes == null ? null : notes,
    "enabled": enabled,
    "hidden": hidden,
  };
}