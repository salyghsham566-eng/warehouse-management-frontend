import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacies_bloc.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacies_event.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacies_state.dart';
import 'package:project_2/Features/auth/data/models/representative_pharmacies_model.dart';
import 'package:project_2/Features/auth/presentation/representative_pharmacy_details_screen.dart';

Route<void> representativePharmaciesRoute() {
  final now = DateTime.now();

  final month =
      '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}';

  return MaterialPageRoute(
    builder: (_) =>
        BlocProvider<
            RepresentativePharmaciesBloc>(
      create: (_) =>
          sl<RepresentativePharmaciesBloc>()
            ..add(
              RepresentativePharmaciesStarted(
                month: month,
              ),
            ),
      child:
          const RepresentativePharmaciesScreen(),
    ),
  );
}

class RepresentativePharmaciesScreen
    extends StatelessWidget {
  const RepresentativePharmaciesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الصيدليات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: BlocBuilder<
            RepresentativePharmaciesBloc,
            RepresentativePharmaciesState>(
          builder: (context, state) {
            if (state.status ==
                    RepresentativePharmaciesStatus
                        .initial ||
                state.status ==
                    RepresentativePharmaciesStatus
                        .loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status ==
                RepresentativePharmaciesStatus
                    .failure) {
              return _ErrorView(
                message: state.errorMessage,
                onRetry: () {
                  final month =
                      state.selectedMonth
                              .trim()
                              .isNotEmpty
                          ? state.selectedMonth
                          : _monthKey(
                              DateTime.now(),
                            );

                  context
                      .read<
                          RepresentativePharmaciesBloc>()
                      .add(
                        RepresentativePharmaciesStarted(
                          month: month,
                        ),
                      );
                },
              );
            }

            return _PharmaciesContent(
              state: state,
            );
          },
        ),
      ),
    );
  }
}

