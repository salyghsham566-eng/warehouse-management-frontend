enum WorkPlanOfficialNoteType {
  note,
  reply,
}

class WorkPlanOfficialNoteModel {
  final int id;
  final int planId;
  final String text;

  // صاحب الملاحظة
  final String authorName;

  // مثلاً: مندوب / مشرف
  final String authorRole;

  final String createdAt;

  final WorkPlanOfficialNoteType type;

  const WorkPlanOfficialNoteModel({
    required this.id,
    required this.planId,
    required this.text,
    required this.authorName,
    required this.authorRole,
    required this.createdAt,
    required this.type,
  });

  factory WorkPlanOfficialNoteModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkPlanOfficialNoteModel(
      id: json['id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      text: json['text'] ?? '',
      authorName: json['author_name'] ?? '',
      authorRole: json['author_role'] ?? '',
      createdAt: json['created_at'] ?? '',
      type: workPlanOfficialNoteTypeFromString(
        json['type']?.toString(),
      ),
    );
  }
}

WorkPlanOfficialNoteType workPlanOfficialNoteTypeFromString(
  String? value,
) {
  if (value == 'reply') {
    return WorkPlanOfficialNoteType.reply;
  }

  return WorkPlanOfficialNoteType.note;
}

String workPlanOfficialNoteTypeToString(
  WorkPlanOfficialNoteType value,
) {
  if (value == WorkPlanOfficialNoteType.reply) {
    return 'reply';
  }

  return 'note';
}