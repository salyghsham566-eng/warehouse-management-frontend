import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/work_plan_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_state.dart';

import 'package:project_2/Features/auth/bloc/work_plan_personal_note_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_personal_note_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_personal_note_state.dart';

import 'package:project_2/Features/auth/bloc/work_plan_official_note_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_official_note_event.dart';
import 'package:project_2/Features/auth/bloc/work_plan_official_note_state.dart';

import 'package:project_2/Features/auth/data/models/work_plan_personal_note_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_official_note_model.dart';

class WorkPlanNotesScreen extends StatefulWidget {
  final int planId;

  const WorkPlanNotesScreen({
    super.key,
    required this.planId,
  });

  @override
  State<WorkPlanNotesScreen> createState() =>
      _WorkPlanNotesScreenState();
}

class _WorkPlanNotesScreenState
    extends State<WorkPlanNotesScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocListener(
        listeners: [
          // ==================================================
          // UC-198
          // ==================================================

          BlocListener<
              WorkPlanPersonalNoteBloc,
              WorkPlanPersonalNoteState>(
            listener: (context, state) {
              if (state
                  is WorkPlanPersonalNoteSuccess) {
                context
                    .read<WorkPlanDetailsBloc>()
                    .add(
                      AddPersonalNoteToDetailsEvent(
                        note: state.note,
                      ),
                    );

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تمت إضافة الملاحظة الخاصة',
                    ),
                  ),
                );
              }

              if (state
                  is WorkPlanPersonalNoteFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content:
                        Text(state.message),
                  ),
                );
              }
            },
          ),

          // ==================================================
          // UC-199
          // ==================================================

          BlocListener<
              WorkPlanOfficialNoteBloc,
              WorkPlanOfficialNoteState>(
            listener: (context, state) {
              if (state
                  is WorkPlanOfficialNoteSuccess) {
                context
                    .read<WorkPlanDetailsBloc>()
                    .add(
                      AddOfficialNoteToDetailsEvent(
                        note: state.note,
                      ),
                    );

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تمت إضافة الرد أو الملاحظة',
                    ),
                  ),
                );
              }

              if (state
                  is WorkPlanOfficialNoteFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content:
                        Text(state.message),
                  ),
                );
              }
            },
          ),
        ],

        child: Scaffold(
          backgroundColor:
              const Color(0xFFF6F7FB),

          appBar: AppBar(
            backgroundColor:
                Colors.white,
            surfaceTintColor:
                Colors.white,
            elevation: 0,
            centerTitle: true,
            foregroundColor:
                const Color(0xFF102A43),
            title: const Text(
              'الملاحظات والمتابعة',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w800,
                color:
                    Color(0xFF102A43),
              ),
            ),
          ),

          body: BlocBuilder<
              WorkPlanDetailsBloc,
              WorkPlanDetailsState>(
            builder: (context, state) {
              if (state
                  is WorkPlanDetailsLoading) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              if (state
                  is WorkPlanDetailsFailure) {
                return _ErrorView(
                  message: state.message,
                  onRetry: () {
                    _reloadPlan(context);
                  },
                );
              }

              if (state
                  is WorkPlanDetailsLoaded) {
                final plan = state.plan;

                return Column(
                  children: [
                    // ========================================
                    // اسم الخطة
                    // ========================================

                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        14,
                      ),
                      child: Text(
                        plan.name,
                        textAlign:
                            TextAlign.center,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          fontSize: 13,
                          color:
                              Color(0xFF667085),
                        ),
                      ),
                    ),

                    // ========================================
                    // Tabs
                    // ========================================

                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        12,
                      ),
                      child: _NotesTabs(
                        selectedTab:
                            _selectedTab,
                        personalCount: plan
                            .personalNotes.length,
                        officialCount: plan
                            .officialNotes.length,
                        onChanged:
                            (index) {
                          setState(() {
                            _selectedTab =
                                index;
                          });
                        },
                      ),
                    ),

                    // ========================================
                    // Content
                    // ========================================

                    Expanded(
                      child:
                          _selectedTab == 0
                              ? _PersonalNotesView(
                                  notes: plan
                                      .personalNotes,
                                )
                              : _OfficialNotesView(
                                  notes: plan
                                      .officialNotes,
                                ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),

          // ==================================================
          // إضافة
          // ==================================================

          floatingActionButton:
              FloatingActionButton.extended(
            onPressed: () {
              if (_selectedTab == 0) {
                _showAddPersonalNoteDialog(
                  context,
                  widget.planId,
                );
              } else {
                _showAddOfficialNoteDialog(
                  context,
                  widget.planId,
                );
              }
            },
            icon: Icon(
              _selectedTab == 0
                  ? Icons.add
                  : Icons
                      .add_comment_outlined,
            ),
            label: Text(
              _selectedTab == 0
                  ? 'إضافة ملاحظة خاصة'
                  : 'إضافة للسجل',
            ),
          ),
        ),
      ),
    );
  }

  void _reloadPlan(
    BuildContext context,
  ) {
    context
        .read<WorkPlanDetailsBloc>()
        .add(
          LoadWorkPlanDetailsEvent(
            planId: widget.planId,
          ),
        );
  }
}

