import 'package:project_2/Features/auth/data/datasources/representative_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacy_details_model.dart';

class MockRepresentativePharmaciesDataSource
    implements RepresentativePharmaciesDataSource {
  @override
  Future<RepresentativePharmaciesResponseModel>
      getRepresentativePharmacies({
    required String month,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 450),
    );

    final now = DateTime.now();

    final pharmacies = [
      RepresentativePharmacyModel(
        id: 'pharmacy-1',
        name: 'صيدلية الشفاء',
        region: 'دمشق',
        lastActivityAt:
            now.subtract(const Duration(days: 2)),
      ),
      RepresentativePharmacyModel(
        id: 'pharmacy-2',
        name: 'صيدلية الأمل',
        region: 'دمشق',
        lastActivityAt:
            now.subtract(const Duration(days: 9)),
      ),
      RepresentativePharmacyModel(
        id: 'pharmacy-3',
        name: 'صيدلية الحياة',
        region: 'دمشق',
        lastActivityAt:
            now.subtract(const Duration(days: 21)),
      ),
      RepresentativePharmacyModel(
        id: 'pharmacy-4',
        name: 'صيدلية النور',
        region: 'ريف دمشق',
        lastActivityAt:
            now.subtract(const Duration(days: 4)),
      ),
      RepresentativePharmacyModel(
        id: 'pharmacy-5',
        name: 'صيدلية الرحمة',
        region: 'ريف دمشق',
        lastActivityAt:
            now.subtract(const Duration(days: 16)),
      ),
      RepresentativePharmacyModel(
        id: 'pharmacy-6',
        name: 'صيدلية الياسمين',
        region: 'حمص',
        lastActivityAt:
            now.subtract(const Duration(days: 6)),
      ),
      RepresentativePharmacyModel(
        id: 'pharmacy-7',
        name: 'صيدلية السلام',
        region: 'حمص',
        lastActivityAt:
            now.subtract(const Duration(days: 28)),
      ),
      const RepresentativePharmacyModel(
        id: 'pharmacy-8',
        name: 'صيدلية الوفاء',
        region: 'حمص',
      ),
    ];

    final monthNumber =
        int.tryParse(month.split('-').last) ??
            now.month;

    final baseTarget =
        480000.0 + (monthNumber * 12000.0);

    final regionTargets = <String, double>{
      'دمشق': baseTarget * 0.45,
      'ريف دمشق': baseTarget * 0.30,
      'حمص': baseTarget * 0.25,
    };

    return RepresentativePharmaciesResponseModel(
      pharmacies: pharmacies,
      targetMonth: month,
      totalTarget: baseTarget,
      regionTargets: regionTargets,
    );
  }@override
