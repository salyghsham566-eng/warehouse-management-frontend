/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';

import 'package:project_2/Features/auth/bloc/collection_payments_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_event.dart';

import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';

import 'package:project_2/Features/auth/presentation/collection_payments_history_page.dart';

class CollectionPaymentsHistoryFeaturePage extends StatelessWidget {
  const CollectionPaymentsHistoryFeaturePage({
    this.initialPharmacyId,
    super.key,
  });

  final String? initialPharmacyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CollectionPaymentsHistoryBloc>(
      create: (_) {
        final CollectionPaymentsHistoryBloc bloc =
            CollectionPaymentsHistoryBloc(
          repository: sl<CollectionPaymentRepository>(),
        );

        bloc.add(
          const CollectionPaymentsHistoryRequested(),
        );

        if (initialPharmacyId != null) {
          bloc.add(
            CollectionPaymentsPharmacyFilterChanged(
              initialPharmacyId,
            ),
          );
        }

        return bloc;
      },
      child: const CollectionPaymentsHistoryPage(),
    );
  }
}*/