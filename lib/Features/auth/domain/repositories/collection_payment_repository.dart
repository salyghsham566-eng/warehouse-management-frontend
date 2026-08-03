import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

abstract class CollectionPaymentRepository {
  Future<CollectionPaymentModel> createPayment(
    CollectionPaymentCreateRequest request,
  );

  Future<List<CollectionPaymentModel>> getPayments();
}
