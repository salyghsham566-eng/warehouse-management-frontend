import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_event.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_state.dart';
import 'package:project_2/Features/auth/bloc/financial_indicator_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacies_bloc.dart';
import 'package:project_2/Features/auth/bloc/region_account_statement_bloc.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';
import 'package:project_2/Features/auth/presentation/financial_indicator_details_page.dart';
import 'package:project_2/Features/auth/presentation/financial_pharmacies_page.dart';
import 'package:project_2/Features/auth/presentation/region_account_statement_page.dart';

class RepresentativeFinancialPage extends StatefulWidget {
  const RepresentativeFinancialPage({
    super.key,
  });

  @override
  State<RepresentativeFinancialPage> createState() =>
      _RepresentativeFinancialPageState();
}

class _RepresentativeFinancialPageState
    extends State<RepresentativeFinancialPage> {
  static const Color _primaryColor = Color(0xFF002B55);
  static const Color _backgroundColor = Color(0xFFF5F7FC);

  late DateTime _fromDate;
  late DateTime _toDate;

  String _selectedRegionId = 'all';

  List<FinancialRegionModel> _regions = const [
    FinancialRegionModel(
      id: 'all',
      name: 'جميع المناطق',
    ),
  ];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _fromDate = DateTime(
      now.year,
      now.month,
      1,
    );

    _toDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: _primaryColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'المالية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<FinancialDashboardBloc,
              FinancialDashboardState>(
            listener: (context, state) {
              if (state is FinancialDashboardSuccess &&
                  state.dashboard.regions.isNotEmpty) {
                setState(() {
                  _regions = state.dashboard.regions;

                  final selectedRegionExists = _regions.any(
                    (region) => region.id == _selectedRegionId,
                  );

                  if (!selectedRegionExists) {
                    _selectedRegionId = 'all';
                  }
                });
              }
            },
            builder: (context, state) {
              final isLoading = state is FinancialDashboardLoading;

              return RefreshIndicator(
                onRefresh: () async {
                  _loadDashboard();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildReadOnlyNotice(),
                    const SizedBox(height: 12),
                    _buildFiltersCard(
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 16),
                    _buildStateContent(state),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyNotice() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFCFE0FA),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.analytics_outlined,
            color: _primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'هذه الشاشة لعرض وتحليل المؤشرات المالية فقط. تسجيل الدفعات يتم من قسم التحصيل.',
              style: TextStyle(
                color: _primaryColor,
                height: 1.5,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersCard({
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'النطاق',
            style: TextStyle(
              color: Color(0xFF344054),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedRegionId,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F7FD),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFFD8DFEB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFFD8DFEB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: _primaryColor,
                  width: 1.4,
                ),
              ),
            ),
            items: _regions
                .map(
                  (region) => DropdownMenuItem<String>(
                    value: region.id,
                    child: Text(region.name),
                  ),
                )
                .toList(),
            onChanged: isLoading
                ? null
                : (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _selectedRegionId = value;
                    });
                  },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'من تاريخ',
                  date: _fromDate,
                  onPressed: isLoading
                      ? null
                      : () {
                          _selectFromDate();
                        },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateField(
                  label: 'إلى تاريخ',
                  date: _toDate,
                  onPressed: isLoading
                      ? null
                      : () {
                          _selectToDate();
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _loadDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    _primaryColor.withOpacity(0.55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.bar_chart_rounded,
                    ),
              label: Text(
                isLoading ? 'جاري تحميل البيانات...' : 'عرض البيانات',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateContent(
    FinancialDashboardState state,
  ) {
    if (state is FinancialDashboardInitial) {
      return const _InitialStateWidget();
    }

    if (state is FinancialDashboardLoading) {
      return const _LoadingStateWidget();
    }

    if (state is FinancialDashboardEmpty) {
      return const _EmptyStateWidget();
    }

    if (state is FinancialDashboardFailure) {
      return _ErrorStateWidget(
        message: state.message,
        onRetry: _loadDashboard,
      );
    }

    if (state is FinancialDashboardSuccess) {
      return _DashboardContent(
        dashboard: state.dashboard,
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _selectFromDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'اختر تاريخ البداية',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _fromDate = selectedDate;

      if (_fromDate.isAfter(_toDate)) {
        _toDate = selectedDate;
      }
    });
  }

  Future<void> _selectToDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: _fromDate,
      lastDate: DateTime.now(),
      helpText: 'اختر تاريخ النهاية',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _toDate = selectedDate;
    });
  }

  void _loadDashboard() {
    if (_fromDate.isAfter(_toDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تاريخ البداية يجب أن يكون قبل تاريخ النهاية',
          ),
        ),
      );

      return;
    }

    context.read<FinancialDashboardBloc>().add(
          LoadFinancialDashboardEvent(
            fromDate: _fromDate,
            toDate: _toDate,
            regionId: _selectedRegionId,
          ),
        );
  }
}

