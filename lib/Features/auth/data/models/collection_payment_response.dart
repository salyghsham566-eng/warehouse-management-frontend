import 'package:equatable/equatable.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';

class CollectionPaymentResponse extends Equatable {
  const CollectionPaymentResponse({
    required this.success,
    required this.message,
    required this.payment,
  });

  final bool success;
  final String message;
  final CollectionPaymentModel? payment;

  factory CollectionPaymentResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final dynamic rawData = json['data'];

    Map<String, dynamic>? paymentJson;

    if (rawData is Map) {
      final dataMap =
          Map<String, dynamic>.from(rawData);

      final dynamic nestedPayment =
          dataMap['payment'];

      if (nestedPayment is Map) {
        paymentJson =
            Map<String, dynamic>.from(
          nestedPayment,
        );
      } else {
        paymentJson = dataMap;
      }
    } else if (json['payment'] is Map) {
      paymentJson =
          Map<String, dynamic>.from(
        json['payment'] as Map,
      );
    }

    return CollectionPaymentResponse(
      success: _parseBool(
        json['success'],
        defaultValue: true,
      ),
      message: json['message']?.toString() ?? '',
      payment: paymentJson == null
          ? null
          : CollectionPaymentModel.fromJson(
              paymentJson,
            ),
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

    return value.toString().toLowerCase() ==
        'true';
  }

  @override
  List<Object?> get props => [
        success,
        message,
        payment,
      ];
}