class WarehouseInventoryFileModel {
  final String id;
  final String fileName;
  final String uploadedAt;
  final String uploadedBy;
  final String? notes;

  const WarehouseInventoryFileModel({
    required this.id,
    required this.fileName,
    required this.uploadedAt,
    required this.uploadedBy,
    this.notes,
  });

  factory WarehouseInventoryFileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    String readString(
      List<String> keys, {
      String fallback = '',
    }) {
      for (final key in keys) {
        final value = json[key];

        if (value != null &&
            value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }

      return fallback;
    }

    String? readNullableString(
      List<String> keys,
    ) {
      final value = readString(keys);

      return value.isEmpty ? null : value;
    }

    return WarehouseInventoryFileModel(
      id: readString(
        const [
          'id',
          'file_id',
          'fileId',
          'inventory_file_id',
          'inventoryFileId',
        ],
      ),
      fileName: readString(
        const [
          'file_name',
          'fileName',
          'name',
          'filename',
        ],
        fallback: 'ملف الجرد.pdf',
      ),
      uploadedAt: readString(
        const [
          'uploaded_at',
          'uploadedAt',
          'upload_date',
          'uploadDate',
          'created_at',
          'createdAt',
        ],
        fallback: 'غير محدد',
      ),
      uploadedBy: readString(
        const [
          'uploaded_by',
          'uploadedBy',
          'biller_name',
          'billerName',
          'uploader_name',
          'uploaderName',
        ],
        fallback: 'غير محدد',
      ),
      notes: readNullableString(
        const [
          'notes',
          'note',
          'description',
        ],
      ),
    );
  }
}
