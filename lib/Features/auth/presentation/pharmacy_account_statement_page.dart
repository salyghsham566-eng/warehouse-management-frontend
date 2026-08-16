import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/pharmacy_account_statement_bloc.dart';
import 'package:project_2/Features/auth/bloc/pharmacy_account_statement_event.dart';
import 'package:project_2/Features/auth/bloc/pharmacy_account_statement_state.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';
import 'package:project_2/Features/auth/presentation/harmacy_statement_pdf_preview_page.dart';
import 'package:project_2/Features/auth/services/pharmacy_statement_pdf_service.dart';
import 'package:project_2/Features/auth/services/statement_pdf_exporter.dart';

class PharmacyAccountStatementPage
    extends StatefulWidget {
  final String pharmacyId;
  final DateTime fromDate;
  final DateTime toDate;

  const PharmacyAccountStatementPage({
    super.key,
    required this.pharmacyId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<PharmacyAccountStatementPage> createState() =>
      _PharmacyAccountStatementPageState();
}

class _PharmacyAccountStatementPageState
    extends State<PharmacyAccountStatementPage> {
  static const Color _primaryColor =
      Color(0xFF002B55);

  static const Color _backgroundColor =
      Color(0xFFF5F7FC);

  bool _isExporting = false;

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
            'كشف حساب الصيدلية',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<
              PharmacyAccountStatementBloc,
              PharmacyAccountStatementState>(
            builder: (context, state) {
              if (state
                      is PharmacyAccountStatementInitial ||
                  state
                      is PharmacyAccountStatementLoading) {
                return const _StatementLoadingView();
              }

              if (state
                  is PharmacyAccountStatementFailure) {
                return _StatementErrorView(
                  message: state.message,
                  onRetry: _loadStatement,
                );
              }

              if (state
                  is PharmacyAccountStatementSuccess) {
                return _StatementContent(
                  statement: state.statement,
                  isExporting: _isExporting,
                  onPreviewPdf: () {
                    _previewPdf(
                      state.statement,
                    );
                  },
                  onExportPdf: () {
                    _exportPdf(
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
    context.read<PharmacyAccountStatementBloc>().add(
          LoadPharmacyAccountStatementEvent(
            pharmacyId: widget.pharmacyId,
            fromDate: widget.fromDate,
            toDate: widget.toDate,
          ),
        );
  }

  void _previewPdf(
    PharmacyAccountStatementModel statement,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PharmacyStatementPdfPreviewPage(
            statement: statement,
            pdfService:
                sl<PharmacyStatementPdfService>(),
          );
        },
      ),
    );
  }

  Future<void> _exportPdf(
    PharmacyAccountStatementModel statement,
  ) async {
    if (_isExporting) {
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      final pdfBytes =
          await sl<PharmacyStatementPdfService>()
              .buildPdf(statement);

      await exportStatementPdf(
        bytes: pdfBytes,
        filename:
            'pharmacy_statement_${statement.pharmacy.id}.pdf',
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
}

class _StatementContent extends StatelessWidget {
  final PharmacyAccountStatementModel statement;
  final bool isExporting;
  final VoidCallback onPreviewPdf;
  final VoidCallback onExportPdf;

  const _StatementContent({
    required this.statement,
    required this.isExporting,
    required this.onPreviewPdf,
    required this.onExportPdf,
  });

  static const Color _primaryColor =
      Color(0xFF002B55);

  static const Color _greenColor =
      Color(0xFF00875A);

  static const Color _redColor =
      Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _PharmacyStatementHeader(
          statement: statement,
        ),
        const SizedBox(height: 12),
        _OpeningBalanceCard(
          openingBalance:
              statement.formattedOpeningBalance,
        ),
        const SizedBox(height: 20),
        const _StatementSectionTitle(
          title: 'الجدول الزمني للحركات',
          icon: Icons.timeline_outlined,
        ),
        const SizedBox(height: 10),
        if (statement.movements.isEmpty)
          const _EmptyMovementsCard()
        else
          _StatementMovementsTable(
            movements: statement.movements,
          ),
        const SizedBox(height: 20),
        const _StatementSectionTitle(
          title: 'الملخص النهائي',
          icon: Icons.summarize_outlined,
        ),
        const SizedBox(height: 10),
        _StatementSummaryCard(
          statement: statement,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: onPreviewPdf,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryColor,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: _primaryColor,
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
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      isExporting ? null : onExportPdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        _primaryColor.withOpacity(0.55),
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
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(14),
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
                  'الفواتير تظهر كحركة مدينة، ودفعات التحصيل تظهر كحركة دائنة. هذه الشاشة للعرض والتقارير فقط.',
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
    );
  }
}

class _PharmacyStatementHeader
    extends StatelessWidget {
  final PharmacyAccountStatementModel statement;

  const _PharmacyStatementHeader({
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
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
                  statement.pharmacy.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  statement.pharmacy.regionName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white70,
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        statement.pharmacy.address,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  'من ${formatStatementDate(statement.fromDate)} '
                  'إلى ${formatStatementDate(statement.toDate)}',
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

class _OpeningBalanceCard extends StatelessWidget {
  final String openingBalance;

  const _OpeningBalanceCard({
    required this.openingBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFCFE0FA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.history_outlined,
              color: Color(0xFF002B55),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'الرصيد السابق',
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                openingBalance,
                style: const TextStyle(
                  color: Color(0xFF002B55),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatementMovementsTable
    extends StatelessWidget {
  final List<PharmacyStatementMovementModel>
      movements;

  const _StatementMovementsTable({
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // على الشاشات الصغيرة لا نحاول ضغط 6 أعمدة داخل عرض الهاتف.
        // نعرض نفس البيانات كبطاقات مرتبة، بينما يبقى الجدول كما هو
        // على التابلت والويب/الكمبيوتر.
        if (constraints.maxWidth < 720) {
          return _MobileMovementsList(
            movements: movements,
          );
        }

        return _DesktopMovementsTable(
          movements: movements,
        );
      },
    );
  }
}

class _DesktopMovementsTable
    extends StatelessWidget {
  final List<PharmacyStatementMovementModel>
      movements;

  const _DesktopMovementsTable({
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          headingRowColor: MaterialStateProperty.all(
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
          columnSpacing: 25,
          horizontalMargin: 14,
          columns: const [
            DataColumn(
              label: Text('التاريخ'),
            ),
            DataColumn(
              label: Text('نوع الحركة'),
            ),
            DataColumn(
              label: Text('رقم العملية'),
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
          ],
          rows: movements.map(
            (movement) {
              final typeColor = movement.isInvoice
                  ? const Color(0xFFC62828)
                  : const Color(0xFF00875A);

              return DataRow(
                cells: [
                  DataCell(
                    Text(movement.formattedDate),
                  ),
                  DataCell(
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color:
                            typeColor.withOpacity(0.10),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        movement.movementTypeLabel,
                        style: TextStyle(
                          color: typeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(movement.operationNumber),
                  ),
                  DataCell(
                    Text(
                      movement.formattedDebit,
                      style: const TextStyle(
                        color: Color(0xFFC62828),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      movement.formattedCredit,
                      style: const TextStyle(
                        color: Color(0xFF00875A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      movement.formattedBalance,
                      style: const TextStyle(
                        color: Color(0xFF002B55),
                        fontWeight: FontWeight.bold,
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

class _MobileMovementsList extends StatelessWidget {
  final List<PharmacyStatementMovementModel>
      movements;

  const _MobileMovementsList({
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE1E6EF),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            color: const Color(0xFF002B55),
            child: const Text(
              'الحركات المالية',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...List.generate(
            movements.length,
            (index) {
              final movement = movements[index];
              final typeColor = movement.isInvoice
                  ? const Color(0xFFC62828)
                  : const Color(0xFF00875A);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _MobileMovementField(
                                label: 'التاريخ',
                                value:
                                    movement.formattedDate,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor
                                    .withOpacity(0.10),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(
                                movement.movementTypeLabel,
                                style: TextStyle(
                                  color: typeColor,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Expanded(
                              child: _MobileMovementField(
                                label: 'رقم العملية',
                                value:
                                    movement.operationNumber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MobileMovementField(
                                label: 'الرصيد',
                                value:
                                    movement.formattedBalance,
                                valueColor:
                                    const Color(0xFF002B55),
                                bold: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            Expanded(
                              child: _MobileMovementField(
                                label: 'مدين',
                                value:
                                    movement.formattedDebit,
                                valueColor:
                                    const Color(0xFFC62828),
                                bold: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MobileMovementField(
                                label: 'دائن',
                                value:
                                    movement.formattedCredit,
                                valueColor:
                                    const Color(0xFF00875A),
                                bold: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index != movements.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE9EDF3),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MobileMovementField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _MobileMovementField({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: valueColor ??
                const Color(0xFF344054),
            fontSize: 12,
            fontWeight:
                bold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatementSummaryCard
    extends StatelessWidget {
  final PharmacyAccountStatementModel statement;

  const _StatementSummaryCard({
    required this.statement,
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
          _SummaryLine(
            title: 'الرصيد السابق',
            value: statement.formattedOpeningBalance,
            color: const Color(0xFF002B55),
          ),
          const Divider(height: 24),
          _SummaryLine(
            title: 'إجمالي المدين',
            value:
                statement.summary.formattedTotalDebit,
            color: const Color(0xFFC62828),
          ),
          const Divider(height: 24),
          _SummaryLine(
            title: 'إجمالي الدائن',
            value:
                statement.summary.formattedTotalCredit,
            color: const Color(0xFF00875A),
          ),
          const Divider(height: 24),
          _SummaryLine(
            title: 'الرصيد النهائي',
            value: statement
                .summary.formattedClosingBalance,
            color: const Color(0xFF002B55),
            isLarge: true,
          ),
          const Divider(height: 24),
          _SummaryLine(
            title: 'عدد الحركات',
            value: statement.summary.movementsCount
                .toString(),
            color: const Color(0xFF475467),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool isLarge;

  const _SummaryLine({
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

class _StatementSectionTitle
    extends StatelessWidget {
  final String title;
  final IconData icon;

  const _StatementSectionTitle({
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

class _EmptyMovementsCard extends StatelessWidget {
  const _EmptyMovementsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 42,
            color: Color(0xFF98A2B3),
          ),
          SizedBox(height: 10),
          Text(
            'لا توجد حركات مالية ضمن الفترة المحددة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatementLoadingView
    extends StatelessWidget {
  const _StatementLoadingView();

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
            'جاري تحميل كشف الحساب...',
            style: TextStyle(
              color: Color(0xFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatementErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _StatementErrorView({
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