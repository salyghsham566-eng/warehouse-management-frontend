import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_mock_data_source.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

class CollectionPaymentRepositoryImpl
    implements CollectionPaymentRepository {
  CollectionPaymentRepositoryImpl(
    this._dataSource,
  );

  final CollectionPaymentMockDataSource _dataSource;

  @override
  Future<CollectionPaymentModel> createPayment(
    CollectionPaymentCreateRequest request,
  ) async {
    final Map<String, dynamic> response =
        await _dataSource.createPayment(
      request.toJson(),
    );

    return CollectionPaymentModel.fromJson(response);
  }

  @override
  Future<List<CollectionPaymentModel>>
      getPayments() async {
    final List<Map<String, dynamic>> response =
        await _dataSource.fetchSavedPayments();

    final List<CollectionPaymentModel> payments =
        response
            .map(CollectionPaymentModel.fromJson)
            .toList(growable: true);

    payments.sort(
      (first, second) =>
          second.createdAt.compareTo(first.createdAt),
    );

    return payments;
  }
}
