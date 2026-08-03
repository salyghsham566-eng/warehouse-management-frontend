import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_event.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_mock_data_source.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository_impl.dart';
import 'package:project_2/Features/auth/presentation/collection_payments_history_page.dart';

class CollectionPaymentsHistoryFeaturePage
    extends StatelessWidget {
  const CollectionPaymentsHistoryFeaturePage({
    this.initialPharmacyId,
    super.key,
  });

  final String? initialPharmacyId;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<
        CollectionPaymentRepository>(
      create: (_) =>
          CollectionPaymentRepositoryImpl(
        CollectionPaymentMockDataSource(),
      ),
      child: BlocProvider<
          CollectionPaymentsHistoryBloc>(
        create: (context) =>
            CollectionPaymentsHistoryBloc(
          repository: context.read<
              CollectionPaymentRepository>(),
          initialPharmacyId: initialPharmacyId,
        )..add(
                const CollectionPaymentsHistoryRequested(),
              ),
        child:
            const CollectionPaymentsHistoryPage(),
      ),
    );
  }
}