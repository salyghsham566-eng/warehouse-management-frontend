class CollectionPaymentMockDataSource {
  static final List<Map<String, dynamic>> _savedPayments = [
    {
      'id': 'COL-1001',
      'pharmacy_id': 'PH-001',
      'pharmacy_name': 'صيدلية النهضة',
      'amount': 1200,
      'payment_date': DateTime.now()
          .subtract(const Duration(days: 1))
          .toUtc()
          .toIso8601String(),
      'payment_method': 'cash',
      'status': 'approved',
      'official_balance_before': 13700,
      'expected_balance_after': 12500,
      'created_at': DateTime.now()
          .subtract(const Duration(days: 1))
          .toUtc()
          .toIso8601String(),
      'notes': 'تم تسليم المبلغ للمندوب',
      'receipt_image_path': null,
      'rejection_reason': null,
    },
    {
      'id': 'COL-1002',
      'pharmacy_id': 'PH-002',
      'pharmacy_name': 'صيدلية الشفاء',
      'amount': 1500,
      'payment_date': DateTime.now()
          .subtract(const Duration(hours: 8))
          .toUtc()
          .toIso8601String(),
      'payment_method': 'bank_transfer',
      'status': 'pending_billing_approval',
      'official_balance_before': 9300,
      'expected_balance_after': 7800,
      'created_at': DateTime.now()
          .subtract(const Duration(hours: 8))
          .toUtc()
          .toIso8601String(),
      'notes': null,
      'receipt_image_path': null,
      'rejection_reason': null,
    },
    {
      'id': 'COL-1003',
      'pharmacy_id': 'PH-004',
      'pharmacy_name': 'صيدلية الأمل',
      'amount': 1000,
      'payment_date': DateTime.now()
          .subtract(const Duration(days: 3))
          .toUtc()
          .toIso8601String(),
      'payment_method': 'cheque',
      'status': 'rejected',
      'official_balance_before': 10300,
      'expected_balance_after': 9300,
      'created_at': DateTime.now()
          .subtract(const Duration(days: 3))
          .toUtc()
          .toIso8601String(),
      'notes': 'دفعة بواسطة شيك',
      'receipt_image_path': null,
      'rejection_reason': 'رقم الشيك غير واضح',
    },
  ];

  Future<Map<String, dynamic>> createPayment(
    Map<String, dynamic> request,
  ) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 900),
    );

    final Map<String, dynamic> response = {
      ...request,
      'id': 'COL-${DateTime.now().millisecondsSinceEpoch}',
      'status': 'pending_billing_approval',
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'rejection_reason': null,
    };

    _savedPayments.insert(0, response);

    return response;
  }

  Future<List<Map<String, dynamic>>>
      fetchSavedPayments() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    return _savedPayments
        .map(
          (payment) => Map<String, dynamic>.from(payment),
        )
        .toList(growable: false);
  }
}