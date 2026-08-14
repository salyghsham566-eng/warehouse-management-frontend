import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/update_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/update_work_plan_event.dart';
import 'package:project_2/Features/auth/bloc/update_work_plan_state.dart';

import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/update_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_details_model.dart';
import 'package:project_2/Features/auth/data/models/work_plan_goal_model.dart';

class EditWorkPlanScreen extends StatefulWidget {
  final WorkPlanDetailsModel plan;

  const EditWorkPlanScreen({
    super.key,
    required this.plan,
  });

  @override
  State<EditWorkPlanScreen> createState() =>
      _EditWorkPlanScreenState();
}

class _EditWorkPlanScreenState
    extends State<EditWorkPlanScreen> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;

  DateTime? _startDate;
  DateTime? _endDate;

  final List<_EditGoalData> _goals = [];

  @override
  void initState() {
    super.initState();

    _descriptionController =
        TextEditingController(
      text: widget.plan.description,
    );

    _notesController =
        TextEditingController(
      text: widget.plan.notes,
    );

    _startDate =
        DateTime.tryParse(
      widget.plan.startDate,
    );

    _endDate =
        DateTime.tryParse(
      widget.plan.endDate,
    );

    for (final goal in widget.plan.goals) {
      _goals.add(
        _EditGoalData.fromModel(goal),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();

    for (final goal in _goals) {
      goal.dispose();
    }

    super.dispose();
  }

  // =========================================================
  // Dates
  // =========================================================

  Future<void> _pickStartDate() async {
    final selected =
        await showDatePicker(
      context: context,
      initialDate:
          _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );

    if (selected == null) return;

    setState(() {
      _startDate = selected;

      if (_endDate != null &&
          _endDate!.isBefore(selected)) {
        _endDate = null;
      }
    });
  }

  Future<void> _pickEndDate() async {
    final selected =
        await showDatePicker(
      context: context,
      initialDate:
          _endDate ??
          _startDate ??
          DateTime.now(),
      firstDate:
          _startDate ?? DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );

    if (selected == null) return;

    setState(() {
      _endDate = selected;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'غير محدد';
    }

    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // =========================================================
  // Goals
  // =========================================================

  void _addGoal() {
    setState(() {
      _goals.add(
        _EditGoalData(),
      );
    });
  }

  void _removeGoal(int index) {
    final goal = _goals[index];

    goal.dispose();

    setState(() {
      _goals.removeAt(index);
    });
  }

  List<int> _parseIds(String value) {
    if (value.trim().isEmpty) {
      return [];
    }

    return value
        .split(',')
        .map(
          (item) =>
              int.tryParse(item.trim()),
        )
        .whereType<int>()
        .toList();
  }

  List<UpdateWorkPlanGoalRequest>
      _buildGoals() {
    return _goals.map((goal) {
      final value =
          double.tryParse(
        goal.valueController.text.trim(),
      );

      return UpdateWorkPlanGoalRequest(
        id: goal.id,
        type: goal.type,
        targetValue: value,

        productIds:
            goal.type ==
                    CreateWorkPlanGoalType
                        .products
                ? _parseIds(
                    goal.idsController.text,
                  )
                : const [],

        companyIds:
            goal.type ==
                    CreateWorkPlanGoalType
                        .companies
                ? _parseIds(
                    goal.idsController.text,
                  )
                : const [],

        pharmacyIds:
            goal.type ==
                    CreateWorkPlanGoalType
                        .pharmacies
                ? _parseIds(
                    goal.idsController.text,
                  )
                : const [],
      );
    }).toList();
  }

  // =========================================================
  // Submit
  // =========================================================

  void _saveAndResubmit() {
    FocusScope.of(context).unfocus();

    if (_descriptionController
        .text
        .trim()
        .isEmpty) {
      _showMessage(
        'يرجى إدخال وصف الخطة',
      );
      return;
    }

    if (_startDate == null ||
        _endDate == null) {
      _showMessage(
        'يرجى تحديد تاريخ البداية والنهاية',
      );
      return;
    }

    if (_endDate!.isBefore(
      _startDate!,
    )) {
      _showMessage(
        'تاريخ النهاية يجب أن يكون بعد تاريخ البداية',
      );
      return;
    }

    if (_goals.isEmpty) {
      _showMessage(
        'يجب إضافة هدف واحد على الأقل',
      );
      return;
    }

    final request =
        UpdateWorkPlanRequestModel(
      description:
          _descriptionController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      goals: _buildGoals(),
      notes: _notesController.text,
    );

    context
        .read<UpdateWorkPlanBloc>()
        .add(
          UpdateWorkPlanSubmitted(
            planId: widget.plan.id,
            request: request,
          ),
        );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor:
            const Color(0xFFF6F7FB),

        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,

          foregroundColor:
              const Color(0xFF102A43),

          title: const Text(
            'تعديل خطة العمل',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),
        ),

        body: BlocConsumer<
            UpdateWorkPlanBloc,
            UpdateWorkPlanState>(
          listener: (context, state) {
            if (state
                is UpdateWorkPlanSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );

              // نرجع true حتى تفاصيل الخطة
              // تعرف أن الخطة تغيرت
              Navigator.pop(
                context,
                true,
              );
            }

            if (state
                is UpdateWorkPlanFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }
          },

          builder: (context, state) {
            final isLoading =
                state
                    is UpdateWorkPlanLoading;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets
                            .fromLTRB(
                      16,
                      16,
                      16,
                      120,
                    ),
                    children: [
                      // =====================================
                      // سبب التعديل
                      // =====================================

                      if (widget.plan.reviewReason !=
                              null &&
                          widget.plan
                              .reviewReason!
                              .trim()
                              .isNotEmpty) ...[
                        _ModificationReasonCard(
                          reason: widget.plan
                              .reviewReason!,
                        ),

                        const SizedBox(
                          height: 18,
                        ),
                      ],

                      // =====================================
                      // اسم الخطة
                      // لا يتعدل حسب UC-203
                      // =====================================

                      const _SectionTitle(
                        icon:
                            Icons.assignment_outlined,
                        title:
                            'الخطة',
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _Card(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              'اسم الخطة',
                              style:
                                  TextStyle(
                                fontSize: 12,
                                color:
                                    Color(
                                  0xFF667085,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            Text(
                              widget.plan.name,
                              style:
                                  const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color:
                                    Color(
                                  0xFF102A43,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // =====================================
                      // الوصف
                      // =====================================

                      const _SectionTitle(
                        icon:
                            Icons.description_outlined,
                        title:
                            'وصف الخطة',
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _Card(
                        child: TextField(
                          controller:
                              _descriptionController,
                          maxLines: 4,
                          textDirection:
                              TextDirection.rtl,

                          decoration:
                              _inputDecoration(
                            label:
                                'الوصف',
                            hint:
                                'اكتب وصف الخطة',
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // =====================================
                      // التواريخ
                      // =====================================

                      const _SectionTitle(
                        icon:
                            Icons.calendar_month_outlined,
                        title:
                            'مدة الخطة',
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _DateCard(
                              title:
                                  'تاريخ البداية',
                              value:
                                  _formatDate(
                                _startDate,
                              ),
                              onTap:
                                  _pickStartDate,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: _DateCard(
                              title:
                                  'تاريخ النهاية',
                              value:
                                  _formatDate(
                                _endDate,
                              ),
                              onTap:
                                  _pickEndDate,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // =====================================
                      // الأهداف
                      // =====================================

                      Row(
                        children: [
                          const Expanded(
                            child:
                                _SectionTitle(
                              icon:
                                  Icons.flag_outlined,
                              title:
                                  'أهداف الخطة',
                            ),
                          ),

                          TextButton.icon(
                            onPressed:
                                _addGoal,
                            icon:
                                const Icon(
                              Icons.add,
                            ),
                            label:
                                const Text(
                              'إضافة هدف',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      if (_goals.isEmpty)
                        _EmptyGoalsCard(
                          onAdd:
                              _addGoal,
                        )
                      else
                        ...List.generate(
                          _goals.length,
                          (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom:
                                    12,
                              ),
                              child:
                                  _EditGoalCard(
                                index:
                                    index,
                                data:
                                    _goals[
                                        index],
                                onDelete:
                                    () {
                                  _removeGoal(
                                    index,
                                  );
                                },
                                onChanged:
                                    () {
                                  setState(
                                    () {},
                                  );
                                },
                              ),
                            );
                          },
                        ),

                      const SizedBox(
                        height: 10,
                      ),

                      // =====================================
                      // ملاحظات
                      // =====================================

                      const _SectionTitle(
                        icon:
                            Icons.notes_outlined,
                        title:
                            'الملاحظات',
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      _Card(
                        child: TextField(
                          controller:
                              _notesController,
                          maxLines: 4,

                          decoration:
                              _inputDecoration(
                            label:
                                'ملاحظات',
                            hint:
                                'أضف ملاحظات الخطة',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===========================================
                // Button
                // ===========================================

                Container(
                  padding:
                      const EdgeInsets
                          .fromLTRB(
                    16,
                    12,
                    16,
                    16,
                  ),

                  decoration:
                      const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color:
                            Color(
                          0xFFE3E7EF,
                        ),
                      ),
                    ),
                  ),

                  child: SafeArea(
                    top: false,

                    child: SizedBox(
                      width:
                          double.infinity,

                      child:
                          ElevatedButton.icon(
                        onPressed:
                            isLoading
                                ? null
                                : _saveAndResubmit,

                        icon: isLoading
                            ? const SizedBox(
                                width:
                                    20,
                                height:
                                    20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons
                                    .send_outlined,
                              ),

                        label: Text(
                          isLoading
                              ? 'جارٍ الحفظ...'
                              : 'حفظ وإعادة الإرسال',
                        ),

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF12355B,
                          ),

                          foregroundColor:
                              Colors.white,

                          elevation: 0,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical:
                                15,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ===========================================================
// Goal Data
// ===========================================================

class _EditGoalData {
  final int? id;

  CreateWorkPlanGoalType type;

  final TextEditingController
      valueController;

  final TextEditingController
      idsController;

  _EditGoalData({
    this.id,
    this.type =
        CreateWorkPlanGoalType.sales,
    String value = '',
    String ids = '',
  })  : valueController =
            TextEditingController(
          text: value,
        ),
        idsController =
            TextEditingController(
          text: ids,
        );

  factory _EditGoalData.fromModel(
    WorkPlanGoalModel goal,
  ) {
    CreateWorkPlanGoalType type;

    String ids = '';

    switch (goal.type) {
      case WorkPlanGoalType.sales:
        type =
            CreateWorkPlanGoalType.sales;
        break;

      case WorkPlanGoalType.collection:
        type =
            CreateWorkPlanGoalType.collection;
        break;

      case WorkPlanGoalType.pharmacyCoverage:
        type = CreateWorkPlanGoalType
            .pharmacyCoverage;
        break;

      case WorkPlanGoalType.visits:
        type =
            CreateWorkPlanGoalType.visits;
        break;

      case WorkPlanGoalType.general:
        // بالـ Mock نعرف النوع من عنوان الهدف
        if (goal.title.contains('أصناف')) {
          type =
              CreateWorkPlanGoalType.products;
        } else if (goal.title
            .contains('شركات')) {
          type =
              CreateWorkPlanGoalType.companies;
        } else if (goal.title
            .contains('صيدليات')) {
          type =
              CreateWorkPlanGoalType.pharmacies;
        } else {
          type =
              CreateWorkPlanGoalType.products;
        }

        ids =
            _extractIds(
          goal.description,
        );

        break;
    }

    return _EditGoalData(
      id: goal.id,
      type: type,

      value: goal.type ==
              WorkPlanGoalType.general
          ? ''
          : _cleanNumber(
              goal.targetValue,
            ),

      ids: ids,
    );
  }

  static String _cleanNumber(
    double value,
  ) {
    if (value ==
        value.truncateToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  static String _extractIds(
    String description,
  ) {
    final matches =
        RegExp(r'\d+')
            .allMatches(description)
            .map(
              (match) =>
                  match.group(0),
            )
            .whereType<String>()
            .toList();

    return matches.join(', ');
  }

  void dispose() {
    valueController.dispose();
    idsController.dispose();
  }
}

// ===========================================================
// Goal Card
// ===========================================================

class _EditGoalCard
    extends StatelessWidget {
  final int index;
  final _EditGoalData data;

  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const _EditGoalCard({
    required this.index,
    required this.data,
    required this.onDelete,
    required this.onChanged,
  });

  bool get _usesValue {
    return data.type ==
            CreateWorkPlanGoalType.sales ||
        data.type ==
            CreateWorkPlanGoalType.collection ||
        data.type ==
            CreateWorkPlanGoalType
                .pharmacyCoverage ||
        data.type ==
            CreateWorkPlanGoalType.visits;
  }

  bool get _usesIds {
    return data.type ==
            CreateWorkPlanGoalType.products ||
        data.type ==
            CreateWorkPlanGoalType.companies ||
        data.type ==
            CreateWorkPlanGoalType.pharmacies;
  }

  String get _valueLabel {
    switch (data.type) {
      case CreateWorkPlanGoalType.sales:
        return 'قيمة المبيعات';

      case CreateWorkPlanGoalType.collection:
        return 'قيمة التحصيل';

      case CreateWorkPlanGoalType.pharmacyCoverage:
        return 'عدد الصيدليات';

      case CreateWorkPlanGoalType.visits:
        return 'عدد الزيارات';

      default:
        return '';
    }
  }

  String get _idsLabel {
    switch (data.type) {
      case CreateWorkPlanGoalType.products:
        return 'الأصناف';

      case CreateWorkPlanGoalType.companies:
        return 'الشركات';

      case CreateWorkPlanGoalType.pharmacies:
        return 'الصيدليات';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment:
                    Alignment.center,

                decoration:
                    const BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color:
                      Color(
                    0xFFEAF1FA,
                  ),
                ),

                child: Text(
                  '${index + 1}',
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(
                      0xFF12355B,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              const Expanded(
                child: Text(
                  'هدف الخطة',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              IconButton(
                onPressed:
                    onDelete,
                icon:
                    const Icon(
                  Icons.delete_outline,
                  color:
                      Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          DropdownButtonFormField<
              CreateWorkPlanGoalType>(
            value: data.type,

            decoration:
                _inputDecoration(
              label:
                  'نوع الهدف',
            ),

            items: const [
              DropdownMenuItem(
                value:
                    CreateWorkPlanGoalType
                        .sales,
                child:
                    Text('مبيعات'),
              ),

              DropdownMenuItem(
                value:
                    CreateWorkPlanGoalType
                        .collection,
                child:
                    Text('تحصيل'),
              ),

              DropdownMenuItem(
                value:
                    CreateWorkPlanGoalType
                        .pharmacyCoverage,
                child:
                    Text(
                  'تغطية صيدليات',
                ),
              ),

              DropdownMenuItem(
                value:
                    CreateWorkPlanGoalType
                        .visits,
                child:
                    Text('زيارات'),
              ),

              DropdownMenuItem(
                value:
                    CreateWorkPlanGoalType
                        .products,
                child:
                    Text(
                  'أصناف محددة',
                ),
              ),

              DropdownMenuItem(
                value:
                    CreateWorkPlanGoalType
                        .companies,
                child:
                    Text(
                  'شركات محددة',
                ),
              ),

              DropdownMenuItem(
                value:
                    CreateWorkPlanGoalType
                        .pharmacies,
                child:
                    Text(
                  'صيدليات محددة',
                ),
              ),
            ],

            onChanged: (value) {
              if (value == null) return;

              data.type = value;

              data.valueController.clear();
              data.idsController.clear();

              onChanged();
            },
          ),

          if (_usesValue) ...[
            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  data.valueController,

              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),

              decoration:
                  _inputDecoration(
                label:
                    _valueLabel,
                hint:
                    'أدخل القيمة الجديدة',
              ),
            ),
          ],

          if (_usesIds) ...[
            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  data.idsController,

              decoration:
                  _inputDecoration(
                label:
                    _idsLabel,
                hint:
                    'مثال: 1, 4, 8',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ===========================================================
// Reason Card
// ===========================================================

class _ModificationReasonCard
    extends StatelessWidget {
  final String reason;

  const _ModificationReasonCard({
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
            const Color(0xFFFFF8E1),

        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color:
              const Color(0xFFFFE082),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.edit_note_outlined,
                color:
                    Color(0xFFF57C00),
              ),

              SizedBox(width: 8),

              Text(
                'التعديلات المطلوبة من المشرف',
                style:
                    TextStyle(
                  fontWeight:
                      FontWeight.w800,
                  color:
                      Color(
                    0xFFE65100,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            reason,
            style:
                const TextStyle(
              height: 1.6,
              color:
                  Color(
                0xFF344054,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// Common UI
// ===========================================================

class _SectionTitle
    extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color:
              const Color(
            0xFF12355B,
          ),
          size: 21,
        ),

        const SizedBox(
          width: 8,
        ),

        Text(
          title,
          style:
              const TextStyle(
            fontSize: 17,
            fontWeight:
                FontWeight.w800,
            color:
                Color(
              0xFF102A43,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color:
              const Color(
            0xFFE3E7EF,
          ),
        ),
      ),

      child: child,
    );
  }
}

class _DateCard
    extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _DateCard({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(14),

      child: Container(
        padding:
            const EdgeInsets.all(14),

        decoration:
            BoxDecoration(
          color:
              Colors.white,

          borderRadius:
              BorderRadius.circular(14),

          border:
              Border.all(
            color:
                const Color(
              0xFFE3E7EF,
            ),
          ),
        ),

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
                    Color(
                  0xFF667085,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Row(
              children: [
                const Icon(
                  Icons
                      .calendar_today_outlined,
                  size: 18,
                  color:
                      Color(
                    0xFF12355B,
                  ),
                ),

                const SizedBox(
                  width: 7,
                ),

                Expanded(
                  child: Text(
                    value,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w700,
                      color:
                          Color(
                        0xFF102A43,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGoalsCard
    extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyGoalsCard({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          const Text(
            'لا توجد أهداف',
            style:
                TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          OutlinedButton.icon(
            onPressed: onAdd,
            icon:
                const Icon(
              Icons.add,
            ),
            label:
                const Text(
              'إضافة هدف',
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  String? hint,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,

    filled: true,

    fillColor:
        const Color(
      0xFFF9FAFC,
    ),

    border:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(
        12,
      ),
      borderSide:
          BorderSide.none,
    ),

    enabledBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(
        12,
      ),

      borderSide:
          const BorderSide(
        color:
            Color(
          0xFFE3E7EF,
        ),
      ),
    ),

    focusedBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(
        12,
      ),

      borderSide:
          const BorderSide(
        color:
            Color(
          0xFF12355B,
        ),
      ),
    ),
  );
}