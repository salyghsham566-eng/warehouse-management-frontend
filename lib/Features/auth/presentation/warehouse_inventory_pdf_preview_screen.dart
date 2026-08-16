import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'package:project_2/Core/theme/app_colors.dart';

class WarehouseInventoryPdfPreviewScreen
    extends StatelessWidget {
  final Uint8List bytes;
  final String fileName;

  const WarehouseInventoryPdfPreviewScreen({
    super.key,
    required this.bytes,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'معاينة ملف الجرد',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: PdfPreview(
          build: (_) async => bytes,
          pdfFileName: fileName,
          allowPrinting: false,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
        ),
      ),
    );
  }
}
