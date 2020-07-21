import 'package:duedate/models/enums.dart';
import 'package:duedate/models/payment.dart';

class PaymentEvent {
  final BlocOperation operation;
  final Payment payment;

  PaymentEvent({this.operation, this.payment});
}