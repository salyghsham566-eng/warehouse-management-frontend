import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/create_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/submit_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_goal_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_goal_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_official_note_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_personal_note_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plans_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plans_event.dart';
import 'package:project_2/Features/auth/bloc/work_plans_state.dart';
import 'package:project_2/Features/auth/data/models/work_plan_model.dart';
import 'package:project_2/create_work_plan_screen.dart';
import 'package:project_2/work_plan_details_screen.dart';

class WorkPlansScreen extends StatefulWidget {
  const WorkPlansScreen({
    super.key,
  });

  @override
  State<WorkPlansScreen> createState() => _WorkPlansScreenState();
}

class _WorkPlansScreenState extends State<WorkPlansScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,

          title: const Text(
            'خطط العمل',
            style: TextStyle(
              color: Color(0xFF102A43),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          centerTitle: true,

          iconTheme: const IconThemeData(
            color: Color(0xFF102A43),
          ),
        ),

        body: BlocBuilder<WorkPlansBloc, WorkPlansState>(
          builder: (context, state) {
            if (state is WorkPlansLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WorkPlansFailure) {
              return _buildErrorState(
                context,
                state.message,
              );
            }

            if (state is WorkPlansLoaded) {
              final plans = _selectedTab == 0
                  ? state.assignedPlans
                  : state.createdPlans;

              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<WorkPlansBloc>()
                      .add(LoadWorkPlansEvent());
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          18,
                          16,
                          12,
                        ),
                        child: _buildTabs(
                          assignedCount: state.assignedPlans.length,
                          createdCount: state.createdPlans.length,
                        ),
                      ),
                    ),

                    if (plans.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyPlansView(),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          4,
                          16,
                          24,
                        ),
                       sliver: SliverList.separated(
  itemCount: plans.length,
  separatorBuilder: (_, __) {
    return const SizedBox(height: 12);
  },
  itemBuilder: (context, index) {
    final plan = plans[index];

    return _WorkPlanCard(
      plan: plan,
    
  onTap: () async {
  final changed = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<WorkPlanDetailsBloc>(
              create: (_) =>
                  sl<WorkPlanDetailsBloc>()
                    ..add(
                      LoadWorkPlanDetailsEvent(
                        planId: plan.id,
                      ),
                    ),
            ),

            // UC-201
            BlocProvider<SubmitWorkPlanBloc>(
              create: (_) =>
                  sl<SubmitWorkPlanBloc>(),
            ),

            // UC-198
            BlocProvider<WorkPlanPersonalNoteBloc>(
              create: (_) =>
                  sl<WorkPlanPersonalNoteBloc>(),
            ),

            // UC-199
            BlocProvider<WorkPlanOfficialNoteBloc>(
              create: (_) =>
                  sl<WorkPlanOfficialNoteBloc>(),
            ),
          ],
          child: WorkPlanDetailsScreen(
            planId: plan.id,
          ),
        );
      },
    ),
  );

  // إذا تغيرت حالة الخطة نعيد تحميل القائمة
  if (changed == true && context.mounted) {
    context.read<WorkPlansBloc>().add(
      LoadWorkPlansEvent(),
    );
  }
},
    );
  },
),
                 ) ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
    floatingActionButtonLocation:
    FloatingActionButtonLocation.endFloat,

