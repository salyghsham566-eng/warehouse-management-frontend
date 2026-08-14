import 'package:project_2/Features/auth/data/datasources/collection_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/repositories/collection_pharmacies_response.dart';

class MockCollectionPharmaciesDataSource
    implements CollectionPharmaciesDataSource {
  static final List<Map<String, dynamic>> _mockPharmacies = [
    {
      'id': 'pharmacy-001',
      'name': 'صيدلية النهدي - فرع الملقا',
      'area': 'حي الملقا',
      'address': 'شارع أنس بن مالك، الرياض',
      'phone_number': '0999999999',
      'official_balance': 1250.00,
      'account_status': 'has_debt',
      'has_pending_collection': false,
      'last_payment_amount': 500.00,
      'last_payment_date':
          '2026-07-28T14:30:00.000Z',
    },
    {
      'id': 'pharmacy-002',
      'name': 'صيدلية الدواء - فرع اليرموك',
      'area': 'حي اليرموك',
      'address': 'طريق عثمان بن عفان، الرياض',
      'phone_number': '0988888888',
      'official_balance': 3840.50,
      'account_status': 'pending_collection',
      'has_pending_collection': true,
      'last_payment_amount': 1200.00,
      'last_payment_date':
          '2026-07-25T10:00:00.000Z',
    },
    {
      'id': 'pharmacy-003',
      'name': 'صيدلية أطلس - فرع المحافظة',
      'area': 'وسط الرياض',
      'address': 'طريق الملك فهد، الرياض',
      'phone_number': '0977777777',
      'official_balance': 0.00,
      'account_status': 'settled',
      'has_pending_collection': false,
      'last_payment_amount': 2450.00,
      'last_payment_date':
          '2026-08-01T09:20:00.000Z',
    },
  ];

  @override
  Future<CollectionPharmaciesResponse>
      getCollectionPharmacies() async {
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    return CollectionPharmaciesResponse.fromJson({
      'success': true,
      'message': 'تم تحميل الصيدليات بنجاح',
      'data': {
        'pharmacies': _mockPharmacies,
      },
    });
  }

  @override
  Future<CollectionPharmacyModel>
      getCollectionPharmacyDetails(
    String pharmacyId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    Map<String, dynamic>? selectedPharmacy;

    for (final pharmacy in _mockPharmacies) {
      if (pharmacy['id'].toString() == pharmacyId) {
        selectedPharmacy = pharmacy;
        break;
      }
    }

    if (selectedPharmacy == null) {
      throw Exception('لم يتم العثور على الصيدلية');
    }

    return CollectionPharmacyModel.fromJson(
      selectedPharmacy,
    );
  }
  static void updateAfterPayment({
  required String pharmacyId,
  required double amount,
  required DateTime paymentDate,
}) {
  final int pharmacyIndex = _mockPharmacies.indexWhere(
    (pharmacy) =>
        pharmacy['id']?.toString() == pharmacyId,
  );

  if (pharmacyIndex == -1) {
    return;
  }

  final Map<String, dynamic> currentPharmacy =
      _mockPharmacies[pharmacyIndex];

  final DateTime? currentLastPaymentDate =
      DateTime.tryParse(
    currentPharmacy['last_payment_date']
            ?.toString() ??
        '',
  );

  final bool isNewestPayment =
      currentLastPaymentDate == null ||
          !paymentDate.isBefore(
            currentLastPaymentDate,
          );

  _mockPharmacies[pharmacyIndex] = {
    ...currentPharmacy,

    // أصبح لدى الصيدلية دفعة معلقة.
    'has_pending_collection': true,
    'account_status': 'pending_collection',

    // نعدّل آخر دفعة فقط إذا كان تاريخها الأحدث.
    if (isNewestPayment)
      'last_payment_amount': amount,

    if (isNewestPayment)
      'last_payment_date':
          paymentDate.toIso8601String(),
  };
}
}