import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';

import 'package:project_2/Features/auth/bloc/create_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/create_work_plan_event.dart';
import 'package:project_2/Features/auth/bloc/create_work_plan_state.dart';

import 'package:project_2/Features/auth/data/models/company_model.dart';
import 'package:project_2/Features/auth/data/models/create_work_plan_request_model.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_model.dart';
import 'package:project_2/Features/auth/data/models/product_model.dart';
import 'package:project_2/Features/auth/data/models/profile_model.dart';

import 'package:project_2/Features/auth/domain/repositories/companies_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacies_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';

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

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  int? _selectedRegionId;

  List<ProfileRegionModel> _regions = const [];
  List<CompanyModel> _companies = const [];
  List<PharmacyModel> _pharmacies = const [];

  bool _isOptionsLoading = true;
  String? _optionsError;

  final List<_GoalFormData> _goals = [];

  @override
  void initState() {
    super.initState();
    _loadSelectionOptions();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();

    for (final goal in _goals) {
      goal.dispose();
    }

    super.dispose();
  }

  // =========================================================
  // Selection data
  // =========================================================

  Future<void> _loadSelectionOptions() async {
    if (mounted) {
      setState(() {
        _isOptionsLoading = true;
        _optionsError = null;
      });
    }

    try {
      final results = await Future.wait<dynamic>([
        sl<ProfileRepository>().getProfile(),
        sl<CompaniesRepository>().getCompanies(),
        sl<PharmaciesRepository>().getPharmacies(),
      ]);

      final profile = results[0] as ProfileModel;
      final companies = results[1] as List<CompanyModel>;
      final pharmacies = results[2] as List<PharmacyModel>;

      if (!mounted) {
        return;
      }

      setState(() {
        _regions = profile.linkedRegions
            .where((region) => region.id != null)
            .toList();
        _companies = companies;
        _pharmacies = pharmacies;
        _isOptionsLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isOptionsLoading = false;
        _optionsError = e
            .toString()
            .replaceFirst('Exception: ', '');
      });
    }
  }

  List<_SelectionOption> _optionsForGoal(
    CreateWorkPlanGoalType type,
  ) {
    switch (type) {
      case CreateWorkPlanGoalType.products:
        final options = <_SelectionOption>[];

        for (final company in _companies) {
          for (final product in company.products) {
            if (product.id <= 0) {
              continue;
            }

            options.add(
              _SelectionOption(
                id: product.id,
                title: product.name,
                subtitle: company.name,
              ),
            );
          }
        }

        return options;

      case CreateWorkPlanGoalType.companies:
        return _companies
            .where((company) => company.id > 0)
            .map(
              (company) => _SelectionOption(
                id: company.id,
                title: company.name,
                subtitle:
                    '${company.products.length} أصناف محملة',
              ),
            )
            .toList();

      case CreateWorkPlanGoalType.pharmacies:
        return _pharmacies
            .where((pharmacy) => pharmacy.id != null)
            .map(
              (pharmacy) => _SelectionOption(
                id: pharmacy.id!,
                title: pharmacy.name,
                subtitle: pharmacy.area.isEmpty
                    ? pharmacy.address
                    : pharmacy.area,
              ),
            )
            .toList();

      default:
        return const [];
    }
  }

  String _selectionSummary(
    _GoalFormData goal,
  ) {
    final options = _optionsForGoal(goal.type);

    if (goal.selectedIds.isEmpty) {
      return 'لم يتم تحديد عناصر بعد';
    }

    final selectedNames = options
        .where(
          (option) => goal.selectedIds.contains(option.id),
        )
        .map((option) => option.title)
        .toList();

    if (selectedNames.isEmpty) {
      return '${goal.selectedIds.length} محدد';
    }

    if (selectedNames.length <= 2) {
      return selectedNames.join('، ');
    }

    return '${selectedNames.take(2).join('، ')} +${selectedNames.length - 2}';
  }

  Future<void> _openGoalSelection(
    int goalIndex,
  ) async {
    final goal = _goals[goalIndex];
    final options = _optionsForGoal(goal.type);

    if (_isOptionsLoading) {
      _showMessage('جارٍ تحميل القوائم، حاول بعد لحظات');
      return;
    }

    if (_optionsError != null) {
      _showMessage(
        'تعذر تحميل القوائم. اضغط إعادة المحاولة ثم حاول مجدداً.',
      );
      return;
    }

    if (options.isEmpty) {
      _showMessage('لا توجد عناصر متاحة للاختيار حالياً');
      return;
    }

    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final selected = <int>{...goal.selectedIds};
        String search = '';

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = options.where((option) {
              final query = search.trim().toLowerCase();

              if (query.isEmpty) {
                return true;
              }

              return option.title.toLowerCase().contains(query) ||
                  option.subtitle.toLowerCase().contains(query);
            }).toList();

            return Directionality(
              textDirection: TextDirection.rtl,
              child: FractionallySizedBox(
                heightFactor: 0.88,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8DEE8),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selectionTitle(goal.type),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF102A43),
                                  ),
                                ),
                              ),
                              Text(
                                '${selected.length} محدد',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF667085),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setSheetState(() {
                                search = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'بحث...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE3E7EF),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: filtered.isEmpty
                              ? const Center(
                                  child: Text(
                                    'لا توجد نتائج',
                                    style: TextStyle(
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(
                                    10,
                                    4,
                                    10,
                                    12,
                                  ),
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final option = filtered[index];
                                    final checked =
                                        selected.contains(option.id);

                                    return CheckboxListTile(
                                      value: checked,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: const Color(0xFF12355B),
                                      title: Text(
                                        option.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      subtitle: option.subtitle.isEmpty
                                          ? null
                                          : Text(option.subtitle),
                                      onChanged: (value) {
                                        setSheetState(() {
                                          if (value == true) {
                                            selected.add(option.id);
                                          } else {
                                            selected.remove(option.id);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            12,
                            16,
                            12,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color(0xFFE3E7EF),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(sheetContext);
                                  },
                                  child: const Text('إلغاء'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF12355B),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                      sheetContext,
                                      selected,
                                    );
                                  },
                                  child: const Text('تطبيق الاختيار'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      goal.selectedIds
        ..clear()
        ..addAll(result);
    });
  }

  String _selectionTitle(CreateWorkPlanGoalType type) {
    switch (type) {
      case CreateWorkPlanGoalType.products:
        return 'اختيار الأصناف';
      case CreateWorkPlanGoalType.companies:
        return 'اختيار الشركات';
      case CreateWorkPlanGoalType.pharmacies:
        return 'اختيار الصيدليات';
      default:
        return 'اختيار العناصر';
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // =========================================================
  // Dates
  // =========================================================

  Future<void> _pickStartDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
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
          _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
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

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // =========================================================
  // Goals
  // =========================================================

  void _addGoal() {
    setState(() {
      _goals.add(_GoalFormData());
    });
  }

  void _removeGoal(int index) {
    final goal = _goals[index];
    goal.dispose();

    setState(() {
      _goals.removeAt(index);
    });
  }

  List<CreateWorkPlanGoalRequest> _buildGoals() {
    return _goals.map((goal) {
      final targetValue = double.tryParse(
        goal.valueController.text.trim(),
      );

      return CreateWorkPlanGoalRequest(
        type: goal.type,
        targetValue: targetValue,
        productIds:
            goal.type == CreateWorkPlanGoalType.products
                ? goal.selectedIds.toList()
                : const [],
        companyIds:
            goal.type == CreateWorkPlanGoalType.companies
                ? goal.selectedIds.toList()
                : const [],
        pharmacyIds:
            goal.type == CreateWorkPlanGoalType.pharmacies
                ? goal.selectedIds.toList()
                : const [],
      );
    }).toList();
  }

  bool _validateGoalsForSubmit() {
    if (_goals.isEmpty) {
      _showMessage('يجب إضافة هدف واحد على الأقل');
      return false;
    }

    for (int i = 0; i < _goals.length; i++) {
      final goal = _goals[i];
      final number = i + 1;

      final usesNumericValue =
          goal.type == CreateWorkPlanGoalType.sales ||
          goal.type == CreateWorkPlanGoalType.collection ||
          goal.type == CreateWorkPlanGoalType.pharmacyCoverage ||
          goal.type == CreateWorkPlanGoalType.visits;

      final usesSelection =
          goal.type == CreateWorkPlanGoalType.products ||
          goal.type == CreateWorkPlanGoalType.companies ||
          goal.type == CreateWorkPlanGoalType.pharmacies;

      if (usesNumericValue) {
        final value = double.tryParse(
          goal.valueController.text.trim(),
        );

        if (value == null || value <= 0) {
          _showMessage(
            'يرجى إدخال قيمة صحيحة للهدف رقم $number',
          );
          return false;
        }
      }

      if (usesSelection && goal.selectedIds.isEmpty) {
        _showMessage(
          'يرجى تحديد عنصر واحد على الأقل للهدف رقم $number',
        );
        return false;
      }
    }

    return true;
  }

  // =========================================================
  // Request
  // =========================================================

  void _submit(WorkPlanCreateAction action) {
    FocusScope.of(context).unfocus();

    if (action == WorkPlanCreateAction.submit &&
        !_validateGoalsForSubmit()) {
      return;
    }

    final request = CreateWorkPlanRequestModel(
      name: _nameController.text,
      description: _descriptionController.text,
      startDate: _startDate,
      endDate: _endDate,
      regionId: _selectedRegionId,
      goals: _buildGoals(),
      notes: _notesController.text,
      action: action,
    );

    context.read<CreateWorkPlanBloc>().add(
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
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: const Color(0xFF102A43),
          title: const Text(
            'إنشاء خطة عمل',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF102A43),
            ),
          ),
        ),
        body: BlocConsumer<CreateWorkPlanBloc, CreateWorkPlanState>(
          listener: (context, state) {
            if (state is CreateWorkPlanSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message),
                ),
              );

              Navigator.pop(context, true);
            }

            if (state is CreateWorkPlanFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is CreateWorkPlanLoading;

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        18,
                        16,
                        120,
                      ),
                      children: [
                        const _SectionTitle(
                          icon: Icons.description_outlined,
                          title: 'معلومات الخطة',
                        ),
                        const SizedBox(height: 10),
                        _FormCard(
                          child: Column(
                            children: [
                              _AppTextField(
                                controller: _nameController,
                                label: 'اسم الخطة',
                                hint: 'مثال: خطة مبيعات شهر آب',
                                required: true,
                              ),
                              const SizedBox(height: 14),
                              _AppTextField(
                                controller: _descriptionController,
                                label: 'وصف الخطة',
                                hint: 'اكتب وصفاً مختصراً للخطة...',
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        const _SectionTitle(
                          icon: Icons.calendar_month_outlined,
                          title: 'مدة الخطة',
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _DateCard(
                                title: 'تاريخ البداية',
                                date: _formatDate(_startDate),
                                selected: _startDate != null,
                                onTap: _pickStartDate,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _DateCard(
                                title: 'تاريخ النهاية',
                                date: _formatDate(_endDate),
                                selected: _endDate != null,
                                onTap: _pickEndDate,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const _SectionTitle(
                          icon: Icons.location_on_outlined,
                          title: 'المنطقة',
                          optional: true,
                        ),
                        const SizedBox(height: 10),
                        _FormCard(
                          child: _buildRegionSelector(),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            const Expanded(
                              child: _SectionTitle(
                                icon: Icons.flag_outlined,
                                title: 'أهداف الخطة',
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _addGoal,
                              icon: const Icon(Icons.add),
                              label: const Text('إضافة هدف'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_isOptionsLoading)
                          const _LoadingOptionsCard()
                        else if (_optionsError != null)
                          _OptionsErrorCard(
                            message: _optionsError!,
                            onRetry: _loadSelectionOptions,
                          ),
                        if (_goals.isEmpty)
                          _EmptyGoalsCard(onAdd: _addGoal)
                        else
                          ...List.generate(
                            _goals.length,
                            (index) {
                              final goal = _goals[index];

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: _GoalCard(
                                  index: index,
                                  data: goal,
                                  selectionSummary:
                                      _selectionSummary(goal),
                                  onSelectItems: () {
                                    _openGoalSelection(index);
                                  },
                                  onChanged: () {
                                    setState(() {});
                                  },
                                  onDelete: () {
                                    _removeGoal(index);
                                  },
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 10),
                        const _SectionTitle(
                          icon: Icons.notes_outlined,
                          title: 'ملاحظات',
                          optional: true,
                        ),
                        const SizedBox(height: 10),
                        _FormCard(
                          child: _AppTextField(
                            controller: _notesController,
                            label: 'ملاحظات إضافية',
                            hint:
                                'أضف أي ملاحظات متعلقة بالخطة...',
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _BottomActions(
                    isLoading: isLoading,
                    onSaveDraft: () => _submit(
                      WorkPlanCreateAction.draft,
                    ),
                    onSubmit: () => _submit(
                      WorkPlanCreateAction.submit,
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

  Widget _buildRegionSelector() {
    if (_isOptionsLoading) {
      return const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 10),
          Text('جارٍ تحميل المناطق...'),
        ],
      );
    }

    if (_optionsError != null) {
      return Row(
        children: [
          const Expanded(
            child: Text(
              'تعذر تحميل المناطق',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
          TextButton(
            onPressed: _loadSelectionOptions,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      );
    }

    if (_regions.isEmpty) {
      return const Text(
        'لا توجد مناطق مرتبطة بالحساب حالياً',
        style: TextStyle(
          color: Color(0xFF667085),
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: _selectedRegionId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'المنطقة',
        hintText: 'اختر المنطقة أو اتركها بدون تحديد',
        filled: true,
        fillColor: const Color(0xFFF9FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE3E7EF),
          ),
        ),
      ),
      items: [
        const DropdownMenuItem<int>(
          value: null,
          child: Text('بدون تحديد منطقة'),
        ),
        ..._regions.map(
          (region) => DropdownMenuItem<int>(
            value: region.id,
            child: Text(
              region.pharmaciesCount == null
                  ? region.name
                  : '${region.name} (${region.pharmaciesCount} صيدلية)',
            ),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedRegionId = value;
        });
      },
    );
  }
}

// ===========================================================
// Goal temporary data
// ===========================================================

class _GoalFormData {
  CreateWorkPlanGoalType type =
      CreateWorkPlanGoalType.sales;

  final valueController = TextEditingController();
  final Set<int> selectedIds = <int>{};

  void dispose() {
    valueController.dispose();
  }
}

class _SelectionOption {
  final int id;
  final String title;
  final String subtitle;

  const _SelectionOption({
    required this.id,
    required this.title,
    this.subtitle = '',
  });
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
          color: const Color(0xFF12355B),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE3E7EF),
        ),
      ),
      child: child,
    );
  }
}

// ===========================================================
// Text field
// ===========================================================

class _AppTextField extends StatelessWidget {
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
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: const Color(0xFFF9FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE3E7EF),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF12355B),
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

class _DateCard extends StatelessWidget {
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
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE3E7EF),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF7A869A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Color(0xFF12355B),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? const Color(0xFF102A43)
                          : const Color(0xFF9BA5B4),
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
// Options state cards
// ===========================================================

class _LoadingOptionsCard extends StatelessWidget {
  const _LoadingOptionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'جارٍ تحميل المناطق والشركات والأصناف والصيدليات...',
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionsErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _OptionsErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF2C8C8),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF7A2E2E),
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// Empty goals
// ===========================================================

class _EmptyGoalsCard extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyGoalsCard({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE3E7EF),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF1FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flag_outlined,
              color: Color(0xFF12355B),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'لم تتم إضافة أهداف بعد',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'يجب إضافة هدف واحد على الأقل عند إرسال الخطة للمراجعة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7A869A),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('إضافة هدف'),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// Goal card
// ===========================================================

class _GoalCard extends StatelessWidget {
  final int index;
  final _GoalFormData data;
  final String selectionSummary;
  final VoidCallback onSelectItems;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const _GoalCard({
    required this.index,
    required this.data,
    required this.selectionSummary,
    required this.onSelectItems,
    required this.onChanged,
    required this.onDelete,
  });

  bool get _usesNumericValue {
    return data.type == CreateWorkPlanGoalType.sales ||
        data.type == CreateWorkPlanGoalType.collection ||
        data.type == CreateWorkPlanGoalType.pharmacyCoverage ||
        data.type == CreateWorkPlanGoalType.visits;
  }

  bool get _usesSelection {
    return data.type == CreateWorkPlanGoalType.products ||
        data.type == CreateWorkPlanGoalType.companies ||
        data.type == CreateWorkPlanGoalType.pharmacies;
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

  String get _selectionLabel {
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE3E7EF),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF1FA),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF12355B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'هدف الخطة',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF102A43),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'حذف الهدف',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<CreateWorkPlanGoalType>(
            value: data.type,
            decoration: InputDecoration(
              labelText: 'نوع الهدف',
              filled: true,
              fillColor: const Color(0xFFF9FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE3E7EF),
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: CreateWorkPlanGoalType.sales,
                child: Text('مبيعات'),
              ),
              DropdownMenuItem(
                value: CreateWorkPlanGoalType.collection,
                child: Text('تحصيل'),
              ),
              DropdownMenuItem(
                value: CreateWorkPlanGoalType.pharmacyCoverage,
                child: Text('تغطية صيدليات'),
              ),
              DropdownMenuItem(
                value: CreateWorkPlanGoalType.visits,
                child: Text('زيارات'),
              ),
              DropdownMenuItem(
                value: CreateWorkPlanGoalType.products,
                child: Text('أصناف محددة'),
              ),
              DropdownMenuItem(
                value: CreateWorkPlanGoalType.companies,
                child: Text('شركات محددة'),
              ),
              DropdownMenuItem(
                value: CreateWorkPlanGoalType.pharmacies,
                child: Text('صيدليات محددة'),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                return;
              }

              data.type = value;
              data.valueController.clear();
              data.selectedIds.clear();
              onChanged();
            },
          ),
          if (_usesNumericValue) ...[
            const SizedBox(height: 12),
            TextField(
              controller: data.valueController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: _valueLabel,
                hintText: 'أدخل القيمة المستهدفة',
                filled: true,
                fillColor: const Color(0xFFF9FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE3E7EF),
                  ),
                ),
              ),
            ),
          ],
          if (_usesSelection) ...[
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onSelectItems,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE3E7EF),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.checklist_rounded,
                      color: Color(0xFF12355B),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectionLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF667085),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            selectionSummary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: data.selectedIds.isEmpty
                                  ? const Color(0xFF98A2B3)
                                  : const Color(0xFF102A43),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (data.selectedIds.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FA),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          '${data.selectedIds.length}',
                          style: const TextStyle(
                            color: Color(0xFF12355B),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 14,
                      color: Color(0xFF98A2B3),
                    ),
                  ],
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

class _BottomActions extends StatelessWidget {
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
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE3E7EF),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onSaveDraft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF12355B),
                  side: const BorderSide(
                    color: Color(0xFF12355B),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'حفظ كمسودة',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF12355B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'إرسال للمراجعة',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
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
