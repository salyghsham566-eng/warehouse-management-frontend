import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/submit_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/submit_work_plan_event.dart';
import 'package:project_2/Features/auth/bloc/submit_work_plan_state.dart';
import 'package:project_2/Features/auth/bloc/update_work_plan_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_state.dart';

import 'package:project_2/Features/auth/bloc/work_plan_goal_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_goal_details_event.dart';

import 'package:project_2/Features/auth/bloc/work_plan_personal_note_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_official_note_bloc.dart';

import 'package:project_2/Features/auth/data/models/work_plan_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_model.dart';
import 'package:project_2/edit_work_plan_screen.dart';

import 'package:project_2/work_plan_goal_details_screen.dart';
import 'package:project_2/work_plan_notes_screen.dart';

class WorkPlanDetailsScreen extends StatelessWidget {
  final int planId;

  const WorkPlanDetailsScreen({
    super.key,
    required this.planId,
  });

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
          centerTitle: true,
          foregroundColor: const Color(0xFF102A43),
          title: const Text(
            'تفاصيل الخطة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),
        ),

        body:BlocListener<
    SubmitWorkPlanBloc,
    SubmitWorkPlanState>(
  listener: (context, submitState) {
    if (submitState is SubmitWorkPlanSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            submitState.response.message,
          ),
        ),
      );

