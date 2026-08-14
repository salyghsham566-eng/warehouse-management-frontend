enum WorkPlanCreateAction {
  draft,
  submit,
}

String workPlanCreateActionToApi(
  WorkPlanCreateAction action,
) {
  switch (action) {
    case WorkPlanCreateAction.draft:
      return 'draft';

    case WorkPlanCreateAction.submit:
      return 'submit';
  }
}

// ==========================================================
// أنواع أهداف الخطة - UC-200
// ==========================================================

enum CreateWorkPlanGoalType {
  sales,
  collection,
  pharmacyCoverage,
  visits,
  products,
  companies,
  pharmacies,
}

String createWorkPlanGoalTypeToApi(
  CreateWorkPlanGoalType type,
) {
  switch (type) {
    case CreateWorkPlanGoalType.sales:
      return 'sales';

    case CreateWorkPlanGoalType.collection:
      return 'collection';

    case CreateWorkPlanGoalType.pharmacyCoverage:
      return 'pharmacy_coverage';

    case CreateWorkPlanGoalType.visits:
      return 'visits';

    case CreateWorkPlanGoalType.products:
      return 'products';

    case CreateWorkPlanGoalType.companies:
      return 'companies';

    case CreateWorkPlanGoalType.pharmacies:
      return 'pharmacies';
  }
}

// ==========================================================
// هدف واحد داخل الخطة
// ==========================================================

class CreateWorkPlanGoalRequest {
  final CreateWorkPlanGoalType type;

  /// القيمة المطلوبة:
  /// مبيعات = مبلغ
  /// تحصيل = مبلغ
  /// تغطية = عدد صيدليات
  /// زيارات = عدد زيارات
  final double? targetValue;

  /// تستخدم عند اختيار أصناف محددة
  final List<int> productIds;

  /// تستخدم عند اختيار شركات محددة
  final List<int> companyIds;

  /// تستخدم عند اختيار صيدليات محددة
  final List<int> pharmacyIds;

  const CreateWorkPlanGoalRequest({
    required this.type,
    this.targetValue,
    this.productIds = const [],
    this.companyIds = const [],
    this.pharmacyIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'type': createWorkPlanGoalTypeToApi(type),

      if (targetValue != null)
        'target_value': targetValue,

      if (productIds.isNotEmpty)
        'product_ids': productIds,

      if (companyIds.isNotEmpty)
        'company_ids': companyIds,

      if (pharmacyIds.isNotEmpty)
        'pharmacy_ids': pharmacyIds,
    };
  }
}

// ==========================================================
// إنشاء الخطة
// ==========================================================

class CreateWorkPlanRequestModel {
  final String name;
  final String? description;

  final DateTime? startDate;
  final DateTime? endDate;

  /// المنطقة اختيارية
  final int? regionId;

  /// هدف واحد أو أكثر
  final List<CreateWorkPlanGoalRequest> goals;

  /// ملاحظات اختيارية
  final String? notes;

  /// draft أو submit
  final WorkPlanCreateAction action;

  const CreateWorkPlanRequestModel({
    required this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.regionId,
    this.goals = const [],
    this.notes,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),

      if (description != null &&
          description!.trim().isNotEmpty)
        'description': description!.trim(),

      if (startDate != null)
        'start_date':
            startDate!.toIso8601String().split('T').first,

      if (endDate != null)
        'end_date':
            endDate!.toIso8601String().split('T').first,

      if (regionId != null)
        'region_id': regionId,

      'goals': goals
          .map(
            (goal) => goal.toJson(),
          )
          .toList(),

      if (notes != null &&
          notes!.trim().isNotEmpty)
        'notes': notes!.trim(),

      'action':
          workPlanCreateActionToApi(action),
    };
  }
}