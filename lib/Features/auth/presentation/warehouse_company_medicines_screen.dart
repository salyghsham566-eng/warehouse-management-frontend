import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/warehouse_bloc.dart';
import 'package:project_2/Features/auth/bloc/warehouse_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_state.dart';
import 'package:project_2/Features/auth/data/models/warehouse_company_model.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_model.dart';
import 'package:project_2/Features/auth/presentation/warehouse_medicine_details_screen.dart';

class WarehouseCompanyMedicinesScreen extends StatelessWidget {
  final WarehouseCompanyModel company;

  const WarehouseCompanyMedicinesScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WarehouseBloc>(
      create: (_) => sl<WarehouseBloc>()
        ..add(
          LoadWarehouseCompanyMedicinesEvent(
            companyId: company.id,
            companyName: company.name,
          ),
        ),
      child: _WarehouseCompanyMedicinesView(
        company: company,
      ),
    );
  }
}

class _WarehouseCompanyMedicinesView extends StatelessWidget {
  final WarehouseCompanyModel company;

  const _WarehouseCompanyMedicinesView({
    required this.company,
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
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.primary,
          title: const Text(
            'أدوية الشركة',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: BlocBuilder<WarehouseBloc, WarehouseState>(
          builder: (context, state) {
            if (state is WarehouseCompanyMedicinesLoading ||
                state is WarehouseInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WarehouseCompanyMedicinesFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context.read<WarehouseBloc>().add(
                        LoadWarehouseCompanyMedicinesEvent(
                          companyId: company.id,
                          companyName: company.name,
                        ),
                      );
                },
              );
            }

            if (state is WarehouseCompanyMedicinesSuccess) {
              return _MedicinesContent(
                companyName: state.companyName,
                medicines: state.medicines,
                onRefresh: () async {
                  context.read<WarehouseBloc>().add(
                        LoadWarehouseCompanyMedicinesEvent(
                          companyId: company.id,
                          companyName: company.name,
                        ),
                      );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _MedicinesContent extends StatefulWidget {
  final String companyName;
  final List<WarehouseMedicineModel> medicines;
  final Future<void> Function() onRefresh;

  const _MedicinesContent({
    required this.companyName,
    required this.medicines,
    required this.onRefresh,
  });

  @override
  State<_MedicinesContent> createState() =>
      _MedicinesContentState();
}

class _MedicinesContentState
    extends State<_MedicinesContent> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WarehouseMedicineModel> get _filteredMedicines {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.medicines;
    }

    return widget.medicines.where((medicine) {
      final tradeName =
          medicine.tradeName.trim().toLowerCase();

      return tradeName.contains(query);
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMedicines = _filteredMedicines;
    final isSearching =
        _searchQuery.trim().isNotEmpty;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
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
          _CompanyHeader(
            companyName: widget.companyName,
            itemsCount: widget.medicines.length,
          ),

          const SizedBox(height: 12),

          const _ReadOnlyNotice(),

          const SizedBox(height: 18),

          // =====================================================
          // UC-226: البحث داخل أدوية الشركة
          // =====================================================
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText:
                  'ابحث باسم الدواء أو جزء منه',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
              ),
              suffixIcon: isSearching
                  ? IconButton(
                      tooltip: 'مسح البحث',
                      onPressed: _clearSearch,
                      icon: const Icon(
                        Icons.close_rounded,
                        color:
                            AppColors.textSecondary,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'الأصناف الدوائية',
                  style: TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              if (isSearching)
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        AppColors.primarySoft,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filteredMedicines.length} نتيجة',
                    style: const TextStyle(
                      color:
                          AppColors.primary,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (widget.medicines.isEmpty)
            const _EmptyView()
          else if (filteredMedicines.isEmpty)
            _SearchEmptyView(
              searchText: _searchQuery,
              onClear: _clearSearch,
            )
          else
            ...filteredMedicines.map(
              (medicine) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _MedicineCard(
                  medicine: medicine,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CompanyHeader extends StatelessWidget {
  final String companyName;
  final int itemsCount;

  const _CompanyHeader({
    required this.companyName,
    required this.itemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$itemsCount صنف دوائي',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
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

class _ReadOnlyNotice extends StatelessWidget {
  const _ReadOnlyNotice();

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
              'الأصناف معروضة للاطلاع فقط من مسار المستودع، ولا يمكن إضافتها إلى السلة أو بدء طلبية من هنا.',
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

class _MedicineCard extends StatelessWidget {
  final WarehouseMedicineModel medicine;

  const _MedicineCard({
    required this.medicine,
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
              WarehouseMedicineDetailsScreen(
            medicineId: medicine.id,
          ),
        ),
      );
    },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.medication_outlined,
                color: AppColors.primary,
                size: 25,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.tradeName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    medicine.scientificName.trim().isEmpty
                        ? 'الاسم العلمي غير محدد'
                        : medicine.scientificName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'للاطلاع',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
class _SearchEmptyView extends StatelessWidget {
  final String searchText;
  final VoidCallback onClear;

  const _SearchEmptyView({
    required this.searchText,
    required this.onClear,
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
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.textSecondary,
            size: 42,
          ),

          const SizedBox(height: 10),

          const Text(
            'لا توجد نتائج',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'لم يتم العثور على دواء باسم "$searchText"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(
              Icons.close_rounded,
            ),
            label: const Text(
              'مسح البحث',
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.medication_outlined,
            color: AppColors.textSecondary,
            size: 42,
          ),
          SizedBox(height: 10),
          Text(
            'لا توجد أصناف لهذه الشركة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
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
              size: 45,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