// ============================================================
// Tabs
// ============================================================

class _NotesTabs extends StatelessWidget {
  final int selectedTab;
  final int personalCount;
  final int officialCount;
  final ValueChanged<int> onChanged;

  const _NotesTabs({
    required this.selectedTab,
    required this.personalCount,
    required this.officialCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:
            const Color(0xFFE9EDF5),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title:
                  'ملاحظاتي الخاصة',
              count:
                  personalCount,
              selected:
                  selectedTab == 0,
              icon:
                  Icons.lock_outline,
              onTap: () {
                onChanged(0);
              },
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: _TabButton(
              title:
                  'سجل الخطة',
              count:
                  officialCount,
              selected:
                  selectedTab == 1,
              icon:
                  Icons.forum_outlined,
              onTap: () {
                onChanged(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final int count;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.count,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(10),
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05),
                    blurRadius: 8,
                    offset:
                        const Offset(
                      0,
                      2,
                    ),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: selected
                  ? const Color(
                      0xFF0B2D5B,
                    )
                  : const Color(
                      0xFF667085,
                    ),
            ),

            const SizedBox(width: 5),

            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: selected
                      ? const Color(
                          0xFF0B2D5B,
                        )
                      : const Color(
                          0xFF667085,
                        ),
                ),
              ),
            ),