Future<RepresentativePharmacyDetailsModel>
    getRepresentativePharmacyDetails(
  String pharmacyId,
) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 400),
  );

  const details =
      <String, RepresentativePharmacyDetailsModel>{
    'pharmacy-1':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-1',
      name: 'صيدلية الشفاء',
      region: 'دمشق',
      address:
          'دمشق - المزة - شارع الجلاء',
      phone: '0115551111',
      contactPerson: 'الدكتور سامر أحمد',
      lastInteraction:
          'بيع بتاريخ 2026-08-14',
      financialStatus: 'مدينة',
      lastInvoice:
          'INV-8829 • 2026-08-14',
      lastPayment:
          '45,000 • 2026-08-13',
      lastSale:
          'فاتورة INV-8829 • 2026-08-14',
      lastVisitOrUpdate:
          'زيارة مندوب • 2026-08-14',
      lastNote:
          'طلبت الصيدلية متابعة توفر بعض الأصناف.',
    ),

    'pharmacy-2':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-2',
      name: 'صيدلية الأمل',
      region: 'دمشق',
      address:
          'دمشق - أبو رمانة - شارع المهدي',
      phone: '0115552222',
      contactPerson: 'الدكتورة رنا علي',
      lastInteraction:
          'زيارة بتاريخ 2026-08-07',
      financialStatus: 'مسددة',
      lastInvoice:
          'INV-8795 • 2026-08-05',
      lastPayment:
          'تم التسديد • 2026-08-06',
      lastSale:
          'فاتورة INV-8795 • 2026-08-05',
      lastVisitOrUpdate:
          'زيارة متابعة • 2026-08-07',
      lastNote:
          'لا توجد ملاحظات مهمة.',
    ),

    'pharmacy-3':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-3',
      name: 'صيدلية الحياة',
      region: 'دمشق',
      address:
          'دمشق - كفرسوسة - الشارع الرئيسي',
      phone: '0115553333',
      contactPerson: 'الدكتور وائل حسن',
      lastInteraction:
          'دفعة بتاريخ 2026-07-26',
      financialStatus: 'مسددة جزئياً',
      lastInvoice:
          'INV-8701 • 2026-07-24',
      lastPayment:
          '30,000 • 2026-07-26',
      lastSale:
          'فاتورة INV-8701 • 2026-07-24',
      lastVisitOrUpdate:
          'تحديث بيانات • 2026-07-25',
      lastNote:
          'متابعة الذمة في الزيارة القادمة.',
    ),

    'pharmacy-4':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-4',
      name: 'صيدلية النور',
      region: 'ريف دمشق',
      address:
          'جرمانا - شارع البلدية',
      phone: '0115554444',
      contactPerson: 'الدكتورة نور محمود',
      lastInteraction:
          'بيع بتاريخ 2026-08-12',
      financialStatus: 'مسددة',
      lastInvoice:
          'INV-8810 • 2026-08-12',
      lastPayment:
          'تم التسديد • 2026-08-12',
      lastSale:
          'فاتورة INV-8810 • 2026-08-12',
      lastVisitOrUpdate:
          'زيارة • 2026-08-11',
      lastNote:
          'مهتمة بالعروض الجديدة.',
    ),

    'pharmacy-5':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-5',
      name: 'صيدلية الرحمة',
      region: 'ريف دمشق',
      address:
          'صحنايا - الطريق العام',
      phone: '0115555555',
      contactPerson: 'الدكتور خالد عمر',
      lastInteraction:
          'زيارة بتاريخ 2026-07-31',
      financialStatus: 'مدينة',
      lastInvoice:
          'INV-8740 • 2026-07-30',
      lastPayment:
          '20,000 • 2026-07-31',
      lastSale:
          'فاتورة INV-8740 • 2026-07-30',
      lastVisitOrUpdate:
          'زيارة تحقّق • 2026-07-31',
      lastNote:
          'بحاجة لمتابعة بعض الأصناف الناقصة.',
    ),

    'pharmacy-6':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-6',
      name: 'صيدلية الياسمين',
      region: 'حمص',
      address:
          'حمص - الإنشاءات - شارع الحضارة',
      phone: '0315556666',
      contactPerson: 'الدكتورة سارة محمد',
      lastInteraction:
          'بيع بتاريخ 2026-08-10',
      financialStatus: 'مسددة',
      lastInvoice:
          'INV-8801 • 2026-08-10',
      lastPayment:
          'تم التسديد • 2026-08-10',
      lastSale:
          'فاتورة INV-8801 • 2026-08-10',
      lastVisitOrUpdate:
          'زيارة • 2026-08-09',
      lastNote:
          'لا توجد ملاحظات.',
    ),

    'pharmacy-7':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-7',
      name: 'صيدلية السلام',
      region: 'حمص',
      address:
          'حمص - الغوطة - شارع المدارس',
      phone: '0315557777',
      contactPerson: 'الدكتور ياسر أحمد',
      lastInteraction:
          'تحديث بتاريخ 2026-07-19',
      financialStatus: 'مسددة جزئياً',
      lastInvoice:
          'INV-8660 • 2026-07-18',
      lastPayment:
          '25,000 • 2026-07-19',
      lastSale:
          'فاتورة INV-8660 • 2026-07-18',
      lastVisitOrUpdate:
          'تحديث بيانات • 2026-07-19',
      lastNote:
          'يفضل التواصل صباحاً.',
    ),

    'pharmacy-8':
        RepresentativePharmacyDetailsModel(
      id: 'pharmacy-8',
      name: 'صيدلية الوفاء',
      region: 'حمص',
      address:
          'حمص - بابا عمرو - الشارع العام',
      phone: '0315558888',
      contactPerson: 'الدكتور مازن صالح',
      lastInteraction: 'غير محدد',
      financialStatus: 'غير محدد',
      lastInvoice: 'غير محدد',
      lastPayment: 'غير محدد',
      lastSale: 'غير محدد',
      lastVisitOrUpdate: 'غير محدد',
      lastNote: 'لا توجد ملاحظات مسجلة.',
    ),
  };

  final result = details[pharmacyId];

  if (result == null) {
    throw Exception(
      'لم يتم العثور على بيانات الصيدلية',
    );
  }

  return result;
}
}
