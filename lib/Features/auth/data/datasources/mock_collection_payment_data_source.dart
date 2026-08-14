import 'package:project_2/Features/auth/data/datasources/collection_payment_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_collection_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_response.dart';
import 'package:project_2/Features/auth/data/models/collection_payments_response.dart';
import 'package:project_2/Features/auth/data/models/create_collection_payment_request.dart';

class MockCollectionPaymentDataSource
    implements CollectionPaymentDataSource {
  final List<Map<String, dynamic>> _mockPayments = [
    {
      'id': 'PAY-1005',
      'pharmacy_id': 'pharmacy-001',
      'pharmacy_name': 'صيدلية النهدي - فرع الملقا',
      'amount': 500.0,
      'payment_date': '2026-08-04T14:30:00.000Z',
      'payment_method': 'cash',
      'status': 'pending_billing_approval',
      'notes': 'تم استلام المبلغ نقداً',
      'receipt_image_path': null,
      'rejection_reason': null,
      
    },
    {
      'id': 'PAY-1004',
      'pharmacy_id': 'pharmacy-002',
      'pharmacy_name': 'صيدلية الدواء - فرع اليرموك',
      'amount': 1200.0,
      'payment_date': '2026-08-03T10:15:00.000Z',
      'payment_method': 'bank_transfer',
      'status': 'approved',
      'notes': null,
      'receipt_image_path': null,
      'rejection_reason': null,
    },
    {
      'id': 'PAY-1003',
      'pharmacy_id': 'pharmacy-003',
      'pharmacy_name': 'صيدلية أطلس - فرع المحافظة',
      'amount': 750.0,
      'payment_date': '2026-08-02T09:20:00.000Z',
      'payment_method': 'cheque',
      'status': 'rejected',
      'notes': 'دفعة بواسطة شيك',
      'receipt_image_path': null,
      'rejection_reason': 'بيانات الشيك غير واضحة',
    },
    {
      'id': 'PAY-1002',
      'pharmacy_id': 'pharmacy-004',
      'pharmacy_name': 'صيدلية الشفاء',
      'amount': 300.0,
      'payment_date': '2026-08-01T12:00:00.000Z',
      'payment_method': 'cash',
      'status': 'approved',
      'notes': null,
      'receipt_image_path': null,
      'rejection_reason': null,
    },
  ];

  @override
  Future<CollectionPaymentsResponse>
      getCollectionPayments() async {
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    return CollectionPaymentsResponse.fromJson({
      'success': true,
      'message': 'تم تحميل التحصيلات بنجاح',
      'data': {
        'payments': _mockPayments,
      },
    });
  }

 @override
Future<CollectionPaymentResponse>
    createCollectionPayment(
  CreateCollectionPaymentRequest request,
) async {
  await Future.delayed(
    const Duration(milliseconds: 900),
  );

   Map<String, dynamic> payment = {
    'id':
        'PAY-${DateTime.now().millisecondsSinceEpoch}',

    'pharmacy_id': request.pharmacyId,
    'pharmacy_name': request.pharmacyName,

    'amount': request.amount,

    'payment_date':
        request.paymentDate.toIso8601String(),

    'payment_method':
        request.paymentMethod.apiValue,

    // الرصيد قبل تسجيل الدفعة
    'official_balance_before':
        request.officialBalanceBefore,

    // الرصيد المتوقع فقط
    'expected_balance_after':
        request.officialBalanceBefore -
            request.amount,

    // لا يوجد رصيد رسمي جديد قبل اعتماد المفوتر
    'official_balance_after': null,

    // الدفعة تبدأ دائماً قيد الانتظار
    'status': 'pending_billing_approval',

    'notes': request.notes,

    'receipt_image_path':
        request.receiptImagePath,

    'rejection_reason': null,
    'approved_at': null,
    'rejected_at': null,
  };

  _mockPayments.insert(0, payment);
MockCollectionPharmaciesDataSource.updateAfterPayment(
  pharmacyId: request.pharmacyId,
  amount: request.amount,
  paymentDate: request.paymentDate,
);
  return CollectionPaymentResponse.fromJson({
    'success': true,
    'message':
        'تم تسجيل الدفعة وإرسالها للمفوتر',
    'data': {
      'payment': payment,
    },
  });
}
@override
Future<CollectionPaymentModel>
    getCollectionPaymentDetails(
  String paymentId,
) async {
  await Future.delayed(
    const Duration(milliseconds: 400),
  );

  Map<String, dynamic>? selectedPayment;

  for (final payment in _mockPayments) {
    if (payment['id']?.toString() ==
        paymentId) {
      selectedPayment = payment;
      break;
    }
  }

  if (selectedPayment == null) {
    throw Exception(
      'لم يتم العثور على الدفعة',
    );
  }

  return CollectionPaymentModel.fromJson(
    selectedPayment,
  );
}
}