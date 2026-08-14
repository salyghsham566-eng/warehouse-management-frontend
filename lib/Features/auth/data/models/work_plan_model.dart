enum WorkPlanStatus {
  draft,
  waitingToStart,
  inProgress,
  completed,
  delayed,
  waitingForReview,
  needsModification,
  rejected,
  approved,
}

class WorkPlanModel {
  final int id;
  final String name;
  final String source;
  final String startDate;
  final String endDate;
  final WorkPlanStatus status;
  final double progress;

  const WorkPlanModel({
    required this.id,
    required this.name,
    required this.source,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.progress,
  });

  factory WorkPlanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkPlanModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      source: json['source'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',

      // هون منستخدم الدالة الموجودة تحت الكلاس
      status: workPlanStatusFromString(
        json['status']?.toString(),
      ),

      progress: _toDouble(
        json['progress'],
      ),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }
}

// ==========================================================
// تحويل status القادم من الـ API إلى Enum
// ==========================================================
// انتبهي: هاي الدالة برا WorkPlanModel
// ==========================================================

WorkPlanStatus workPlanStatusFromString(
  String? value,
) {
  switch (value) {
    case 'draft':
      return WorkPlanStatus.draft;

    case 'waiting_to_start':
      return WorkPlanStatus.waitingToStart;

    case 'in_progress':
      return WorkPlanStatus.inProgress;

    case 'completed':
      return WorkPlanStatus.completed;

    case 'delayed':
      return WorkPlanStatus.delayed;

    case 'waiting_for_review':
      return WorkPlanStatus.waitingForReview;

    case 'approved':
      return WorkPlanStatus.approved;

    case 'needs_modification':
      return WorkPlanStatus.needsModification;

    case 'rejected':
      return WorkPlanStatus.rejected;

    default:
      return WorkPlanStatus.draft;
  }
}