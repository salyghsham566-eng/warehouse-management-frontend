import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Features/auth/bloc/evaluation_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_event.dart';
import 'package:project_2/Features/auth/bloc/work_plans_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plans_event.dart';
import 'package:project_2/Features/auth/presentation/evaluation_screen.dart';
import 'package:project_2/work_plans_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<_MoreOption> options = [
      _MoreOption(
        title: 'خطط العمل',
        subtitle: 'عرض ومتابعة الخطط',
        icon: Icons.assignment_outlined,
        onTap: () {
       Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) {
      return BlocProvider<WorkPlansBloc>(
        create: (_) {
          return sl<WorkPlansBloc>()
            ..add(LoadWorkPlansEvent());
        },
        child: const WorkPlansScreen(),
      );
    },
  ),
);
        },
      ),
_MoreOption(
  title: 'تقييمي',
  subtitle:
      'عرض التقييم الشهري والأداء',

  icon:
      Icons.workspace_premium_outlined,

  onTap: () {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) {
          return BlocProvider<
              EvaluationBloc>(
            create: (_) =>
                sl<EvaluationBloc>()
                  ..add(
                    LoadCurrentEvaluationEvent(),
                  ),

            child:
                const EvaluationScreen(),
          );
        },
      ),
    );
  },
),
      // لاحقاً منضيف باقي أقسام "المزيد" هون.
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'المزيد',
            style: TextStyle(
              color: Color(0xFF101828),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        body: GridView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: options.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,

            // المسافة بين العامودين
            crossAxisSpacing: 12,

            // المسافة بين الصفوف
            mainAxisSpacing: 12,

            // شكل الكارد
            childAspectRatio: 1.15,
          ),

          itemBuilder: (context, index) {
            return _MoreCard(
              option: options[index],
            );
          },
        ),
      ),
    );
  }
}

// ==========================================================
// بيانات كل عنصر داخل صفحة المزيد
// ==========================================================

class _MoreOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MoreOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

// ==========================================================
// تصميم الكارد
// ==========================================================

class _MoreCard extends StatelessWidget {
  final _MoreOption option;

  const _MoreCard({
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(18),

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE4E7EC),
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // الأيقونة
              // =========================
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2D5B).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  option.icon,
                  size: 26,
                  color: const Color(0xFF0B2D5B),
                ),
              ),

              const Spacer(),

              // =========================
              // اسم القسم
              // =========================
              Text(
                option.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),

              const SizedBox(height: 5),

              // =========================
              // الوصف
              // =========================
              Text(
                option.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}