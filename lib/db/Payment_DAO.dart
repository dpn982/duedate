import 'package:sembast/sembast.dart';
import '../models/PaymentModel.dart';
import 'DatabaseSetup.dart';

class PaymentDAO {
  static const String folderName = "Payments";
  final _paymentFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<int> insert(Payment payment) async {
    return await _paymentFolder.add(await _db, payment.toJson());
  }

  Future<int> update(Payment payment) async {
    final finder = Finder(filter: Filter.byKey(payment.id));
    return await _paymentFolder.update(await _db, payment.toJson(),
        finder: finder);
  }

  Future<int> delete(Payment payment) async {
    final finder = Finder(filter: Filter.byKey(payment.id));
    return await _paymentFolder.delete(await _db, finder: finder);
  }

  Future<List<Payment>> getAllPayments({sortby: 'name', ascending: true}) async {
    return _getPayments(sortby, ascending, Filter.equals("hidden", false));
  }

  Future<List<Payment>> getCompletedPayments({sortby: 'name', ascending: true}) async {
    return _getPayments(sortby, ascending, Filter.and([Filter.equals("completed", true), Filter.equals("hidden", false)]));
  }

  Future<List<Payment>> getUnCompletedPayments({sortby: 'name', ascending: true}) async {
    return _getPayments(sortby, ascending, Filter.and([Filter.equals("completed", false), Filter.equals("hidden", false)]));
  }

  Future<List<Payment>> getHiddenPayments({sortby: 'name', ascending: true}) async {
    return _getPayments(sortby, ascending, Filter.equals("hidden", true));
  }

  Future<List<Payment>> getRecurringPayments({sortby: 'name', ascending: true}) async {
    return _getPayments(sortby, ascending, Filter.equals("recurring", true));
  }

  Future<List<Payment>> _getPayments(String sortby, bool ascending, Filter filter) async {
    var finder = Finder(filter: filter,
        sortOrders: [SortOrder(sortby, ascending)]);
    final recordSnapshot = await _paymentFolder.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot) {
      final payment = Payment.fromJson(snapshot.value);
      payment.id = snapshot.key;
      return payment;
    }).toList();
  }
}
