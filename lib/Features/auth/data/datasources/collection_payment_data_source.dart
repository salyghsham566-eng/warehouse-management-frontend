import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_response.dart';
import 'package:project_2/Features/auth/data/models/collection_payments_response.dart';
import 'package:project_2/Features/auth/data/models/create_collection_payment_request.dart';

abstract class CollectionPaymentDataSource {
  Future<CollectionPaymentResponse>
      createCollectionPayment(
    CreateCollectionPaymentRequest request,
  );

  Future<CollectionPaymentsResponse>
      getCollectionPayments();

  Future<CollectionPaymentModel>
      getCollectionPaymentDetails(
    String paymentId,
  );
}