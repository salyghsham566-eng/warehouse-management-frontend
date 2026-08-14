import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';

class RegionStatementPdfService {
  Future<Uint8List> buildPdf(
    RegionAccountStatementModel statement,
  ) async {
    final regularFont =
        await PdfGoogleFonts.cairoRegular();

    final boldFont =
        await PdfGoogleFonts.cairoBold();

    final document = pw.Document(
      title: 'كشف حساب ${statement.regionName}',
      author: 'Sales Representative',
      subject: 'كشف حساب منطقة',
    );

    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(24),
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(
        base: regularFont,
        bold: boldFont,
      ),
    );

    document.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox.shrink();
          }

          return pw.Container(
            margin: const pw.EdgeInsets.only(
              bottom: 10,
            ),
            padding: const pw.EdgeInsets.only(
              bottom: 7,
            ),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: PdfColors.grey400,
                  width: 0.5,
                ),
              ),
            ),
            child: pw.Text(
              'كشف حساب ${statement.regionName}',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
          );
        },
        footer: (context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 10),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'صفحة ${context.pageNumber} من '
              '${context.pagesCount}',
              style: const pw.TextStyle(
                color: PdfColors.grey600,
                fontSize: 9,
              ),
            ),
          );
        },
        build: (_) {
          return [
            _buildHeader(statement),
            pw.SizedBox(height: 14),
            _buildScopeInformation(statement),
            pw.SizedBox(height: 18),
            pw.Text(
              'صيدليات الكشف',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 15,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildTable(statement),
            pw.SizedBox(height: 18),
            _buildSummary(statement),
            pw.SizedBox(height: 12),
            _buildNotice(),
          ];
        },
      ),
    );

    return document.save();
  }

  pw.Widget _buildHeader(
    RegionAccountStatementModel statement,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(17),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue900,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'كشف حساب منطقة',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            statement.regionName,
            style: const pw.TextStyle(
              fontSize: 15,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'من ${formatRegionStatementDate(statement.fromDate)} '
            'إلى ${formatRegionStatementDate(statement.toDate)}',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey200,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildScopeInformation(
    RegionAccountStatementModel statement,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(13),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey300,
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: _informationItem(
              'النطاق',
              statement.regionName,
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            child: _informationItem(
              'عدد الصيدليات',
              statement.summary.pharmaciesCount
                  .toString(),
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            child: _informationItem(
              'الفترة',
              '${formatRegionStatementDate(statement.fromDate)}'
              ' - '
              '${formatRegionStatementDate(statement.toDate)}',
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTable(
    RegionAccountStatementModel statement,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(
        color: PdfColors.grey300,
        width: 0.6,
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.15),
        1: pw.FlexColumnWidth(1.15),
        2: pw.FlexColumnWidth(1.15),
        3: pw.FlexColumnWidth(1.45),
        4: pw.FlexColumnWidth(1.45),
        5: pw.FlexColumnWidth(1.35),
        6: pw.FlexColumnWidth(1.45),
      },
      children: [
        // الصيدلية موجودة في آخر عنصر لتظهر جهة اليمين.
        _tableRow(
          const [
            'الرصيد',
            'دائن',
            'مدين',
            'آخر دفعة',
            'آخر فاتورة',
            'المنطقة',
            'الصيدلية',
          ],
          isHeader: true,
        ),
        ...statement.pharmacies.map(
          (pharmacy) => _tableRow(
            [
              pharmacy.formattedBalance,
              pharmacy.formattedCredit,
              pharmacy.formattedDebit,
              _transactionText(
                pharmacy.lastPayment,
              ),
              _transactionText(
                pharmacy.lastInvoice,
              ),
              pharmacy.regionName,
              pharmacy.name,
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummary(
    RegionAccountStatementModel statement,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(
          color: PdfColors.grey300,
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'الإجماليات',
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              pw.Expanded(
                child: _summaryItem(
                  'إجمالي المدين',
                  statement
                      .summary.formattedTotalDebit,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _summaryItem(
                  'إجمالي الدائن',
                  statement
                      .summary.formattedTotalCredit,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _summaryItem(
                  'إجمالي الرصيد',
                  statement
                      .summary.formattedTotalBalance,
                  highlighted: true,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Expanded(
                child: _summaryItem(
                  'الصيدليات المدينة',
                  statement.summary
                      .debtorPharmaciesCount
                      .toString(),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _summaryItem(
                  'المسددة بالكامل',
                  statement.summary
                      .fullyPaidPharmaciesCount
                      .toString(),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _summaryItem(
                  'عدد الصيدليات',
                  statement.summary.pharmaciesCount
                      .toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildNotice() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(11),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        borderRadius: pw.BorderRadius.circular(7),
        border: pw.Border.all(
          color: PdfColors.amber200,
        ),
      ),
      child: pw.Text(
        'هذا الكشف مخصص للعرض والتحليل والتقارير فقط. '
        'تسجيل دفعات التحصيل يتم من قسم التحصيل.',
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(
          color: PdfColors.brown800,
          fontSize: 9,
        ),
      ),
    );
  }

  pw.Widget _informationItem(
    String title,
    String value,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: const pw.TextStyle(
            color: PdfColors.grey600,
            fontSize: 9,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  pw.Widget _summaryItem(
    String title,
    String value, {
    bool highlighted = false,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: highlighted
            ? PdfColors.blue50
            : PdfColors.white,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(
          color: highlighted
              ? PdfColors.blue200
              : PdfColors.grey300,
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 9,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: highlighted
                  ? PdfColors.blue900
                  : PdfColors.grey900,
              fontSize: highlighted ? 12 : 10,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.TableRow _tableRow(
    List<String> cells, {
    bool isHeader = false,
  }) {
    return pw.TableRow(
      decoration: isHeader
          ? const pw.BoxDecoration(
              color: PdfColors.blue900,
            )
          : null,
      children: cells.map(
        (cell) {
          return pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 7,
            ),
            child: pw.Text(
              cell,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: isHeader ? 8.5 : 7.8,
                fontWeight: isHeader
                    ? pw.FontWeight.bold
                    : pw.FontWeight.normal,
                color: isHeader
                    ? PdfColors.white
                    : PdfColors.grey900,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  String _transactionText(
    RegionStatementTransactionModel? transaction,
  ) {
    if (transaction == null) {
      return '-';
    }

    return '${transaction.operationNumber}\n'
        '${transaction.formattedDate}\n'
        '${transaction.formattedAmount}';
  }
}