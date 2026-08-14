import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/data/models/create_collection_payment_request.dart';

abstract class CollectionPaymentRepository {
  Future<CollectionPaymentModel>
      createCollectionPayment(
    CreateCollectionPaymentRequest request,
  );

  Future<List<CollectionPaymentModel>>
      getCollectionPayments();

  Future<CollectionPaymentModel>
      getCollectionPaymentDetails(
    String paymentId,
  );
}