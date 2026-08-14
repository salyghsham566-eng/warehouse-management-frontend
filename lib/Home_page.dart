import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/login_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_event.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';
import 'package:project_2/Features/auth/presentation/LogIn.dart';
import 'package:project_2/Features/auth/presentation/Profile.dart';
import 'package:project_2/InventoryScreen.dart';
import 'package:project_2/OffersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> companies = [
      {"name": "الحكمة", "icon": Icons.business},
      {"name": "أوغاريت", "icon": Icons.local_pharmacy},
      {"name": "ابن حيان", "icon": Icons.medication},
      {"name": "يونيفارما", "icon": Icons.science},
      {"name": "آسيا", "icon": Icons.inventory},
      {"name": "أفاميا", "icon": Icons.healing},
    ];
    const String username = "ahmad123";
    const String fullName = "أحمد محمد";
    const String phone = "0999999999";
    const String role = "مندوب";
    const String accountStatus = "فعال";
    const String address = "دمشق - المزة";
    const String governorate = "دمشق";
    const String birthDate = "2000-05-15";

    // تأتي لاحقاً من صلاحيات المستخدم.
    const bool canEditUsername = false;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (scaffoldContext) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(scaffoldContext).openDrawer();
                },
                icon: const Icon(Icons.menu),
              );
            },
          ),

          title: const Text(
            'مندوب المبيعات',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
                Positioned(
                  right: 10,
                  top: 8,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(radius: 18, child: Icon(Icons.person)),
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF12355B)),
                  accountName: Text(
                    fullName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    "$role - $phone",
                    style: TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                   
                   
                      Icons.person,
                      size: 40,
                      color: Color(0xFF12355B),
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text("الملف الشخصي"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => ProfileBloc(
                            profileRepository: ProfileRepository(),
                          )..add(ProfileRequested()),
                          child: const ProfilePage(),
                        ),
                      ),
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "تسجيل الخروج",
                    style: TextStyle(color: Colors.red),
                  ),
                 onTap: () async {
  Navigator.pop(context);

  final prefs =
      await SharedPreferences.getInstance();

  // حذف بيانات جلسة المندوب
  await prefs.remove('token');
  await prefs.remove('role');
  await prefs.remove('name');
  await prefs.remove('usernameOrPhone');

  // حذف التوكن من Dio
  sl<Dio>()
      .options
      .headers
      .remove('Authorization');

  if (!context.mounted) return;

  // الرجوع للـ Login وحذف كل الصفحات السابقة
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (_) =>
          BlocProvider<LoginBloc>(
        create: (_) => sl<LoginBloc>(),
        child:
            const RepresentativeLoginScreen(),
      ),
    ),
    (route) => false,
  );
},
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color(0xffF4F5F7),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                const SizedBox(height: 15),

                /// Welcome Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff163B6B),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //ربط
                      Text(
                        "مرحباً، أحمد محمد",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6),
                      //ربط
                      Text(
                        "المنطقة الوسطى • ملخص يومك الميداني",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Statistics
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    StatCard(
                      title: "طلبات اليوم",
                      //ربط
                      value: "12",
                      icon: Icons.calendar_today,
                    ),
                    StatCard(
                      title: "طلبات معلقة",
                      //ربط
                      value: "3",
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ),
                    StatCard(
                      title: "مديونية معلقة",
                      //ربط
                      value: "120,000",
                      icon: Icons.account_balance_wallet,
                      color: Colors.red,
                    ),
                    StatCard(
                      title: "تحصيلات اليوم",
                      //ربط
                      value: "45,000",
                      icon: Icons.payments,
                      color: Colors.green,
                    ),
                    StatCard(
                      title: "تحقيق التارجت",
                      //ربط
                      value: "75%",
                      icon: Icons.pie_chart,
                      color: Colors.green,
                    ),
                    StatCard(
                      title: "صيدليات مدينة",
                      //ربط
                      value: "15",
                      icon: Icons.local_pharmacy,
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// Quick Actions
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "إجراءات سريعة",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      QuickAction(
                        icon: Icons.shopping_cart,
                        title: "طلب جديد",
                        color: Color(0xff0B2D5B),
                      ),
                      QuickAction(
                        icon: Icons.receipt,
                        title: "تسجيل دفعة",
                        color: Colors.green,
                      ),
                      QuickAction(
                        icon: Icons.local_pharmacy,
                        title: "الصيدليات",
                        color: Color(0xffDDEBFF),
                      ),
                      QuickAction(
                        icon: Icons.calendar_month,
                        title: "خطة العمل",
                        color: Color(0xffDDEBFF),
                      ),
                      QuickAction(
                        icon: Icons.discount,
                        title: "العروض",
                        color: Color(0xffFFE4C6),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _sectionCard(
                  title: "آخر طلبية",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const ListTile(
                        //ربط
                        title: Text("صيدلية الشفاء"),
                        //ربط
                        subtitle: Text("INV-8829 • 1,250 SAR"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("متابعة الطلب"),
                      ),
                    ],
                  ),
                ),

                _sectionCard(
                  title: "خطة العمل الحالية",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      //ربط
                      Text("توسعة القطاع الأوسط", textAlign: TextAlign.right),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        //ربط
                        value: 0.75,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "12 من أصل 16 مهمة مكتملة",
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "العروض الحالية",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.local_offer, color: Colors.green),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "خصم 15% على منتجات العناية بالبشرة",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الأصناف المقترحة للبيع",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: [
                          Chip(label: Text("Panadol")),
                          Chip(label: Text("Omega 3")),
                          Chip(label: Text("Vitamin C")),
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OffersScreen(),
                              ),
                            );
                          },
                          child: const Text("عرض العروض"),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "المستودع",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "شركات المستودع",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        height: 95,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CompanyCircle(
                              name: "الحكمة",
                              image: "assets/company1.png",
                              onTap: () {},
                            ),
                            CompanyCircle(
                              name: "أوغاريت",
                              image: "assets/company2.png",
                              onTap: () {},
                            ),
                            CompanyCircle(
                              name: "ابن حيان",
                              image: "assets/company3.png",
                              onTap: () {},
                            ),
                            CompanyCircle(
                              name: "يونيفارما",
                              image: "assets/company4.png",
                              onTap: () {},
                            ),
                            CompanyCircle(
                              name: "آسيا",
                              image: "assets/company5.png",
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                "12 صنفاً قابلاً للنفاد قريباً",
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InventoryScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.inventory_2),
                          label: const Text("عرض الأصناف القابلة للنفاد"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("عرض الجرد PDF"),
                        ),
                      ),
                    ],
                  ),
                ),

                _sectionCard(
                  title: "التقييم العام",
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xffF4F6FC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    child: Text(
                                      "88",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text("نقاط التغطية"),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "142 / 120",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xffF4F6FC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Text("نقاط التارجت"),
                                  SizedBox(height: 5),
                                  Text(
                                    "500 / 450",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("تفاصيل الأداء"),
                      ),
                    ],
                  ),
                ),

                _sectionCard(
                  title: "تنبيهات حديثة",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      NotificationCard(
                        title: "تمت الموافقة على الطلب INV-8829",
                        time: "قبل 15 دقيقة",
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),

                      NotificationCard(
                        title: "لقد حققت 75% من هدفك الشهري",
                        time: "قبل ساعتين",
                        icon: Icons.trending_up,
                        color: Colors.blue,
                      ),

                      NotificationCard(
                        title: "ملاحظات جديدة من المشرف الميداني",
                        time: "قبل 5 ساعات",
                        icon: Icons.message,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = const Color(0xff163B6B),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          /*   BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),*/
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 28, backgroundColor: color, child: Icon(icon)),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  const NotificationCard({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyCircle extends StatelessWidget {
  final String name;
  final String image;
  final VoidCallback onTap;

  const CompanyCircle({
    super.key,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(height: 6),
            Text(name, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