            const SizedBox(width: 5),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 2,
              ),
              decoration:
                  BoxDecoration(
                color: selected
                    ? const Color(
                        0xFFE6EFFA,
                      )
                    : const Color(
                        0xFFD9DEE8,
                      ),
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              child: Text(
                '$count',
                style:
                    const TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      Color(0xFF0B2D5B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// UC-198
// ============================================================

class _PersonalNotesView
    extends StatelessWidget {
  final List<WorkPlanPersonalNoteModel>
      notes;

  const _PersonalNotesView({
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const _EmptyNotesView(
        icon: Icons.lock_outline,
        title:
            'لا توجد ملاحظات خاصة',
        subtitle:
            'أضف ملاحظات شخصية لمساعدتك على متابعة الخطة.',
      );
    }

    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        100,
      ),
      itemCount: notes.length,
      separatorBuilder:
          (_, __) =>
              const SizedBox(
        height: 10,
      ),
      itemBuilder:
          (context, index) {
        final note =
            notes[index];

        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            border: Border.all(
              color:
                  const Color(
                0xFFE7EAF0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFEAF0F7,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        11,
                      ),
                    ),
                    child:
                        const Icon(
                      Icons
                          .lock_outline,
                      size: 20,
                      color:
                          Color(
                        0xFF0B2D5B,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  const Expanded(
                    child: Text(
                      'ملاحظة خاصة',
                      style:
                          TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight
                                .w700,
                        color:
                            Color(
                          0xFF344054,
                        ),
                      ),
                    ),
                  ),

                  Text(
                    _formatNoteDate(
                      note.createdAt,
                    ),
                    style:
                        const TextStyle(
                      fontSize: 10.5,
                      color:
                          Color(
                        0xFF98A2B3,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                note.text,
                style:
                    const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color:
                      Color(0xFF344054),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// UC-199
// ============================================================

class _OfficialNotesView
    extends StatelessWidget {
  final List<
          WorkPlanOfficialNoteModel>
      notes;

  const _OfficialNotesView({
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const _EmptyNotesView(
        icon:
            Icons.forum_outlined,
        title:
            'سجل الخطة فارغ',
        subtitle:
            'لا توجد ملاحظات أو ردود رسمية حتى الآن.',
      );
    }

    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        100,
      ),
      itemCount:
          notes.length,
      separatorBuilder:
          (_, __) =>
              const SizedBox(
        height: 10,
      ),
      itemBuilder:
          (context, index) {
        final note =
            notes[index];

        final isReply =
            note.type ==
                WorkPlanOfficialNoteType
                    .reply;

        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            border: Border.all(
              color:
                  const Color(
                0xFFE7EAF0,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor:
                        const Color(
                      0xFFEAF0F7,
                    ),
                    child:
                        const Icon(
                      Icons
                          .person_outline,
                      size: 20,
                      color:
                          Color(
                        0xFF0B2D5B,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          note.authorName
                                  .isEmpty
                              ? 'غير محدد'
                              : note
                                  .authorName,
                          style:
                              const TextStyle(
                            fontSize:
                                13.5,
                            fontWeight:
                                FontWeight
                                    .w700,
                            color:
                                Color(
                              0xFF344054,
                            ),
                          ),
                        ),

                        if (note
                            .authorRole
                            .isNotEmpty)
                          Text(
                            note
                                .authorRole,
                            style:
                                const TextStyle(
                              fontSize:
                                  11,
                              color:
                                  Color(
                                0xFF98A2B3,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration:
                        BoxDecoration(
                      color: isReply
                          ? const Color(
                              0xFFEFF8FF,
                            )
                          : const Color(
                              0xFFFFFAEB,
                            ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),
                    child: Text(
                      isReply
                          ? 'رد'
                          : 'ملاحظة',
                      style:
                          TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight
                                .w700,
                        color: isReply
                            ? const Color(
                                0xFF175CD3,
                              )
                            : const Color(
                                0xFFB54708,
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                note.text,
                style:
                    const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color:
                      Color(0xFF344054),
                ),
              ),

              if (note
                  .createdAt
                  .isNotEmpty) ...[
                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .schedule_outlined,
                      size: 14,
                      color:
                          Color(
                        0xFF98A2B3,
                      ),
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    Text(
                      _formatNoteDate(
                        note.createdAt,
                      ),
                      style:
                          const TextStyle(
                        fontSize: 11,
                        color:
                            Color(
                          0xFF98A2B3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// Empty State
// ============================================================

class _EmptyNotesView
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyNotesView({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFEAF0F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color:
                    const Color(
                  0xFF0B2D5B,
                ),
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              title,
              style:
                  const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF102A43),
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              subtitle,
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                fontSize: 13,
                height: 1.6,
                color:
                    Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Error
// ============================================================

class _ErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color:
                  Colors.redAccent,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton.icon(
              onPressed:
                  onRetry,
              icon:
                  const Icon(
                Icons.refresh,
              ),
              label:
                  const Text(
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
// UC-198 Dialog
// ============================================================

void _showAddPersonalNoteDialog(
  BuildContext parentContext,
  int planId,
) {
  final controller =
      TextEditingController();

  final noteBloc =
      parentContext
          .read<
              WorkPlanPersonalNoteBloc>();

  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return Directionality(
       
        textDirection:
            TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'إضافة ملاحظة خاصة',
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets
                        .all(10),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF2F4F7,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(10),
                ),
                child:
                    const Row(
                  children: [
                    Icon(
                      Icons
                          .lock_outline,
                      size: 18,
                      color:
                          Color(
                        0xFF667085,
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Text(
                        'هذه الملاحظة شخصية ولا تعتبر رداً رسمياً على الخطة.',
                        style:
                            TextStyle(
                          fontSize:
                              11.5,
                          height:
                              1.5,
                          color:
                              Color(
                            0xFF667085,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              TextField(
                controller:
                    controller,
                minLines: 3,
                maxLines: 5,
                textDirection:
                    TextDirection.rtl,
                textAlign:
                    TextAlign.right,
                autofocus: true,
                decoration:
                    const InputDecoration(
                  hintText:
                      'اكتب ملاحظتك للمتابعة...',
                  border:
                      OutlineInputBorder(),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                'إلغاء',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final text =
                    controller.text
                        .trim();

                if (text.isEmpty) {
                  ScaffoldMessenger
                          .of(
                    parentContext,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'يرجى كتابة الملاحظة',
                      ),
                    ),
                  );

                  return;
                }

                noteBloc.add(
                  AddWorkPlanPersonalNoteEvent(
                    planId:
                        planId,
                    text: text,
                  ),
                );

                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                'حفظ',
              ),
            ),
          ],
        ),
      );
    },
  );
}

// ============================================================
// UC-199 Dialog
// ============================================================

void _showAddOfficialNoteDialog(
  BuildContext parentContext,
  int planId,
) {
  final controller =
      TextEditingController();

  WorkPlanOfficialNoteType
      selectedType =
      WorkPlanOfficialNoteType.note;

  final noteBloc =
      parentContext
          .read<
              WorkPlanOfficialNoteBloc>();

  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder:
            (context, setDialogState) {
          return Directionality(
            textDirection:
                TextDirection.rtl,
            child: AlertDialog(
              title: const Text(
                'إضافة إلى سجل الخطة',
              ),

              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    'نوع الإضافة',
                    style:
                        TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  DropdownButtonFormField<
                      WorkPlanOfficialNoteType>(
                    value:
                        selectedType,
                    decoration:
                        const InputDecoration(
                      border:
                          OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value:
                            WorkPlanOfficialNoteType
                                .note,
                        child:
                            Text(
                          'ملاحظة',
                        ),
                      ),

                      DropdownMenuItem(
                        value:
                            WorkPlanOfficialNoteType
                                .reply,
                        child:
                            Text(
                          'رد',
                        ),
                      ),
                    ],
                    onChanged:
                        (value) {
                      if (value ==
                          null) {
                        return;
                      }

                      setDialogState(
                        () {
                          selectedType =
                              value;
                        },
                      );
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Text(
                    'النص',
                    style:
                        TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextField(
                    controller:
                        controller,
                    minLines: 3,
                    maxLines: 5,
                    textDirection:
                        TextDirection.rtl,
                    textAlign:
                        TextAlign.right,
                    autofocus: true,
                    decoration:
                        const InputDecoration(
                      hintText:
                          'اكتب الرد أو الملاحظة...',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text(
                    'إلغاء',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    final text =
                        controller.text
                            .trim();

                    if (text.isEmpty) {
                      ScaffoldMessenger
                              .of(
                        parentContext,
                      ).showSnackBar(
                        const SnackBar(
                          content:
                              Text(
                            'يرجى كتابة النص',
                          ),
                        ),
                      );

                      return;
                    }

                    noteBloc.add(
                      AddWorkPlanOfficialNoteEvent(
                        planId:
                            planId,
                        text: text,
                        type:
                            selectedType,
                      ),
                    );

                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child:
                      const Text(
                    'إرسال',
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// ============================================================
// Date
// ============================================================

String _formatNoteDate(
  String value,
) {
  if (value.isEmpty) {
    return '';
  }

  try {
    final date =
        DateTime.parse(value)
            .toLocal();

    final day =
        date.day
            .toString()
            .padLeft(
              2,
              '0',
            );

    final month =
        date.month
            .toString()
            .padLeft(
              2,
              '0',
            );

    final hour =
        date.hour
            .toString()
            .padLeft(
              2,
              '0',
            );

    final minute =
        date.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$day/$month/${date.year} - $hour:$minute';
  } catch (_) {
    return value;
  }
}