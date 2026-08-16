import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/evaluation_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_event.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_bloc.dart';
import 'package:project_2/Features/auth/bloc/login_bloc.dart';
import 'package:project_2/Features/auth/bloc/notifications_bloc.dart';
import 'package:project_2/Features/auth/bloc/notifications_event.dart';
import 'package:project_2/Features/auth/bloc/offers_bloc.dart';
import 'package:project_2/Features/auth/bloc/offers_event.dart';
import 'package:project_2/Features/auth/bloc/profile_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plans_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plans_event.dart';

import 'package:project_2/Features/auth/data/models/notification_model.dart';
import 'package:project_2/Features/auth/data/models/profile_model.dart';

import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_dashboard_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/notifications_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/orders_tracking_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';

import 'package:project_2/Features/auth/presentation/2pharmacy_search_page.dart';
import 'package:project_2/Features/auth/presentation/ChooseCompanyScreen.dart';
import 'package:project_2/Features/auth/presentation/LogIn.dart';
import 'package:project_2/Features/auth/presentation/Profile.dart';
import 'package:project_2/Features/auth/presentation/app_information_screen.dart';
import 'package:project_2/Features/auth/presentation/evaluation_screen.dart';
import 'package:project_2/Features/auth/presentation/notification_details_screen.dart';
import 'package:project_2/Features/auth/presentation/notifications_screen.dart';
import 'package:project_2/Features/auth/presentation/privacy_and_terms_screen.dart';
import 'package:project_2/Features/auth/presentation/representative_financial_page.dart';
import 'package:project_2/Features/auth/presentation/representative_offers_screen.dart';
import 'package:project_2/Features/auth/presentation/representative_pharmacies_screen.dart';
import 'package:project_2/Features/auth/presentation/warehouse_screen.dart';
import 'package:project_2/work_plans_screen.dart';
import 'package:project_2/collection_feature_page.dart';
import 'package:project_2/Features/auth/presentation/orders_tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProfileModel? _profile;

  bool _isLoading = true;
  bool _isRefreshing = false;

  int _todayOrdersCount = 0;
  int _pendingOrdersCount = 0;
  String _pendingReceivables = '—';
  String _todayCollections = '—';
  String _targetAchievement = '—';
  String _debtorPharmacies = '—';

  List<NotificationModel> _latestNotifications = const [];
  int _unreadNotificationsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  // =========================================================
  // HOME DATA
  // كل بيانات الرئيسية تُقرأ من نفس Repositories المستخدمة
  // في الشاشات الأصلية، لذلك Mock/Remote يظلان متطابقين.
  // =========================================================

  Future<void> _loadHomeData({bool refresh = false}) async {
    if (mounted) {
      setState(() {
        if (refresh) {
          _isRefreshing = true;
        } else {
          _isLoading = true;
        }
      });
    }

    ProfileModel? profile = _profile;
    int todayOrders = _todayOrdersCount;
    int pendingOrders = _pendingOrdersCount;
    String receivables = _pendingReceivables;
    String collections = _todayCollections;
    String target = _targetAchievement;
    String debtorPharmacies = _debtorPharmacies;
    List<NotificationModel> latest = _latestNotifications;
    int unreadCount = _unreadNotificationsCount;

    // Profile: الاسم + الصورة + الدور + المناطق
    try {
      profile = await sl<ProfileRepository>().getProfile();
    } catch (_) {}

    // Orders: طلبات اليوم + الطلبات المعلقة
    try {
      final orders = await sl<OrdersTrackingRepository>().getOrders();
      final now = DateTime.now();

      todayOrders = orders.where((order) {
        return _isSameDay(order.createdAt, now);
      }).length;

      pendingOrders = orders.where((order) {
        final status = order.status.trim().toLowerCase();
        return status == 'pending_review' ||
            status == 'pending' ||
            status == 'waiting_review' ||
            status == 'waiting_for_review';
      }).length;
    } catch (_) {}

    // Financial: ذمم + تحصيلات اليوم + الصيدليات المدينة
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(now.year, now.month, now.day);
      final endOfToday = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
        999,
      );

      final dashboard =
          await sl<FinancialDashboardRepository>().getFinancialDashboard(
        fromDate: startOfToday,
        toDate: endOfToday,
        regionId: 'all',
      );

      receivables = dashboard.metricById('total_receivables')?.formattedValue ?? '—';
      collections = dashboard.metricById('total_collections')?.formattedValue ?? '—';
      debtorPharmacies =
          dashboard.metricById('debtor_pharmacies')?.formattedValue ?? '—';
    } catch (_) {}

    // Evaluation: نسبة تحقيق التارجت الفعلية
    try {
      final evaluation =
          await sl<EvaluationRepository>().getCurrentEvaluation(regionId: 'all');

      final targetDetails =
          await sl<EvaluationRepository>().getTargetDetails(
        regionId: 'all',
        month: evaluation.month,
        year: evaluation.year,
      );

      target = '${targetDetails.percentage.toStringAsFixed(0)}%';
    } catch (_) {}

    // Notifications: آخر 3 + العداد
    try {
      final notifications =
          await sl<NotificationsRepository>().getNotifications();

      notifications.sort(
        (a, b) => b.dateTime.compareTo(a.dateTime),
      );

      unreadCount = notifications.where((item) => !item.isRead).length;
      latest = notifications.take(3).toList();
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _profile = profile;
      _todayOrdersCount = todayOrders;
      _pendingOrdersCount = pendingOrders;
      _pendingReceivables = receivables;
      _todayCollections = collections;
      _targetAchievement = target;
      _debtorPharmacies = debtorPharmacies;
      _latestNotifications = latest;
      _unreadNotificationsCount = unreadCount;
      _isLoading = false;
      _isRefreshing = false;
    });
  }

  Future<void> _reloadNotifications() async {
    try {
      final notifications =
          await sl<NotificationsRepository>().getNotifications();

      notifications.sort(
        (a, b) => b.dateTime.compareTo(a.dateTime),
      );

      if (!mounted) return;

      setState(() {
        _unreadNotificationsCount =
            notifications.where((item) => !item.isRead).length;
        _latestNotifications = notifications.take(3).toList();
      });
    } catch (_) {}
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // =========================================================
  // ROUTES
  // =========================================================

  void _openNewOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChooseCompanyPage(),
      ),
    );
  }

  void _openRecordPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CollectionPharmaciesFilterScreen(),
      ),
    );
  }

  void _openPharmacies() {
    Navigator.push(
      context,
      representativePharmaciesRoute(),
    );
  }

  void _openOrdersTracking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrdersTrackingScreen(),
      ),
    );
  }

  void _openCollectionDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CollectionDashboardFeaturePage(),
      ),
    );
  }

  void _openWorkPlans() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<WorkPlansBloc>(
          create: (_) => sl<WorkPlansBloc>()..add(LoadWorkPlansEvent()),
          child: const WorkPlansScreen(),
        ),
      ),
    );
  }

  void _openOffers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<OffersBloc>(
          create: (_) => sl<OffersBloc>()..add(LoadOffersEvent()),
          child: const RepresentativeOffersScreen(),
        ),
      ),
    );
  }

  void _openEvaluation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<EvaluationBloc>(
          create: (_) => sl<EvaluationBloc>()..add(LoadCurrentEvaluationEvent()),
          child: const EvaluationScreen(),
        ),
      ),
    );
  }

  void _openFinancial() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<FinancialDashboardBloc>(
          create: (_) => sl<FinancialDashboardBloc>(),
          child: const RepresentativeFinancialPage(),
        ),
      ),
    );
  }

  void _openWarehouse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<WarehouseBloc>(
          create: (_) => sl<WarehouseBloc>(),
          child: const WarehouseScreen(),
        ),
      ),
    );
  }

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<NotificationsBloc>(
          create: (_) => sl<NotificationsBloc>()..add(LoadNotificationsEvent()),
          child: const NotificationsScreen(),
        ),
      ),
    );

    if (!mounted) return;
    await _reloadNotifications();
  }

  Future<void> _openNotificationDetails(NotificationModel notification) async {
    NotificationModel openedNotification = notification;

    if (!notification.isRead) {
      try {
        await sl<NotificationsRepository>().markNotificationAsRead(
          notification.id,
        );
        openedNotification = notification.copyWith(isRead: true);
      } catch (_) {}
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailsScreen(
          notification: openedNotification,
        ),
      ),
    );

    if (!mounted) return;
    await _reloadNotifications();
  }

  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>()..add(ProfileRequested()),
          child: const ProfilePage(),
        ),
      ),
    );

    if (!mounted) return;

    // مهم: عند تعديل الصورة في الملف الشخصي نعيد جلب الـProfile،
    // لذلك تتبدل الصورة في الهوم والدراور والـAppBar فور الرجوع.
    await _loadHomeData(refresh: true);
  }

  ImageProvider? get _profileImage {
    final Uint8List? bytes = _profile?.imageBytes;
    final String? url = _profile?.imageUrl;

    if (bytes != null && bytes.isNotEmpty) {
      return MemoryImage(bytes);
    }

    if (url != null && url.trim().isNotEmpty) {
      return NetworkImage(url.trim());
    }

    return null;
  }

  String get _displayName {
    final value = _profile?.fullName.trim() ?? '';
    return value.isEmpty ? 'مندوب المبيعات' : value;
  }

  String get _displayRole {
    final value = _profile?.role.trim() ?? '';
    return value.isEmpty ? 'مندوب' : value;
  }

  String get _regionsText {
    final regions = _profile?.linkedRegions
            .map((region) => region.name.trim())
            .where((name) => name.isNotEmpty)
            .toList() ??
        const <String>[];

    if (regions.isEmpty) return 'جميع المناطق المرتبطة';
    return regions.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (scaffoldContext) {
              return IconButton(
                tooltip: 'القائمة',
                onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
              );
            },
          ),
          title: const Text(
            'الرئيسية',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                IconButton(
                  tooltip: 'الإشعارات',
                  onPressed: _openNotifications,
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
                if (_unreadNotificationsCount > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _unreadNotificationsCount > 9
                            ? '9+'
                            : '$_unreadNotificationsCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 4),
              child: InkWell(
                onTap: _openProfile,
                customBorder: const CircleBorder(),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primarySoft,
                  backgroundImage: _profileImage,
                  child: _profileImage == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 21,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _loadHomeData(refresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: LinearProgressIndicator(minHeight: 2),
                )
              else if (_isRefreshing)
                const SizedBox.shrink(),

              // =================================================
              // الصورة + الاسم + المنطقة
              // =================================================
              _ProfileWelcomeCard(
                fullName: _displayName,
                role: _displayRole,
                regionsText: _regionsText,
                imageProvider: _profileImage,
               
              ),

              const SizedBox(height: 18),

              const _SectionTitle(
                title: 'ملخص اليوم',
                subtitle: 'مؤشرات مرتبطة مباشرة ببيانات حسابك',
              ),

              const SizedBox(height: 10),

              // =================================================
              // الست كروت - نفس فكرة الهوم القديمة لكن بيانات حقيقية
              // =================================================
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.46,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeStatCard(
                    title: 'طلبات اليوم',
                    value: '$_todayOrdersCount',
                    icon: Icons.shopping_bag_outlined,
                    color: AppColors.primary,
                  
                  ),
                  HomeStatCard(
                    title: 'طلبات معلقة',
                    value: '$_pendingOrdersCount',
                    icon: Icons.pending_actions_rounded,
                    color: const Color(0xFFF79009),
                   
                  ),
                  HomeStatCard(
                    title: 'مديونية معلقة',
                    value: _pendingReceivables,
                    icon: Icons.account_balance_wallet_outlined,
                    color: const Color(0xFFD92D20),
                 
                  ),
                  HomeStatCard(
                    title: 'تحصيلات اليوم',
                    value: _todayCollections,
                    icon: Icons.payments_outlined,
                    color: const Color(0xFF039855),
                  
                  ),
                  HomeStatCard(
                    title: 'تحقيق التارجت',
                    value: _targetAchievement,
                    icon: Icons.track_changes_rounded,
                    color: const Color(0xFF6941C6),
                  
                  ),
                  HomeStatCard(
                    title: 'صيدليات مدينة',
                    value: _debtorPharmacies,
                    icon: Icons.local_pharmacy_outlined,
                    color: const Color(0xFF175CD3),
                   
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const _SectionTitle(
                title: 'اختصارات سريعة',
                subtitle: 'وصول مباشر للأقسام المستخدمة يومياً',
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 94,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    QuickAction(
                      icon: Icons.add_shopping_cart_rounded,
                      title: 'طلب جديد',
                      color: AppColors.primary,
                      onTap: _openNewOrder,
                    ),
                    QuickAction(
                      icon: Icons.payments_outlined,
                      title: 'تسجيل دفعة',
                      color: const Color(0xFF039855),
                      onTap: _openRecordPayment,
                    ),
                    QuickAction(
                      icon: Icons.local_pharmacy_outlined,
                      title: 'الصيدليات',
                      color: const Color(0xFF175CD3),
                      onTap: _openPharmacies,
                    ),
                    QuickAction(
                      icon: Icons.assignment_outlined,
                      title: 'خطة العمل',
                      color: const Color(0xFF6941C6),
                      onTap: _openWorkPlans,
                    ),
                    QuickAction(
                      icon: Icons.local_offer_outlined,
                      title: 'العروض',
                      color: const Color(0xFFF79009),
                      onTap: _openOffers,
                    ),
                    QuickAction(
                      icon: Icons.inventory_2_outlined,
                      title: 'المستودع',
                      color: const Color(0xFF475467),
                      onTap: _openWarehouse,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  const Expanded(
                    child: _SectionTitle(
                      title: 'آخر الإشعارات',
                      subtitle: 'أحدث التنبيهات المرتبطة بحسابك',
                    ),
                  ),
                  TextButton(
                    onPressed: _openNotifications,
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (_latestNotifications.isEmpty)
                const _EmptyNotificationsCard()
              else
                ..._latestNotifications.map(
                  (notification) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: HomeNotificationCard(
                      notification: notification,
                      onTap: () => _openNotificationDetails(notification),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.96),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                children: [
                  _DrawerProfileHeader(
                    fullName: _displayName,
                    role: _displayRole,
                    phone: _profile?.phone ?? '',
                    imageProvider: _profileImage,
                    onTap: () {
                      Navigator.pop(context);
                      _openProfile();
                    },
                  ),
                  const SizedBox(height: 20),
                  const _DrawerSectionTitle(title: 'الحساب'),
                  const SizedBox(height: 8),
                  _DrawerGroup(
                    children: [
                      _DrawerItem(
                        icon: Icons.manage_accounts_outlined,
                        title: 'إدارة الحساب',
                        subtitle: 'الملف الشخصي وبيانات الحساب',
                        onTap: () {
                          Navigator.pop(context);
                          _openProfile();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _DrawerSectionTitle(title: 'حول التطبيق'),
                  const SizedBox(height: 8),
                  _DrawerGroup(
                    children: [
                      _DrawerItem(
                        icon: Icons.info_outline_rounded,
                        title: 'معلومات التطبيق',
                        subtitle: 'الإصدار ومعلومات الدعم',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AppInformationScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      _DrawerItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'الخصوصية والشروط',
                        subtitle: 'سياسة الخصوصية وشروط الاستخدام',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PrivacyAndTermsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
              child: _DrawerLogoutButton(
                onTap: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    Navigator.pop(context);

    final bool? confirm = await showDialog<bool>(
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
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'هل أنت متأكد من تسجيل الخروج من الحساب؟',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
              ),
              child: const Text('تسجيل الخروج'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('name');
    await prefs.remove('usernameOrPhone');

    sl<Dio>().options.headers.remove('Authorization');

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => BlocProvider<LoginBloc>(
          create: (_) => sl<LoginBloc>(),
          child: const RepresentativeLoginScreen(),
        ),
      ),
      (route) => false,
    );
  }
}

// =========================================================
// PROFILE WELCOME CARD
// =========================================================

class _ProfileWelcomeCard extends StatelessWidget {
  final String fullName;
  final String role;
  final String regionsText;
  final ImageProvider? imageProvider;


  const _ProfileWelcomeCard({
    required this.fullName,
    required this.role,
    required this.regionsText,
    required this.imageProvider,
   
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
     
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF12355B),
                Color(0xFF245E91),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A12355B),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0x55FFFFFF),
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 34,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، $fullName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      role,
                      style: const TextStyle(
                        color: Color(0xFFD9E8F5),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            regionsText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// SECTION TITLE
// =========================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// =========================================================
// SIX STAT CARDS
// =========================================================

class HomeStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const HomeStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
   
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 19),
                  ),
                  
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: color,
                  fontSize: value.length > 12 ? 15 : 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}

// =========================================================
// QUICK ACTION
// =========================================================

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 82,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// LATEST NOTIFICATION CARD
// =========================================================

class HomeNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const HomeNotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _notificationColor(notification.type);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.border
                  : color.withOpacity(0.35),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _notificationIcon(notification.type),
                  color: color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: notification.isRead
                                  ? FontWeight.w700
                                  : FontWeight.w900,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _relativeTime(notification.dateTime),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyNotificationsCard extends StatelessWidget {
  const _EmptyNotificationsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'لا توجد إشعارات حالياً',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// DRAWER
// =========================================================

class _DrawerProfileHeader extends StatelessWidget {
  final String fullName;
  final String role;
  final String phone;
  final ImageProvider? imageProvider;
  final VoidCallback onTap;

  const _DrawerProfileHeader({
    required this.fullName,
    required this.role,
    required this.phone,
    required this.imageProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF12355B),
              Color(0xFF1F5C8F),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 32,
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              role,
              style: const TextStyle(
                color: Color(0xFFD8E5F2),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (phone.trim().isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(
                phone,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  final String title;

  const _DrawerSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
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

class _DrawerGroup extends StatelessWidget {
  final List<Widget> children;

  const _DrawerGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _DrawerItem extends StatelessWidget {
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
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 21),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DrawerLogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.dangerSoft,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.danger, size: 21),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: AppColors.danger,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// NOTIFICATION HELPERS
// =========================================================

IconData _notificationIcon(NotificationType type) {
  switch (type) {
    case NotificationType.orders:
      return Icons.shopping_bag_outlined;
    case NotificationType.collection:
      return Icons.payments_outlined;
    case NotificationType.workPlans:
      return Icons.assignment_outlined;
    case NotificationType.offers:
      return Icons.local_offer_outlined;
    case NotificationType.evaluation:
      return Icons.workspace_premium_outlined;
    case NotificationType.general:
      return Icons.campaign_outlined;
  }
}

Color _notificationColor(NotificationType type) {
  switch (type) {
    case NotificationType.orders:
      return const Color(0xFF175CD3);
    case NotificationType.collection:
      return const Color(0xFF039855);
    case NotificationType.workPlans:
      return const Color(0xFF6941C6);
    case NotificationType.offers:
      return const Color(0xFFF79009);
    case NotificationType.evaluation:
      return const Color(0xFFC11574);
    case NotificationType.general:
      return const Color(0xFF475467);
  }
}

String _relativeTime(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inMinutes < 1) return 'الآن';
  if (difference.inMinutes < 60) return 'قبل ${difference.inMinutes} دقيقة';
  if (difference.inHours < 24) return 'قبل ${difference.inHours} ساعة';
  if (difference.inDays == 1) return 'أمس';
  if (difference.inDays < 7) return 'قبل ${difference.inDays} أيام';

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
