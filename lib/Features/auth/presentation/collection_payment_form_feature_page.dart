import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';

import 'package:project_2/Features/auth/bloc/collection_payment_form_bloc.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/presentation/collection_payment_form_page.dart';

class CollectionPaymentFormFeaturePage extends StatelessWidget {
  const CollectionPaymentFormFeaturePage({
    required this.pharmacy,
    super.key,
  });

  final CollectionPharmacyModel pharmacy;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CollectionPaymentFormBloc>(
      create: (_) => sl<CollectionPaymentFormBloc>(
        param1: pharmacy,
      ),
      child: CollectionPaymentFormPage(
        pharmacy: pharmacy,
      ),
    );
  }
}