class _PharmaciesContent
    extends StatelessWidget {
  final RepresentativePharmaciesState state;

  const _PharmaciesContent({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        28,
      ),
      children: [
        const _HeaderCard(),

        const SizedBox(height: 12),

        const _ReadOnlyNotice(),

        const SizedBox(height: 18),

        _MonthTargetSection(
          state: state,
        ),

        const SizedBox(height: 16),

        _SearchField(
          value: state.searchText,
        ),

        const SizedBox(height: 12),

        _DateFilterCard(
          fromDate: state.fromDate,
          toDate: state.toDate,
        ),

        const SizedBox(height: 16),

        _RegionFilter(
          selectedRegion:
              state.selectedRegion,
          regionCounts:
              state.regionCounts,
        ),

        const SizedBox(height: 18),

        _CountsSummary(
          totalLinked:
              state.totalLinkedCount,
          visibleCount:
              state.visibleCount,
          selectedRegion:
              state.selectedRegion,
          selectedRegionCount:
              state.selectedRegion ==
                      'الكل'
                  ? null
                  : state.regionCounts[
                      state.selectedRegion],
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            const Expanded(
              child: Text(
                'قائمة الصيدليات',
                style: TextStyle(
                  color:
                      AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${state.visibleCount} نتيجة',
              style: const TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (state.visiblePharmacies.isEmpty)
          const _EmptyView()
        else
          ...state.visiblePharmacies.map(
            (pharmacy) => Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 10,
              ),
              child: _PharmacyCard(
                pharmacy: pharmacy,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF12355B),
            Color(0xFF1F5C8F),
          ],
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          _HeaderIcon(),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'صيدليات المندوب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'استعراض الصيدليات المرتبطة بك والبحث والفلترة حسب المنطقة والتاريخ.',
                  style: TextStyle(
                    color:
                        Color(0xFFD8E5F2),
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.14),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.local_pharmacy_outlined,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

class _ReadOnlyNotice
    extends StatelessWidget {
  const _ReadOnlyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.visibility_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'هذه الشاشة للاستعراض والفلترة فقط. لا يبدأ منها طلب أو تحصيل أو كشف حساب كامل.',
              style: TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 12.5,
                height: 1.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthTargetSection
    extends StatelessWidget {
  final RepresentativePharmaciesState state;

  const _MonthTargetSection({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final months =
        _buildMonthOptions();

    final selectedMonth =
        months.any(
          (item) =>
              item.key ==
              state.selectedMonth,
        )
        ? state.selectedMonth
        : months.first.key;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'الشهر والتارغت',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          value: selectedMonth,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'الشهر',
            prefixIcon: const Icon(
              Icons.calendar_month_outlined,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15),
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
          ),
          items: months
              .map(
                (item) =>
                    DropdownMenuItem<String>(
                  value: item.key,
                  child: Text(
                    item.label,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null ||
                value ==
                    state.selectedMonth) {
              return;
            }

            context
                .read<
                    RepresentativePharmaciesBloc>()
                .add(
                  RepresentativePharmaciesMonthChanged(
                    value,
                  ),
                );
          },
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _TargetCard(
                title:
                    'التارغت الكلي',
                value: state.totalTarget,
                icon:
                    Icons.flag_outlined,
              ),
            ),

            if (state.selectedRegion !=
                'الكل') ...[
              const SizedBox(width: 10),
              Expanded(
                child: _TargetCard(
                  title:
                      'تارغت ${state.selectedRegion}',
                  value: state
                      .selectedRegionTarget,
                  icon:
                      Icons.location_on_outlined,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _TargetCard extends StatelessWidget {
  final String title;
  final double? value;
  final IconData icon;

  const _TargetCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(height: 9),
          Text(
            title,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTarget(value),
            style: const TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 17,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final String value;

  const _SearchField({
    required this.value,
  });

  @override
  State<_SearchField> createState() =>
      _SearchFieldState();
}

class _SearchFieldState
    extends State<_SearchField> {
  late final TextEditingController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        TextEditingController(
      text: widget.value,
    );
  }

  @override
  void didUpdateWidget(
    covariant _SearchField oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.value !=
        _controller.text) {
      _controller.value =
          TextEditingValue(
        text: widget.value,
        selection:
            TextSelection.collapsed(
          offset:
              widget.value.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction:
          TextInputAction.search,
      onChanged: (value) {
        setState(() {});

        context
            .read<
                RepresentativePharmaciesBloc>()
            .add(
              RepresentativePharmaciesSearchChanged(
                value,
              ),
            );
      },
      decoration: InputDecoration(
        hintText:
            'ابحث باسم الصيدلية أو جزء منه',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.primary,
        ),
        suffixIcon:
            _controller.text
                    .trim()
                    .isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _controller.clear();

                      setState(() {});

                      context
                          .read<
                              RepresentativePharmaciesBloc>()
                          .add(
                            const RepresentativePharmaciesSearchChanged(
                              '',
                            ),
                          );
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  )
                : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _DateFilterCard
    extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;

  const _DateFilterCard({
    required this.fromDate,
    required this.toDate,
  });

  @override
  Widget build(BuildContext context) {
    final hasRange =
        fromDate != null ||
        toDate != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'نطاق آخر تعامل / بيع / تحديث',
                  style: TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 13.5,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
              if (hasRange)
                TextButton(
                  onPressed: () {
                    context
                        .read<
                            RepresentativePharmaciesBloc>()
                        .add(
                          const RepresentativePharmaciesDateRangeChanged(
                            fromDate: null,
                            toDate: null,
                          ),
                        );
                  },
                  child:
                      const Text('مسح'),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            hasRange
                ? 'من ${_formatDate(fromDate)}  •  إلى ${_formatDate(toDate)}'
                : 'جميع التواريخ',
            style: const TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12.5,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final now =
                    DateTime.now();

                final picked =
                    await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(
                    now.year - 3,
                    1,
                    1,
                  ),
                  lastDate: DateTime(
                    now.year + 1,
                    12,
                    31,
                  ),
                  initialDateRange:
                      fromDate != null &&
                              toDate != null
                          ? DateTimeRange(
                              start:
                                  fromDate!,
                              end: toDate!,
                            )
                          : null,
                  helpText:
                      'اختر نطاق التاريخ',
                  cancelText: 'إلغاء',
                  confirmText: 'تطبيق',
                  saveText: 'تطبيق',
                );

                if (picked == null ||
                    !context.mounted) {
                  return;
                }

                context
                    .read<
                        RepresentativePharmaciesBloc>()
                    .add(
                      RepresentativePharmaciesDateRangeChanged(
                        fromDate:
                            picked.start,
                        toDate:
                            picked.end,
                      ),
                    );
              },
              icon: const Icon(
                Icons.tune_rounded,
              ),
              label: const Text(
                'اختيار من / إلى تاريخ',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionFilter
    extends StatelessWidget {
  final String selectedRegion;
  final Map<String, int>
      regionCounts;

  const _RegionFilter({
    required this.selectedRegion,
    required this.regionCounts,
  });

  @override
  Widget build(BuildContext context) {
    final regions =
        regionCounts.keys.toList();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'المنطقة',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 9),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(
                  left: 7,
                ),
                child: ChoiceChip(
                  label:
                      const Text('الكل'),
                  selected:
                      selectedRegion ==
                          'الكل',
                  onSelected: (_) {
                    context
                        .read<
                            RepresentativePharmaciesBloc>()
                        .add(
                          const RepresentativePharmaciesRegionChanged(
                            'الكل',
                          ),
                        );
                  },
                ),
              ),

              ...regions.map(
                (region) => Padding(
                  padding:
                      const EdgeInsets.only(
                    left: 7,
                  ),
                  child: ChoiceChip(
                    label: Text(
                      '$region (${regionCounts[region] ?? 0})',
                    ),
                    selected:
                        selectedRegion ==
                            region,
                    onSelected: (_) {
                      context
                          .read<
                              RepresentativePharmaciesBloc>()
                          .add(
                            RepresentativePharmaciesRegionChanged(
                              region,
                            ),
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CountsSummary
    extends StatelessWidget {
  final int totalLinked;
  final int visibleCount;
  final String selectedRegion;
  final int? selectedRegionCount;

  const _CountsSummary({
    required this.totalLinked,
    required this.visibleCount,
    required this.selectedRegion,
    required this.selectedRegionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CountCard(
            title:
                'إجمالي الصيدليات',
            value: '$totalLinked',
            icon:
                Icons.local_pharmacy_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CountCard(
            title:
                selectedRegion == 'الكل'
                    ? 'النتائج المعروضة'
                    : 'صيدليات $selectedRegion',
            value:
                '${selectedRegion == 'الكل' ? visibleCount : (selectedRegionCount ?? visibleCount)}',
            icon:
                Icons.location_on_outlined,
          ),
        ),
      ],
    );
  }
}

class _CountCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _CountCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  AppColors.primarySoft,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors
                        .textSecondary,
                    fontSize: 10.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PharmacyCard
    extends StatelessWidget {
  final RepresentativePharmacyModel
      pharmacy;

  const _PharmacyCard({
    required this.pharmacy,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(17),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(17),

        // =================================================
        // UC-242 -> UC-245
        // =================================================
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RepresentativePharmacyDetailsScreen(
                pharmacyId:
                    pharmacy.id,
              ),
            ),
          );
        },

        child: Container(
          padding:
              const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color:
                      AppColors.primarySoft,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons
                      .local_pharmacy_outlined,
                  color:
                      AppColors.primary,
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style:
                          const TextStyle(
                        color: AppColors
                            .textPrimary,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          color: AppColors
                              .textSecondary,
                          size: 16,
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Expanded(
                          child: Text(
                            pharmacy.region,
                            style:
                                const TextStyle(
                              color: AppColors
                                  .textSecondary,
                              fontSize: 12.5,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_left_rounded,
                color:
                    AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            color:
                AppColors.textSecondary,
            size: 42,
          ),
          SizedBox(height: 10),
          Text(
            'لا توجد صيدليات مطابقة للفلاتر',
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 15,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
                  const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthOption {
  final String key;
  final String label;

  const _MonthOption({
    required this.key,
    required this.label,
  });
}

List<_MonthOption> _buildMonthOptions() {
  final now = DateTime.now();

  return List.generate(
    12,
    (index) {
      final date = DateTime(
        now.year,
        now.month - index,
        1,
      );

      return _MonthOption(
        key: _monthKey(date),
        label:
            '${_arabicMonthName(date.month)} ${date.year}',
      );
    },
  );
}

String _monthKey(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';
}

String _arabicMonthName(int month) {
  const names = [
    'كانون الثاني',
    'شباط',
    'آذار',
    'نيسان',
    'أيار',
    'حزيران',
    'تموز',
    'آب',
    'أيلول',
    'تشرين الأول',
    'تشرين الثاني',
    'كانون الأول',
  ];

  return names[month - 1];
}

String _formatDate(DateTime? date) {
  if (date == null) {
    return 'غير محدد';
  }

  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

String _formatTarget(double? value) {
  if (value == null) {
    return 'غير متوفر';
  }

  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(2);
}
