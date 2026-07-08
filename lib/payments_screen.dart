import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'صفحة التحصيل',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
