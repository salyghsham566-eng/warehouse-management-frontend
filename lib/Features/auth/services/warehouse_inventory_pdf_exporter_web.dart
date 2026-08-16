// هذا الملف يُستخدم فقط عند تشغيل Flutter Web.
// ignore_for_file: deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';

Future<void> exportWarehouseInventoryPdf({
  required Uint8List bytes,
  required String filename,
}) async {
  final blob = html.Blob(
    [bytes],
    'application/pdf',
  );

  final url =
      html.Url.createObjectUrlFromBlob(blob);

  try {
    final anchor =
        html.AnchorElement(href: url)
          ..download = filename
          ..style.display = 'none';

    html.document.body?.children.add(
      anchor,
    );

    anchor.click();
    anchor.remove();
  } finally {
    html.Url.revokeObjectUrl(url);
  }
}
