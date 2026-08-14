import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

class CollectionPaymentsResponse extends Equatable {
  const CollectionPaymentsResponse({
    required this.success,
    required this.message,
    required this.payments,
  });

  final bool success;
  final String message;
  final List<CollectionPaymentModel> payments;

  factory CollectionPaymentsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic rawData = json['data'];

    List<dynamic> rawPayments = [];

    if (rawData is List) {
      rawPayments = rawData;
    } else if (rawData is Map) {
      final Map<String, dynamic> dataMap =
          Map<String, dynamic>.from(rawData);

      final dynamic nestedPayments =
          dataMap['payments'] ??
          dataMap['items'] ??
          dataMap['results'];

      if (nestedPayments is List) {
        rawPayments = nestedPayments;
      }
    } else if (json['payments'] is List) {
      rawPayments = json['payments'] as List;
    }

    final payments = rawPayments
        .whereType<Map>()
        .map(
          (item) => CollectionPaymentModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);

    return CollectionPaymentsResponse(
      success: _parseBool(
        json['success'],
        defaultValue: true,
      ),
      message: json['message']?.toString() ?? '',
      payments: payments,
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

    final normalized =
        value.toString().trim().toLowerCase();

    return normalized == 'true' ||
        normalized == '1';
  }

  @override
  List<Object?> get props => [
        success,
        message,
        payments,
      ];
}