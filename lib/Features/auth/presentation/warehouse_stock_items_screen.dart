import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/di/injection_container.dart';
import 'package:project_2/Core/theme/app_colors.dart';
import 'package:project_2/Features/auth/bloc/warehouse_bloc.dart';
import 'package:project_2/Features/auth/bloc/warehouse_event.dart';
import 'package:project_2/Features/auth/bloc/warehouse_state.dart';
import 'package:project_2/Features/auth/data/models/warehouse_stock_item_model.dart';
import 'package:project_2/Features/auth/presentation/warehouse_medicine_details_screen.dart';

class WarehouseStockItemsScreen
    extends StatelessWidget {
  final WarehouseStockFilter filter;

  const WarehouseStockItemsScreen({
    super.key,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WarehouseBloc>(
      create: (_) => sl<WarehouseBloc>()
        ..add(
          LoadWarehouseStockItemsEvent(
            filter: filter,
          ),
        ),
      child: _WarehouseStockItemsView(
        filter: filter,
      ),
    );
  }
}

class _WarehouseStockItemsView
    extends StatelessWidget {
  final WarehouseStockFilter filter;

  const _WarehouseStockItemsView({
    required this.filter,
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
          title: Text(
            filter.title,
            style: const TextStyle(
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
                    is WarehouseStockItemsLoading ||
                state is WarehouseInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state
                is WarehouseStockItemsFailure) {
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<WarehouseBloc>()
                      .add(
                        LoadWarehouseStockItemsEvent(
                          filter: filter,
                        ),
                      );
                },
              );
            }

            if (state
                is WarehouseStockItemsSuccess) {
              return _StockItemsContent(
                filter: state.filter,
                items: state.items,
                onRefresh: () async {
                  context
                      .read<WarehouseBloc>()
                      .add(
                        LoadWarehouseStockItemsEvent(
                          filter: filter,
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

class _StockItemsContent
    extends StatelessWidget {
  final WarehouseStockFilter filter;
  final List<WarehouseStockItemModel> items;
  final Future<void> Function() onRefresh;

  const _StockItemsContent({
    required this.filter,
    required this.items,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock =
        filter == WarehouseStockFilter.lowStock;

    final accentColor = isLowStock
        ? AppColors.warning
        : AppColors.danger;

    return RefreshIndicator(
      onRefresh: onRefresh,
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
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color:
                        accentColor.withOpacity(0.10),
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: Icon(
                    isLowStock
                        ? Icons
                            .warning_amber_rounded
                        : Icons
                            .remove_shopping_cart_outlined,
                    color: accentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        filter.title,
                        style: const TextStyle(
                          color:
                              AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isLowStock
                            ? 'الأصناف التي أصبحت حالتها قابلة للنفاد.'
                            : 'الأصناف التي حالتها غير متوفر حالياً.',
                        style: const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 12.5,
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
              borderRadius:
                  BorderRadius.circular(14),
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
                    'القائمة للاطلاع فقط. لا تظهر أي كمية رقمية ولا يمكن إضافة الأصناف إلى السلة من هذا المسار.',
                    style: TextStyle(
                      color:
                          AppColors.textPrimary,
                      fontSize: 12.5,
                      height: 1.5,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'الأصناف',
                  style: TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      accentColor.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length} صنف',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (items.isEmpty)
            _EmptyView(
              filter: filter,
            )
          else
            ...items.map(
              (item) => Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _StockItemCard(
                  item: item,
                  filter: filter,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StockItemCard
    extends StatelessWidget {
  final WarehouseStockItemModel item;
  final WarehouseStockFilter filter;

  const _StockItemCard({
    required this.item,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock =
        filter == WarehouseStockFilter.lowStock;

    final accentColor = isLowStock
        ? AppColors.warning
        : AppColors.danger;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: item.id.trim().isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        WarehouseMedicineDetailsScreen(
                      medicineId: item.id,
                    ),
                  ),
                );
              },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                      color: accentColor
                          .withOpacity(0.10),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isLowStock
                          ? Icons
                              .warning_amber_rounded
                          : Icons
                              .inventory_2_outlined,
                      color: accentColor,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tradeName,
                          style: const TextStyle(
                            color: AppColors
                                .textPrimary,
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.companyName
                                  .trim()
                                  .isEmpty
                              ? 'الشركة غير محددة'
                              : item.companyName,
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
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor
                          .withOpacity(0.10),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        if (isLowStock) ...[
                          Icon(
                            Icons
                                .warning_amber_rounded,
                            color: accentColor,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                        ],
                        Text(
                          item.availabilityStatus,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 11.5,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Divider(
                height: 1,
                color: AppColors.border,
              ),

              const SizedBox(height: 11),

              Row(
                children: [
                  const Icon(
                    Icons.event_outlined,
                    color:
                        AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.expiryDate
                                  ?.trim()
                                  .isNotEmpty ==
                              true
                          ? 'الانتهاء: ${item.expiryDate}'
                          : 'تاريخ الانتهاء: غير محدد',
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _ExpiryBadge(
                    status: item.expiryStatus,
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

class _ExpiryBadge
    extends StatelessWidget {
  final String status;

  const _ExpiryBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.trim()) {
      case 'صالح':
        color = AppColors.success;
        break;
      case 'قريب الانتهاء':
        color = AppColors.warning;
        break;
      case 'منتهي الصلاحية':
        color = AppColors.danger;
        break;
      default:
        color = AppColors.textSecondary;
    }

    final showWarning =
        status.trim() == 'قريب الانتهاء';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius:
            BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showWarning) ...[
            Icon(
              Icons.warning_amber_rounded,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            status.trim().isEmpty
                ? 'غير محدد'
                : status,
            style: TextStyle(
              color: color,
              fontSize: 10.5,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final WarehouseStockFilter filter;

  const _EmptyView({
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock =
        filter == WarehouseStockFilter.lowStock;

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isLowStock
                ? Icons.check_circle_outline
                : Icons.inventory_2_outlined,
            color: AppColors.textSecondary,
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            isLowStock
                ? 'لا توجد أصناف قابلة للنفاد حالياً'
                : 'لا توجد أصناف غير متوفرة حالياً',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
              size: 46,
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
