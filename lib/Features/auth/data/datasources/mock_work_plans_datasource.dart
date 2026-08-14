import 'package:project_2/Features/auth/data/datasources/work_plans_datasource.dart';
import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/create_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/submit_work_plan_response_model.dart';
import 'package:project_2/Features/auth/data/models/update_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plans_response_model.dart';

class MockWorkPlansDataSource
    implements WorkPlansDataSource {
      final List<Map<String, dynamic>> _createdPlans = [
  {
    "id": 5,
    "name": "خطة زيادة زيارات القطاع الغربي",
    "source": "المندوب",
    "start_date": "2026-08-10",
    "end_date": "2026-08-20",
    "status": "waiting_for_review",
    "progress": 0,
  },
  {
    "id": 6,
    "name": "خطة تغطية صيدليات جديدة",
    "source": "المندوب",
    "start_date": "2026-08-12",
    "end_date": "2026-08-25",
    "status": "needs_modification",
    "progress": 0,
  },
  {
    "id": 7,
    "name": "خطة مبيعات شهر أغسطس",
    "source": "المندوب",
    "start_date": "2026-08-01",
    "end_date": "2026-08-31",
    "status": "rejected",
    "progress": 0,
  },
  {
  "id": 8,
  "name": "خطة تحصيل المنطقة الشمالية",
  "source": "المندوب",
  "start_date": "2026-08-15",
  "end_date": "2026-08-30",
  "status": "approved",
  "progress": 0,
},
];

  // تفاصيل الخطط التي ينشئها المندوب أثناء تشغيل الـ Mock
  final Map<int, Map<String, dynamic>> _createdPlanDetails = {
    6: {
  "id": 6,
  "name": "خطة تغطية صيدليات جديدة",
  "description":
      "تغطية مجموعة جديدة من الصيدليات خلال الفترة المحددة.",
  "source": "المندوب",
  "start_date": "2026-08-12",
  "end_date": "2026-08-25",
  "status": "needs_modification",
  "progress": 0,
  "region": "القطاع الغربي",
  "notes": "",
  "review_reason":
      "يرجى زيادة عدد الزيارات وتعديل تاريخ نهاية الخطة.",
  "goals": [],
  "personal_notes": [],
  "official_notes": [],
},7: {
  "id": 7,
  "name": "خطة مبيعات شهر أغسطس",
  "description":
      "خطة لرفع المبيعات خلال شهر أغسطس.",
  "source": "المندوب",
  "start_date": "2026-08-01",
  "end_date": "2026-08-31",
  "status": "rejected",
  "progress": 0,
  "region": "جميع المناطق",
  "notes": "",
  "review_reason":
      "الأهداف المقترحة لا تتناسب مع الفترة المحددة.",
  "goals": [],
  "personal_notes": [],
  "official_notes": [],
},8: {
  "id": 8,
  "name": "خطة تحصيل المنطقة الشمالية",
  "description":
      "رفع نسبة التحصيل ضمن المنطقة الشمالية.",
  "source": "المندوب",
  "start_date": "2026-08-15",
  "end_date": "2026-08-30",
  "status": "approved",
  "progress": 0,
  "region": "المنطقة الشمالية",
  "notes": "",
  "review_reason": null,
  "goals": [],
  "personal_notes": [],
  "official_notes": [],
},
  };

  // معرفات أهداف الخطط الجديدة
  int _nextGoalId = 1000;



  final Map<int, List<Map<String, dynamic>>> _personalNotes = {};

int _nextPersonalNoteId = 1;
final Map<int, List<Map<String, dynamic>>> _officialNotes = {
  1: [
    {
      "id": 1,
      "plan_id": 1,
      "text":
          "يرجى التركيز على الصيدليات ذات الأولوية خلال هذا الأسبوع.",
      "author_name": "د. عبدالله القحطاني",
      "author_role": "مشرف",
      "created_at": "2026-08-05T10:30:00",
      "type": "note",
    },
    {
      "id": 2,
      "plan_id": 1,
      "text":
          "تم الاطلاع، سأركز على الصيدليات المستهدفة.",
      "author_name": "المندوب الحالي",
      "author_role": "مندوب",
      "created_at": "2026-08-05T11:15:00",
      "type": "reply",
    },
  ],
};

int _nextOfficialNoteId = 10;
  @override
  Future<WorkPlansResponseModel> getWorkPlans() async {
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    final response = {
      "success": true,
      "message": "تم تحميل خطط العمل بنجاح",
      "data": {
        "assigned_plans": [
          {
            "id": 1,
            "name":
                "توسعة القطاع الأوسط - الأسبوع الثالث",
            "source":
                "المشرف: د. عبدالله القحطاني",
            "start_date": "2026-08-01",
            "end_date": "2026-08-07",
            "status": "in_progress",
            "progress": 75,
          },
          {
            "id": 2,
            "name":
                "زيادة مبيعات صيدليات المنطقة الشمالية",
            "source": "المشرف: أحمد خالد",
            "start_date": "2026-08-08",
            "end_date": "2026-08-15",
            "status": "waiting_to_start",
            "progress": 0,
          },
          {
            "id": 3,
            "name": "تحصيل الذمم المتأخرة",
            "source": "المشرف: محمد علي",
            "start_date": "2026-07-20",
            "end_date": "2026-07-31",
            "status": "completed",
            "progress": 100,
          },
          {
            "id": 4,
            "name": "تغطية الصيدليات الجديدة",
            "source": "المشرف: د. سامر أحمد",
            "start_date": "2026-07-15",
            "end_date": "2026-07-30",
            "status": "delayed",
            "progress": 62,
          },
        ],

        "created_plans": _createdPlans,
        
      },
    };

    return WorkPlansResponseModel.fromJson(
      response,
    );
  }
  @override
Future<WorkPlanDetailsModel> getWorkPlanDetails({
  required int planId,
}) async {
  await Future.delayed(
    const Duration(milliseconds: 600),
  );

  Map<String, dynamic> data;
// ==========================================================
// الخطط الجديدة التي أنشأها المندوب بالـ Mock
// ==========================================================

if (_createdPlanDetails.containsKey(planId)) {
  data = Map<String, dynamic>.from(
    _createdPlanDetails[planId]!,
  );

  data['personal_notes'] =
      _personalNotes[planId] ?? [];

  data['official_notes'] =
      _officialNotes[planId] ?? [];

  return WorkPlanDetailsModel.fromJson(
    data,
  );
}

// ==========================================================
// الخطط القديمة الموجودة مسبقاً ضمن created_plans (5 / 6 / 7)
// حتى لا يحصل خطأ عند فتح تفاصيلها
// ==========================================================

final createdPlanIndex = _createdPlans.indexWhere(
  (plan) => plan['id'] == planId,
);

if (createdPlanIndex != -1) {
  final summary = _createdPlans[createdPlanIndex];

  data = {
    "id": summary['id'] ?? planId,
    "name": summary['name']?.toString() ?? '',
    "description": '',
    "source": summary['source']?.toString() ?? 'المندوب',
    "start_date": summary['start_date']?.toString() ?? '',
    "end_date": summary['end_date']?.toString() ?? '',
    "status": summary['status']?.toString() ?? 'draft',
    "progress": summary['progress'] ?? 0,
    "region": "غير محددة",
    "notes": "",
    "goals": <Map<String, dynamic>>[],
    "personal_notes": _personalNotes[planId] ?? [],
    "official_notes": _officialNotes[planId] ?? [],
  };

  return WorkPlanDetailsModel.fromJson(
    data,
  );
}
  // ==========================================================
  // الخطة رقم 1
  // ==========================================================

  if (planId == 1) {
    data = {
      "id": 1,
      "name": "توسعة القطاع الأوسط - الأسبوع الثالث",
      "description":
          "رفع مستوى التغطية والمبيعات في القطاع الأوسط وتحسين الزيارات للصيدليات المستهدفة.",
      "source": "المشرف: د. عبدالله القحطاني",
      "start_date": "2026-08-01",
      "end_date": "2026-08-15",
      "status": "in_progress",
      "progress": 75,
      "region": "القطاع الأوسط",
      "notes":
          "التركيز على الصيدليات ذات المبيعات المنخفضة ومتابعة الزيارات بشكل يومي.",
      "goals": [
        {
          "id": 101,
          "title": "هدف المبيعات",
          "description": "تحقيق مبيعات بقيمة 100,000 ر.س",
          "type": "sales",
          "target_value": 100000,
          "achieved_value": 85000,
          "progress": 85,
          "unit": "ر.س",
        },
        {
          "id": 102,
          "title": "تغطية الصيدليات",
          "description": "تغطية 20 صيدلية مستهدفة",
          "type": "pharmacy_coverage",
          "target_value": 20,
          "achieved_value": 16,
          "progress": 80,
          "unit": "صيدلية",
        },
        {
          "id": 103,
          "title": "الزيارات",
          "description": "تنفيذ 30 زيارة ميدانية",
          "type": "visits",
          "target_value": 30,
          "achieved_value": 21,
          "progress": 70,
          "unit": "زيارة",
        },
        {
          "id": 104,
          "title": "هدف التحصيل",
          "description": "تحصيل مبلغ 50,000 ر.س",
          "type": "collection",
          "target_value": 50000,
          "achieved_value": 35000,
          "progress": 70,
          "unit": "ر.س",
        },
      ],
    };
  }

  // ==========================================================
  // الخطة رقم 2
  // ==========================================================

  else if (planId == 2) {
    data = {
      "id": 2,
      "name": "زيادة مبيعات صيدليات المنطقة الشمالية",
      "description":
          "خطة تستهدف زيادة حجم المبيعات في صيدليات المنطقة الشمالية والتركيز على العملاء النشطين.",
      "source": "المشرف: أحمد خالد",
      "start_date": "2026-08-08",
      "end_date": "2026-08-15",
      "status": "waiting_to_start",
      "progress": 0,
      "region": "المنطقة الشمالية",
      "notes":
          "يبدأ تنفيذ الخطة مع بداية الفترة المحددة.",
      "goals": [
        {
          "id": 201,
          "title": "رفع المبيعات",
          "description": "تحقيق مبيعات بقيمة 150,000 ر.س",
          "type": "sales",
          "target_value": 150000,
          "achieved_value": 0,
          "progress": 0,
          "unit": "ر.س",
        },
        {
          "id": 202,
          "title": "زيارات الصيدليات",
          "description": "تنفيذ 25 زيارة للصيدليات",
          "type": "visits",
          "target_value": 25,
          "achieved_value": 0,
          "progress": 0,
          "unit": "زيارة",
        },
        {
          "id": 203,
          "title": "تغطية صيدليات جديدة",
          "description": "تغطية 10 صيدليات جديدة",
          "type": "pharmacy_coverage",
          "target_value": 10,
          "achieved_value": 0,
          "progress": 0,
          "unit": "صيدلية",
        },
      ],
    };
  }

  // ==========================================================
  // الخطة رقم 3
  // ==========================================================

  else if (planId == 3) {
    data = {
      "id": 3,
      "name": "تحصيل الذمم المتأخرة",
      "description":
          "متابعة الذمم المستحقة على الصيدليات والعمل على رفع نسبة التحصيل.",
      "source": "المشرف: محمد علي",
      "start_date": "2026-07-20",
      "end_date": "2026-07-31",
      "status": "completed",
      "progress": 100,
      "region": "جميع المناطق",
      "notes":
          "تم الانتهاء من جميع أهداف الخطة بنجاح.",
      "goals": [
        {
          "id": 301,
          "title": "تحصيل الذمم",
          "description": "تحصيل مبلغ 80,000 ر.س",
          "type": "collection",
          "target_value": 80000,
          "achieved_value": 80000,
          "progress": 100,
          "unit": "ر.س",
        },
        {
          "id": 302,
          "title": "زيارات متابعة التحصيل",
          "description": "تنفيذ 15 زيارة متابعة",
          "type": "visits",
          "target_value": 15,
          "achieved_value": 15,
          "progress": 100,
          "unit": "زيارة",
        },
      ],
    };
  }

  // ==========================================================
  // الخطة رقم 4
  // ==========================================================

  else if (planId == 4) {
    data = {
      "id": 4,
      "name": "تغطية الصيدليات الجديدة",
      "description":
          "توسيع التغطية للوصول إلى الصيدليات الجديدة ضمن المنطقة المستهدفة.",
      "source": "المشرف: د. سامر أحمد",
      "start_date": "2026-07-15",
      "end_date": "2026-07-30",
      "status": "delayed",
      "progress": 62,
      "region": "القطاع الغربي",
      "notes":
          "الخطة متأخرة عن الموعد المحدد ويجب التركيز على الصيدليات غير المغطاة.",
      "goals": [
        {
          "id": 401,
          "title": "تغطية الصيدليات",
          "description": "تغطية 40 صيدلية",
          "type": "pharmacy_coverage",
          "target_value": 40,
          "achieved_value": 25,
          "progress": 62.5,
          "unit": "صيدلية",
        },
        {
          "id": 402,
          "title": "الزيارات الميدانية",
          "description": "تنفيذ 50 زيارة",
          "type": "visits",
          "target_value": 50,
          "achieved_value": 30,
          "progress": 60,
          "unit": "زيارة",
        },
        {
          "id": 403,
          "title": "مبيعات الصيدليات الجديدة",
          "description": "تحقيق 60,000 ر.س مبيعات",
          "type": "sales",
          "target_value": 60000,
          "achieved_value": 39000,
          "progress": 65,
          "unit": "ر.س",
        },
      ],
    };
  }

  // ==========================================================
  // خطة غير موجودة
  // ==========================================================

  else {
    throw Exception(
      'الخطة المطلوبة غير موجودة',
    );
  }
data['personal_notes'] =
    _personalNotes[planId] ?? [];
    data['official_notes'] =
    _officialNotes[planId] ?? [];
  return WorkPlanDetailsModel.fromJson(data);

 
}
@override
Future<WorkPlanOfficialNoteModel> addOfficialNote({
  required int planId,
  required String text,
  required WorkPlanOfficialNoteType type,
}) async {
  await Future.delayed(
    const Duration(milliseconds: 500),
  );

  final cleanText = text.trim();

  if (cleanText.isEmpty) {
    throw Exception(
      'يرجى كتابة النص',
    );
  }

  final note = {
    "id": _nextOfficialNoteId++,
    "plan_id": planId,
    "text": cleanText,

    // بالـMock فقط
    "author_name": "المندوب الحالي",
    "author_role": "مندوب",

    "created_at":
        DateTime.now().toIso8601String(),

    "type":
        workPlanOfficialNoteTypeToString(type),
  };

  _officialNotes.putIfAbsent(
    planId,
    () => [],
  );

  // الجديد يظهر بالأعلى
  _officialNotes[planId]!.insert(
    0,
    note,
  );

  return WorkPlanOfficialNoteModel.fromJson(
    note,
  );
}
@override
Future<WorkPlanGoalDetailsModel> getGoalDetails({
  required int planId,
  required int goalId,
}) async {
  await Future.delayed(
    const Duration(milliseconds: 500),
  );

  Map<String, dynamic> data;

  // ==========================================================
  // أهداف الخطط الجديدة التي أنشأها المندوب بالـ Mock
  // ==========================================================

  final createdPlan = _createdPlanDetails[planId];

  if (createdPlan != null) {
    final rawGoals =
        createdPlan['goals'] as List<dynamic>? ?? [];

    Map<String, dynamic>? matchedGoal;

    for (final item in rawGoals) {
      if (item is Map) {
        final goal = Map<String, dynamic>.from(item);

        if (goal['id'] == goalId) {
          matchedGoal = goal;
          break;
        }
      }
    }

    if (matchedGoal != null) {
      final goalType =
          matchedGoal['type']?.toString() ?? 'general';

      data = {
        "goal_id": matchedGoal['id'] ?? goalId,
        "title": matchedGoal['title']?.toString() ?? '',
        "type": goalType,
        "target_value": matchedGoal['target_value'] ?? 0,
        "achieved_value": matchedGoal['achieved_value'] ?? 0,
        "progress": matchedGoal['progress'] ?? 0,
        "unit": matchedGoal['unit']?.toString() ?? '',
        "actual_data": <Map<String, dynamic>>[],
        "invoices": <Map<String, dynamic>>[],
        "coverage": <Map<String, dynamic>>[],
        "collection_summary":
            goalType == 'collection'
                ? {
                    "target_amount":
                        matchedGoal['target_value'] ?? 0,
                    "collected_amount":
                        matchedGoal['achieved_value'] ?? 0,
                    "operations_count": 0,
                  }
                : null,
      };

      return WorkPlanGoalDetailsModel.fromJson(
        data,
      );
    }
  }

  // ==========================================================
  // PLAN 1
  // ==========================================================

  if (planId == 1 && goalId == 101) {
    // هدف المبيعات للخطة الأولى

    data = {
      "goal_id": 101,
      "title": "هدف المبيعات",
      "type": "sales",
      "target_value": 100000,
      "achieved_value": 85000,
      "progress": 85,
      "unit": "ر.س",

      "actual_data": [],

      "invoices": [
        {
          "id": 1001,
          "invoice_number": "INV-1001",
          "pharmacy_name": "صيدلية الشفاء",
          "date": "2026-08-03",
          "amount": 25000,
        },
        {
          "id": 1002,
          "invoice_number": "INV-1002",
          "pharmacy_name": "صيدلية الحياة",
          "date": "2026-08-05",
          "amount": 35000,
        },
        {
          "id": 1003,
          "invoice_number": "INV-1003",
          "pharmacy_name": "صيدلية الأمل",
          "date": "2026-08-07",
          "amount": 25000,
        },
      ],

      "coverage": [],
      "collection_summary": null,
    };
  }

  else if (planId == 1 && goalId == 102) {
    // تغطية الصيدليات للخطة الأولى

    data = {
      "goal_id": 102,
      "title": "تغطية الصيدليات",
      "type": "pharmacy_coverage",
      "target_value": 20,
      "achieved_value": 16,
      "progress": 80,
      "unit": "صيدلية",

      "actual_data": [],
      "invoices": [],

      "coverage": [
        {
          "pharmacy_id": 1,
          "pharmacy_name": "صيدلية الشفاء",
          "date": "2026-08-02",
          "completed": true,
        },
        {
          "pharmacy_id": 2,
          "pharmacy_name": "صيدلية الحياة",
          "date": "2026-08-03",
          "completed": true,
        },
        {
          "pharmacy_id": 3,
          "pharmacy_name": "صيدلية الأمل",
          "date": "2026-08-04",
          "completed": true,
        },
        {
          "pharmacy_id": 4,
          "pharmacy_name": "صيدلية النور",
          "date": "",
          "completed": false,
        },
      ],

      "collection_summary": null,
    };
  }

  else if (planId == 1 && goalId == 103) {
    // الزيارات للخطة الأولى

    data = {
      "goal_id": 103,
      "title": "الزيارات",
      "type": "visits",
      "target_value": 30,
      "achieved_value": 21,
      "progress": 70,
      "unit": "زيارة",

      "actual_data": [],
      "invoices": [],

      "coverage": [
        {
          "pharmacy_id": 1,
          "pharmacy_name": "صيدلية الشفاء",
          "date": "2026-08-02",
          "completed": true,
        },
        {
          "pharmacy_id": 2,
          "pharmacy_name": "صيدلية الحياة",
          "date": "2026-08-04",
          "completed": true,
        },
        {
          "pharmacy_id": 3,
          "pharmacy_name": "صيدلية النور",
          "date": "2026-08-05",
          "completed": true,
        },
      ],

      "collection_summary": null,
    };
  }

  else if (planId == 1 && goalId == 104) {
    // التحصيل للخطة الأولى

    data = {
      "goal_id": 104,
      "title": "هدف التحصيل",
      "type": "collection",
      "target_value": 50000,
      "achieved_value": 35000,
      "progress": 70,
      "unit": "ر.س",

      "actual_data": [],
      "invoices": [],
      "coverage": [],

      "collection_summary": {
        "target_amount": 50000,
        "collected_amount": 35000,
        "operations_count": 8,
      },
    };
  }

  // ==========================================================
  // PLAN 2
  // ==========================================================

  else if (planId == 2 && goalId == 201) {
    data = {
      "goal_id": 201,
      "title": "رفع المبيعات",
      "type": "sales",
      "target_value": 150000,
      "achieved_value": 0,
      "progress": 0,
      "unit": "ر.س",

      "actual_data": [],
      "invoices": [],
      "coverage": [],
      "collection_summary": null,
    };
  }

  else if (planId == 2 && goalId == 202) {
    data = {
      "goal_id": 202,
      "title": "زيارات الصيدليات",
      "type": "visits",
      "target_value": 25,
      "achieved_value": 0,
      "progress": 0,
      "unit": "زيارة",

      "actual_data": [],
      "invoices": [],

      "coverage": [
        {
          "pharmacy_id": 11,
          "pharmacy_name": "صيدلية الوفاء",
          "date": "",
          "completed": false,
        },
        {
          "pharmacy_id": 12,
          "pharmacy_name": "صيدلية الروضة",
          "date": "",
          "completed": false,
        },
      ],

      "collection_summary": null,
    };
  }

  else if (planId == 2 && goalId == 203) {
    data = {
      "goal_id": 203,
      "title": "تغطية صيدليات جديدة",
      "type": "pharmacy_coverage",
      "target_value": 10,
      "achieved_value": 0,
      "progress": 0,
      "unit": "صيدلية",

      "actual_data": [],
      "invoices": [],

      "coverage": [
        {
          "pharmacy_id": 21,
          "pharmacy_name": "صيدلية الشمال",
          "date": "",
          "completed": false,
        },
        {
          "pharmacy_id": 22,
          "pharmacy_name": "صيدلية الندى",
          "date": "",
          "completed": false,
        },
      ],

      "collection_summary": null,
    };
  }

  // ==========================================================
  // PLAN 3
  // ==========================================================

  else if (planId == 3 && goalId == 301) {
    data = {
      "goal_id": 301,
      "title": "تحصيل الذمم",
      "type": "collection",
      "target_value": 80000,
      "achieved_value": 80000,
      "progress": 100,
      "unit": "ر.س",

      "actual_data": [],
      "invoices": [],
      "coverage": [],

      "collection_summary": {
        "target_amount": 80000,
        "collected_amount": 80000,
        "operations_count": 14,
      },
    };
  }

  else if (planId == 3 && goalId == 302) {
    data = {
      "goal_id": 302,
      "title": "زيارات متابعة التحصيل",
      "type": "visits",
      "target_value": 15,
      "achieved_value": 15,
      "progress": 100,
      "unit": "زيارة",

      "actual_data": [],
      "invoices": [],

      "coverage": [
        {
          "pharmacy_id": 31,
          "pharmacy_name": "صيدلية السلام",
          "date": "2026-07-22",
          "completed": true,
        },
        {
          "pharmacy_id": 32,
          "pharmacy_name": "صيدلية الربيع",
          "date": "2026-07-24",
          "completed": true,
        },
      ],

      "collection_summary": null,
    };
  }

  // ==========================================================
  // PLAN 4
  // ==========================================================

  else if (planId == 4 && goalId == 401) {
    data = {
      "goal_id": 401,
      "title": "تغطية الصيدليات",
      "type": "pharmacy_coverage",
      "target_value": 40,
      "achieved_value": 25,
      "progress": 62.5,
      "unit": "صيدلية",

      "actual_data": [],
      "invoices": [],

      "coverage": [
        {
          "pharmacy_id": 41,
          "pharmacy_name": "صيدلية الغرب",
          "date": "2026-07-18",
          "completed": true,
        },
        {
          "pharmacy_id": 42,
          "pharmacy_name": "صيدلية المدينة",
          "date": "2026-07-20",
          "completed": true,
        },
        {
          "pharmacy_id": 43,
          "pharmacy_name": "صيدلية الرحمة",
          "date": "",
          "completed": false,
        },
      ],

      "collection_summary": null,
    };
  }

  else if (planId == 4 && goalId == 402) {
    data = {
      "goal_id": 402,
      "title": "الزيارات الميدانية",
      "type": "visits",
      "target_value": 50,
      "achieved_value": 30,
      "progress": 60,
      "unit": "زيارة",

      "actual_data": [],
      "invoices": [],

      "coverage": [
        {
          "pharmacy_id": 44,
          "pharmacy_name": "صيدلية الغرب",
          "date": "2026-07-19",
          "completed": true,
        },
        {
          "pharmacy_id": 45,
          "pharmacy_name": "صيدلية الرحمة",
          "date": "2026-07-21",
          "completed": true,
        },
      ],

      "collection_summary": null,
    };
  }

  else if (planId == 4 && goalId == 403) {
    data = {
      "goal_id": 403,
      "title": "مبيعات الصيدليات الجديدة",
      "type": "sales",
      "target_value": 60000,
      "achieved_value": 39000,
      "progress": 65,
      "unit": "ر.س",

      "actual_data": [],

      "invoices": [
        {
          "id": 4001,
          "invoice_number": "INV-4001",
          "pharmacy_name": "صيدلية الغرب",
          "date": "2026-07-20",
          "amount": 14000,
        },
        {
          "id": 4002,
          "invoice_number": "INV-4002",
          "pharmacy_name": "صيدلية المدينة",
          "date": "2026-07-23",
          "amount": 25000,
        },
      ],

      "coverage": [],
      "collection_summary": null,
    };
  }

  // ==========================================================
  // غير موجود
  // ==========================================================

  else {
    throw Exception(
      'تفاصيل الهدف المطلوبة غير موجودة',
    );
  }

  return WorkPlanGoalDetailsModel.fromJson(data);
}@override
Future<WorkPlanPersonalNoteModel> addPersonalNote({
  required int planId,
  required String text,
}) async {
  await Future.delayed(
    const Duration(milliseconds: 500),
  );

  final cleanText = text.trim();

  if (cleanText.isEmpty) {
    throw Exception(
      'يرجى كتابة الملاحظة',
    );
  }

  final note = {
    "id": _nextPersonalNoteId++,
    "plan_id": planId,
    "text": cleanText,
    "created_at": DateTime.now().toIso8601String(),
  };

  _personalNotes.putIfAbsent(
    planId,
    () => [],
  );

  _personalNotes[planId]!.insert(
    0,
    note,
  );

  return WorkPlanPersonalNoteModel.fromJson(
    note,
  );
}
@override
Future<SubmitWorkPlanResponseModel> submitWorkPlan({
  required int planId,
}) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 500),
  );

  final int index = _createdPlans.indexWhere(
    (plan) => plan['id'] == planId,
  );

  if (index == -1) {
    throw Exception(
      'الخطة المطلوبة غير موجودة',
    );
  }

  // تحديث حالة الخطة في قائمة "أنشأتها أنا"
  _createdPlans[index] = {
    ..._createdPlans[index],
    'status': 'waiting_for_review',
  };

  // تحديث نفس الحالة داخل تفاصيل الخطة
  if (_createdPlanDetails.containsKey(planId)) {
    _createdPlanDetails[planId] = {
      ..._createdPlanDetails[planId]!,
      'status': 'waiting_for_review',
    };
  }

  return SubmitWorkPlanResponseModel(
    planId: planId,
    status: 'waiting_for_review',
    message: 'تم إرسال الخطة للمراجعة',
  );
}


