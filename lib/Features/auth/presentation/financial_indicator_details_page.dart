import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_indicator_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_indicator_details_event.dart';
import 'package:project_2/Features/auth/bloc/financial_indicator_details_state.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';
import 'package:project_2/Features/auth/data/models/financial_indicator_details_model.dart';

class FinancialIndicatorDetailsPage extends StatefulWidget {
  final FinancialMetricModel metric;
  final FinancialDashboardModel dashboard;

  const FinancialIndicatorDetailsPage({
    super.key,
    required this.metric,
    required this.dashboard,
  });

  @override
  State<FinancialIndicatorDetailsPage> createState() =>
      _FinancialIndicatorDetailsPageState();
}

class _FinancialIndicatorDetailsPageState
    extends State<FinancialIndicatorDetailsPage> {
  static const Color _primaryColor = Color(0xFF002B55);
  static const Color _backgroundColor = Color(0xFFF5F7FC);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDetails();
      }
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
          title: Text(
            widget.metric.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<
              FinancialIndicatorDetailsBloc,
              FinancialIndicatorDetailsState>(
            builder: (context, state) {
              if (state is FinancialIndicatorDetailsInitial ||
                  state is FinancialIndicatorDetailsLoading) {
                return const _DetailsLoadingWidget();
              }

              if (state is FinancialIndicatorDetailsFailure) {
                return _DetailsErrorWidget(
                  message: state.message,
                  onRetry: _loadDetails,
                );
              }

              if (state is FinancialIndicatorDetailsSuccess) {
                return _DetailsSuccessView(
                  response: state.response,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _loadDetails() {
    context.read<FinancialIndicatorDetailsBloc>().add(
          LoadFinancialIndicatorDetailsEvent(
            indicatorId: widget.metric.id,
            fromDate: widget.dashboard.fromDate,
            toDate: widget.dashboard.toDate,
            regionId: widget.dashboard.scopeId,
          ),
        );
  }
}

class _DetailsSuccessView extends StatelessWidget {
  final FinancialIndicatorDetailsResponseModel response;

  const _DetailsSuccessView({
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            10,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _IndicatorHeaderCard(
                  response: response,
                ),
                const SizedBox(height: 12),
                _ScopePeriodCard(
                  response: response,
                ),
                if (response.note != null &&
                    response.note!.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _InformationNotice(
                    message: response.note!,
                  ),
                ],
                const SizedBox(height: 18),
                _DetailsSectionTitle(
                  title: _sectionTitle(),
                  count: _sectionCount(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        ..._buildContentSlivers(),
        const SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
      ],
    );
  }

  String _sectionTitle() {
    if (response.showsInvoiceList) {
      return 'الفواتير';
    }

    if (response.showsPharmacyList) {
      return 'الصيدليات';
    }

    if (response.showsCollectionSummary) {
      return 'ملخص التحصيل';
    }

    if (response.showsAverageCalculation) {
      return 'طريقة الحساب';
    }

    if (response.showsInvoiceData) {
      return 'بيانات الفاتورة';
    }

    return 'تفاصيل المؤشر';
  }

  int? _sectionCount() {
    if (response.showsInvoiceList) {
      return response.invoices.length;
    }

    if (response.showsPharmacyList) {
      return response.pharmacies.length;
    }

    return null;
  }

  List<Widget> _buildContentSlivers() {
    if (response.showsInvoiceList) {
      if (response.invoices.isEmpty) {
        return [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _EmptyDetailsWidget(
                message: 'لا توجد فواتير ضمن الفترة المحددة.',
              ),
            ),
          ),
        ];
      }

      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InvoiceCard(
                    invoice: response.invoices[index],
                  ),
                );
              },
              childCount: response.invoices.length,
            ),
          ),
        ),
      ];
    }

    if (response.showsPharmacyList) {
      if (response.pharmacies.isEmpty) {
        return [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _EmptyDetailsWidget(
                message: 'لا توجد صيدليات ضمن هذا التصنيف.',
              ),
            ),
          ),
        ];
      }

      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PharmacyDetailsCard(
                    pharmacy: response.pharmacies[index],
                  ),
                );
              },
              childCount: response.pharmacies.length,
            ),
          ),
        ),
      ];
    }

    if (response.showsCollectionSummary) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CollectionSummaryCard(
              summary: response.collectionSummary,
            ),
          ),
        ),
      ];
    }

    if (response.showsAverageCalculation) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _AverageCalculationCard(
              calculation: response.averageCalculation,
            ),
          ),
        ),
      ];
    }

    if (response.showsInvoiceData) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: response.invoice == null
                ? const _EmptyDetailsWidget(
                    message: 'لا توجد بيانات فاتورة.',
                  )
                : _FullInvoiceDetailsCard(
                    invoice: response.invoice!,
                  ),
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _GenericSummaryCard(
            items: response.summaryItems,
          ),
        ),
      ),
    ];
  }
}

