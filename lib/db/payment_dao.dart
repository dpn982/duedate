import 'package:duedate/models/enums.dart';
import 'package:sembast/sembast.dart';
import '../models/payment.dart';
import 'database_setup.dart';

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

  Future<List<Payment>> getPayments(
      {sortby: 'name', ascending: true, filterType: FilterType.All}) async {
    Filter filter;

    switch (filterType) {
      case FilterType.All:
        {
          filter = Filter.equals("hidden", false);
        }
        break;
      case FilterType.UnCompleted:
        {
          filter = Filter.and([
            Filter.equals("completed", false),
            Filter.equals("hidden", false)
          ]);
        }
        break;
      case FilterType.Completed:
        {
          filter = Filter.and([
            Filter.equals("completed", true),
            Filter.equals("hidden", false)
          ]);
        }
        break;
      case FilterType.Hidden:
        {
          filter = Filter.equals("hidden", true);
        }
        break;
      case FilterType.Recurring:
        {
          filter = Filter.equals("recurring", true);
        }
        break;
    }

    return _getPayments(sortby, ascending, filter);
  }

  Future<List<Payment>> _getPayments(
      String sortby, bool ascending, Filter filter) async {
    var finder =
        Finder(filter: filter, sortOrders: [SortOrder(sortby, ascending)]);
    final recordSnapshot = await _paymentFolder.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot) {
      final payment = Payment.fromJson(snapshot.value);
      payment.id = snapshot.key;
      return payment;
    }).toList();
  }
}
