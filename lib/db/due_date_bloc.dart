import 'package:duedate/db/payment_dao.dart';
import 'package:duedate/models/payment.dart';
import 'package:duedate/models/enums.dart';
import 'package:duedate/models/payment_event.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class DueDateBloc {
  final PaymentDAO _paymentDAO = new PaymentDAO();
  final _paymentsSubject = BehaviorSubject<List<Payment>>();

  final _filterTypeController = StreamController<FilterType>();
  final _crudPaymentController = StreamController<PaymentEvent>();
  Stream<List<Payment>> get payments => _paymentsSubject.stream;
  Sink<FilterType> get filterType => _filterTypeController.sink;
  Sink<PaymentEvent> get crud => _crudPaymentController.sink;

  var _payments = <Payment>[];

  DueDateBloc() {
    _loadAndPopulateStream();
    
    _filterTypeController.stream.listen((filterType) {
      _loadAndPopulateStream(filterType: filterType);
    });

    _crudPaymentController.stream.listen((paymentEvent) {
      switch (paymentEvent.operation) {
        case BlocOperation.Insert:
          {
            _insertPayment(paymentEvent.payment).then((_) {
              _loadAndPopulateStream();
            });
          }
          break;
        case BlocOperation.Delete:
          {
            _deletePayment(paymentEvent.payment).then((_) {
              _loadAndPopulateStream();
            });
          }
          break;
        case BlocOperation.Update:
          {
            _updatePayment(paymentEvent.payment).then((_) {
              _loadAndPopulateStream();
            });
          }
          break;
      }
    });
  }

  void _loadAndPopulateStream({filterType: FilterType.All}) {
    _loadPayments(filterType: filterType).then((_) {
      _paymentsSubject.add(_payments);
    });
  }

  Future<Null> _loadPayments({filterType: FilterType.All}) async {
    _payments = await _paymentDAO.getPayments(filterType: filterType);
  }

  Future<Null> _insertPayment(Payment payment) async {
    await _paymentDAO.insert(payment);
  }

  Future<Null> _deletePayment(Payment payment) async {
    await _paymentDAO.delete(payment);
  }

  Future<Null> _updatePayment(Payment payment) async {
    await _paymentDAO.update(payment);
  }
}
