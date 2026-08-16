import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/notifications_bloc.dart';
import 'package:project_2/Features/auth/bloc/notifications_event.dart';
import 'package:project_2/Features/auth/bloc/notifications_state.dart';

import 'package:project_2/Features/auth/data/models/notification_model.dart';

import 'package:project_2/Features/auth/presentation/notification_details_screen.dart';

class NotificationsArchiveScreen extends StatefulWidget {
  const NotificationsArchiveScreen({
    super.key,
  });

  @override
  State<NotificationsArchiveScreen> createState() =>
      _NotificationsArchiveScreenState();
}

class _NotificationsArchiveScreenState
    extends State<NotificationsArchiveScreen> {
  @override
  void initState() {
    super.initState();

    context
        .read<NotificationsBloc>()
        .add(
          LoadNotificationsArchiveEvent(),
        );
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

          title: const Text(
            'أرشيف الإشعارات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: BlocBuilder<
            NotificationsBloc,
            NotificationsState>(
          builder: (context, state) {
            // ==============================================
            // Loading
            // ==============================================

            if (state is NotificationsInitial ||
                state is NotificationsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ==============================================
            // Error
            // ==============================================

            if (state is NotificationsFailure) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 46,
                        color: AppColors.danger,
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        state.message,
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<
                                  NotificationsBloc>()
                              .add(
                                LoadNotificationsArchiveEvent(),
                              );
                        },
                        icon: const Icon(
                          Icons.refresh,
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

            // ==============================================
            // Loaded
            // ==============================================

            if (state is NotificationsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<NotificationsBloc>()
                      .add(
                        LoadNotificationsArchiveEvent(),
                      );
                },

                child: ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(),

                  padding:
                      const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    30,
                  ),

                  children: [
                    // ======================================
                    // Intro
                    // ======================================

                    Container(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                        border: Border.all(
                          color:
                              AppColors.border,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons
                                .inventory_2_outlined,
                            color:
                                AppColors.primary,
                            size: 27,
                          ),

                          SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'الإشعارات السابقة',
                                  style: TextStyle(
                                    color: AppColors
                                        .textPrimary,
                                    fontSize: 15,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),

                                SizedBox(
                                  height: 4,
                                ),

                                Text(
                                  'يمكنك مراجعة الإشعارات القديمة والمقروءة دون تعديل محتواها.',
                                  style: TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                    fontSize: 11.5,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ======================================
                    // Filters
                    // ======================================

                    _ArchiveFilters(
                      state: state,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    Row(
                      children: [
                        const Text(
                          'الأرشيف',
                          style: TextStyle(
                            color: AppColors
                                .textPrimary,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          '${state.visibleNotifications.length} إشعار',
                          style:
                              const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    if (state
                        .visibleNotifications
                        .isEmpty)
                      const _EmptyArchive(),

                    ...state.visibleNotifications.map(
                      (notification) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child:
                              _ArchiveNotificationCard(
                            notification:
                                notification,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ==========================================================
// Filters
// ==========================================================

class _ArchiveFilters extends StatelessWidget {
  final NotificationsLoaded state;

  const _ArchiveFilters({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color:
                    AppColors.primary,
                size: 19,
              ),

              SizedBox(
                width: 7,
              ),

              Text(
                'تصفية الأرشيف',
                style: TextStyle(
                  color:
                      AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          const Text(
            'النوع',
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 11,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          SingleChildScrollView(
            scrollDirection:
                Axis.horizontal,
            child: Row(
              children: [
                _ArchiveChip(
                  title: 'الكل',
                  selected:
                      state.selectedType ==
                          null,
                  onTap: () {
                    context
                        .read<
                            NotificationsBloc>()
                        .add(
                          FilterNotificationsByTypeEvent(
                            type: null,
                          ),
                        );
                  },
                ),

                const SizedBox(
                  width: 7,
                ),

                ...NotificationType.values
                    .map(
                  (type) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        left: 7,
                      ),
                      child: _ArchiveChip(
                        title:
                            _typeLabel(type),
                        selected:
                            state.selectedType ==
                                type,
                        onTap: () {
                          context
                              .read<
                                  NotificationsBloc>()
                              .add(
                                FilterNotificationsByTypeEvent(
                                  type:
                                      type,
                                ),
                              );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  onTap: () async {
                    final now =
                        DateTime.now();

                    final result =
                        await showDateRangePicker(
                      context: context,

                      firstDate:
                          DateTime(2020),

                      lastDate:
                          DateTime(
                        now.year + 2,
                      ),

                      initialDateRange:
                          state.fromDate !=
                                      null &&
                                  state.toDate !=
                                      null
                              ? DateTimeRange(
                                  start:
                                      state.fromDate!,
                                  end:
                                      state.toDate!,
                                )
                              : null,

                      helpText:
                          'تحديد نطاق التاريخ',

                      cancelText:
                          'إلغاء',

                      confirmText:
                          'اختيار',

                      saveText:
                          'اختيار',
                    );

                    if (result == null ||
                        !context.mounted) {
                      return;
                    }

                    context
                        .read<
                            NotificationsBloc>()
                        .add(
                          FilterNotificationsByDateEvent(
                            fromDate:
                                result.start,
                            toDate:
                                result.end,
                          ),
                        );
                  },

                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          AppColors.background,
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                      border:
                          Border.all(
                        color:
                            AppColors.border,
                      ),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .date_range_outlined,
                          color: AppColors
                              .primary,
                          size: 19,
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Expanded(
                          child: Text(
                            state.fromDate ==
                                        null ||
                                    state.toDate ==
                                        null
                                ? 'جميع التواريخ'
                                : 'من ${_formatDate(state.fromDate!)} إلى ${_formatDate(state.toDate!)}',

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              color: AppColors
                                  .textPrimary,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              IconButton(
                tooltip:
                    'إلغاء التصفية',

                onPressed: () {
                  context
                      .read<
                          NotificationsBloc>()
                      .add(
                        ClearNotificationsFiltersEvent(),
                      );
                },

                icon: const Icon(
                  Icons
                      .restart_alt_rounded,
                  color:
                      AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Archive card
// ==========================================================

class _ArchiveNotificationCard
    extends StatelessWidget {
  final NotificationModel notification;

  const _ArchiveNotificationCard({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        16,
      ),

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          16,
        ),

        // مراجعة فقط بدون تعديل
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  NotificationDetailsScreen(
                notification:
                    notification.copyWith(
                  isRead: true,
                ),
              ),
            ),
          );
        },

        child: Container(
          padding:
              const EdgeInsets.all(
            14,
          ),

          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              16,
            ),

            border: Border.all(
              color:
                  AppColors.border,
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,

                decoration:
                    BoxDecoration(
                  color:
                      AppColors.primarySoft,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Icon(
                  _typeIcon(
                    notification.type,
                  ),
                  color:
                      AppColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      notification.title,

                      style:
                          const TextStyle(
                        color: AppColors
                            .textPrimary,
                        fontSize: 13.5,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      notification.summary,

                      maxLines: 2,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 11.5,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Row(
                      children: [
                        Text(
                          notification
                              .typeLabel,

                          style:
                              const TextStyle(
                            color: AppColors
                                .primary,
                            fontSize: 10.5,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          _formatDateTime(
                            notification
                                .dateTime,
                          ),

                          style:
                              const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 5,
              ),

              const Icon(
                Icons
                    .arrow_back_ios_new_rounded,
                color:
                    AppColors.textSecondary,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Chip
// ==========================================================

class _ArchiveChip
    extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ArchiveChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(30),

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.background,

          borderRadius:
              BorderRadius.circular(30),

          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
          ),
        ),

        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : AppColors.textSecondary,
            fontSize: 11,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Empty
// ==========================================================

class _EmptyArchive
    extends StatelessWidget {
  const _EmptyArchive();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
        top: 20,
      ),
      padding:
          const EdgeInsets.all(35),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 45,
            color:
                AppColors.textSecondary,
          ),

          SizedBox(
            height: 12,
          ),

          Text(
            'لا توجد إشعارات في الأرشيف',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  AppColors.textPrimary,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Helpers
// ==========================================================

String _typeLabel(
  NotificationType type,
) {
  switch (type) {
    case NotificationType.orders:
      return 'طلبات';

    case NotificationType.collection:
      return 'تحصيل';

    case NotificationType.workPlans:
      return 'خطط عمل';

    case NotificationType.offers:
      return 'عروض';

    case NotificationType.evaluation:
      return 'تقييم';

    case NotificationType.general:
      return 'عام';
  }
}

IconData _typeIcon(
  NotificationType type,
) {
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

String _formatDate(
  DateTime date,
) {
  final day =
      date.day.toString().padLeft(
    2,
    '0',
  );

  final month =
      date.month.toString().padLeft(
    2,
    '0',
  );

  return '$day/$month/${date.year}';
}

String _formatDateTime(
  DateTime date,
) {
  final day =
      date.day.toString().padLeft(
    2,
    '0',
  );

  final month =
      date.month.toString().padLeft(
    2,
    '0',
  );

  return '$day/$month/${date.year}';
}