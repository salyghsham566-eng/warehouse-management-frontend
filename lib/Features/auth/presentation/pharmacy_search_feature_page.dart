/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/2pharmacy_search_bloc.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_event.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/models/collection_payment_model.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacy_mock_data_source.dart';
import 'package:project_2/Features/auth/presentation/2pharmacy_search_page.dart';
import 'package:project_2/Features/auth/presentation/collection_payment_form_feature_page.dart';
import 'package:project_2/Features/auth/presentation/collection_payments_history_feature_page.dart';
import 'package:project_2/Features/auth/presentation/collection_pharmacy_details_page.dart';

class PharmacySearchFeaturePage extends StatelessWidget {
  const PharmacySearchFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CollectionPharmacyRepository>(
      create: (_) =>
          CollectionPharmacyRepositoryImpl(CollectionPharmacyMockDataSource()),
      child: BlocProvider<PharmacySearchBloc>(
        create: (context) =>
            PharmacySearchBloc(context.read<CollectionPharmacyRepository>())
              ..add(const PharmacySearchRequested()),
        child: Builder(
          builder: (context) {
            return PharmacySearchPage(
             onPharmacySelected: (CollectionPharmacyModel pharmacy) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => CollectionPharmacyDetailsPage(
        pharmacy: pharmacy,

        onRecordPayment: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) =>
                  CollectionPaymentFormFeaturePage(
                pharmacy: pharmacy,
              ),
            ),
          );
        },

        // ضيفيها هون
        onOpenHistory: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) =>
                  CollectionPaymentsHistoryFeaturePage(
                initialPharmacyId: pharmacy.id,
              ),
            ),
          );
        },
      ),
    ),
  );
},
      );})));
          }}*/