int _nextWorkPlanId = 100;
@override
Future<CreateWorkPlanResponseModel>
    createWorkPlan({
  required CreateWorkPlanRequestModel request,
}) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 500),
  );

  final int planId =
      _nextWorkPlanId++;

  final String status =
      request.action ==
              WorkPlanCreateAction.draft
          ? 'draft'
          : 'waiting_for_review';

  final String startDate =
      request.startDate == null
          ? ''
          : request.startDate!
              .toIso8601String()
              .split('T')
              .first;

  final String endDate =
      request.endDate == null
          ? ''
          : request.endDate!
              .toIso8601String()
              .split('T')
              .first;

  // ========================================================
  // تحويل أهداف الإنشاء إلى أهداف قابلة للعرض بالتفاصيل
  // ========================================================

  final List<Map<String, dynamic>>
      goals = [];

  for (final goal in request.goals) {
    final int goalId =
        _nextGoalId++;

    String title;
    String type;
    String unit;
    String description;

    switch (goal.type) {
      case CreateWorkPlanGoalType.sales:
        title = 'هدف المبيعات';
        type = 'sales';
        unit = 'ر.س';
        description =
            'تحقيق مبيعات بالقيمة المحددة';
        break;

      case CreateWorkPlanGoalType.collection:
        title = 'هدف التحصيل';
        type = 'collection';
        unit = 'ر.س';
        description =
            'تحقيق قيمة التحصيل المحددة';
        break;

      case CreateWorkPlanGoalType.pharmacyCoverage:
        title = 'تغطية الصيدليات';
        type = 'pharmacy_coverage';
        unit = 'صيدلية';
        description =
            'تغطية عدد الصيدليات المحدد';
        break;

      case CreateWorkPlanGoalType.visits:
        title = 'الزيارات';
        type = 'visits';
        unit = 'زيارة';
        description =
            'تنفيذ عدد الزيارات المحدد';
        break;

      case CreateWorkPlanGoalType.products:
        title = 'أصناف محددة';
        type = 'general';
        unit = 'صنف';
        description =
            'الأصناف: ${goal.productIds.join(', ')}';
        break;

      case CreateWorkPlanGoalType.companies:
        title = 'شركات محددة';
        type = 'general';
        unit = 'شركة';
        description =
            'الشركات: ${goal.companyIds.join(', ')}';
        break;

      case CreateWorkPlanGoalType.pharmacies:
        title = 'صيدليات محددة';
        type = 'general';
        unit = 'صيدلية';
        description =
            'الصيدليات: ${goal.pharmacyIds.join(', ')}';
        break;
    }

    goals.add(
      {
        "id": goalId,
        "title": title,
        "description": description,
        "type": type,
        "target_value":
            goal.targetValue ?? 0,
        "achieved_value": 0,
        "progress": 0,
        "unit": unit,
      },
    );
  }

  // ========================================================
  // نسخة القائمة
  // ========================================================

  final Map<String, dynamic>
      listPlan = {
    "id": planId,
    "name": request.name.trim(),
    "source": "المندوب",
    "start_date": startDate,
    "end_date": endDate,
    "status": status,
    "progress": 0,
  };

  // ========================================================
  // نسخة التفاصيل
  // ========================================================

  final Map<String, dynamic>
      detailsPlan = {
    "id": planId,

    "name":
        request.name.trim(),

    "description":
        request.description?.trim() ?? '',

    "source":
        "المندوب",

    "start_date":
        startDate,

    "end_date":
        endDate,

    "status":
        status,

    "progress":
        0,

    "region":
        request.regionId == null
            ? 'غير محددة'
            : 'المنطقة ${request.regionId}',

    "notes":
        request.notes?.trim() ?? '',

    "goals":
        goals,

    "personal_notes":
        [],

    "official_notes":
        [],
  };

  // ========================================================
  // حفظ الاثنين
  // ========================================================

  _createdPlans.insert(
    0,
    listPlan,
  );

  _createdPlanDetails[planId] =
      detailsPlan;

  return CreateWorkPlanResponseModel(
    planId: planId,
    status: status,
    message:
        request.action ==
                WorkPlanCreateAction.draft
            ? 'تم حفظ الخطة كمسودة'
            : 'تم إرسال الخطة للمراجعة',
  );
}
@override
Future<void> updateWorkPlan({
  required int planId,
  required UpdateWorkPlanRequestModel request,
}) async {
  await Future<void>.delayed(
    const Duration(milliseconds: 500),
  );

  final details =
      _createdPlanDetails[planId];

  if (details == null) {
    throw Exception(
      'الخطة المطلوبة غير موجودة',
    );
  }

  if (details['status'] !=
      'needs_modification') {
    throw Exception(
      'لا يمكن تعديل هذه الخطة حالياً',
    );
  }

  if (request.description.trim().isEmpty) {
    throw Exception(
      'يرجى إدخال وصف الخطة',
    );
  }

  if (request.endDate.isBefore(
    request.startDate,
  )) {
    throw Exception(
      'تاريخ النهاية يجب أن يكون بعد تاريخ البداية',
    );
  }

  if (request.goals.isEmpty) {
    throw Exception(
      'يجب إضافة هدف واحد على الأقل',
    );
  }

  final List<Map<String, dynamic>>
      updatedGoals = [];

  for (final goal in request.goals) {
    final int goalId =
        goal.id ?? _nextGoalId++;

    String title;
    String type;
    String unit;
    String description;

    switch (goal.type) {
      case CreateWorkPlanGoalType.sales:
        title = 'هدف المبيعات';
        type = 'sales';
        unit = 'ر.س';
        description =
            'تحقيق مبيعات بالقيمة المحددة';
        break;

      case CreateWorkPlanGoalType.collection:
        title = 'هدف التحصيل';
        type = 'collection';
        unit = 'ر.س';
        description =
            'تحقيق قيمة التحصيل المحددة';
        break;

      case CreateWorkPlanGoalType.pharmacyCoverage:
        title = 'تغطية الصيدليات';
        type = 'pharmacy_coverage';
        unit = 'صيدلية';
        description =
            'تغطية عدد الصيدليات المحدد';
        break;

      case CreateWorkPlanGoalType.visits:
        title = 'الزيارات';
        type = 'visits';
        unit = 'زيارة';
        description =
            'تنفيذ عدد الزيارات المحدد';
        break;

      case CreateWorkPlanGoalType.products:
        title = 'أصناف محددة';
        type = 'general';
        unit = 'صنف';
        description =
            'الأصناف: ${goal.productIds.join(', ')}';
        break;

      case CreateWorkPlanGoalType.companies:
        title = 'شركات محددة';
        type = 'general';
        unit = 'شركة';
        description =
            'الشركات: ${goal.companyIds.join(', ')}';
        break;

      case CreateWorkPlanGoalType.pharmacies:
        title = 'صيدليات محددة';
        type = 'general';
        unit = 'صيدلية';
        description =
            'الصيدليات: ${goal.pharmacyIds.join(', ')}';
        break;
    }

    updatedGoals.add(
      {
        'id': goalId,
        'title': title,
        'description': description,
        'type': type,
        'target_value':
            goal.targetValue ?? 0,
        'achieved_value': 0,
        'progress': 0,
        'unit': unit,
      },
    );
  }

  final String startDate = request
      .startDate
      .toIso8601String()
      .split('T')
      .first;

  final String endDate = request
      .endDate
      .toIso8601String()
      .split('T')
      .first;

  // تحديث التفاصيل
  _createdPlanDetails[planId] = {
    ...details,

    'description':
        request.description.trim(),

    'start_date': startDate,
    'end_date': endDate,

    'notes':
        request.notes?.trim() ?? '',

    'goals': updatedGoals,

    // ما منغير الحالة هون
    // UC-201 رح يغيرها بعد إعادة الإرسال
    'status': 'needs_modification',
  };

  // تحديث نسخة القائمة
  final int index =
      _createdPlans.indexWhere(
    (plan) => plan['id'] == planId,
  );

  if (index != -1) {
    _createdPlans[index] = {
      ..._createdPlans[index],
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
}