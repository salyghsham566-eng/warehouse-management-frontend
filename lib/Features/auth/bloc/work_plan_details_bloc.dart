import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_state.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';

class WorkPlanDetailsBloc
    extends Bloc<WorkPlanDetailsEvent, WorkPlanDetailsState> {
  final WorkPlansRepository repository;

  WorkPlanDetailsBloc({
    required this.repository,
  }) : super(WorkPlanDetailsInitial()) {
    on<LoadWorkPlanDetailsEvent>(_loadDetails);
  }

  Future<void> _loadDetails(
    LoadWorkPlanDetailsEvent event,
    Emitter<WorkPlanDetailsState> emit,
  ) async {
    // إذا كانت التفاصيل محمّلة مسبقاً، فهذا Refresh بعد إضافة
    // ملاحظة/رد أو تحديث آخر. نحافظ على البيانات الحالية أثناء
    // جلب النسخة الجديدة حتى لا تتحول الشاشة إلى Loading بالكامل.
    final hasLoadedData = state is WorkPlanDetailsLoaded;

    if (!hasLoadedData) {
      emit(WorkPlanDetailsLoading());
    }

    try {
      final plan = await repository.getWorkPlanDetails(
        planId: event.planId,
      );

      emit(
        WorkPlanDetailsLoaded(
          plan: plan,
        ),
      );
    } catch (e) {
      // عند أول فتح للشاشة نعرض الخطأ بشكل طبيعي.
      // أما أثناء Refresh ولدينا بيانات ظاهرة بالفعل، فلا نمسح
      // الشاشة ولا نحولها إلى Error بسبب فشل تحديث مؤقت.
      if (!hasLoadedData) {
        emit(
          WorkPlanDetailsFailure(
            message: e.toString(),
          ),
        );
      }
    }
  }
}
