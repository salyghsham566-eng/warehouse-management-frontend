import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_bloc.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_mock_data_source.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository_impl.dart';
import 'package:project_2/Features/auth/presentation/collection_payment_form_page.dart';

class CollectionPaymentFormFeaturePage extends StatelessWidget {
  const CollectionPaymentFormFeaturePage({required this.pharmacy, super.key});

  final CollectionPharmacyModel pharmacy;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CollectionPaymentRepository>(
      create: (_) =>
          CollectionPaymentRepositoryImpl(CollectionPaymentMockDataSource()),
      child: BlocProvider<CollectionPaymentFormBloc>(
        create: (context) => CollectionPaymentFormBloc(
          pharmacy: pharmacy,
          repository: context.read<CollectionPaymentRepository>(),
        ),
        child: CollectionPaymentFormPage(pharmacy: pharmacy),
      ),
    );
  }
}
