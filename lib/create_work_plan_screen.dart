import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/create_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/create_work_plan_event.dart';
import 'package:project_2/Features/auth/bloc/create_work_plan_state.dart';

import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';

class CreateWorkPlanScreen extends StatefulWidget {
  const CreateWorkPlanScreen({
    super.key,
  });

  @override
  State<CreateWorkPlanScreen> createState() =>
      _CreateWorkPlanScreenState();
}

class _CreateWorkPlanScreenState
    extends State<CreateWorkPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  final _regionController =
      TextEditingController();

  final _notesController =
      TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final List<_GoalFormData> _goals = [];

  // =========================================================
  // Dispose
  // =========================================================

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _regionController.dispose();
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
    final result = await showDatePicker(
      context: context,
      initialDate:
          _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );

    if (result == null) return;

    setState(() {
      _startDate = result;

      if (_endDate != null &&
          _endDate!.isBefore(result)) {
        _endDate = null;
      }
    });
  }

  Future<void> _pickEndDate() async {
    final result = await showDatePicker(
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

    if (result == null) return;

    setState(() {
      _endDate = result;
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
        _GoalFormData(),
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
          (item) => int.tryParse(
            item.trim(),
          ),
        )
        .whereType<int>()
        .toList();
  }

  List<CreateWorkPlanGoalRequest>
      _buildGoals() {
    return _goals.map((goal) {
      final targetValue =
          double.tryParse(
        goal.valueController.text.trim(),
      );

     return CreateWorkPlanGoalRequest(
  type: goal.type,

  targetValue: targetValue,

  productIds:
      goal.type ==
              CreateWorkPlanGoalType.products
          ? _parseIds(
              goal.idsController.text,
            )
          : const [],

  companyIds:
      goal.type ==
              CreateWorkPlanGoalType.companies
          ? _parseIds(
              goal.idsController.text,
            )
          : const [],

  pharmacyIds:
      goal.type ==
              CreateWorkPlanGoalType.pharmacies
          ? _parseIds(
              goal.idsController.text,
            )
          : const [],
);
    }).toList();
  }

  // =========================================================
  // Request
  // =========================================================

  void _submit(
    WorkPlanCreateAction action,
  ) {
    FocusScope.of(context).unfocus();

    final request =
        CreateWorkPlanRequestModel(
      name: _nameController.text,
      description:
          _descriptionController.text,
      startDate: _startDate,
      endDate: _endDate,

      // مؤقتاً حتى نربط قائمة المناطق
      regionId: int.tryParse(
        _regionController.text.trim(),
      ),

      goals: _buildGoals(),

      notes: _notesController.text,

      action: action,
    );

    context
        .read<CreateWorkPlanBloc>()
        .add(
          CreateWorkPlanSubmitted(
            request: request,
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
            'إنشاء خطة عمل',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),
        ),

        body: BlocConsumer<
            CreateWorkPlanBloc,
            CreateWorkPlanState>(
          listener: (context, state) {
            if (state
                is CreateWorkPlanSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    state.response.message,
                  ),
                ),
              );

              Navigator.pop(
                context,
                true,
              );
            }

            if (state
                is CreateWorkPlanFailure) {
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
                    is CreateWorkPlanLoading;

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding:
                          const EdgeInsets
                              .fromLTRB(
                        16,
                        18,
                        16,
                        120,
                      ),
                      children: [
                        // ===================================
                        // Basic information
                        // ===================================

                        _SectionTitle(
                          icon:
                              Icons.description_outlined,
                          title:
                              'معلومات الخطة',
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        _FormCard(
                          child: Column(
                            children: [
                              _AppTextField(
                                controller:
                                    _nameController,
                                label:
                                    'اسم الخطة',
                                hint:
                                    'مثال: خطة مبيعات شهر آب',
                                required:
                                    true,
                              ),

                              const SizedBox(
                                height: 14,
                              ),

                              _AppTextField(
                                controller:
                                    _descriptionController,
                                label:
                                    'وصف الخطة',
                                hint:
                                    'اكتب وصفاً مختصراً للخطة...',
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // ===================================
                        // Dates
                        // ===================================

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
                              child:
                                  _DateCard(
                                title:
                                    'تاريخ البداية',
                                date:
                                    _formatDate(
                                  _startDate,
                                ),
                                selected:
                                    _startDate !=
                                        null,
                                onTap:
                                    _pickStartDate,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(
                              child:
                                  _DateCard(
                                title:
                                    'تاريخ النهاية',
                                date:
                                    _formatDate(
                                  _endDate,
                                ),
                                selected:
                                    _endDate !=
                                        null,
                                onTap:
                                    _pickEndDate,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // ===================================
                        // Region
                        // ===================================

                        const _SectionTitle(
                          icon:
                              Icons.location_on_outlined,
                          title:
                              'المنطقة',
                          optional: true,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        _FormCard(
                          child:
                              _AppTextField(
                            controller:
                                _regionController,
                            label:
                                'المنطقة',
                            hint:
                                'معرف المنطقة مؤقتاً',
                            keyboardType:
                                TextInputType
                                    .number,
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        // ===================================
                        // Goals
                        // ===================================

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
                                    _GoalCard(
                                  index:
                                      index,
                                  data:
                                      _goals[
                                          index],
                                  onChanged:
                                      () {
                                    setState(
                                      () {},
                                    );
                                  },
                                  onDelete:
                                      () {
                                    _removeGoal(
                                      index,
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                        const SizedBox(
                          height: 10,
                        ),

                        // ===================================
                        // Notes
                        // ===================================

                        const _SectionTitle(
                          icon:
                              Icons.notes_outlined,
                          title:
                              'ملاحظات',
                          optional: true,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        _FormCard(
                          child:
                              _AppTextField(
                            controller:
                                _notesController,
                            label:
                                'ملاحظات إضافية',
                            hint:
                                'أضف أي ملاحظات متعلقة بالخطة...',
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =========================================
                  // Bottom actions
                  // =========================================

                  _BottomActions(
                    isLoading:
                        isLoading,

                    onSaveDraft:
                        () => _submit(
                      WorkPlanCreateAction
                          .draft,
                    ),

                    onSubmit:
                        () => _submit(
                      WorkPlanCreateAction
                          .submit,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===========================================================
// Goal temporary data
// ===========================================================

class _GoalFormData {
  CreateWorkPlanGoalType type =
      CreateWorkPlanGoalType.sales;

  final valueController =
      TextEditingController();

  final idsController =
      TextEditingController();

  void dispose() {
    valueController.dispose();
    idsController.dispose();
  }
}

// ===========================================================
// Section title
// ===========================================================

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool optional;

  const _SectionTitle({
    required this.icon,
    required this.title,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 21,
          color:
              const Color(0xFF12355B),
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF102A43),
          ),
        ),

        if (optional) ...[
          const SizedBox(width: 7),
          const Text(
            '(اختياري)',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7A869A),
            ),
          ),
        ],
      ],
    );
  }
}

// ===========================================================
// Form card
// ===========================================================

class _FormCard extends StatelessWidget {
  final Widget child;

  const _FormCard({
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
              const Color(0xFFE3E7EF),
        ),
      ),
      child: child,
    );
  }
}

// ===========================================================
// Text field
// ===========================================================

class _AppTextField
    extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;

  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textDirection:
          TextDirection.rtl,

      decoration: InputDecoration(
        labelText:
            required
                ? '$label *'
                : label,

        hintText: hint,

        alignLabelWithHint:
            maxLines > 1,

        filled: true,
        fillColor:
            const Color(0xFFF9FAFC),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide.none,
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
                Color(0xFFE3E7EF),
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
                Color(0xFF12355B),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// Date card
// ===========================================================

class _DateCard
    extends StatelessWidget {
  final String title;
  final String date;
  final bool selected;
  final VoidCallback onTap;

  const _DateCard({
    required this.title,
    required this.date,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color:
                const Color(0xFFE3E7EF),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color:
                    Color(0xFF7A869A),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color:
                      Color(0xFF12355B),
                ),

                const SizedBox(
                  width: 7,
                ),

                Expanded(
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w700,
                      color: selected
                          ? const Color(
                              0xFF102A43,
                            )
                          : const Color(
                              0xFF9BA5B4,
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

// ===========================================================
// Empty goals
// ===========================================================

class _EmptyGoalsCard
    extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyGoalsCard({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color(0xFFE3E7EF),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration:
                const BoxDecoration(
              color:
                  Color(0xFFEAF1FA),
              shape:
                  BoxShape.circle,
            ),
            child: const Icon(
              Icons.flag_outlined,
              color:
                  Color(0xFF12355B),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          const Text(
            'لم تتم إضافة أهداف بعد',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF102A43),
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          const Text(
            'يجب إضافة هدف واحد على الأقل عند إرسال الخطة للمراجعة',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color:
                  Color(0xFF7A869A),
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          OutlinedButton.icon(
            onPressed: onAdd,
            icon:
                const Icon(Icons.add),
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

// ===========================================================
// Goal Card
// ===========================================================

class _GoalCard extends StatelessWidget {
  final int index;
  final _GoalFormData data;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const _GoalCard({
    required this.index,
    required this.data,
    required this.onChanged,
    required this.onDelete,
  });

  bool get _usesNumericValue {
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
        return 'قيمة المبيعات المستهدفة';

      case CreateWorkPlanGoalType.collection:
        return 'قيمة التحصيل المستهدفة';

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
        return 'الأصناف المحددة';

      case CreateWorkPlanGoalType.companies:
        return 'الشركات المحددة';

      case CreateWorkPlanGoalType.pharmacies:
        return 'الصيدليات المحددة';

      default:
        return '';
    }
  }

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
              const Color(0xFFE3E7EF),
        ),
      ),
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
                  color:
                      Color(0xFFEAF1FA),
                  shape:
                      BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style:
                      const TextStyle(
                    color:
                        Color(0xFF12355B),
                    fontWeight:
                        FontWeight.bold,
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
                    color:
                        Color(0xFF102A43),
                  ),
                ),
              ),

              IconButton(
                tooltip:
                    'حذف الهدف',
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
                InputDecoration(
              labelText:
                  'نوع الهدف',

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
              if (value == null) {
                return;
              }

              data.type = value;

              data.valueController
                  .clear();

              data.idsController
                  .clear();

              onChanged();
            },
          ),

          if (_usesNumericValue) ...[
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
                  InputDecoration(
                labelText:
                    _valueLabel,

                hintText:
                    'أدخل القيمة المستهدفة',

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

              keyboardType:
                  TextInputType.text,

              decoration:
                  InputDecoration(
                labelText:
                    _idsLabel,

                hintText:
                    'مثال: 1, 4, 8',

                helperText:
                    'مؤقتاً - سنستبدلها باختيار من القوائم',

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
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ===========================================================
// Bottom actions
// ===========================================================

class _BottomActions
    extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSaveDraft;
  final VoidCallback onSubmit;

  const _BottomActions({
    required this.isLoading,
    required this.onSaveDraft,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color:
                Color(0xFFE3E7EF),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child:
                  OutlinedButton(
                onPressed:
                    isLoading
                        ? null
                        : onSaveDraft,

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(
                    0xFF12355B,
                  ),

                  side:
                      const BorderSide(
                    color:
                        Color(
                      0xFF12355B,
                    ),
                  ),

                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                child:
                    const Text(
                  'حفظ كمسودة',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            Expanded(
              child:
                  ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : onSubmit,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF12355B,
                  ),

                  foregroundColor:
                      Colors.white,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                  ),

                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                child: isLoading
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Text(
                        'إرسال للمراجعة',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}