      // نرجع لقائمة الخطط ونخبرها أن البيانات تغيرت
      Navigator.pop(
        context,
        true,
      );
    }

    if (submitState is SubmitWorkPlanFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            submitState.message,
          ),
        ),
      );
    }
  },

  child: BlocBuilder<
            WorkPlanDetailsBloc,
            WorkPlanDetailsState>(
          builder: (context, state) {
            if (state is WorkPlanDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WorkPlanDetailsFailure) {
              return _buildError(
                context,
                state.message,
                planId,
              );
            }

            if (state is WorkPlanDetailsLoaded) {
              final plan = state.plan;

              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<WorkPlanDetailsBloc>()
                      .add(
                        LoadWorkPlanDetailsEvent(
                          planId: planId,
                        ),
                      );
                },
                child: ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    30,
                  ),
                  children: [
                    // =================================================
                    // UC-192
                    // معلومات الخطة
                    // =================================================

                    _PlanHeaderCard(
                      name: plan.name,
                      description: plan.description,
                      source: plan.source,
                      status: plan.status,
                      progress: plan.progress,
                    ),
if ((plan.status == WorkPlanStatus.rejected ||
        plan.status ==
            WorkPlanStatus.needsModification) &&
    plan.reviewReason != null &&
    plan.reviewReason!.trim().isNotEmpty) ...[
  const SizedBox(height: 14),

  _ReviewReasonCard(
    status: plan.status,
    reason: plan.reviewReason!,
  ),
],
                    const SizedBox(height: 14),

                    _PlanInformationCard(
                      region: plan.region,
                      startDate: plan.startDate,
                      endDate: plan.endDate,
                    ),
if (plan.status ==
    WorkPlanStatus.needsModification) ...[
  const SizedBox(height: 14),

  SizedBox(
    width: double.infinity,

    child: ElevatedButton.icon(
      onPressed: () async {
        final changed =
            await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider<
                  UpdateWorkPlanBloc>(
                create: (_) =>
                    sl<UpdateWorkPlanBloc>(),

                child:
                    EditWorkPlanScreen(
                  plan: plan,
                ),
              );
            },
          ),
        );

        if (changed == true &&
            context.mounted) {
          // الخطة تعدلت وانرسلت من جديد
          // نرجع للقائمة حتى تعمل Refresh
          Navigator.pop(
            context,
            true,
          );
        }
      },

      icon:
          const Icon(
        Icons.edit_outlined,
      ),

      label:
          const Text(
        'تعديل الخطة',
      ),

      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            const Color(
          0xFFF59E0B,
        ),

        foregroundColor:
            Colors.white,

        elevation: 0,

        padding:
            const EdgeInsets
                .symmetric(
          vertical: 14,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            14,
          ),
        ),

        textStyle:
            const TextStyle(
          fontSize: 15,
          fontWeight:
              FontWeight.w800,
        ),
      ),
    ),
  ),
],
                    const SizedBox(height: 14),

                    // =================================================
                    // ملاحظات الخطة الأصلية UC-192
                    // =================================================

                    _PlanNotesCard(
                      notes: plan.notes,
                    ),

                    const SizedBox(height: 14),

                    // =================================================
                    // UC-198 + UC-199
                    // مدخل شاشة الملاحظات فقط
                    // =================================================

                    _WorkPlanNotesCard(
                      personalNotesCount:
                          plan.personalNotes.length,
                      officialNotesCount:
                          plan.officialNotes.length,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return MultiBlocProvider(
                                providers: [
                                  // نستخدم نفس Bloc تفاصيل الخطة
                                  BlocProvider.value(
                                    value: context.read<
                                        WorkPlanDetailsBloc>(),
                                  ),

                                  // UC-198
                                  // نستخدم نفس Bloc الموجود من شاشة التفاصيل
                                  BlocProvider.value(
                                    value: context.read<
                                        WorkPlanPersonalNoteBloc>(),
                                  ),

                                  // UC-199
                                  // نستخدم نفس Bloc الموجود من شاشة التفاصيل
                                  BlocProvider.value(
                                    value: context.read<
                                        WorkPlanOfficialNoteBloc>(),
                                  ),
                                ],
                                child: WorkPlanNotesScreen(
                                  planId: plan.id,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // =================================================
                    // UC-193
                    // أهداف الخطة
                    // =================================================

                    Row(
                      children: [
                        const Text(
                          'أهداف الخطة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF102A43),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFE8F0FA),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${plan.goals.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0B2D5B),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (plan.goals.isEmpty)
                      const _EmptyGoalsCard()
                    else
                      ...List.generate(
                        plan.goals.length,
                        (index) {
                          final goal =
                              plan.goals[index];

                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: _GoalCard(
                              goal: goal,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return BlocProvider<
                                          WorkPlanGoalDetailsBloc>(
                                        create: (_) =>
                                            sl<
                                                WorkPlanGoalDetailsBloc>()
                                              ..add(
                                                LoadWorkPlanGoalDetailsEvent(
                                                  planId:
                                                      plan.id,
                                                  goalId:
                                                      goal.id,
                                                ),
                                              ),
                                        child:
                                            WorkPlanGoalDetailsScreen(
                                          planId:
                                              plan.id,
                                          goalId:
                                              goal.id,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      if (plan.status == WorkPlanStatus.draft) ...[
  const SizedBox(height: 20),

  BlocBuilder<
      SubmitWorkPlanBloc,
      SubmitWorkPlanState>(
    builder: (context, submitState) {
      final isSubmitting =
          submitState is SubmitWorkPlanLoading;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isSubmitting
              ? null
              : () async {
                  // =========================================
                  // UC-201
                  // تحقق قبل الإرسال
                  // =========================================

                  if (plan.name.trim().isEmpty) {
                    _showMessage(
                      context,
                      'يجب إدخال اسم الخطة قبل الإرسال',
                    );
                    return;
                  }

                  if (plan.description.trim().isEmpty) {
                    _showMessage(
                      context,
                      'يجب إدخال وصف الخطة قبل الإرسال',
                    );
                    return;
                  }

                  if (plan.startDate.trim().isEmpty ||
                      plan.endDate.trim().isEmpty) {
                    _showMessage(
                      context,
                      'يجب تحديد تواريخ الخطة قبل الإرسال',
                    );
                    return;
                  }

                  if (plan.goals.isEmpty) {
                    _showMessage(
                      context,
                      'يجب إضافة هدف واحد على الأقل قبل الإرسال',
                    );
                    return;
                  }

                  final confirm =
                      await _confirmSubmit(
                    context,
                  );

                  if (confirm != true ||
                      !context.mounted) {
                    return;
                  }

                  context
                      .read<SubmitWorkPlanBloc>()
                      .add(
                        SubmitWorkPlanRequested(
                          planId: plan.id,
                        ),
                      );
                },

          icon: isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.send_outlined,
                ),

          label: Text(
            isSubmitting
                ? 'جارٍ الإرسال...'
                : 'إرسال للمراجعة',
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF12355B),
            foregroundColor:
                Colors.white,
            elevation: 0,

            padding:
                const EdgeInsets.symmetric(
              vertical: 15,
            ),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(14),
            ),

            textStyle:
                const TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),
      );
    },
  ),
],
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    ));
  }
void _showMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

Future<bool?> _confirmSubmit(
  BuildContext context,
) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text(
          'إرسال الخطة للمراجعة',
        ),

        content: const Text(
          'بعد إرسال الخطة ستصبح بانتظار مراجعة المشرف. هل تريد المتابعة؟',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                false,
              );
            },
            child: const Text(
              'إلغاء',
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                true,
              );
            },
            child: const Text(
              'إرسال',
            ),
          ),
        ],
      );
    },
  );
}
  Widget _buildError(
    BuildContext context,
    String message,
    int currentPlanId,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 14),

            const Text(
              'تعذر تحميل تفاصيل الخطة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF102A43),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF667085),
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<WorkPlanDetailsBloc>()
                    .add(
                      LoadWorkPlanDetailsEvent(
                        planId:
                            currentPlanId,
                      ),
                    );
              },
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Header
// ============================================================

