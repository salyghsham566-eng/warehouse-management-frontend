import 'package:flutter/material.dart';

class PharmaciesScreen extends StatelessWidget {
  const PharmaciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'صفحة الصيدليات',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
