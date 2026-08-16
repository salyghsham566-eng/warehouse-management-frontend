import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/login_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_event.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';
import 'package:project_2/Features/auth/bloc/warehouse_bloc.dart';
import 'package:project_2/Features/auth/presentation/app_information_screen.dart';
import 'package:project_2/Features/auth/presentation/privacy_and_terms_screen.dart';
import 'package:project_2/Features/auth/presentation/representative_pharmacies_screen.dart';
import 'package:project_2/Features/auth/presentation/warehouse_screen.dart';
import 'package:project_2/Features/auth/presentation/LogIn.dart';
import 'package:project_2/Features/auth/presentation/Profile.dart';
import 'package:project_2/InventoryScreen.dart';
import 'package:project_2/OffersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  Uint8List? _drawerImageBytes;
  String? _drawerImageUrl;

  String? _drawerFullName;
  String? _drawerRole;
  String? _drawerPhone;

  @override
  void initState() {
    super.initState();

    _loadDrawerProfile();
  }

  Future<void> _loadDrawerProfile() async {
    try {
      final profile =
          await sl<ProfileRepository>()
              .getProfile();

      if (!mounted) return;

      setState(() {
        _drawerImageBytes =
            profile.imageBytes;

        _drawerImageUrl =
            profile.imageUrl;

        _drawerFullName =
            profile.fullName;

        _drawerRole =
            profile.role;

        _drawerPhone =
            profile.phone;
      });
    } catch (_) {
      // نترك البيانات الافتراضية
      // إذا تعذر جلب البروفايل.
    }
  }

  void _openWarehouseCompanies(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<WarehouseBloc>(
          create: (_) => sl<WarehouseBloc>(),
          child: const WarehouseScreen(
            initialSection: WarehouseSection.companies,
          ),
        ),
      ),
    );
  }

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
    
    const String fullName = "أحمد محمد";
    const String phone = "0999999999";
    const String role = "مندوب";
  

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
  backgroundColor:  Colors.white.withOpacity(0.94),
  child: SafeArea(
    child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              14,
              14,
              14,
              10,
            ),
            children: [
              // =============================================
              // Header
              // =============================================
             _DrawerProfileHeader(
  fullName:
      _drawerFullName ?? fullName,
  role:
      _drawerRole ?? role,
  phone:
      _drawerPhone ?? phone,
  imageBytes:
      _drawerImageBytes,
  imageUrl:
      _drawerImageUrl,
),

              const SizedBox(height: 22),

              // =============================================
              // Account
              // =============================================
              const _DrawerSectionTitle(
                title: 'الحساب',
              ),

              const SizedBox(height: 8),

              _DrawerGroup(
                children: [
                  _DrawerItem(
                    icon:
                        Icons.manage_accounts_outlined,
                    title: 'إدارة الحساب',
                    subtitle:
                        'بياناتك وإعدادات الحساب',
                    onTap: () async {
  Navigator.pop(context);

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          BlocProvider<ProfileBloc>(
        create: (_) =>
            sl<ProfileBloc>()
              ..add(
                ProfileRequested(),
              ),
        child:
            const ProfilePage(),
      ),
    ),
  );

  if (!mounted) return;

  await _loadDrawerProfile();
},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =============================================
              // About App
              // =============================================
              const _DrawerSectionTitle(
                title: 'حول التطبيق',
              ),

              const SizedBox(height: 8),

              _DrawerGroup(
                children: [
                  _DrawerItem(
                    icon:
                        Icons.info_outline_rounded,
                    title: 'معلومات التطبيق',
                    subtitle:
                        'الإصدار ومعلومات الدعم',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AppInformationScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(
                    height: 1,
                    color: AppColors.border,
                  ),

                  _DrawerItem(
                    icon:
                        Icons.privacy_tip_outlined,
                    title:
                        'الخصوصية والشروط',
                    subtitle:
                        'سياسة الخصوصية وشروط الاستخدام',
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PrivacyAndTermsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // =============================================
        // Logout
        // =============================================
        Padding(
          padding: const EdgeInsets.fromLTRB(
            14,
            8,
            14,
            16,
          ),
          child: _DrawerLogoutButton(
            onTap: () async {
              Navigator.pop(context);

              final bool? confirm =
                  await showDialog<bool>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.danger,
                      size: 42,
                    ),
                    title: const Text(
                      'تسجيل الخروج',
                      textAlign:
                          TextAlign.center,
                    ),
                    content: const Text(
                      'هل أنت متأكد من تسجيل الخروج من الحساب؟',
                      textAlign:
                          TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            false,
                          );
                        },
                        child:
                            const Text('إلغاء'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            true,
                          );
                        },
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              AppColors.danger,
                          foregroundColor:
                              Colors.white,
                        ),
                        child: const Text(
                          'تسجيل الخروج',
                        ),
                      ),
                    ],
                  );
                },
              );

              if (confirm != true ||
                  !context.mounted) {
                return;
              }

              final prefs =
                  await SharedPreferences
                      .getInstance();

              await prefs.remove('token');
              await prefs.remove('role');
              await prefs.remove('name');
              await prefs.remove(
                'usernameOrPhone',
              );

              sl<Dio>()
                  .options
                  .headers
                  .remove(
                    'Authorization',
                  );

              if (!context.mounted) {
                return;
              }

              Navigator.of(context)
                  .pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) =>
                      BlocProvider<LoginBloc>(
                    create: (_) =>
                        sl<LoginBloc>(),
                    child:
                        const RepresentativeLoginScreen(),
                  ),
                ),
                (route) => false,
              );
            },
          ),
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
                    children:  [
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
  color: const Color(0xffDDEBFF),
  onTap: () {
    Navigator.push(
      context,
      representativePharmaciesRoute(),
    );
  },
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () =>
                              _openWarehouseCompanies(context),
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "شركات المستودع",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.chevron_left_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
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
                              onTap: () => _openWarehouseCompanies(context),
                            ),
                            CompanyCircle(
                              name: "أوغاريت",
                              image: "assets/company2.png",
                              onTap: () => _openWarehouseCompanies(context),
                            ),
                            CompanyCircle(
                              name: "ابن حيان",
                              image: "assets/company3.png",
                              onTap: () => _openWarehouseCompanies(context),
                            ),
                            CompanyCircle(
                              name: "يونيفارما",
                              image: "assets/company4.png",
                              onTap: () => _openWarehouseCompanies(context),
                            ),
                            CompanyCircle(
                              name: "آسيا",
                              image: "assets/company5.png",
                              onTap: () => _openWarehouseCompanies(context),
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
  final VoidCallback? onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            /*
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
            */
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon),
            ),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
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
// =========================================================
// Drawer UI
// =========================================================

