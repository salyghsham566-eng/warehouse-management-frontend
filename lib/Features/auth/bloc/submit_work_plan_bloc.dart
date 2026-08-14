import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/submit_work_plan_event.dart';
import 'package:project_2/Features/auth/bloc/submit_work_plan_state.dart';

import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class SubmitWorkPlanBloc
    extends Bloc<
        SubmitWorkPlanEvent,
        SubmitWorkPlanState> {
  final WorkPlansRepository repository;

  SubmitWorkPlanBloc({
    required this.repository,
  }) : super(SubmitWorkPlanInitial()) {
    on<SubmitWorkPlanRequested>(
      _submitWorkPlan,
    );
  }

  Future<void> _submitWorkPlan(
    SubmitWorkPlanRequested event,
    Emitter<SubmitWorkPlanState> emit,
  ) async {
    if (event.planId <= 0) {
      emit(
        SubmitWorkPlanFailure(
          message: 'معرف الخطة غير صحيح',
        ),
      );
      return;
    }

    emit(
      SubmitWorkPlanLoading(),
    );

    try {
      final response =
          await repository.submitWorkPlan(
        planId: event.planId,
      );

      emit(
        SubmitWorkPlanSuccess(
          response: response,
        ),
      );
    } catch (e) {
      emit(
        SubmitWorkPlanFailure(
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