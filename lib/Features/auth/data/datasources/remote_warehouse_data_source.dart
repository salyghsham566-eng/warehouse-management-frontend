import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:project_2/Core/network/api_endpoints.dart';
import 'package:project_2/Features/auth/data/datasources/warehouse_data_source.dart';
import 'package:project_2/Features/auth/data/models/warehouse_company_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_inventory_file_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_details_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_overview_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';

class RemoteWarehouseDataSource
    implements WarehouseDataSource {
  final Dio dio;

  const RemoteWarehouseDataSource({
    required this.dio,
  });

  @override
  Future<WarehouseOverviewModel>
      getWarehouseOverview() async {
    try {
      final response = await dio.get(
        ApiEndpoints.warehouseOverview,
      );

      final dynamic responseData =
          response.data;

      if (responseData is! Map) {
        throw Exception(
          'صيغة استجابة المستودع غير صحيحة',
        );
      }

      final Map<String, dynamic> root =
          Map<String, dynamic>.from(
        responseData,
      );

      final dynamic nestedData =
          root['data'];

      final Map<String, dynamic> payload =
          nestedData is Map
              ? Map<String, dynamic>.from(
                  nestedData,
                )
              : root;

      return WarehouseOverviewModel.fromJson(
        payload,
      );
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }

  @override
  Future<List<WarehouseCompanyModel>>
      getWarehouseCompanies() async {
    try {
      final response = await dio.get(
        ApiEndpoints.warehouseCompanies,
      );

      final dynamic responseData =
          response.data;

      final List<dynamic> rawCompanies =
          _extractList(
        responseData,
        preferredKeys: const [
          'companies',
          'items',
          'results',
        ],
      );

      return rawCompanies
          .whereType<Map>()
          .map(
            (item) =>
                WarehouseCompanyModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where(
            (company) =>
                company.name.trim().isNotEmpty,
          )
          .toList();
    } on DioException catch (error) {
      throw Exception(
        _handleDioError(error),
      );
    }
  }
@override
Future<List<WarehouseMedicineModel>>
    getWarehouseCompanyMedicines(
  String companyId,
) async {
  try {
    final response = await dio.get(
      ApiEndpoints.warehouseCompanyMedicines(
        companyId,
      ),
    );

    final List<dynamic> rawMedicines =
        _extractList(
      response.data,
      preferredKeys: const [
        'medicines',
        'products',
        'items',
        'results',
      ],
    );

    return rawMedicines
        .whereType<Map>()
        .map(
          (item) => WarehouseMedicineModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where(
          (medicine) =>
              medicine.tradeName.trim().isNotEmpty,
        )
        .toList();
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}@override
Future<WarehouseMedicineDetailsModel>
    getWarehouseMedicineDetails(
  String medicineId,
) async {
  try {
    final response = await dio.get(
      ApiEndpoints.warehouseMedicineDetails(
        medicineId,
      ),
    );

    final dynamic responseData =
        response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة بيانات الدواء غير صحيحة',
      );
    }

    final root =
        Map<String, dynamic>.from(
      responseData,
    );

    final dynamic data =
        root['data'] ??
        root['medicine'] ??
        root['product'];

    final Map<String, dynamic> payload =
        data is Map
            ? Map<String, dynamic>.from(
                data,
              )
            : root;

    return WarehouseMedicineDetailsModel
        .fromJson(
      payload,
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}@override
Future<List<WarehouseStockItemModel>>
    getWarehouseStockItems(
  WarehouseStockFilter filter,
) async {
  try {
    final response = await dio.get(
      ApiEndpoints.warehouseItems,
      queryParameters: {
        'status': filter.apiValue,
      },
    );

    final rawItems = _extractList(
      response.data,
      preferredKeys: const [
        'items',
        'medicines',
        'products',
        'results',
      ],
    );

    return rawItems
        .whereType<Map>()
        .map(
          (item) =>
              WarehouseStockItemModel.fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
        )
        .where(
          (item) =>
              item.tradeName
                  .trim()
                  .isNotEmpty &&
              item.availabilityStatus ==
                  filter.availabilityLabel,
        )
        .toList();
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}// =========================================================
// UC-232
// =========================================================
@override
Future<WarehouseInventoryFileModel?>
    getWarehouseInventoryFile() async {
  try {
    final response = await dio.get(
      ApiEndpoints.warehouseInventoryFile,
    );

    if (response.statusCode == 204 ||
        response.data == null) {
      return null;
    }

    final dynamic responseData =
        response.data;

    if (responseData is! Map) {
      throw Exception(
        'صيغة بيانات ملف الجرد غير صحيحة',
      );
    }

    final root =
        Map<String, dynamic>.from(
      responseData,
    );

    final dynamic nested =
        root['data'] ??
        root['file'] ??
        root['inventory_file'] ??
        root['inventoryFile'];

    if (nested == null) {
      // إذا كانت بيانات الملف مباشرة بالجذر.
      if (root.containsKey('file_name') ||
          root.containsKey('fileName') ||
          root.containsKey('filename')) {
        return WarehouseInventoryFileModel
            .fromJson(
          root,
        );
      }

      return null;
    }

    if (nested is! Map) {
      return null;
    }

    return WarehouseInventoryFileModel
        .fromJson(
      Map<String, dynamic>.from(
        nested,
      ),
    );
  } on DioException catch (error) {
    if (error.response?.statusCode ==
        404) {
      return null;
    }

    throw Exception(
      _handleDioError(error),
    );
  }
}

// =========================================================
// UC-233 + UC-234
// =========================================================
@override
Future<Uint8List> getWarehouseInventoryPdf(
  String fileId,
) async {
  try {
    final response = await dio.get(
      ApiEndpoints.warehouseInventoryFilePdf(
        fileId,
      ),
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    final dynamic data =
        response.data;

    if (data is Uint8List) {
      return data;
    }

    if (data is List<int>) {
      return Uint8List.fromList(
        data,
      );
    }

    if (data is List) {
      return Uint8List.fromList(
        data.cast<int>(),
      );
    }

    throw Exception(
      'تعذر قراءة ملف PDF',
    );
  } on DioException catch (error) {
    throw Exception(
      _handleDioError(error),
    );
  }
}
  List<dynamic> _extractList(
    dynamic responseData, {
    required List<String> preferredKeys,
  }) {
    if (responseData is List) {
      return responseData;
    }

    if (responseData is! Map) {
      throw Exception(
        'صيغة استجابة المستودع غير صحيحة',
      );
    }

    final Map<String, dynamic> root =
        Map<String, dynamic>.from(
      responseData,
    );

    for (final key in preferredKeys) {
      final value = root[key];
      if (value is List) {
        return value;
      }
    }

    final dynamic data = root['data'];

    if (data is List) {
      return data;
    }

    if (data is Map) {
      final nested = Map<String, dynamic>.from(
        data,
      );

      for (final key in preferredKeys) {
        final value = nested[key];
        if (value is List) {
          return value;
        }
      }
    }

    return const [];
  }

  String _handleDioError(
    DioException error,
  ) {
    final dynamic data =
        error.response?.data;

    if (data is Map) {
      final dynamic message =
          data['message'] ??
              data['error'];

      if (message != null &&
          message
              .toString()
              .trim()
              .isNotEmpty) {
        return message.toString();
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم';

      case DioExceptionType.badResponse:
        return 'تعذر تحميل بيانات المستودع';

      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';

      default:
        return 'حدث خطأ أثناء الاتصال بالخادم';
    }
  }
}
