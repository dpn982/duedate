import 'package:sembast/sembast.dart';
import '../models/PaymentModel.dart';
import 'DatabaseSetup.dart';

class PaymentDAO{
  static const String folderName = "Payments";
  final _paymentFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  void insert(Payment payment) async {
    await _paymentFolder.add(await _db, payment.toJson());
  }

  void update(Payment payment) async {
    final finder = Finder(filter: Filter.byKey(payment.id));
    await _paymentFolder.update(await _db, payment.toJson(), finder: finder);
  }

  void delete(Payment payment) async {
    final finder = Finder(filter: Filter.byKey(payment.id));
    await _paymentFolder.delete(await _db, finder: finder);
  }

  Future<List<Payment>> getAllPayments() async {
    final recordSnapshot = await _paymentFolder.find(await _db);
    return recordSnapshot.map((snapshot) {
      final payment = Payment.fromJson(snapshot.value);
      return payment;
    }).toList();
  }
}