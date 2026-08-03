class CollectionMockDataSource {
  Future<Map<String, dynamic>> fetchDashboard() async {
    // محاكاة مدة طلب API.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    return <String, dynamic>{
      'summary': <String, dynamic>{
        'total_today': 5400,
        'growth_percent': 12,
        'approved_count': 12,
        'pending_count': 3,
        'rejected_count': 1,
      },
      'recent_collections': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'COL-1001',
          'pharmacy_name': 'صيدلية النهضة',
          'area_name': 'دمشق - المزة',
          'amount': 1200,
          'date': '2026-08-02T08:30:00.000Z',
          'status': 'approved',
          'rejection_reason': null,
        },
        <String, dynamic>{
          'id': 'COL-1002',
          'pharmacy_name': 'مستشفى المواساة',
          'area_name': 'دمشق - المواساة',
          'amount': 3500,
          'date': '2026-08-02T07:10:00.000Z',
          'status': 'pending',
          'rejection_reason': null,
        },
        <String, dynamic>{
          'id': 'COL-1003',
          'pharmacy_name': 'مركز النخبة الطبي',
          'area_name': 'دمشق - برزة',
          'amount': 700,
          'date': '2026-08-01T16:00:00.000Z',
          'status': 'approved',
          'rejection_reason': null,
        },
        <String, dynamic>{
          'id': 'COL-1004',
          'pharmacy_name': 'صيدلية الشفاء',
          'area_name': 'ريف دمشق - جرمانا',
          'amount': 950,
          'date': '2026-08-01T12:25:00.000Z',
          'status': 'rejected',
          'rejection_reason': 'صورة الوصل غير واضحة',
        },
        <String, dynamic>{
          'id': 'COL-1005',
          'pharmacy_name': 'صيدلية الحياة',
          'area_name': 'دمشق - كفرسوسة',
          'amount': 1800,
          'date': '2026-07-31T11:15:00.000Z',
          'status': 'pending',
          'rejection_reason': null,
        },
      ],
    };
  }
}
