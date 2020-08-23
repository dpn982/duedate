import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Payment({
    this.name,
    this.description,
    this.amount,
    this.dueDate,
    this.recurring,
    this.frequency,
    this.frequencyUnits,
    this.notification,
    this.notificationFrequency,
    this.notificationFrequencyUnits,
    this.color,
    this.icon,
    this.paymentMethod,
    this.interestPercentage,
    this.compoundedFrequency,
    this.notes,
    this.hidden,
    this.completed,
    this.completedDate,
    this.tags,
  });

  int id;
  String name;
  String description;
  double amount;
  DateTime createdDate = DateTime.now();
  DateTime dueDate;
  bool recurring;
  int frequency;
  String frequencyUnits;
  Color color;
  bool notification;
  int notificationFrequency;
  String notificationFrequencyUnits;
  IconData icon;
  String paymentMethod;
  double interestPercentage;
  String compoundedFrequency;
  String notes;
  bool hidden;
  bool completed;
  DateTime completedDate;
  List<dynamic> tags;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        name: json["name"],
        description: json["description"],
        amount: json["amount"].toDouble(),
        dueDate: DateTime.parse(json["dueDate"]),
        recurring: json["recurring"],
        frequency: json["frequency"] == null ? 0 : json["frequency"],
        frequencyUnits:
            json["frequencyUnits"] == null ? "DAYS" : json["frequencyUnits"],
        notification:
            json["notification"] == null ? false : json["notification"],
        notificationFrequency: json["notificationFrequency"] == null
            ? 0
            : json["notificationFrequency"],
        notificationFrequencyUnits: json["notificationFrequencyUnits"] == null
            ? "DAYS"
            : json["notificationFrequencyUnits"],
        color: Color(json["color"]),
        icon: IconData(json["icon"], fontFamily: 'MaterialIcons'),
        paymentMethod: json["payment_method"],
        interestPercentage: json["interestPercentage"] == null
            ? null
            : json["interestPercentage"].toDouble(),
        compoundedFrequency: json["compoundedFrequency"] == null
            ? null
            : json["compoundedFrequency"],
        notes: json["notes"] == null ? null : json["notes"],
        hidden: json["hidden"],
        completed: json["completed"],
        completedDate: json["completedDate"] == null
            ? null
            : DateTime.parse(json["completedDate"]),
        tags: json["tags"] == null ? List<dynamic>() : jsonDecode(json["tags"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "amount": amount,
        "createdDate": createdDate.toIso8601String(),
        "dueDate": dueDate.toIso8601String(),
        "recurring": recurring,
        "frequency": frequency == null ? 0 : frequency,
        "frequencyUnits": frequencyUnits == null ? "DAYS" : frequencyUnits,
        "notification": notification == null ? false : notification,
        "notificationFrequency":
            notificationFrequency == null ? 0 : notificationFrequency,
        "notificationFrequencyUnits": notificationFrequencyUnits == null
            ? "DAYS"
            : notificationFrequencyUnits,
        "color": color.value,
        "icon": icon.codePoint,
        "payment_method": paymentMethod,
        "interestPercentage":
            interestPercentage == null ? null : interestPercentage,
        "compoundedFrequency":
            compoundedFrequency == null ? null : compoundedFrequency,
        "notes": notes == null ? null : notes,
        "hidden": hidden,
        "completed": completed,
        "completedDate":
            completedDate == null ? null : completedDate.toIso8601String(),
        "tags": tags == null ? [] : jsonEncode(tags),
      };

  String formatDueDate() {
    return dateFormat.format(dueDate);
  }
}
