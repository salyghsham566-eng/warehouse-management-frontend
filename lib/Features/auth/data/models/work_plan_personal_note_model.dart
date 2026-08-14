class WorkPlanPersonalNoteModel {
  final int id;
  final int planId;
  final String text;
  final String createdAt;

  const WorkPlanPersonalNoteModel({
    required this.id,
    required this.planId,
    required this.text,
    required this.createdAt,
  });

  factory WorkPlanPersonalNoteModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkPlanPersonalNoteModel(
      id: json['id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}