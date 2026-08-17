import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';

abstract class WorkPlanDetailsEvent {}

class LoadWorkPlanDetailsEvent
    extends WorkPlanDetailsEvent {
  final int planId;

  LoadWorkPlanDetailsEvent({
    required this.planId,
  });
}

// ============================================================
// UC-198
// تحديث تفاصيل الخطة مباشرة بعد إضافة ملاحظة خاصة
// بدون إعادة تحميل الخطة كاملة
// ============================================================

class AddPersonalNoteToDetailsEvent
    extends WorkPlanDetailsEvent {
  final WorkPlanPersonalNoteModel note;

  AddPersonalNoteToDetailsEvent({
    required this.note,
  });
}



class AddOfficialNoteToDetailsEvent
    extends WorkPlanDetailsEvent {
  final WorkPlanOfficialNoteModel note;

  AddOfficialNoteToDetailsEvent({
    required this.note,
  });
}