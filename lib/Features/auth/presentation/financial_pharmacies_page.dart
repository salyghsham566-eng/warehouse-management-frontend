import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacies_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacies_event.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacies_state.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_bloc.dart';
import 'package:project_2/Features/auth/data/models/financial_pharmacy_model.dart';
import 'package:project_2/Features/auth/presentation/financial_pharmacy_details_page.dart';

class FinancialPharmaciesPage
    extends StatefulWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final String regionId;
  final String regionName;

  const FinancialPharmaciesPage({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.regionId,
    required this.regionName,
  });

  @override
  State<FinancialPharmaciesPage> createState() =>
      _FinancialPharmaciesPageState();
}

class _FinancialPharmaciesPageState
    extends State<FinancialPharmaciesPage> {
  static const Color _primaryColor =
      Color(0xFF002B55);

  static const Color _backgroundColor =
      Color(0xFFF5F7FC);

  FinancialPharmacySort _selectedSort =
      FinancialPharmacySort.highestSales;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _loadPharmacies();
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
            'الصيدليات المالية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<
              FinancialPharmaciesBloc,
              FinancialPharmaciesState>(
            builder: (context, state) {
              final isLoading =
                  state is FinancialPharmaciesLoading;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildFilterSummary(),
                  const SizedBox(height: 12),
                  _buildSortCard(
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 16),
                  _buildStateContent(state),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_pharmacy_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  widget.regionName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'من ${_formatDate(widget.fromDate)} إلى ${_formatDate(widget.toDate)}',
                  style: const TextStyle(
                    color: Colors.white70,
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

  Widget _buildSortCard({
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      child: DropdownButtonFormField<
          FinancialPharmacySort>(
        value: _selectedSort,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'ترتيب الصيدليات',
          prefixIcon: const Icon(
            Icons.sort_rounded,
          ),
          filled: true,
          fillColor: const Color(0xFFF5F7FC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: Color(0xFFD8DFEB),
            ),
          ),
        ),
        items: FinancialPharmacySort.values
            .map(
              (sort) => DropdownMenuItem(
                value: sort,
                child: Text(sort.label),
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
                  _selectedSort = value;
                });

                _loadPharmacies();
              },
      ),
    );
  }

  Widget _buildStateContent(
    FinancialPharmaciesState state,
  ) {
    if (state is FinancialPharmaciesInitial ||
        state is FinancialPharmaciesLoading) {
      return const _LoadingWidget();
    }

    if (state is FinancialPharmaciesEmpty) {
      return const _MessageWidget(
        icon: Icons.inbox_outlined,
        title: 'لا توجد صيدليات',
        message:
            'لا توجد بيانات مالية للصيدليات ضمن الفترة والنطاق المحددين.',
      );
    }

    if (state is FinancialPharmaciesFailure) {
      return _ErrorWidget(
        message: state.message,
        onRetry: _loadPharmacies,
      );
    }

    if (state is FinancialPharmaciesSuccess) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.list_alt_outlined,
                color: _primaryColor,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'عدد الصيدليات: ${state.response.totalItems}',
                  style: const TextStyle(
                    color: _primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _loadPharmacies,
                icon: const Icon(
                  Icons.refresh,
                ),
                color: _primaryColor,
                tooltip: 'تحديث',
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...state.response.pharmacies.map(
            (pharmacy) => Padding(
              padding:
                  const EdgeInsets.only(bottom: 12),
              child: _FinancialPharmacyCard(
                pharmacy: pharmacy,
                  onOpenDetails: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider<
              FinancialPharmacyDetailsBloc>(
            create: (_) =>
                sl<FinancialPharmacyDetailsBloc>(),
            child: FinancialPharmacyDetailsPage(
              pharmacyId: pharmacy.id,
              fromDate: widget.fromDate,
              toDate: widget.toDate,
            ),
          );
        },
      ),
    );
  },
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _loadPharmacies() {
    context.read<FinancialPharmaciesBloc>().add(
          LoadFinancialPharmaciesEvent(
            fromDate: widget.fromDate,
            toDate: widget.toDate,
            regionId: widget.regionId,
            sort: _selectedSort,
          ),
        );
  }

  String _formatDate(DateTime date) {
    final day =
        date.day.toString().padLeft(2, '0');
    final month =
        date.month.toString().padLeft(2, '0');

    return '${date.year}/$month/$day';
  }
}

class _FinancialPharmacyCard
    extends StatelessWidget {
  final FinancialPharmacyModel pharmacy;
  final VoidCallback onOpenDetails;
  const _FinancialPharmacyCard({
    required this.pharmacy,
    required this.onOpenDetails,
  });

  static const Color _primaryColor =
      Color(0xFF002B55);

  static const Color _greenColor =
      Color(0xFF00875A);

  static const Color _redColor =
      Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 49,
                height: 49,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.local_pharmacy_outlined,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacy.name,
                      style: const TextStyle(
                        color: _primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  'تحصيل ${pharmacy.formattedCollectionRate}',
                  style: const TextStyle(
                    color: Color(0xFFB54708),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF667085),
                size: 19,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  pharmacy.address,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Row(
            children: [
              Expanded(
                child: _MoneyItem(
                  title: 'المبيعات',
                  value: pharmacy.formattedSales,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MoneyItem(
                  title: 'التحصيلات',
                  value:
                      pharmacy.formattedCollections,
                  color: _greenColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MoneyItem(
                  title: 'الذمم',
                  value:
                      pharmacy.formattedReceivables,
                  color: _redColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _CountItem(
                  icon: Icons.description_outlined,
                  title:
                      '${pharmacy.invoicesCount} فاتورة',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CountItem(
                  icon: Icons.sync_alt_outlined,
                  title:
                      '${pharmacy.collectionsCount} عملية تحصيل',
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          _TransactionItem(
            title: 'آخر فاتورة',
            icon: Icons.receipt_long_outlined,
            transaction: pharmacy.lastInvoice,
            color: _primaryColor,
          ),
          const SizedBox(height: 10),
          _TransactionItem(
            title: 'آخر دفعة',
            icon:
                Icons.account_balance_wallet_outlined,
            transaction: pharmacy.lastPayment,
            color: _greenColor,
          ),
        
      
      const SizedBox(height: 14),

SizedBox(
  width: double.infinity,
  height: 46,
  child: OutlinedButton.icon(
    onPressed: onOpenDetails,
    style: OutlinedButton.styleFrom(
      foregroundColor:
          const Color(0xFF002B55),
      side: const BorderSide(
        color: Color(0xFF002B55),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    icon: const Icon(
      Icons.analytics_outlined,
      size: 20,
    ),
    label: const Text(
      'عرض البطاقة المالية',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
    
 ]) );}
  
}

class _MoneyItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MoneyItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: color,
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

class _CountItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CountItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF475467),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF475467),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final FinancialTransactionSummaryModel?
      transaction;

  const _TransactionItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final value = transaction;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: color,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
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
              const SizedBox(height: 4),
              if (value == null)
                const Text(
                  'لا توجد عملية مسجلة',
                  style: TextStyle(
                    color: Color(0xFF98A2B3),
                    fontSize: 12,
                  ),
                )
              else
                Text(
                  '${value.referenceNumber} • '
                  '${value.formattedDate} • '
                  '${value.formattedAmount}',
                  style: const TextStyle(
                    color: Color(0xFF344054),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF002B55),
          ),
          SizedBox(height: 14),
          Text(
            'جاري تحميل الصيدليات المالية...',
            style: TextStyle(
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _MessageWidget({
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 44,
            color: const Color(0xFF98A2B3),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ),
          ),
          const SizedBox(height: 14),
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