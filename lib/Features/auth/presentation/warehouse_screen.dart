import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/warehouse_bloc.dart';
import 'package:project_2/Features/auth/bloc/warehouse_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_state.dart';
import 'package:project_2/Features/auth/data/models/warehouse_company_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_overview_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';
import 'package:project_2/Features/auth/presentation/warehouse_company_medicines_screen.dart';
import 'package:project_2/Features/auth/presentation/warehouse_inventory_file_screen.dart';
import 'package:project_2/Features/auth/presentation/warehouse_stock_items_screen.dart';

enum WarehouseSection {
  overview,
  companies,
  lowStock,
  outOfStock,
  inventoryFile,
}

class WarehouseScreen extends StatefulWidget {
  final WarehouseSection initialSection;

  const WarehouseScreen({
    super.key,
    this.initialSection = WarehouseSection.overview,
  });

  @override
  State<WarehouseScreen> createState() =>
      _WarehouseScreenState();
}

class _WarehouseScreenState
    extends State<WarehouseScreen> {
  late WarehouseSection _currentSection;

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection;

    if (_currentSection ==
        WarehouseSection.companies) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        if (!mounted) return;
        context
            .read<WarehouseBloc>()
            .add(
              LoadWarehouseCompaniesEvent(),
            );
      });
    }
  }

 void _openSection(
  WarehouseSection section,
) {
  // =====================================================
  // UC-230 + UC-231
  // =====================================================
  if (section ==
          WarehouseSection.lowStock ||
      section ==
          WarehouseSection.outOfStock) {
    final filter =
        section ==
                WarehouseSection.lowStock
            ? WarehouseStockFilter.lowStock
            : WarehouseStockFilter
                .outOfStock;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WarehouseStockItemsScreen(
          filter: filter,
        ),
      ),
    );

    return;
  }
 // =====================================================
  // UC-230 + UC-231
  // =====================================================
  if (section ==
          WarehouseSection.lowStock ||
      section ==
          WarehouseSection.outOfStock) {
    final filter =
        section ==
                WarehouseSection.lowStock
            ? WarehouseStockFilter.lowStock
            : WarehouseStockFilter
                .outOfStock;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WarehouseStockItemsScreen(
          filter: filter,
        ),
      ),
    );

    return;
  }

  // =====================================================
  // UC-232 + UC-233 + UC-234
  // =====================================================
  if (section ==
      WarehouseSection.inventoryFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const WarehouseInventoryFileScreen(),
      ),
    );

    return;
  }
  // =====================================================
  // UC-224
  // =====================================================
  if (section ==
      WarehouseSection.companies) {
    context
        .read<WarehouseBloc>()
        .add(
          LoadWarehouseCompaniesEvent(),
        );
  }

  setState(() {
    _currentSection = section;
  });
}

  void _backToOverview() {
    context
        .read<WarehouseBloc>()
        .add(
          LoadWarehouseOverviewEvent(),
        );

    setState(() {
      _currentSection =
          WarehouseSection.overview;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.primary,
          title: Text(
            _screenTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: _buildCurrentSection(),
      ),
    );
  }


  Widget _buildCurrentSection() {
    switch (_currentSection) {
      case WarehouseSection.overview:
        return _buildOverview();
      case WarehouseSection.companies:
        return _buildCompanies();
      case WarehouseSection.lowStock:
      case WarehouseSection.outOfStock:
      case WarehouseSection.inventoryFile:
        return _WarehouseSectionPlaceholder(
          section: _currentSection,
          onBack: _backToOverview,
        );
    }
  }

  Widget _buildCompanies() {
    return BlocBuilder<
        WarehouseBloc,
        WarehouseState>(
      builder: (context, state) {
        if (state is WarehouseCompaniesLoading ||
            state is WarehouseInitial ||
            state is WarehouseLoading ||
            state is WarehouseSuccess) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is WarehouseCompaniesFailure) {
          return _WarehouseError(
            message: state.message,
            onRetry: () {
              context
                  .read<WarehouseBloc>()
                  .add(
                    LoadWarehouseCompaniesEvent(),
                  );
            },
          );
        }

        if (state is WarehouseCompaniesSuccess) {
          return _WarehouseCompaniesContent(
            companies: state.companies,
            onBack: _backToOverview,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  String get _screenTitle {
    switch (_currentSection) {
      case WarehouseSection.companies:
        return 'شركات المستودع';
      case WarehouseSection.lowStock:
        return 'الأصناف القابلة للنفاد';
      case WarehouseSection.outOfStock:
        return 'الأصناف غير المتوفرة';
      case WarehouseSection.inventoryFile:
        return 'ملف الجرد';
      case WarehouseSection.overview:
        return 'المستودع';
    }
  }

  Widget _buildOverview() {
    return BlocBuilder<
        WarehouseBloc,
        WarehouseState>(
      builder: (context, state) {
        if (state is WarehouseLoading ||
            state is WarehouseInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is WarehouseFailure) {
          return _WarehouseError(
            message: state.message,
            onRetry: () {
              context
                  .read<WarehouseBloc>()
                  .add(
                    LoadWarehouseOverviewEvent(),
                  );
            },
          );
        }

        if (state is WarehouseSuccess) {
          return _WarehouseOverviewContent(
            overview: state.overview,
            onSectionSelected: _openSection,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _WarehouseOverviewContent
    extends StatelessWidget {
  final WarehouseOverviewModel overview;
  final ValueChanged<WarehouseSection>
      onSectionSelected;

  const _WarehouseOverviewContent({
    required this.overview,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<WarehouseBloc>()
            .add(
              LoadWarehouseOverviewEvent(),
            );
      },
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          28,
        ),
        children: [
          _WarehouseHeader(),
          const SizedBox(height: 14),
          const _ReadOnlyNotice(),
          const SizedBox(height: 22),
          const Text(
            'أقسام المستودع',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _WarehouseSectionCard(
            title: 'شركات المستودع',
            subtitle:
                'استعراض الشركات الدوائية والأصناف التابعة لها.',
            statusText: 'للاطلاع فقط',
            icon: Icons.business_outlined,
            accentColor: AppColors.primary,
            onTap: () {
              onSectionSelected(
                WarehouseSection.companies,
              );
            },
          ),
          const SizedBox(height: 12),
          _WarehouseSectionCard(
            title: 'الأصناف القابلة للنفاد',
            subtitle:
                'متابعة الأصناف التي أصبحت حالتها قابلة للنفاد دون إظهار الكمية.',
            statusText: overview.hasLowStockItems
                ? 'يوجد أصناف تحتاج انتباه'
                : 'لا توجد تنبيهات حالياً',
            icon:
                Icons.warning_amber_rounded,
            accentColor: AppColors.warning,
            onTap: () {
              onSectionSelected(
                WarehouseSection.lowStock,
              );
            },
          ),
          const SizedBox(height: 12),
          _WarehouseSectionCard(
            title: 'الأصناف غير المتوفرة',
            subtitle:
                'استعراض الأصناف ذات حالة غير متوفر دون عرض أي كمية رقمية.',
            statusText: overview.hasOutOfStockItems
                ? 'يوجد أصناف غير متوفرة'
                : 'لا توجد أصناف غير متوفرة',
            icon:
                Icons.remove_shopping_cart_outlined,
            accentColor: AppColors.danger,
            onTap: () {
              onSectionSelected(
                WarehouseSection.outOfStock,
              );
            },
          ),
          const SizedBox(height: 12),
          _WarehouseSectionCard(
            title:
                'ملف الجرد المرفوع من المفوتر',
            subtitle:
                'معاينة ملف الجرد واستخراج نسخة PDF للقراءة فقط.',
            statusText: overview.hasInventoryFile
                ? overview.inventoryFileName ??
                    'يوجد ملف متاح'
                : 'لا يوجد ملف مرفوع حالياً',
            icon:
                Icons.picture_as_pdf_outlined,
            accentColor: AppColors.success,
            onTap: () {
              onSectionSelected(
                WarehouseSection.inventoryFile,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WarehouseHeader
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12355B)
                .withOpacity(0.16),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.14),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.warehouse_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'الجرد والمستودع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'متابعة حالة توفر الأصناف وملف الجرد من مكان واحد.',
                  style: TextStyle(
                    color: Color(0xFFD8E5F2),
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
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

class _ReadOnlyNotice
    extends StatelessWidget {
  const _ReadOnlyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.12),
        ),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.visibility_off_outlined,
            color: AppColors.primary,
            size: 22,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'هذا القسم للاطلاع فقط. الكميات الرقمية غير ظاهرة، ولا يمكن إنشاء طلبية من مسار المستودع.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarehouseSectionCard
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusText;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _WarehouseSectionCard({
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      accentColor.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color:
                            AppColors.textSecondary,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      statusText,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarehouseCompaniesContent
    extends StatelessWidget {
  final List<WarehouseCompanyModel> companies;
  final VoidCallback onBack;

  const _WarehouseCompaniesContent({
    required this.companies,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<WarehouseBloc>()
            .add(
              LoadWarehouseCompaniesEvent(),
            );
      },
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          28,
        ),
        children: [
          const _CompaniesHeader(),
          const SizedBox(height: 12),
          const _CompaniesReadOnlyNotice(),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'الشركات الدوائية',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  '${companies.length} شركة',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (companies.isEmpty)
            const _WarehouseEmptyState(
              icon: Icons.business_outlined,
              title: 'لا توجد شركات حالياً',
              subtitle:
                  'لم يتم العثور على شركات دوائية ضمن بيانات المستودع.',
            )
          else
            ...companies.map(
              (company) => Padding(
                padding:
                    const EdgeInsets.only(bottom: 10),
                child: _WarehouseCompanyCard(
                  company: company,
                ),
              ),
            ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(
              Icons.grid_view_rounded,
            ),
            label: const Text(
              'العودة إلى أقسام المستودع',
            ),
          ),
        ],
      ),
    );
  }
}

class _CompaniesHeader
    extends StatelessWidget {
  const _CompaniesHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Row(
        children: [
          _WarehouseIconBox(
            icon: Icons.business_outlined,
            color: AppColors.primary,
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'شركات المستودع',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'استعراض الشركات الدوائية الموجودة في المستودع.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.45,
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

class _CompaniesReadOnlyNotice
    extends StatelessWidget {
  const _CompaniesReadOnlyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.visibility_outlined,
            color: AppColors.primary,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'القائمة للاطلاع فقط، ولا يبدأ منها إنشاء طلبية أو إضافة أصناف إلى السلة.',
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
    );
  }
}

class _WarehouseCompanyCard
    extends StatelessWidget {
  final WarehouseCompanyModel company;

  const _WarehouseCompanyCard({
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  WarehouseCompanyMedicinesScreen(
                company: company,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              const _WarehouseIconBox(
                icon: Icons.apartment_rounded,
                color: AppColors.primary,
                size: 46,
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: const TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.medication_outlined,
                          color:
                              AppColors.textSecondary,
                          size: 17,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          company.itemsCount == null
                              ? 'عدد الأصناف غير متوفر'
                              : '${company.itemsCount} صنف',
                          style: const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 12.5,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'عرض الأدوية',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _WarehouseIconBox
    extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _WarehouseIconBox({
    required this.icon,
    required this.color,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.52,
      ),
    );
  }
}

class _WarehouseEmptyState
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WarehouseEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 42,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarehouseSectionPlaceholder
    extends StatelessWidget {
  final WarehouseSection section;
  final VoidCallback onBack;

  const _WarehouseSectionPlaceholder({
    required this.section,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final data = _sectionData(section);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        28,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color:
                      data.color.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: Icon(
                  data.icon,
                  color: data.color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(
                    Icons.grid_view_rounded,
                  ),
                  label: const Text(
                    'العودة إلى أقسام المستودع',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _WarehouseSectionData _sectionData(
    WarehouseSection section,
  ) {
    switch (section) {
      case WarehouseSection.companies:
        return const _WarehouseSectionData(
          title: 'شركات المستودع',
          description:
              'تم تجهيز مسار هذا القسم داخل شاشة المستودع، وسيتم عرض قائمة الشركات والأصناف فيه ضمن الخطوات التالية.',
          icon: Icons.business_outlined,
          color: AppColors.primary,
        );
      case WarehouseSection.lowStock:
        return const _WarehouseSectionData(
          title: 'الأصناف القابلة للنفاد',
          description:
              'هذا المسار مخصص لعرض الأصناف ذات الحالة الوصفية قابل للنفاد فقط، دون أي كمية رقمية.',
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
        );
      case WarehouseSection.outOfStock:
        return const _WarehouseSectionData(
          title: 'الأصناف غير المتوفرة',
          description:
              'هذا المسار مخصص لعرض الأصناف غير المتوفرة للقراءة فقط ودون إمكانية إضافتها إلى طلبية.',
          icon:
              Icons.remove_shopping_cart_outlined,
          color: AppColors.danger,
        );
      case WarehouseSection.inventoryFile:
        return const _WarehouseSectionData(
          title:
              'ملف الجرد المرفوع من المفوتر',
          description:
              'هذا المسار مخصص لمعاينة ملف الجرد واستخراج نسخة PDF دون تعديل الملف الأصلي.',
          icon: Icons.picture_as_pdf_outlined,
          color: AppColors.success,
        );
      case WarehouseSection.overview:
        return const _WarehouseSectionData(
          title: 'المستودع',
          description: '',
          icon: Icons.warehouse_outlined,
          color: AppColors.primary,
        );
    }
  }
}

class _WarehouseSectionData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _WarehouseSectionData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _WarehouseError
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _WarehouseError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
