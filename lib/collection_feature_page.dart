import 'package:flutter/material.dart';

import 'package:project_2/collection_home_screen.dart';

import 'package:project_2/Features/auth/presentation/2pharmacy_search_page.dart';
import 'package:project_2/Features/auth/presentation/collection_payments_history_page.dart';

class CollectionDashboardFeaturePage extends StatelessWidget {
  const CollectionDashboardFeaturePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CollectionDashboardPage(
      // زر تسجيل دفعة جديدة
      onRecordPayment: () async {
        await Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) {
              return const CollectionPharmaciesFilterScreen();
            },
          ),
        );
      },

      // زر سجل التحصيلات
      onOpenHistory: () async {
        await Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) {
              return const CollectionPaymentsHistoryPage();
            },
          ),
        );
      },
    );
  }
}