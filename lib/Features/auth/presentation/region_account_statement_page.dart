import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/region_account_statement_bloc.dart';
import 'package:project_2/Features/auth/bloc/region_account_statement_event.dart';
import 'package:project_2/Features/auth/bloc/region_account_statement_state.dart';
import 'package:project_2/Features/auth/data/models/financial_dashboard_model.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';
import 'package:project_2/Features/auth/presentation/financial_pharmacy_details_page.dart';
import 'package:project_2/Features/auth/presentation/region_statement_pdf_preview_page.dart';
import 'package:project_2/Features/auth/services/region_statement_pdf_service.dart';

class RegionAccountStatementPage
    extends StatefulWidget {
  final FinancialDashboardModel dashboard;

  const RegionAccountStatementPage({
    super.key,
    required this.dashboard,
  });

  @override
  State<RegionAccountStatementPage> createState() =>
      _RegionAccountStatementPageState();
}

class _RegionAccountStatementPageState
    extends State<RegionAccountStatementPage> {
  static const Color _primaryColor =
      Color(0xFF002B55);

  static const Color _backgroundColor =
      Color(0xFFF5F7FC);

  bool _isExporting = false;
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _loadStatement();
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
            'كشف حساب المنطقة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<
              RegionAccountStatementBloc,
              RegionAccountStatementState>(
            builder: (context, state) {
              if (state is RegionAccountStatementInitial ||
                  state is RegionAccountStatementLoading) {
                return const _LoadingView();
              }

              if (state is RegionAccountStatementEmpty) {
                return const _EmptyView();
              }

              if (state is RegionAccountStatementFailure) {
                return _ErrorView(
                  message: state.message,
                  onRetry: _loadStatement,
                );
              }

              if (state is RegionAccountStatementSuccess) {
                return _StatementContent(
                  statement: state.statement,
                  isExporting: _isExporting,
                  isPrinting: _isPrinting,
                  onRefresh: _loadStatement,
                  onOpenPharmacy: _openPharmacy,
                  onPreview: () {
                    _previewPdf(
                      state.statement,
                    );
                  },
                  onExport: () {
                    _exportPdf(
                      state.statement,
                    );
                  },
                  onPrint: () {
                    _printPdf(
                      state.statement,
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _loadStatement() {
    context.read<RegionAccountStatementBloc>().add(
          LoadRegionAccountStatementEvent(
            regionId: widget.dashboard.scopeId,
            fromDate: widget.dashboard.fromDate,
            toDate: widget.dashboard.toDate,
          ),
        );
  }

  void _openPharmacy(
    RegionStatementPharmacyModel pharmacy,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider<
              FinancialPharmacyDetailsBloc>(
            create: (_) =>
                sl<FinancialPharmacyDetailsBloc>(),
            child: FinancialPharmacyDetailsPage(
              pharmacyId: pharmacy.id,
              fromDate: widget.dashboard.fromDate,
              toDate: widget.dashboard.toDate,
            ),
          );
        },
      ),
    );
  }

  void _previewPdf(
    RegionAccountStatementModel statement,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return RegionStatementPdfPreviewPage(
            statement: statement,
            pdfService:
                sl<RegionStatementPdfService>(),
          );
        },
      ),
    );
  }

  Future<void> _exportPdf(
    RegionAccountStatementModel statement,
  ) async {
    if (_isExporting) {
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      final bytes =
          await sl<RegionStatementPdfService>()
              .buildPdf(statement);

      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'region_statement_${statement.regionId}.pdf',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر استخراج ملف PDF: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _printPdf(
    RegionAccountStatementModel statement,
  ) async {
    if (_isPrinting) {
      return;
    }

    setState(() {
      _isPrinting = true;
    });

    try {
      await Printing.layoutPdf(
        name:
            'region_statement_${statement.regionId}.pdf',
        onLayout: (_) {
          return sl<RegionStatementPdfService>()
              .buildPdf(statement);
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذرت طباعة كشف الحساب: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPrinting = false;
        });
      }
    }
  }
}

class _StatementContent extends StatelessWidget {
  final RegionAccountStatementModel statement;
  final bool isExporting;
  final bool isPrinting;

  final VoidCallback onRefresh;
  final VoidCallback onPreview;
  final VoidCallback onExport;
  final VoidCallback onPrint;

  final ValueChanged<RegionStatementPharmacyModel>
      onOpenPharmacy;

  const _StatementContent({
    required this.statement,
    required this.isExporting,
    required this.isPrinting,
    required this.onRefresh,
    required this.onPreview,
    required this.onExport,
    required this.onPrint,
    required this.onOpenPharmacy,
  });

  static const Color _primaryColor =
      Color(0xFF002B55);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _ScopeHeader(
            statement: statement,
          ),
          const SizedBox(height: 12),
          _SummaryCounters(
            summary: statement.summary,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: _SectionTitle(
                  title: 'صيدليات الكشف',
                  icon: Icons.table_chart_outlined,
                ),
              ),
              IconButton(
                onPressed: onRefresh,
                color: _primaryColor,
                tooltip: 'تحديث',
                icon: const Icon(
                  Icons.refresh,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _PharmaciesTable(
            pharmacies: statement.pharmacies,
            onOpenPharmacy: onOpenPharmacy,
          ),
          const SizedBox(height: 20),
          const _SectionTitle(
            title: 'إجماليات الكشف',
            icon: Icons.summarize_outlined,
          ),
          const SizedBox(height: 10),
          _FinancialTotalsCard(
            summary: statement.summary,
          ),
          const SizedBox(height: 18),
          _PdfActions(
            isExporting: isExporting,
            isPrinting: isPrinting,
            onPreview: onPreview,
            onExport: onExport,
            onPrint: onPrint,
          ),
          const SizedBox(height: 14),
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
                    'يمكن فتح البطاقة المالية لأي صيدلية من الجدول. هذه الشاشة للعرض والتقارير فقط، وتسجيل الدفعات يتم من قسم التحصيل.',
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
}

class _ScopeHeader extends StatelessWidget {
  final RegionAccountStatementModel statement;

  const _ScopeHeader({
    required this.statement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF002B55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              statement.isAllRegions
                  ? Icons.public_outlined
                  : Icons.location_on_outlined,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'نطاق كشف الحساب',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statement.regionName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'من ${formatRegionStatementDate(statement.fromDate)} '
                  'إلى ${formatRegionStatementDate(statement.toDate)}',
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
}

class _SummaryCounters extends StatelessWidget {
  final RegionStatementSummaryModel summary;

  const _SummaryCounters({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CounterCard(
            title: 'الصيدليات',
            value: summary.pharmaciesCount.toString(),
            icon: Icons.local_pharmacy_outlined,
            color: const Color(0xFF002B55),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CounterCard(
            title: 'المدينة',
            value:
                summary.debtorPharmaciesCount.toString(),
            icon: Icons.money_off_csred_outlined,
            color: const Color(0xFFC62828),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CounterCard(
            title: 'المسددة',
            value: summary.fullyPaidPharmaciesCount
                .toString(),
            icon: Icons.verified_outlined,
            color: const Color(0xFF00875A),
          ),
        ),
      ],
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _CounterCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 120,
      ),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 26,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _PharmaciesTable extends StatelessWidget {
  final List<RegionStatementPharmacyModel>
      pharmacies;

  final ValueChanged<RegionStatementPharmacyModel>
      onOpenPharmacy;

  const _PharmaciesTable({
    required this.pharmacies,
    required this.onOpenPharmacy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              WidgetStateProperty.all(
            const Color(0xFF002B55),
          ),
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          dataTextStyle: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 12,
          ),
          columnSpacing: 24,
          horizontalMargin: 14,
          showCheckboxColumn: false,
          columns: const [
            DataColumn(
              label: Text('الصيدلية'),
            ),
            DataColumn(
              label: Text('المنطقة'),
            ),
            DataColumn(
              label: Text('آخر فاتورة'),
            ),
            DataColumn(
              label: Text('آخر دفعة'),
            ),
            DataColumn(
              numeric: true,
              label: Text('مدين'),
            ),
            DataColumn(
              numeric: true,
              label: Text('دائن'),
            ),
            DataColumn(
              numeric: true,
              label: Text('الرصيد'),
            ),
            DataColumn(
              label: Text('فتح'),
            ),
          ],
          rows: pharmacies.map(
            (pharmacy) {
              final balanceColor =
                  pharmacy.isFullyPaid
                      ? const Color(0xFF00875A)
                      : const Color(0xFFC62828);

              return DataRow(
                onSelectChanged: (_) {
                  onOpenPharmacy(pharmacy);
                },
                cells: [
                  DataCell(
                    SizedBox(
                      width: 145,
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacy.name,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:
                                  Color(0xFF002B55),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            pharmacy.address,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color:
                                  Color(0xFF667085),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 125,
                      child: Text(
                        pharmacy.regionName,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    _TransactionTableCell(
                      transaction:
                          pharmacy.lastInvoice,
                      emptyText: 'لا توجد فاتورة',
                      color:
                          const Color(0xFF002B55),
                    ),
                  ),
                  DataCell(
                    _TransactionTableCell(
                      transaction:
                          pharmacy.lastPayment,
                      emptyText: 'لا توجد دفعة',
                      color:
                          const Color(0xFF00875A),
                    ),
                  ),
                  DataCell(
                    Text(
                      pharmacy.formattedDebit,
                      style: const TextStyle(
                        color: Color(0xFFC62828),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      pharmacy.formattedCredit,
                      style: const TextStyle(
                        color: Color(0xFF00875A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      pharmacy.formattedBalance,
                      style: TextStyle(
                        color: balanceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      onPressed: () {
                        onOpenPharmacy(pharmacy);
                      },
                      tooltip:
                          'فتح البطاقة المالية',
                      color:
                          const Color(0xFF002B55),
                      icon: const Icon(
                        Icons.open_in_new_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

class _TransactionTableCell
    extends StatelessWidget {
  final RegionStatementTransactionModel?
      transaction;

  final String emptyText;
  final Color color;

  const _TransactionTableCell({
    required this.transaction,
    required this.emptyText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final value = transaction;

    if (value == null) {
      return SizedBox(
        width: 125,
        child: Text(
          emptyText,
          style: const TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 10,
          ),
        ),
      );
    }

    return SizedBox(
      width: 135,
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            value.operationNumber,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.formattedDate,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.formattedAmount,
            style: const TextStyle(
              color: Color(0xFF344054),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialTotalsCard
    extends StatelessWidget {
  final RegionStatementSummaryModel summary;

  const _FinancialTotalsCard({
    required this.summary,
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
          _TotalLine(
            title: 'إجمالي المدين',
            value: summary.formattedTotalDebit,
            color: const Color(0xFFC62828),
          ),
          const Divider(height: 24),
          _TotalLine(
            title: 'إجمالي الدائن',
            value: summary.formattedTotalCredit,
            color: const Color(0xFF00875A),
          ),
          const Divider(height: 24),
          _TotalLine(
            title: 'إجمالي الرصيد',
            value: summary.formattedTotalBalance,
            color: const Color(0xFF002B55),
            isLarge: true,
          ),
        ],
      ),
    );
  }
}

class _TotalLine extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool isLarge;

  const _TotalLine({
    required this.title,
    required this.value,
    required this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF667085),
              fontSize: isLarge ? 15 : 13,
              fontWeight: isLarge
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: isLarge ? 21 : 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PdfActions extends StatelessWidget {
  final bool isExporting;
  final bool isPrinting;

  final VoidCallback onPreview;
  final VoidCallback onExport;
  final VoidCallback onPrint;

  const _PdfActions({
    required this.isExporting,
    required this.isPrinting,
    required this.onPreview,
    required this.onExport,
    required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: onPreview,
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  const Color(0xFF002B55),
              backgroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFF002B55),
                width: 1.3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
            ),
            icon: const Icon(
              Icons.picture_as_pdf_outlined,
            ),
            label: const Text(
              'معاينة PDF',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      isExporting ? null : onExport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF002B55),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFF002B55)
                            .withOpacity(0.55),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  icon: isExporting
                      ? const SizedBox(
                          width: 19,
                          height: 19,
                          child:
                              CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.download_outlined,
                        ),
                  label: Text(
                    isExporting
                        ? 'جاري الاستخراج...'
                        : 'استخراج PDF',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      isPrinting ? null : onPrint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF475467),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFF475467)
                            .withOpacity(0.55),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  icon: isPrinting
                      ? const SizedBox(
                          width: 19,
                          height: 19,
                          child:
                              CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.print_outlined,
                        ),
                  label: Text(
                    isPrinting
                        ? 'جاري التحضير...'
                        : 'طباعة',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
            'جاري تحميل كشف حساب المنطقة...',
            style: TextStyle(
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'لا توجد صيدليات أو حركات مالية ضمن الفترة والنطاق المحددين.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF667085),
            height: 1.5,
          ),
        ),
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
            borderRadius:
                BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 45,
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
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'إعادة المحاولة',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}