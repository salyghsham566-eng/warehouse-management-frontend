import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_event.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_state.dart';
import 'package:project_2/Features/auth/bloc/pharmacy_account_statement_bloc.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_details_model.dart';
import 'package:project_2/Features/auth/presentation/pharmacy_account_statement_page.dart';

class FinancialPharmacyDetailsPage
    extends StatefulWidget {
  final String pharmacyId;
  final DateTime fromDate;
  final DateTime toDate;

  const FinancialPharmacyDetailsPage({
    super.key,
    required this.pharmacyId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<FinancialPharmacyDetailsPage> createState() =>
      _FinancialPharmacyDetailsPageState();
}

class _FinancialPharmacyDetailsPageState
    extends State<FinancialPharmacyDetailsPage> {
  static const Color _primaryColor =
      Color(0xFF002B55);

  static const Color _backgroundColor =
      Color(0xFFF5F7FC);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _loadDetails();
        }
      },
    );
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
            'بطاقة الصيدلية المالية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<
              FinancialPharmacyDetailsBloc,
              FinancialPharmacyDetailsState>(
            builder: (context, state) {
              if (state
                      is FinancialPharmacyDetailsInitial ||
                  state
                      is FinancialPharmacyDetailsLoading) {
                return const _LoadingView();
              }

              if (state
                  is FinancialPharmacyDetailsFailure) {
                return _ErrorView(
                  message: state.message,
                  onRetry: _loadDetails,
                );
              }

              if (state
                  is FinancialPharmacyDetailsSuccess) {
                return _DetailsContent(
                  details: state.details,
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
    context.read<FinancialPharmacyDetailsBloc>().add(
          LoadFinancialPharmacyDetailsEvent(
            pharmacyId: widget.pharmacyId,
            fromDate: widget.fromDate,
            toDate: widget.toDate,
          ),
        );
  }
}

class _DetailsContent extends StatelessWidget {
  final FinancialPharmacyDetailsModel details;

  const _DetailsContent({
    required this.details,
  });

  static const Color _primaryColor =
      Color(0xFF002B55);

  static const Color _greenColor =
      Color(0xFF00875A);

  static const Color _redColor =
      Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FinancialPharmacyDetailsBloc>().add(
              LoadFinancialPharmacyDetailsEvent(
                pharmacyId: details.id,
                fromDate: details.fromDate,
                toDate: details.toDate,
              ),
            );
      },
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _buildPharmacyHeader(),
          const SizedBox(height: 12),
          _buildPeriodCard(),
          const SizedBox(height: 18),

          const _SectionTitle(
            title: 'المؤشرات المالية',
            icon:
                Icons.account_balance_wallet_outlined,
          ),

          const SizedBox(height: 10),

          _FinancialValueCard(
            title: 'إجمالي المبيعات',
            value: details.formattedSales,
            icon: Icons.payments_outlined,
            color: _primaryColor,
          ),

          const SizedBox(height: 10),

          _FinancialValueCard(
            title: 'إجمالي التحصيلات',
            value: details.formattedCollections,
            icon:
                Icons.account_balance_wallet_outlined,
            color: _greenColor,
          ),

          const SizedBox(height: 10),

          _FinancialValueCard(
            title: 'الذمم الباقية',
            value: details.formattedReceivables,
            icon: details.isFullyPaid
                ? Icons.verified_outlined
                : Icons.money_off_csred_outlined,
            color: details.isFullyPaid
                ? _greenColor
                : _redColor,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _CountCard(
                  title: 'عدد الفواتير',
                  value:
                      details.invoicesCount.toString(),
                  icon: Icons.description_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CountCard(
                  title: 'عمليات التحصيل',
                  value: details.collectionsCount
                      .toString(),
                  icon: Icons.sync_alt_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _AverageCollectionCard(
            details: details,
          ),

          const SizedBox(height: 20),

          const _SectionTitle(
            title: 'عمليات البيع',
            icon: Icons.receipt_long_outlined,
          ),

          const SizedBox(height: 10),

          _SaleCard(
            title: 'أول عملية بيع',
            sale: details.firstSale,
            icon: Icons.first_page_outlined,
          ),

          const SizedBox(height: 12),

          _SaleCard(
            title: 'آخر عملية بيع',
            sale: details.lastSale,
            icon: Icons.last_page_outlined,
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) {
        return BlocProvider<
            PharmacyAccountStatementBloc>(
          create: (_) =>
              sl<PharmacyAccountStatementBloc>(),
          child: PharmacyAccountStatementPage(
            pharmacyId: details.id,
            fromDate: details.fromDate,
            toDate: details.toDate,
          ),
        );
      },
    ),
  );
},
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(
                Icons.receipt_long_outlined,
              ),
              label: const Text(
                'كشف حساب صيدلية',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius:
                  BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFCFE0FA),
              ),
            ),
            child: const Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: _primaryColor,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'هذه الشاشة مخصصة لعرض وتحليل بيانات الصيدلية فقط. تسجيل الدفعات يتم من قسم التحصيل.',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildPharmacyHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_pharmacy_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  details.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  details.regionName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        details.address,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodCard() {
    return Container(
      padding: const EdgeInsets.all(14),
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
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.date_range_outlined,
              color: _primaryColor,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'الفترة المالية',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'من ${formatFinancialPharmacyDate(details.fromDate)} '
                  'إلى ${formatFinancialPharmacyDate(details.toDate)}',
                  style: const TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
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
}

class _FinancialValueCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _FinancialValueCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
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
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment:
                      AlignmentDirectional.centerStart,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
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
      constraints: const BoxConstraints(
        minHeight: 125,
      ),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF002B55),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF002B55),
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _AverageCollectionCard
    extends StatelessWidget {
  final FinancialPharmacyDetailsModel details;

  const _AverageCollectionCard({
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1DCFF),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF6B4EFF)
                      .withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.calculate_outlined,
              color: Color(0xFF6B4EFF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'متوسط التحصيل',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  details
                      .formattedAverageCollection,
                  style: const TextStyle(
                    color: Color(0xFF6B4EFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'نسبة التحصيل من المبيعات: '
                  '${details.formattedCollectionRate}',
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 11,
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

class _SaleCard extends StatelessWidget {
  final String title;
  final FinancialPharmacySaleModel? sale;
  final IconData icon;

  const _SaleCard({
    required this.title,
    required this.sale,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final value = sale;

    if (value == null) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Text(
          'لا توجد بيانات لـ $title',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF667085),
          ),
        ),
      );
    }

    final statusColor = value.isPaid
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
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color:
                      const Color(0xFF002B55),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color:
                            Color(0xFF002B55),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value.invoiceNumber,
                      style: const TextStyle(
                        color:
                            Color(0xFF667085),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      statusColor.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  value.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _DetailLine(
            title: 'التاريخ',
            value: value.formattedDate,
          ),
          _DetailLine(
            title: 'قيمة الفاتورة',
            value: value.formattedAmount,
          ),
          _DetailLine(
            title: 'المبلغ المسدد',
            value: value.formattedPaidAmount,
            valueColor:
                const Color(0xFF00875A),
          ),
          _DetailLine(
            title: 'المبلغ الباقي',
            value:
                value.formattedRemainingAmount,
            valueColor: value.isPaid
                ? const Color(0xFF00875A)
                : const Color(0xFFC62828),
          ),
        ],
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
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF667085),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: valueColor ??
                    const Color(0xFF344054),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
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
        const SizedBox(width: 7),
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

class _LoadingView extends StatelessWidget {
  const _LoadingView();

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
            'جاري تحميل بطاقة الصيدلية...',
            style: TextStyle(
              color: Color(0xFF667085),
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
                size: 44,
                color: Color(0xFFC62828),
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
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label:
                    const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}