import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:project_2/Features/auth/data/models/region_account_statement_model.dart';
import 'package:project_2/Features/auth/services/region_statement_pdf_service.dart';

class RegionStatementPdfPreviewPage
    extends StatelessWidget {
  final RegionAccountStatementModel statement;
  final RegionStatementPdfService pdfService;

  const RegionStatementPdfPreviewPage({
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
            'معاينة كشف المنطقة',
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
              'region_statement_${statement.regionId}.pdf',
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