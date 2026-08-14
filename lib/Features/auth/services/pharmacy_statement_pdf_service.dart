import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';

class PharmacyStatementPdfService {
  Future<Uint8List> buildPdf(
    PharmacyAccountStatementModel statement,
  ) async {
    final regularFont =
        await PdfGoogleFonts.cairoRegular();

    final boldFont =
        await PdfGoogleFonts.cairoBold();

    final document = pw.Document(
      title: 'كشف حساب ${statement.pharmacy.name}',
      author: 'Sales Representative',
      subject: 'كشف حساب صيدلية',
    );

    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(28),
      theme: pw.ThemeData.withFont(
        base: regularFont,
        bold: boldFont,
      ),
      textDirection: pw.TextDirection.rtl,
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
              bottom: 12,
            ),
            padding: const pw.EdgeInsets.only(
              bottom: 8,
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
              'كشف حساب ${statement.pharmacy.name}',
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
            margin: const pw.EdgeInsets.only(top: 12),
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
        build: (context) {
          return [
            _buildTitle(statement),
            pw.SizedBox(height: 16),
            _buildPharmacyInformation(statement),
            pw.SizedBox(height: 14),
            _buildOpeningBalance(statement),
            pw.SizedBox(height: 18),
            pw.Text(
              'الجدول الزمني للحركات',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 15,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 9),
            _buildMovementsTable(statement),
            pw.SizedBox(height: 18),
            _buildSummary(statement),
            pw.SizedBox(height: 14),
            _buildNotice(),
          ];
        },
      ),
    );

    return document.save();
  }

  pw.Widget _buildTitle(
    PharmacyAccountStatementModel statement,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue900,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'كشف حساب صيدلية',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            statement.pharmacy.name,
            style: const pw.TextStyle(
              fontSize: 15,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'من ${formatStatementDate(statement.fromDate)} '
            'إلى ${formatStatementDate(statement.toDate)}',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey200,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPharmacyInformation(
    PharmacyAccountStatementModel statement,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey300,
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          _pdfInfoRow(
            'اسم الصيدلية',
            statement.pharmacy.name,
          ),
          _pdfInfoRow(
            'رقم الصيدلية',
            statement.pharmacy.id,
          ),
          _pdfInfoRow(
            'المنطقة',
            statement.pharmacy.regionName,
          ),
          _pdfInfoRow(
            'العنوان',
            statement.pharmacy.address,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildOpeningBalance(
    PharmacyAccountStatementModel statement,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(
          color: PdfColors.blue200,
        ),
      ),
      child: pw.Row(
        mainAxisAlignment:
            pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'الرصيد السابق',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.Text(
            statement.formattedOpeningBalance,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 16,
              color: PdfColors.blue900,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMovementsTable(
    PharmacyAccountStatementModel statement,
  ) {
    if (statement.movements.isEmpty) {
      return pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(20),
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColors.grey300,
          ),
        ),
        child: pw.Text(
          'لا توجد حركات مالية ضمن الفترة المحددة',
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(
        color: PdfColors.grey300,
        width: 0.6,
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(1.30),
        1: pw.FlexColumnWidth(1.25),
        2: pw.FlexColumnWidth(1.25),
        3: pw.FlexColumnWidth(1.35),
        4: pw.FlexColumnWidth(1.35),
        5: pw.FlexColumnWidth(1.25),
      },
      children: [
        // ترتيب الأعمدة معكوس حتى يظهر التاريخ جهة اليمين.
        _pdfTableRow(
          const [
            'الرصيد',
            'دائن',
            'مدين',
            'رقم العملية',
            'نوع الحركة',
            'التاريخ',
          ],
          isHeader: true,
        ),
        ...statement.movements.map(
          (movement) => _pdfTableRow(
            [
              movement.formattedBalance,
              movement.formattedCredit,
              movement.formattedDebit,
              movement.operationNumber,
              movement.movementTypeLabel,
              movement.formattedDate,
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummary(
    PharmacyAccountStatementModel statement,
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
            'الملخص النهائي',
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 12),
          _pdfInfoRow(
            'الرصيد السابق',
            statement.formattedOpeningBalance,
          ),
          _pdfInfoRow(
            'إجمالي المدين',
            statement.summary.formattedTotalDebit,
          ),
          _pdfInfoRow(
            'إجمالي الدائن',
            statement.summary.formattedTotalCredit,
          ),
          pw.Divider(
            color: PdfColors.grey400,
          ),
          _pdfInfoRow(
            'الرصيد النهائي',
            statement.summary.formattedClosingBalance,
            bold: true,
          ),
          _pdfInfoRow(
            'عدد الحركات',
            statement.summary.movementsCount.toString(),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildNotice() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        borderRadius: pw.BorderRadius.circular(7),
        border: pw.Border.all(
          color: PdfColors.amber200,
        ),
      ),
      child: pw.Text(
        'هذا الكشف مخصص للعرض والتحليل المالي فقط. '
        'تسجيل دفعات التحصيل يتم من قسم التحصيل.',
        textAlign: pw.TextAlign.center,
        style: const pw.TextStyle(
          color: PdfColors.brown800,
          fontSize: 9,
        ),
      ),
    );
  }

  pw.Widget _pdfInfoRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              style: const pw.TextStyle(
                color: PdfColors.grey700,
                fontSize: 10,
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(
                fontWeight: bold
                    ? pw.FontWeight.bold
                    : pw.FontWeight.normal,
                color: bold
                    ? PdfColors.blue900
                    : PdfColors.grey900,
                fontSize: bold ? 12 : 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.TableRow _pdfTableRow(
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
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 7,
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              cell,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: isHeader ? 8.5 : 8,
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
}