class _DashboardContent extends StatelessWidget {
  final FinancialDashboardModel dashboard;


  const _DashboardContent({
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    final featuredMetrics = _metricsByIds(
      dashboard,
      const [
        'total_sales',
        'total_collections',
        'total_receivables',
      ],
    );

    final countMetrics = _metricsByIds(
      dashboard,
      const [
        'debtor_pharmacies',
        'fully_paid_pharmacies',
        'invoices_count',
        'collection_operations',
      ],
    );

    final additionalMetrics = _metricsByIds(
      dashboard,
      const [
        'average_collection',
        'first_sale',
        'last_sale',
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PeriodSummaryCard(
          dashboard: dashboard,
        ),
const SizedBox(height: 12),

_FinancialPharmaciesButton(
  dashboard: dashboard,
),
        // يظهر فقط عند تحديد منطقة واحدة.
        if (dashboard.isSpecificRegion) ...[
          const SizedBox(height: 12),
          _RegionStatementButton(
            dashboard: dashboard,
          ),
        ],

        const SizedBox(height: 16),

        _SectionTitle(
          title: dashboard.isAllRegions
              ? 'المؤشرات المالية'
              : 'مؤشرات ${dashboard.scopeName}',
          icon: Icons.account_balance_wallet_outlined,
        ),

        const SizedBox(height: 10),

        ...featuredMetrics.map(
          (metric) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FinancialMetricCard(
              metric: metric,
              compact: false,
                dashboard: dashboard,
            ),
          ),
        ),

        if (countMetrics.isNotEmpty) ...[
          const SizedBox(height: 4),
          const _SectionTitle(
            title: 'الإحصائيات',
            icon: Icons.grid_view_rounded,
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount =
                  constraints.maxWidth >= 720 ? 4 : 2;

              final totalSpacing =
                  (columnCount - 1) * 12;

              final cardWidth =
                  (constraints.maxWidth - totalSpacing) /
                      columnCount;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: countMetrics
                    .map(
                      (metric) => SizedBox(
                        width: cardWidth,
                        child: _FinancialMetricCard(
                          metric: metric,
                            dashboard: dashboard,
                          compact: true,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],

        if (additionalMetrics.isNotEmpty) ...[
          const SizedBox(height: 20),
          const _SectionTitle(
            title: 'تفاصيل إضافية',
            icon: Icons.insights_outlined,
          ),
          const SizedBox(height: 10),
          ...additionalMetrics.map(
            (metric) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FinancialMetricCard(
                metric: metric,
                  dashboard: dashboard,
                compact: false,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<FinancialMetricModel> _metricsByIds(
    FinancialDashboardModel dashboard,
    List<String> ids,
  ) {
    final result = <FinancialMetricModel>[];

    for (final id in ids) {
      final metric = dashboard.metricById(id);

      if (metric != null) {
        result.add(metric);
      }
    }

    return result;
  }
}
class _FinancialPharmaciesButton
    extends StatelessWidget {
  final FinancialDashboardModel dashboard;

  const _FinancialPharmaciesButton({
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider<
                  FinancialPharmaciesBloc>(
                create: (_) =>
                    sl<FinancialPharmaciesBloc>(),
                child: FinancialPharmaciesPage(
                  fromDate: dashboard.fromDate,
                  toDate: dashboard.toDate,
                  regionId: dashboard.scopeId,
                  regionName: dashboard.scopeName,
                ),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFF002B55),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(
          Icons.local_pharmacy_outlined,
        ),
        label: const Text(
          'عرض الصيدليات المالية',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class _RegionStatementButton extends StatelessWidget {
  final FinancialDashboardModel dashboard;

  const _RegionStatementButton({
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
       onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) {
        return BlocProvider<
            RegionAccountStatementBloc>(
          create: (_) =>
              sl<RegionAccountStatementBloc>(),
          child: RegionAccountStatementPage(
            dashboard: dashboard,
          ),
        );
      },
    ),
  );
},
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF002B55),
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFF002B55),
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(
          Icons.receipt_long_outlined,
        ),
        label: Text(
          'كشف حساب ${dashboard.scopeName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class _PeriodSummaryCard extends StatelessWidget {
  final FinancialDashboardModel dashboard;

  const _PeriodSummaryCard({
    required this.dashboard,
  });

  static const Color _primaryColor = Color(0xFF002B55);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.date_range_outlined,
              color: _primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboard.scopeName,
                  style: const TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'من ${_formatDate(dashboard.fromDate)} إلى ${_formatDate(dashboard.toDate)}',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '${date.year}/$month/$day';
  }
}

class _FinancialMetricCard extends StatelessWidget {
  final FinancialMetricModel metric;
  final FinancialDashboardModel dashboard;
  final bool compact;

  const _FinancialMetricCard({
    required this.metric,
    required this.dashboard,
    required this.compact,
  });

  @override
Widget build(BuildContext context) {
  final accentColor = _accentColorFor(metric.id);

  return Container(
    width: double.infinity,
    constraints: BoxConstraints(
      minHeight: compact ? 190 : 0,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: accentColor.withOpacity(0.20),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(
        compact ? 13 : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: compact
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.stretch,
        children: [
          if (compact)
            _buildCompactHeader(accentColor)
          else
            _buildWideHeader(accentColor),

          if (metric.subtitle != null &&
              metric.subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 9),
            Text(
              metric.subtitle!,
              textAlign: compact
                  ? TextAlign.center
                  : TextAlign.start,
              maxLines: compact ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF667085),
                height: 1.45,
                fontSize: 12,
              ),
            ),
          ],

          const SizedBox(height: 12),

          Align(
            alignment: compact
                ? Alignment.center
                : AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (routeContext) {
        return BlocProvider<FinancialIndicatorDetailsBloc>(
          create: (_) => sl<FinancialIndicatorDetailsBloc>(),
          child: FinancialIndicatorDetailsPage(
            metric: metric,
            dashboard: dashboard,
          ),
        );
      },
    ),
  );
},
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 18,
              ),
              label: const Text(
                'عرض التفاصيل',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildWideHeader(Color accentColor) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            _iconFor(metric.iconKey),
            color: accentColor,
            size: 27,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.title,
                style: const TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                metric.formattedValue,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactHeader(Color accentColor) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            _iconFor(metric.iconKey),
            color: accentColor,
            size: 25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          metric.formattedValue,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: accentColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          metric.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _accentColorFor(String metricId) {
    switch (metricId) {
      case 'total_sales':
        return const Color(0xFF003B73);

      case 'total_collections':
        return const Color(0xFF00875A);

      case 'total_receivables':
        return const Color(0xFFC62828);

      case 'fully_paid_pharmacies':
        return const Color(0xFF00875A);

      case 'debtor_pharmacies':
        return const Color(0xFFD97706);

      case 'average_collection':
        return const Color(0xFF6B4EFF);

      case 'first_sale':
        return const Color(0xFF0277BD);

      case 'last_sale':
        return const Color(0xFF7B1FA2);

      default:
        return const Color(0xFF355070);
    }
  }

  IconData _iconFor(String iconKey) {
    switch (iconKey) {
      case 'sales':
        return Icons.payments_outlined;

      case 'collections':
        return Icons.account_balance_wallet_outlined;

      case 'receivables':
        return Icons.money_off_csred_outlined;

      case 'pharmacy_debt':
        return Icons.local_pharmacy_outlined;

      case 'fully_paid':
        return Icons.verified_outlined;

      case 'invoice':
        return Icons.description_outlined;

      case 'collection_operations':
        return Icons.sync_alt_outlined;

      case 'average':
        return Icons.calculate_outlined;

      case 'first_sale':
        return Icons.first_page_outlined;

      case 'last_sale':
        return Icons.last_page_outlined;

      default:
        return Icons.analytics_outlined;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF002B55),
          size: 21,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF002B55),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback? onPressed;

  const _DateField({
    required this.label,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(13),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF4F7FD),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: Color(0xFFD8DFEB),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: Color(0xFFD8DFEB),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatDate(date),
                style: const TextStyle(
                  color: Color(0xFF1D2939),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.calendar_month_outlined,
              size: 19,
              color: Color(0xFF475467),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');

    return '${value.year}/$month/$day';
  }
}

class _InitialStateWidget extends StatelessWidget {
  const _InitialStateWidget();

  @override
  Widget build(BuildContext context) {
    return const _StateContainer(
      icon: Icons.analytics_outlined,
      title: 'المؤشرات المالية',
      message: 'حدد الفترة والنطاق ثم اضغط عرض البيانات.',
    );
  }
}

class _LoadingStateWidget extends StatelessWidget {
  const _LoadingStateWidget();

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 180,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF002B55),
          ),
          SizedBox(height: 14),
          Text(
            'جاري تحميل المؤشرات المالية...',
            style: TextStyle(
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return const _StateContainer(
      icon: Icons.inbox_outlined,
      title: 'لا توجد بيانات',
      message: 'لا توجد مؤشرات مالية ضمن الفترة والنطاق المحددين.',
    );
  }
}

class _ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorStateWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 45,
            color: Color(0xFFC62828),
          ),
          const SizedBox(height: 12),
          const Text(
            'تعذر تحميل البيانات',
            style: TextStyle(
              color: Color(0xFF101828),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class _StateContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _StateContainer({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 45,
            color: const Color(0xFF98A2B3),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101828),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}