import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/create_work_plan_event.dart';
import 'package:project_2/Features/auth/bloc/create_work_plan_state.dart';

import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';

import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class CreateWorkPlanBloc
    extends Bloc<
        CreateWorkPlanEvent,
        CreateWorkPlanState> {
  final WorkPlansRepository repository;

  CreateWorkPlanBloc({
    required this.repository,
  }) : super(CreateWorkPlanInitial()) {
    on<CreateWorkPlanSubmitted>(
      _createWorkPlan,
    );
  }

  Future<void> _createWorkPlan(
    CreateWorkPlanSubmitted event,
    Emitter<CreateWorkPlanState> emit,
  ) async {
    final request = event.request;

    // الاسم مطلوب سواء مسودة أو إرسال
    if (request.name.trim().isEmpty) {
      emit(
        CreateWorkPlanFailure(
          message: 'يرجى إدخال اسم الخطة',
        ),
      );
      return;
    }

    // =========================================
    // في حال إرسال الخطة مباشرة للمراجعة
    // UC-200 + شرط UC-201
    // =========================================

    if (request.action ==
        WorkPlanCreateAction.submit) {
      if (request.description == null ||
          request.description!.trim().isEmpty) {
        emit(
          CreateWorkPlanFailure(
            message:
                'يرجى إدخال وصف الخطة',
          ),
        );
        return;
      }

      if (request.startDate == null ||
          request.endDate == null) {
        emit(
          CreateWorkPlanFailure(
            message:
                'يرجى تحديد تاريخ بداية ونهاية الخطة',
          ),
        );
        return;
      }

      if (request.endDate!.isBefore(
        request.startDate!,
      )) {
        emit(
          CreateWorkPlanFailure(
            message:
                'تاريخ النهاية يجب أن يكون بعد تاريخ البداية',
          ),
        );
        return;
      }

      if (request.goals.isEmpty) {
        emit(
          CreateWorkPlanFailure(
            message:
                'يجب إضافة هدف واحد على الأقل',
          ),
        );
        return;
      }
    }

    emit(CreateWorkPlanLoading());

    try {
      final response =
          await repository.createWorkPlan(
        request: request,
      );

      emit(
        CreateWorkPlanSuccess(
          response: response,
        ),
      );
    } catch (e) {
      emit(
        CreateWorkPlanFailure(
          message: e
              .toString()
              .replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}