floatingActionButton: FloatingActionButton(
  backgroundColor: const Color(0xFF12355B),
  foregroundColor: Colors.white,
  elevation: 6,

  onPressed: () async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<CreateWorkPlanBloc>(
          create: (_) => sl<CreateWorkPlanBloc>(),
          child: const CreateWorkPlanScreen(),
        ),
      ),
    );

    if (result == true && context.mounted) {
      setState(() {
        _selectedTab = 1;
      });

      context
          .read<WorkPlansBloc>()
          .add(LoadWorkPlansEvent());
    }
  },

  child: const Icon(
    Icons.add,
    size: 30,
  ),
),
      ),
    );
  }

  // ========================================================
  // Tabs
  // ========================================================

  Widget _buildTabs({
    required int assignedCount,
    required int createdCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDF5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'مكلف بها',
              count: assignedCount,
              selected: _selectedTab == 0,
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: _TabButton(
              title: 'أنشأتها أنا',
              count: createdCount,
              selected: _selectedTab == 1,
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // Error
  // ========================================================

  Widget _buildErrorState(
    BuildContext context,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 55,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 16),

            const Text(
              'تعذر تحميل خطط العمل',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF667085),
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: () {
                context
                    .read<WorkPlansBloc>()
                    .add(LoadWorkPlansEvent());
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
class _TabButton extends StatelessWidget {
  final String title;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF0B2D5B)
                    : const Color(0xFF667085),
                fontSize: 14,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),

            const SizedBox(width: 6),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE6EFFA)
                    : const Color(0xFFD9DEE8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0B2D5B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}class _WorkPlanCard extends StatelessWidget {
  final WorkPlanModel plan;
  final VoidCallback onTap;

  const _WorkPlanCard({
    required this.plan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(plan.status);

    final progress =
        (plan.progress.clamp(0, 100)) / 100;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE7EAF0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =============================================
              // الحالة + النسبة
              // =============================================

              Row(
                children: [
                  _StatusChip(
                    title: statusInfo.title,
                    backgroundColor:
                        statusInfo.backgroundColor,
                    foregroundColor:
                        statusInfo.foregroundColor,
                  ),

                  const Spacer(),

                  Text(
                    '${plan.progress.toInt()}%',
                    style: const TextStyle(
                      color: Color(0xFF0B2D5B),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =============================================
              // Progress
              // =============================================

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor:
                      const Color(0xFFE3ECF8),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    statusInfo.progressColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =============================================
              // اسم الخطة
              // =============================================

              Text(
                plan.name,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.4,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF102A43),
                ),
              ),

              const SizedBox(height: 8),

              // =============================================
              // المصدر
              // =============================================

              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Color(0xFF667085),
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      plan.source,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Divider(
                height: 1,
                color: Color(0xFFEAECF0),
              ),

              const SizedBox(height: 14),

              // =============================================
              // التواريخ
              // =============================================

              Row(
                children: [
                  Expanded(
                    child: _DateInfo(
                      title: 'من',
                      date: _formatDate(plan.startDate),
                    ),
                  ),

                  Container(
                    height: 34,
                    width: 1,
                    color: const Color(0xFFEAECF0),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _DateInfo(
                      title: 'إلى',
                      date: _formatDate(plan.endDate),
                    ),
                  ),

                  const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Color(0xFF98A2B3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}class _DateInfo extends StatelessWidget {
  final String title;
  final String date;

  const _DateInfo({
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF98A2B3),
          ),
        ),

        const SizedBox(height: 3),

        Text(
          date,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF344054),
          ),
        ),
      ],
    );
  }
}class _StatusChip extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;

  const _StatusChip({
    required this.title,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: foregroundColor,
        ),
      ),
    );
  }
}class _StatusInfo {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color progressColor;

  const _StatusInfo({
    required this.title,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.progressColor,
  });
}

_StatusInfo _getStatusInfo(
  WorkPlanStatus status,
) {
  switch (status) {
    case WorkPlanStatus.approved:
  return const _StatusInfo(
    title: 'معتمدة',
    backgroundColor: Color(0xFFE8F5E9),
    foregroundColor: Color(0xFF2E7D32),
    progressColor: Color(0xFF2E7D32),
  );
    case WorkPlanStatus.draft:
  return const _StatusInfo(
    title: 'مسودة',
    backgroundColor: Color(0xFFF2F4F7),
    foregroundColor: Color(0xFF475467),
    progressColor: Color(0xFF98A2B3),
  );
    case WorkPlanStatus.waitingToStart:
      return const _StatusInfo(
        title: 'بانتظار البدء',
        backgroundColor: Color(0xFFEEF2F6),
        foregroundColor: Color(0xFF475467),
        progressColor: Color(0xFF98A2B3),
      );

    case WorkPlanStatus.inProgress:
      return const _StatusInfo(
        title: 'قيد التنفيذ',
        backgroundColor: Color(0xFFE8F3FF),
        foregroundColor: Color(0xFF175CD3),
        progressColor: Color(0xFF087443),
      );

    case WorkPlanStatus.completed:
      return const _StatusInfo(
        title: 'مكتملة',
        backgroundColor: Color(0xFFECFDF3),
        foregroundColor: Color(0xFF027A48),
        progressColor: Color(0xFF12B76A),
      );

    case WorkPlanStatus.delayed:
      return const _StatusInfo(
        title: 'متأخرة',
        backgroundColor: Color(0xFFFFF4ED),
        foregroundColor: Color(0xFFB93815),
        progressColor: Color(0xFFF79009),
      );

    case WorkPlanStatus.waitingForReview:
      return const _StatusInfo(
        title: 'بانتظار المراجعة',
        backgroundColor: Color(0xFFFFFAEB),
        foregroundColor: Color(0xFFB54708),
        progressColor: Color(0xFFF79009),
      );

    case WorkPlanStatus.needsModification:
      return const _StatusInfo(
        title: 'بحاجة تعديل',
        backgroundColor: Color(0xFFFFF4ED),
        foregroundColor: Color(0xFFC4320A),
        progressColor: Color(0xFFF79009),
      );

    case WorkPlanStatus.rejected:
      return const _StatusInfo(
        title: 'مرفوضة',
        backgroundColor: Color(0xFFFEF3F2),
        foregroundColor: Color(0xFFB42318),
        progressColor: Color(0xFFD92D20),
      );
  }
}
String _formatDate(String value) {
  try {
    final date = DateTime.parse(value);

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  } catch (_) {
    return value;
  }
}class _EmptyPlansView extends StatelessWidget {
  const _EmptyPlansView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF0F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 34,
                color: Color(0xFF0B2D5B),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'لا توجد خطط حالياً',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF102A43),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'ستظهر خطط العمل هنا عند توفرها',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}