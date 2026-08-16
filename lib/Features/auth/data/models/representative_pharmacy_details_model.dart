class RepresentativePharmacyDetailsModel {
  final String id;
  final String name;
  final String region;
  final String address;
  final String phone;
  final String contactPerson;

  /// ملخص آخر تعامل ظاهر في أعلى التفاصيل.
  final String lastInteraction;

  /// UC-244: ملخص مالي فقط.
  final String financialStatus;
  final String lastInvoice;
  final String lastPayment;

  /// UC-245: آخر التعاملات المختصرة.
  final String lastSale;
  final String lastVisitOrUpdate;
  final String lastNote;

  const RepresentativePharmacyDetailsModel({
    required this.id,
    required this.name,
    required this.region,
    required this.address,
    required this.phone,
    required this.contactPerson,
    required this.lastInteraction,
    required this.financialStatus,
    required this.lastInvoice,
    required this.lastPayment,
    required this.lastSale,
    required this.lastVisitOrUpdate,
    required this.lastNote,
  });

  factory RepresentativePharmacyDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    String readString(
      Map<String, dynamic> source,
      List<String> keys, {
      String fallback = 'غير محدد',
    }) {
      for (final key in keys) {
        final value = source[key];

        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }

      return fallback;
    }

    Map<String, dynamic> readMap(
      Map<String, dynamic> source,
      List<String> keys,
    ) {
      for (final key in keys) {
        final value = source[key];

        if (value is Map) {
          return Map<String, dynamic>.from(
            value,
          );
        }
      }

      return const <String, dynamic>{};
    }

    final contact = readMap(
      json,
      const [
        'contact',
        'contact_info',
        'contactInfo',
      ],
    );

    final financial = readMap(
      json,
      const [
        'financial_summary',
        'financialSummary',
        'financial',
      ],
    );

    final interactions = readMap(
      json,
      const [
        'recent_interactions',
        'recentInteractions',
        'last_interactions',
        'lastInteractions',
        'interactions',
      ],
    );

    final lastSale = readString(
      interactions.isNotEmpty
          ? interactions
          : json,
      const [
        'last_sale',
        'lastSale',
        'sale',
      ],
    );

    final lastVisitOrUpdate = readString(
      interactions.isNotEmpty
          ? interactions
          : json,
      const [
        'last_visit_or_update',
        'lastVisitOrUpdate',
        'last_visit',
        'lastVisit',
        'last_update',
        'lastUpdate',
        'visit_or_update',
        'visitOrUpdate',
      ],
    );

    final lastPayment = readString(
      financial.isNotEmpty
          ? financial
          : json,
      const [
        'last_payment',
        'lastPayment',
        'payment',
      ],
    );

    var lastInteraction = readString(
      json,
      const [
        'last_interaction',
        'lastInteraction',
        'last_activity',
        'lastActivity',
      ],
      fallback: '',
    );

    if (lastInteraction.isEmpty) {
      if (lastSale != 'غير محدد') {
        lastInteraction = lastSale;
      } else if (lastVisitOrUpdate !=
          'غير محدد') {
        lastInteraction = lastVisitOrUpdate;
      } else if (lastPayment !=
          'غير محدد') {
        lastInteraction = lastPayment;
      } else {
        lastInteraction = 'غير محدد';
      }
    }

    final id = readString(
      json,
      const [
        'id',
        'pharmacy_id',
        'pharmacyId',
      ],
      fallback: '',
    );

    final name = readString(
      json,
      const [
        'name',
        'pharmacy_name',
        'pharmacyName',
      ],
    );

    return RepresentativePharmacyDetailsModel(
      id: id.isNotEmpty ? id : name,
      name: name,
      region: readString(
        json,
        const [
          'region',
          'region_name',
          'regionName',
          'area',
          'area_name',
          'areaName',
        ],
      ),
      address: readString(
        contact.isNotEmpty
            ? contact
            : json,
        const [
          'address',
          'full_address',
          'fullAddress',
          'detailed_address',
          'detailedAddress',
        ],
      ),
      phone: readString(
        contact.isNotEmpty
            ? contact
            : json,
        const [
          'phone',
          'phone_number',
          'phoneNumber',
          'mobile',
        ],
      ),
      contactPerson: readString(
        contact.isNotEmpty
            ? contact
            : json,
        const [
          'contact_person',
          'contactPerson',
          'contact_name',
          'contactName',
          'responsible_person',
          'responsiblePerson',
        ],
      ),
      lastInteraction: lastInteraction,
      financialStatus: readString(
        financial.isNotEmpty
            ? financial
            : json,
        const [
          'financial_status',
          'financialStatus',
          'debt_status',
          'debtStatus',
          'status',
        ],
      ),
      lastInvoice: readString(
        financial.isNotEmpty
            ? financial
            : json,
        const [
          'last_invoice',
          'lastInvoice',
          'invoice',
        ],
      ),
      lastPayment: lastPayment,
      lastSale: lastSale,
      lastVisitOrUpdate:
          lastVisitOrUpdate,
      lastNote: readString(
        interactions.isNotEmpty
            ? interactions
            : json,
        const [
          'last_note',
          'lastNote',
          'note',
        ],
      ),
    );
  }
}
