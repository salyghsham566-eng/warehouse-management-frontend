import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/presentation/representative_financial_page.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_bloc.dart';

import 'package:project_2/Home_page.dart';
import 'package:project_2/collection_feature_page.dart';
import 'package:project_2/orders_screen.dart';

// صفحة المزيد
import 'package:project_2/more_screen.dart';

import 'package:project_2/Core/di/injection_container.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({
    super.key,
  });

  @override
  State<HomeScreen2> createState() {
    return _HomeScreenState2();
  }
}

class _HomeScreenState2 extends State<HomeScreen2> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      // 0 - الرئيسية
      const HomeScreen(),

      // 1 - الطلبات
      OrdersScreen(),

      // 2 - التحصيل
      const CollectionDashboardFeaturePage(),

      // 3 - المالية
      BlocProvider<FinancialDashboardBloc>(
        create: (_) => sl<FinancialDashboardBloc>(),
        child: const RepresentativeFinancialPage(),
      ),

      // 4 - المزيد
      const MoreScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF0B2D5B),
        unselectedItemColor: const Color(0xFF667085),

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          // الرئيسية
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home,
            ),
            label: 'الرئيسية',
          ),

          // الطلبات
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            activeIcon: Icon(
              Icons.shopping_cart,
            ),
            label: 'الطلبات',
          ),

          // التحصيل
          BottomNavigationBarItem(
            icon: Icon(
              Icons.payments_outlined,
            ),
            activeIcon: Icon(
              Icons.payments,
            ),
            label: 'التحصيل',
          ),

          // المالية
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
            ),
            activeIcon: Icon(
              Icons.account_balance_wallet,
            ),
            label: 'المالية',
          ),

          // المزيد
          BottomNavigationBarItem(
            icon: Icon(
              Icons.more_horiz,
            ),
            activeIcon: Icon(
              Icons.more_horiz,
            ),
            label: 'المزيد',
          ),
        ],
      ),
    );
  }
}