class SubmitWorkPlanResponseModel {
  final int planId;
  final String status;
  final String message;

  const SubmitWorkPlanResponseModel({
    required this.planId,
    required this.status,
    required this.message,
  });

  factory SubmitWorkPlanResponseModel.fromJson(
    Map<String, dynamic> json, {
    String? message,
  }) {
    return SubmitWorkPlanResponseModel(
      planId:
          json['id'] ??
          json['plan_id'] ??
          0,

      status:
          json['status']?.toString() ??
          'waiting_for_review',

      message:
          message ??
          json['message']?.toString() ??
          'تم إرسال الخطة للمراجعة',
    );
  }
}