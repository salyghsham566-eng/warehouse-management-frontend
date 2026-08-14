import 'package:project_2/Features/auth/data/datasources/collection_payment_data_source.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/data/models/create_collection_payment_request.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

class CollectionPaymentRepositoryImpl
    implements CollectionPaymentRepository {
  const CollectionPaymentRepositoryImpl({
    required this.dataSource,
  });

  final CollectionPaymentDataSource dataSource;

  @override
  Future<List<CollectionPaymentModel>>
      getCollectionPayments() async {
    final response =
        await dataSource.getCollectionPayments();

    if (!response.success) {
      throw Exception(
        response.message.trim().isNotEmpty
            ? response.message
            : 'تعذر تحميل التحصيلات',
      );
    }

    return response.payments;
  }

  @override
  Future<CollectionPaymentModel>
      createCollectionPayment(
    CreateCollectionPaymentRequest request,
  ) async {
    final response =
        await dataSource.createCollectionPayment(
      request,
    );

    if (!response.success ||
        response.payment == null) {
      throw Exception(
        response.message.trim().isNotEmpty
            ? response.message
            : 'تعذر تسجيل الدفعة',
      );
    }

    return response.payment!;
  }
  @override
Future<CollectionPaymentModel>
    getCollectionPaymentDetails(
  String paymentId,
) {
  return dataSource.getCollectionPaymentDetails(
    paymentId,
  );
}
}