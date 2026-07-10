import 'package:flutter/material.dart';
import 'package:project_2/Home_page.dart';
import 'package:project_2/orders_screen.dart';
import 'package:project_2/collection_home_screen.dart';
import 'package:project_2/pharmacies_screen.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreenState2();
}

class _HomeScreenState2 extends State<HomeScreen2> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    OrdersScreen(),
    CollectionHomeScreen(),
    PharmaciesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xff0B2D5B)),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, color: Color(0xff0B2D5B)),
            label: "الطلبات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments_outlined, color: Color(0xff0B2D5B)),
            label: "التحصيل",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy_outlined, color: Color(0xff0B2D5B)),
            label: "الصيدليات",
          ),
        ],
      ),
    );
  }
}