class _IndicatorHeaderCard extends StatelessWidget {
  final FinancialIndicatorDetailsResponseModel response;

  const _IndicatorHeaderCard({
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF002B55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 10),
          Text(
            response.indicatorTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            response.formattedValue,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScopePeriodCard extends StatelessWidget {
  final FinancialIndicatorDetailsResponseModel response;

  const _ScopePeriodCard({
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
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
              color: Color(0xFF002B55),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.regionName,
                  style: const TextStyle(
                    color: Color(0xFF002B55),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'من ${formatFinancialIndicatorDate(response.fromDate)} '
                  'إلى ${formatFinancialIndicatorDate(response.toDate)}',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
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

class _DetailsSectionTitle extends StatelessWidget {
  final String title;
  final int? count;

  const _DetailsSectionTitle({
    required this.title,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.list_alt_outlined,
          color: Color(0xFF002B55),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF002B55),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (count != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Color(0xFF002B55),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final FinancialIndicatorInvoiceModel invoice;

  const _InvoiceCard({
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = invoice.isPaid
        ? const Color(0xFF00875A)
        : const Color(0xFFD97706);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF002B55),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(
                        color: Color(0xFF002B55),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      invoice.pharmacyName,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  invoice.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          _DetailLine(
            title: 'التاريخ',
            value: invoice.formattedDate,
          ),
          _DetailLine(
            title: 'المنطقة',
            value: invoice.regionName,
          ),
          _DetailLine(
            title: 'قيمة الفاتورة',
            value: invoice.formattedAmount,
            valueColor: const Color(0xFF002B55),
          ),
          _DetailLine(
            title: 'المبلغ المسدد',
            value: invoice.formattedPaidAmount,
            valueColor: const Color(0xFF00875A),
          ),
          _DetailLine(
            title: 'المبلغ الباقي',
            value: invoice.formattedRemainingAmount,
            valueColor: invoice.isPaid
                ? const Color(0xFF00875A)
                : const Color(0xFFC62828),
          ),
        ],
      ),
    );
  }
}

class _PharmacyDetailsCard extends StatelessWidget {
  final FinancialIndicatorPharmacyModel pharmacy;

  const _PharmacyDetailsCard({
    required this.pharmacy,
  });

  @override
  Widget build(BuildContext context) {
    final balanceColor = pharmacy.isFullyPaid
        ? const Color(0xFF00875A)
        : const Color(0xFFC62828);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: balanceColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  pharmacy.isFullyPaid
                      ? Icons.verified_outlined
                      : Icons.local_pharmacy_outlined,
                  color: balanceColor,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: const TextStyle(
                        color: Color(0xFF002B55),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pharmacy.regionName,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Color(0xFF667085),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  pharmacy.address,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          _DetailLine(
            title: 'إجمالي المبيعات',
            value: pharmacy.formattedSales,
          ),
          _DetailLine(
            title: 'إجمالي التحصيلات',
            value: pharmacy.formattedCollections,
            valueColor: const Color(0xFF00875A),
          ),
          _DetailLine(
            title: 'الذمم الباقية',
            value: pharmacy.formattedReceivables,
            valueColor: balanceColor,
          ),
          _DetailLine(
            title: 'عدد الفواتير',
            value: '${pharmacy.invoicesCount}',
          ),
          _DetailLine(
            title: 'عدد عمليات التحصيل',
            value: '${pharmacy.collectionsCount}',
          ),
        ],
      ),
    );
  }
}

class _CollectionSummaryCard extends StatelessWidget {
  final FinancialCollectionSummaryModel? summary;

  const _CollectionSummaryCard({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final value = summary;

    if (value == null) {
      return const _EmptyDetailsWidget(
        message: 'لا يوجد ملخص تحصيل.',
      );
    }

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: Column(
        children: [
          _SummaryIcon(
            icon: Icons.account_balance_wallet_outlined,
            color: const Color(0xFF00875A),
          ),
          const SizedBox(height: 14),
          _DetailLine(
            title: 'إجمالي التحصيلات',
            value: value.formattedTotalCollections,
            valueColor: const Color(0xFF00875A),
          ),
          _DetailLine(
            title: 'عدد العمليات',
            value: '${value.operationsCount}',
          ),
          _DetailLine(
            title: 'العمليات المعتمدة',
            value: '${value.approvedOperationsCount}',
          ),
          _DetailLine(
            title: 'متوسط التحصيل',
            value: value.formattedAverageCollection,
          ),
          if (value.lastCollectionDate != null)
            _DetailLine(
              title: 'تاريخ آخر تحصيل',
              value: formatFinancialIndicatorDate(
                value.lastCollectionDate!,
              ),
            ),
          const SizedBox(height: 10),
          const _InformationNotice(
            message:
                'لعرض عمليات التحصيل بشكل كامل انتقل إلى قسم التحصيل.',
          ),
        ],
      ),
    );
  }
}

class _AverageCalculationCard extends StatelessWidget {
  final FinancialAverageCalculationModel? calculation;

  const _AverageCalculationCard({
    required this.calculation,
  });

  @override
  Widget build(BuildContext context) {
    final value = calculation;

    if (value == null) {
      return const _EmptyDetailsWidget(
        message: 'لا توجد بيانات كافية لحساب المتوسط.',
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: Column(
        children: [
          const _SummaryIcon(
            icon: Icons.calculate_outlined,
            color: Color(0xFF6B4EFF),
          ),
          const SizedBox(height: 15),
          const Text(
            'متوسط التحصيل',
            style: TextStyle(
              color: Color(0xFF002B55),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  value.formattedTotalCollections,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6B4EFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Text(
                  '${value.operationsCount} عملية تحصيل',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF475467),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF6B4EFF),
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            value.formattedResult,
            style: const TextStyle(
              color: Color(0xFF6B4EFF),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'إجمالي التحصيلات ÷ عدد عمليات التحصيل',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullInvoiceDetailsCard extends StatelessWidget {
  final FinancialIndicatorInvoiceModel invoice;

  const _FullInvoiceDetailsCard({
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: Column(
        children: [
          const _SummaryIcon(
            icon: Icons.receipt_long_outlined,
            color: Color(0xFF002B55),
          ),
          const SizedBox(height: 15),
          _DetailLine(
            title: 'رقم الفاتورة',
            value: invoice.invoiceNumber,
          ),
          _DetailLine(
            title: 'الصيدلية',
            value: invoice.pharmacyName,
          ),
          _DetailLine(
            title: 'المنطقة',
            value: invoice.regionName,
          ),
          _DetailLine(
            title: 'العنوان',
            value: invoice.address,
          ),
          _DetailLine(
            title: 'تاريخ الفاتورة',
            value: invoice.formattedDate,
          ),
          _DetailLine(
            title: 'قيمة الفاتورة',
            value: invoice.formattedAmount,
            valueColor: const Color(0xFF002B55),
          ),
          _DetailLine(
            title: 'المبلغ المسدد',
            value: invoice.formattedPaidAmount,
            valueColor: const Color(0xFF00875A),
          ),
          _DetailLine(
            title: 'المبلغ الباقي',
            value: invoice.formattedRemainingAmount,
            valueColor: invoice.isPaid
                ? const Color(0xFF00875A)
                : const Color(0xFFC62828),
          ),
          _DetailLine(
            title: 'الحالة',
            value: invoice.status,
          ),
        ],
      ),
    );
  }
}

class _GenericSummaryCard extends StatelessWidget {
  final List<FinancialIndicatorSummaryItemModel> items;

  const _GenericSummaryCard({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyDetailsWidget(
        message: 'لا توجد تفاصيل إضافية لهذا المؤشر.',
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: items
            .map(
              (item) => _DetailLine(
                title: item.label,
                value: item.value,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const _DetailLine({
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF667085),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                color:
                    valueColor ?? const Color(0xFF344054),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SummaryIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Icon(
        icon,
        color: color,
        size: 29,
      ),
    );
  }
}

class _InformationNotice extends StatelessWidget {
  final String message;

  const _InformationNotice({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFCFE0FA),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFF002B55),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF002B55),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDetailsWidget extends StatelessWidget {
  final String message;

  const _EmptyDetailsWidget({
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
          const Icon(
            Icons.inbox_outlined,
            color: Color(0xFF98A2B3),
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsLoadingWidget extends StatelessWidget {
  const _DetailsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF002B55),
          ),
          SizedBox(height: 14),
          Text(
            'جاري تحميل تفاصيل المؤشر...',
            style: TextStyle(
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DetailsErrorWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFC62828),
                size: 44,
              ),
              const SizedBox(height: 12),
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
        ),
      ),
    );
  }
}