class _DrawerProfileHeader
    extends StatelessWidget {
  final String fullName;
  final String role;
  final String phone;
  final Uint8List? imageBytes;
final String? imageUrl;

 const _DrawerProfileHeader({
  required this.fullName,
  required this.role,
  required this.phone,
  this.imageBytes,
  this.imageUrl,
});

  @override
  Widget build(BuildContext context) {
    ImageProvider? profileImage;

if (imageBytes != null &&
    imageBytes!.isNotEmpty) {
  profileImage =
      MemoryImage(imageBytes!);
} else if (
    imageUrl != null &&
    imageUrl!.trim().isNotEmpty) {
  profileImage =
      NetworkImage(imageUrl!);
}
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF12355B),
            Color(0xFF1F5C8F),
          ],
        ),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(
                  0x33FFFFFF,
                ),
                width: 3,
              ),
            ),
            child:CircleAvatar(
  radius: 28,
  backgroundColor: Colors.white,
  backgroundImage:
      profileImage,
  child: profileImage == null
      ? const Icon(
          Icons.person_rounded,
          color: AppColors.primary,
          size: 32,
        )
      : null,
),
          ),

          const SizedBox(height: 12),

          Text(
            fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            role,
            style: const TextStyle(
              color: Color(0xFFD8E5F2),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 9),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0x20FFFFFF,
              ),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_outlined,
                  color: Colors.white70,
                  size: 15,
                ),
                const SizedBox(width: 6),
                Text(
                  phone,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerSectionTitle
    extends StatelessWidget {
  final String title;

  const _DrawerSectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DrawerGroup
    extends StatelessWidget {
  final List<Widget> children;

  const _DrawerGroup({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _DrawerItem
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color:
                    AppColors.primarySoft,
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors
                          .textPrimary,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors
                          .textSecondary,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            const Icon(
              Icons.chevron_left_rounded,
              color:
                  AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerLogoutButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _DrawerLogoutButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dangerSoft,
      borderRadius:
          BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          child: const Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: AppColors.danger,
                size: 22,
              ),

              SizedBox(width: 11),

              Expanded(
                child: Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color:
                        AppColors.danger,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_left_rounded,
                color: AppColors.danger,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}