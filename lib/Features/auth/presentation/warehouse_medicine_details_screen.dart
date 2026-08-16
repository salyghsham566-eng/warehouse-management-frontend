import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/warehouse_bloc.dart';
import 'package:project_2/Features/auth/bloc/warehouse_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_state.dart';
import 'package:project_2/Features/auth/data/models/warehouse_medicine_details_model.dart';

class WarehouseMedicineDetailsScreen
    extends StatelessWidget {
  final String medicineId;

  const WarehouseMedicineDetailsScreen({
    super.key,
    required this.medicineId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WarehouseBloc>(
      create: (_) => sl<WarehouseBloc>()
        ..add(
          LoadWarehouseMedicineDetailsEvent(
            medicineId: medicineId,
          ),
        ),
      child: _WarehouseMedicineDetailsView(
        medicineId: medicineId,
      ),
    );
  }
}

class _WarehouseMedicineDetailsView
    extends StatelessWidget {
  final String medicineId;

  const _WarehouseMedicineDetailsView({
    required this.medicineId,
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
            'تفاصيل الدواء',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: BlocBuilder<
            WarehouseBloc,
            WarehouseState>(
          builder: (context, state) {
            if (state
                    is WarehouseMedicineDetailsLoading ||
                state is WarehouseInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state
                is WarehouseMedicineDetailsFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<WarehouseBloc>()
                      .add(
                        LoadWarehouseMedicineDetailsEvent(
                          medicineId:
                              medicineId,
                        ),
                      );
                },
              );
            }

            if (state
                is WarehouseMedicineDetailsSuccess) {
              return _MedicineDetailsContent(
                details: state.details,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _MedicineDetailsContent
    extends StatelessWidget {
  final WarehouseMedicineDetailsModel details;

  const _MedicineDetailsContent({
    required this.details,
  });

  String _formatPrice(double? price) {
    if (price == null) {
      return 'غير محدد';
    }

    if (price == price.roundToDouble()) {
      return '${price.toInt()}';
    }

    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        28,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius:
                      BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  color: AppColors.primary,
                  size: 31,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.tradeName.isEmpty
                          ? 'اسم الدواء غير محدد'
                          : details.tradeName,
                      style: const TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      details.scientificName
                              .trim()
                              .isEmpty
                          ? 'الاسم العلمي غير محدد'
                          : details
                              .scientificName,
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.visibility_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'هذه البيانات للقراءة فقط. لا تُعرض الكمية الرقمية ولا يمكن إضافة الصنف إلى السلة من مسار المستودع.',
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

        const SizedBox(height: 18),

        const Text(
          'بيانات الصنف',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        _DetailsCard(
          children: [
            _DetailsRow(
              icon: Icons.science_outlined,
              label: 'الاسم العلمي',
              value: details.scientificName
                      .trim()
                      .isEmpty
                  ? 'غير محدد'
                  : details.scientificName,
            ),
            const _DetailsDivider(),
            _DetailsRow(
              icon: Icons.apartment_outlined,
              label: 'الشركة',
              value: details.companyName
                      .trim()
                      .isEmpty
                  ? 'غير محدد'
                  : details.companyName,
            ),
            const _DetailsDivider(),
            _DetailsRow(
              icon:
                  Icons.payments_outlined,
              label: 'السعر',
              value:
                  _formatPrice(details.price),
            ),
            const _DetailsDivider(),
            _DetailsRow(
              icon:
                  Icons.local_offer_outlined,
              label: 'العرض',
              value: details.offerText
                          ?.trim()
                          .isNotEmpty ==
                      true
                  ? details.offerText!
                  : 'لا يوجد عرض حالياً',
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Text(
          'التوفر والصلاحية',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        _DetailsCard(
          children: [
           _StatusDetailsRow(
  icon:
      Icons.inventory_2_outlined,
  label: 'حالة التوفر',
  value:
      details.availabilityStatus,
  color: _availabilityColor(
    details.availabilityStatus,
  ),
  showWarning:
      details.availabilityStatus ==
          'قابل للنفاد',
),
            const _DetailsDivider(),
            _DetailsRow(
              icon:
                  Icons.event_outlined,
              label: 'تاريخ الانتهاء',
              value: details.expiryDate
                          ?.trim()
                          .isNotEmpty ==
                      true
                  ? details.expiryDate!
                  : 'غير محدد',
            ),
            const _DetailsDivider(),
           _StatusDetailsRow(
  icon:
      Icons.health_and_safety_outlined,
  label: 'حالة الصلاحية',
  value:
      details.expiryStatus,
  color: _expiryColor(
    details.expiryStatus,
  ),
  showWarning:
      details.expiryStatus ==
          'قريب الانتهاء',
),
          ],
        ),
      ],
    );
  }

 static Color _availabilityColor(
  String status,
) {
  switch (status.trim()) {
    case 'متوفر':
      return AppColors.success;

    case 'قابل للنفاد':
      return AppColors.warning;

    case 'غير متوفر':
      return AppColors.danger;

    default:
      return AppColors.danger;
  }
}

 static Color _expiryColor(
  String status,
) {
  switch (status.trim()) {
    case 'صالح':
      return AppColors.success;

    case 'قريب الانتهاء':
      return AppColors.warning;

    case 'منتهي الصلاحية':
      return AppColors.danger;

    case 'غير محدد':
    default:
      return AppColors.textSecondary;
  }
}
}

class _DetailsCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailsCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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

class _DetailsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailsRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
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
                color:
                    AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 13.5,
                fontWeight:
                    FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDetailsRow
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool showWarning;

  const _StatusDetailsRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
   this.showWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
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
                color:
                    AppColors.textSecondary,
                fontSize: 12.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment:
                  Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    if (showWarning) ...[
      Icon(
        Icons.warning_amber_rounded,
        color: color,
        size: 16,
      ),
      const SizedBox(width: 5),
    ],

    Text(
      value.trim().isEmpty
          ? 'غير متوفر'
          : value,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight:
            FontWeight.w800,
      ),
    ),
  ],
),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsDivider
    extends StatelessWidget {
  const _DetailsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
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
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
