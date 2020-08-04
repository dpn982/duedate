import 'dart:async';

import 'package:duedate/db/payment_dao.dart';
import 'package:duedate/models/payment.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final PaymentDAO _paymentDAO = new PaymentDAO();
  final _paymentsSearchSubject = BehaviorSubject<List<Payment>>();
  final _searchTermController = StreamController<String>();

  Stream<List<Payment>> get searchResults => _paymentsSearchSubject.stream;
  Sink<String> get searchTerm => _searchTermController.sink;

  var _searchResults = <Payment>[];

  SearchBloc() {
    _searchTermController.stream.listen((query) {
      _loadAndPopulateSearchStream(query);
    });
  }

  void _loadAndPopulateSearchStream(String query) {
    _loadSearchResults(query).then((_) {
      _paymentsSearchSubject.add(_searchResults);
    });
  }

  Future<Null> _loadSearchResults(query) async {
    _searchResults = await _paymentDAO.getPaymentsByName(query);
  }

  void close() {
    _paymentsSearchSubject.close();
    _searchTermController.close();
  }
}
