import 'package:flutter/material.dart';

import 'package:project_2/Core/theme/app_colors.dart';

class AppInformationScreen extends StatelessWidget {
  const AppInformationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'معلومات التطبيق',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            28,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
                    BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.medical_services_outlined,
                      color: AppColors.primary,
                      size: 35,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'مندوب المبيعات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'تطبيق إدارة أعمال مندوب المبيعات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD8E5F2),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const _SectionTitle(
              title: 'بيانات التطبيق',
              icon: Icons.info_outline_rounded,
            ),

            const SizedBox(height: 10),

            const _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.apps_rounded,
                  label: 'اسم التطبيق',
                  value: 'مندوب المبيعات',
                ),
                _InfoDivider(),
                _InfoRow(
                  icon: Icons.numbers_rounded,
                  label: 'رقم الإصدار',
                  value: '1.0.0',
                ),
                _InfoDivider(),
                _InfoRow(
                  icon: Icons.update_rounded,
                  label: 'آخر تحديث',
                  value: '16/08/2026',
                ),
              ],
            ),

            const SizedBox(height: 18),

            const _SectionTitle(
              title: 'الدعم',
              icon: Icons.support_agent_rounded,
            ),

            const SizedBox(height: 10),

            const _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'البريد',
                  value: 'support@example.com',
                ),
                _InfoDivider(),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'الهاتف',
                  value: 'غير محدد',
                ),
                _InfoDivider(),
                _InfoRow(
                  icon: Icons.schedule_outlined,
                  label: 'ساعات الدعم',
                  value: 'وفق أوقات عمل الشركة',
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'معلومات التطبيق للقراءة فقط ولا يمكن تعديلها من حساب المندوب.',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12.5,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 21,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 21,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
    );
  }
}