class _PlanHeaderCard extends StatelessWidget {
  final String name;
  final String description;
  final String source;
  final WorkPlanStatus status;
  final double progress;

  const _PlanHeaderCard({
    required this.name,
    required this.description,
    required this.source,
    required this.status,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo =
        _getStatusInfo(status);

    final progressValue =
        progress.clamp(0, 100).toDouble() / 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
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
                '${progress.toInt()}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0B2D5B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 9,
              backgroundColor:
                  const Color(0xFFE2EAF5),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                statusInfo.progressColor,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            name,
            style: const TextStyle(
              fontSize: 19,
              height: 1.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.person_outline,
                size: 19,
                color: Color(0xFF667085),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  source.isEmpty
                      ? 'غير محدد'
                      : source,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF667085),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(
            height: 1,
            color: Color(0xFFEAECF0),
          ),

          const SizedBox(height: 16),

          const Text(
            'وصف الخطة',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF344054),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            description.isEmpty
                ? 'لا يوجد وصف للخطة'
                : description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// المنطقة والتواريخ
// ============================================================

class _PlanInformationCard
    extends StatelessWidget {
  final String region;
  final String startDate;
  final String endDate;

  const _PlanInformationCard({
    required this.region,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7EAF0),
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon:
                Icons.location_on_outlined,
            title: 'المنطقة',
            value: region.isEmpty
                ? 'جميع المناطق'
                : region,
          ),

          const Padding(
            padding:
                EdgeInsets.symmetric(
              vertical: 13,
            ),
            child: Divider(
              height: 1,
              color: Color(0xFFEAECF0),
            ),
          ),

          _InfoRow(
            icon:
                Icons.calendar_today_outlined,
            title: 'تاريخ البداية',
            value:
                _formatDate(startDate),
          ),

          const Padding(
            padding:
                EdgeInsets.symmetric(
              vertical: 13,
            ),
            child: Divider(
              height: 1,
              color: Color(0xFFEAECF0),
            ),
          ),

          _InfoRow(
            icon:
                Icons.event_available_outlined,
            title: 'تاريخ النهاية',
            value:
                _formatDate(endDate),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                const Color(0xFFF1F5FA),
            borderRadius:
                BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 21,
            color:
                const Color(0xFF0B2D5B),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 12,
                  color:
                      Color(0xFF98A2B3),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      Color(0xFF344054),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ملاحظات الخطة UC-192
// ============================================================

class _PlanNotesCard
    extends StatelessWidget {
  final String notes;

  const _PlanNotesCard({
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              const Color(0xFFF4E6BF),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons
                    .sticky_note_2_outlined,
                size: 21,
                color:
                    Color(0xFFB07800),
              ),

              SizedBox(width: 8),

              Text(
                'ملاحظات الخطة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Color(0xFF5F4700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            notes.isEmpty
                ? 'لا توجد ملاحظات على الخطة.'
                : notes,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.7,
              color: Color(0xFF78642C),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// UC-198 + UC-199
// كارد صغير يفتح شاشة الملاحظات
// ============================================================

class _WorkPlanNotesCard
    extends StatelessWidget {
  final int personalNotesCount;
  final int officialNotesCount;
  final VoidCallback onTap;

  const _WorkPlanNotesCard({
    required this.personalNotesCount,
    required this.officialNotesCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          padding:
              const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color:
                  const Color(0xFFE7EAF0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFEAF0F7),
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),
                child: const Icon(
                  Icons.forum_outlined,
                  color:
                      Color(0xFF0B2D5B),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'الملاحظات والمتابعة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF102A43),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '$personalNotesCount خاصة'
                      '  •  '
                      '$officialNotesCount في سجل الخطة',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color:
                    Color(0xFF98A2B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Goal Card
// ============================================================

class _GoalCard extends StatelessWidget {
  final WorkPlanGoalModel goal;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        goal.progress.clamp(
              0,
              100,
            ).toDouble() /
            100;

    final goalInfo =
        _getGoalTypeInfo(
      goal.type,
    );

    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(17),
        child: Container(
          padding:
              const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color:
                  const Color(0xFFE7EAF0),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration:
                        BoxDecoration(
                      color: goalInfo
                          .backgroundColor,
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Icon(
                      goalInfo.icon,
                      color:
                          goalInfo.iconColor,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          goal.title,
                          style:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight
                                    .w700,
                            color: Color(
                              0xFF102A43,
                            ),
                          ),
                        ),

                        if (goal
                            .description
                            .isNotEmpty) ...[
                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            goal.description,
                            maxLines: 2,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: Color(
                                0xFF667085,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '${goal.progress.toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          goalInfo.iconColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                child:
                    LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor:
                      const Color(
                    0xFFE8EDF3,
                  ),
                  valueColor:
                      AlwaysStoppedAnimation<
                          Color>(
                    goalInfo.iconColor,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_formatNumber(goal.achievedValue)} / '
                      '${_formatNumber(goal.targetValue)} '
                      '${goal.unit}',
                      style:
                          const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF344054),
                      ),
                    ),
                  ),

                  const Text(
                    'عرض التفاصيل',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF0B2D5B),
                    ),
                  ),

                  const SizedBox(width: 5),

                  const Icon(
                    Icons.arrow_back_ios_new,
                    size: 13,
                    color:
                        Color(0xFF0B2D5B),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyGoalsCard
    extends StatelessWidget {
  const _EmptyGoalsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color:
              const Color(0xFFE7EAF0),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.flag_outlined,
            size: 38,
            color:
                Color(0xFF98A2B3),
          ),

          SizedBox(height: 10),

          Text(
            'لا توجد أهداف في هذه الخطة',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
              color:
                  Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Status
// ============================================================

class _StatusChip extends StatelessWidget {
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
      padding:
          const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight:
              FontWeight.w700,
          color: foregroundColor,
        ),
      ),
    );
  }
}

class _StatusInfo {
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
        backgroundColor:
            Color(0xFFEEF2F6),
        foregroundColor:
            Color(0xFF475467),
        progressColor:
            Color(0xFF98A2B3),
      );

    case WorkPlanStatus.inProgress:
      return const _StatusInfo(
        title: 'قيد التنفيذ',
        backgroundColor:
            Color(0xFFE8F3FF),
        foregroundColor:
            Color(0xFF175CD3),
        progressColor:
            Color(0xFF087443),
      );

    case WorkPlanStatus.completed:
      return const _StatusInfo(
        title: 'مكتملة',
        backgroundColor:
            Color(0xFFECFDF3),
        foregroundColor:
            Color(0xFF027A48),
        progressColor:
            Color(0xFF12B76A),
      );

    case WorkPlanStatus.delayed:
      return const _StatusInfo(
        title: 'متأخرة',
        backgroundColor:
            Color(0xFFFFF4ED),
        foregroundColor:
            Color(0xFFB93815),
        progressColor:
            Color(0xFFF79009),
      );

    case WorkPlanStatus.waitingForReview:
      return const _StatusInfo(
        title: 'بانتظار المراجعة',
        backgroundColor:
            Color(0xFFFFFAEB),
        foregroundColor:
            Color(0xFFB54708),
        progressColor:
            Color(0xFFF79009),
      );

    case WorkPlanStatus.needsModification:
      return const _StatusInfo(
        title: 'بحاجة تعديل',
        backgroundColor:
            Color(0xFFFFF4ED),
        foregroundColor:
            Color(0xFFC4320A),
        progressColor:
            Color(0xFFF79009),
      );

    case WorkPlanStatus.rejected:
      return const _StatusInfo(
        title: 'مرفوضة',
        backgroundColor:
            Color(0xFFFEF3F2),
        foregroundColor:
            Color(0xFFB42318),
        progressColor:
            Color(0xFFD92D20),
      );
  }
}

// ============================================================
// Goal Type
// ============================================================

class _GoalTypeInfo {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _GoalTypeInfo({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}

_GoalTypeInfo _getGoalTypeInfo(
  WorkPlanGoalType type,
) {
  switch (type) {
    case WorkPlanGoalType.general:
      return const _GoalTypeInfo(
        icon: Icons.flag_outlined,
        iconColor:
            Color(0xFF475467),
        backgroundColor:
            Color(0xFFF2F4F7),
      );

    case WorkPlanGoalType.sales:
      return const _GoalTypeInfo(
        icon: Icons.trending_up,
        iconColor:
            Color(0xFF087443),
        backgroundColor:
            Color(0xFFECFDF3),
      );

    case WorkPlanGoalType.pharmacyCoverage:
      return const _GoalTypeInfo(
        icon:
            Icons.local_pharmacy_outlined,
        iconColor:
            Color(0xFF175CD3),
        backgroundColor:
            Color(0xFFEFF8FF),
      );

    case WorkPlanGoalType.visits:
      return const _GoalTypeInfo(
        icon:
            Icons.location_on_outlined,
        iconColor:
            Color(0xFF6941C6),
        backgroundColor:
            Color(0xFFF4F3FF),
      );

    case WorkPlanGoalType.collection:
      return const _GoalTypeInfo(
        icon: Icons.payments_outlined,
        iconColor:
            Color(0xFFB54708),
        backgroundColor:
            Color(0xFFFFFAEB),
      );
  }
}

// ============================================================
// Helpers
// ============================================================

String _formatDate(String value) {
  if (value.isEmpty) {
    return 'غير محدد';
  }

  try {
    final date =
        DateTime.parse(value);

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  } catch (_) {
    return value;
  }
}

String _formatNumber(double value) {
  if (value ==
      value.roundToDouble()) {
    final number =
        value.toInt().toString();

    final buffer =
        StringBuffer();

    for (int i = 0;
        i < number.length;
        i++) {
      if (i > 0 &&
          (number.length - i) % 3 ==
              0) {
        buffer.write(',');
      }

      buffer.write(number[i]);
    }

    return buffer.toString();
  }

  return value.toStringAsFixed(2);
}
class _ReviewReasonCard extends StatelessWidget {
  final WorkPlanStatus status;
  final String reason;

  const _ReviewReasonCard({
    required this.status,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    final bool rejected =
        status == WorkPlanStatus.rejected;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: rejected
            ? const Color(0xFFFFF1F0)
            : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: rejected
              ? const Color(0xFFFFCDD2)
              : const Color(0xFFFFE082),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                rejected
                    ? Icons.cancel_outlined
                    : Icons.edit_note_outlined,
                color: rejected
                    ? Colors.red
                    : Colors.orange.shade800,
              ),

              const SizedBox(width: 8),

              Text(
                rejected
                    ? 'سبب رفض الخطة'
                    : 'التعديلات المطلوبة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: rejected
                      ? Colors.red.shade800
                      : Colors.orange.shade900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            reason,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF344054),
            ),
          ),
        ],
      ),
    );
  }
}