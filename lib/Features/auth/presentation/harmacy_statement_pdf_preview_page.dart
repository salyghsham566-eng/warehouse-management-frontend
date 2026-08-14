import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:project_2/Features/auth/data/models/pharmacy_account_statement_model.dart';
import 'package:project_2/Features/auth/services/pharmacy_statement_pdf_service.dart';

class PharmacyStatementPdfPreviewPage
    extends StatelessWidget {
  final PharmacyAccountStatementModel statement;
  final PharmacyStatementPdfService pdfService;

  const PharmacyStatementPdfPreviewPage({
    super.key,
    required this.statement,
    required this.pdfService,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF002B55),
          centerTitle: true,
          title: const Text(
            'معاينة كشف الحساب',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: PdfPreview(
          build: (_) {
            return pdfService.buildPdf(
              statement,
            );
          },
          pdfFileName:
              'pharmacy_statement_${statement.pharmacy.id}.pdf',
          allowPrinting: true,
          allowSharing: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
        ),
      ),
    );
  }
}