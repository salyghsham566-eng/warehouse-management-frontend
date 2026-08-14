import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';

class CollectionPharmaciesResponse
    extends Equatable {
  const CollectionPharmaciesResponse({
    required this.success,
    required this.message,
    required this.pharmacies,
  });

  final bool success;
  final String message;
  final List<CollectionPharmacyModel> pharmacies;

  factory CollectionPharmaciesResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic rawData = json['data'];

    List<dynamic> pharmaciesJson = [];

    if (rawData is List) {
      pharmaciesJson = rawData;
    } else if (rawData is Map) {
      final dataMap =
          Map<String, dynamic>.from(rawData);

      final dynamic rawPharmacies =
          dataMap['pharmacies'] ??
          dataMap['items'] ??
          dataMap['results'];

      if (rawPharmacies is List) {
        pharmaciesJson = rawPharmacies;
      }
    } else if (json['pharmacies'] is List) {
      pharmaciesJson =
          json['pharmacies'] as List<dynamic>;
    }

    return CollectionPharmaciesResponse(
      success: _parseBool(
        json['success'],
        defaultValue: true,
      ),
      message: json['message']?.toString() ?? '',
      pharmacies: pharmaciesJson
          .whereType<Map>()
          .map(
            (item) =>
                CollectionPharmacyModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }

  static bool _parseBool(
    dynamic value, {
    required bool defaultValue,
  }) {
    if (value == null) {
      return defaultValue;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value == 1;
    }

    final normalizedValue =
        value.toString().trim().toLowerCase();

    return normalizedValue == 'true' ||
        normalizedValue == '1';
  }

  @override
  List<Object?> get props => [
        success,
        message,
        pharmacies,
      ];
}