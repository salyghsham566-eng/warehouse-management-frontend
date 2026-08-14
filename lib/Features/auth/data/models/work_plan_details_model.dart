import 'package:project_2/Features/auth/data/models/work_plan_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';

class WorkPlanDetailsModel {
  final int id;
  final String name;
  final String description;
  final String source;

  final String startDate;
  final String endDate;

  final WorkPlanStatus status;
  final double progress;
  final String? reviewReason;

  final String region;
  final String notes;
  final List<WorkPlanOfficialNoteModel> officialNotes;

  final List<WorkPlanGoalModel> goals;
final List<WorkPlanPersonalNoteModel> personalNotes;
  const WorkPlanDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.source,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.progress,
    required this.region,
    required this.notes,
    required this.officialNotes,
    required this.goals,
    required this.personalNotes,
    required this.reviewReason,
  });

  factory WorkPlanDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final goalsJson =
        json['goals'] as List<dynamic>? ?? [];

    return WorkPlanDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      source: json['source'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: workPlanStatusFromString(
        json['status']?.toString(),
      ),
      progress: _toDouble(json['progress']),
      region: json['region'] ?? '',
      notes: json['notes'] ?? '',
      goals: goalsJson
          .map(
            (e) => WorkPlanGoalModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
     personalNotes:
    (json['personal_notes'] as List<dynamic>? ?? [])
        .map(
          (item) => WorkPlanPersonalNoteModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(),
        officialNotes:
    (json['official_notes'] as List<dynamic>? ?? [])
        .map(
          (item) => WorkPlanOfficialNoteModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(),
        reviewReason:
    json['review_reason']?.toString() ??
    json['reason']?.toString() ??
    json['rejection_reason']?.toString() ??
    json['modification_reason']?.toString(),
    );
    
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}