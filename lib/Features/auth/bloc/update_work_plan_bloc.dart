import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/update_work_plan_event.dart';
import 'package:project_2/Features/auth/bloc/update_work_plan_state.dart';

import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class UpdateWorkPlanBloc
    extends Bloc<
        UpdateWorkPlanEvent,
        UpdateWorkPlanState> {
  final WorkPlansRepository repository;

  UpdateWorkPlanBloc({
    required this.repository,
  }) : super(UpdateWorkPlanInitial()) {
    on<UpdateWorkPlanSubmitted>(
      _updateWorkPlan,
    );
  }

  Future<void> _updateWorkPlan(
    UpdateWorkPlanSubmitted event,
    Emitter<UpdateWorkPlanState> emit,
  ) async {
    final request = event.request;

    if (event.planId <= 0) {
      emit(
        UpdateWorkPlanFailure(
          message: 'معرف الخطة غير صحيح',
        ),
      );
      return;
    }

    if (request.description.trim().isEmpty) {
      emit(
        UpdateWorkPlanFailure(
          message: 'يرجى إدخال وصف الخطة',
        ),
      );
      return;
    }

    if (request.endDate.isBefore(
      request.startDate,
    )) {
      emit(
        UpdateWorkPlanFailure(
          message:
              'تاريخ النهاية يجب أن يكون بعد تاريخ البداية',
        ),
      );
      return;
    }

    if (request.goals.isEmpty) {
      emit(
        UpdateWorkPlanFailure(
          message:
              'يجب إضافة هدف واحد على الأقل',
        ),
      );
      return;
    }

    emit(
      UpdateWorkPlanLoading(),
    );

    try {
      // ==========================================
      // 1. تعديل الخطة
      // ==========================================

      await repository.updateWorkPlan(
        planId: event.planId,
        request: request,
      );

      // ==========================================
      // 2. إعادة إرسالها للمراجعة - UC-201
      // ==========================================

      await repository.submitWorkPlan(
        planId: event.planId,
      );

      emit(
        UpdateWorkPlanSuccess(
          message:
              'تم تعديل الخطة وإعادة إرسالها للمراجعة',
        ),
      );
    } catch (e) {
      emit(
        UpdateWorkPlanFailure(
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