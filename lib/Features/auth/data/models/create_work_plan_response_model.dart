class CreateWorkPlanResponseModel {
  final int planId;
  final String status;
  final String message;

  const CreateWorkPlanResponseModel({
    required this.planId,
    required this.status,
    required this.message,
  });

  factory CreateWorkPlanResponseModel.fromJson(
    Map<String, dynamic> json, {
    String? message,
  }) {
    return CreateWorkPlanResponseModel(
      planId:
          json['id'] ??
          json['plan_id'] ??
          0,

      status:
          json['status']?.toString() ??
          '',

      message:
          message ??
          json['message']?.toString() ??
          'تم حفظ خطة العمل بنجاح',
    );
  }
}