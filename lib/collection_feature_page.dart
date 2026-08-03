import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_dashboard_bloc.dart'
    show CollectionDashboardBloc;
import 'package:project_2/Features/auth/bloc/collection_dashboard_event.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_mock_data_source.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_repository_impl.dart';
import 'package:project_2/Features/auth/presentation/collection_payments_history_feature_page.dart';
import 'package:project_2/Features/auth/presentation/pharmacy_search_feature_page.dart';
import 'package:project_2/collection_home_screen.dart';

class CollectionFeaturePage extends StatelessWidget {
  const CollectionFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CollectionRepository>(
      create: (_) => CollectionRepositoryImpl(CollectionMockDataSource()),
      child: BlocProvider<CollectionDashboardBloc>(
        create: (context) =>
            CollectionDashboardBloc(context.read<CollectionRepository>())
              ..add(const CollectionDashboardRequested()),
        child: Builder(
          builder: (context) {
            return CollectionDashboardPage(
              onRecordPayment: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const PharmacySearchFeaturePage(),
                  ),
                );
              },
              onOpenHistory: () {
                  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) =>
          const CollectionPaymentsHistoryFeaturePage(),
    ),
  );
              },
              onOpenPaymentDetails: (collectionId) {
                _showNextStepMessage(
                  context,
                  'تفاصيل الدفعة: $collectionId - UC-179',
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showNextStepMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}
