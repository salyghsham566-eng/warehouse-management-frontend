import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Core/theme/app_colors.dart';

import 'package:project_2/Features/auth/bloc/notifications_bloc.dart';
import 'package:project_2/Features/auth/bloc/notifications_event.dart';
import 'package:project_2/Features/auth/bloc/notifications_state.dart';

import 'package:project_2/Features/auth/data/models/notification_model.dart';
import 'package:project_2/Features/auth/presentation/notification_details_screen.dart';
import 'package:project_2/Features/auth/presentation/notifications_archive_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({
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
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.primary,

          title: const Text(
            'الإشعارات',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
  IconButton(
    tooltip: 'أرشيف الإشعارات',

    icon: const Icon(
      Icons.inventory_2_outlined,
    ),

    onPressed: () async {
      final bloc =
          context.read<NotificationsBloc>();

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return BlocProvider<
                NotificationsBloc>.value(
              value: bloc,
              child:
                  const NotificationsArchiveScreen(),
            );
          },
        ),
      );

      // بعد الرجوع من الأرشيف
      // نرجع نحمل الإشعارات العادية
      if (!context.mounted) {
        return;
      }

      context
          .read<NotificationsBloc>()
          .add(
            LoadNotificationsEvent(),
          );
    },
  ),
],
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
              return _ErrorView(
                message: state.message,
                onRetry: () {
                  context
                      .read<NotificationsBloc>()
                      .add(
                        LoadNotificationsEvent(),
                      );
                },
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
                        LoadNotificationsEvent(),
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
                    32,
                  ),

                  children: [
                    // ======================================
                    // Header
                    // ======================================

                    _NotificationsHeader(
                      unreadCount:
                          state.unreadCount,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // ======================================
                    // Filters
                    // ======================================

                    _FiltersSection(
                      state: state,
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ======================================
                    // Mark all read
                    // ======================================

                    if (state.unreadCount > 0)
                      _MarkAllReadButton(
                        unreadCount:
                            state.unreadCount,
                      ),

                    if (state.unreadCount > 0)
                      const SizedBox(
                        height: 14,
                      ),

                    // ======================================
                    // Result count
                    // ======================================

                    Row(
                      children: [
                        const Text(
                          'الإشعارات',
                          style: TextStyle(
                            color:
                                AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          '${state.visibleNotifications.length} إشعار',
                          style: const TextStyle(
                            color:
                                AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // ======================================
                    // Empty
                    // ======================================

                    if (state
                        .visibleNotifications
                        .isEmpty)
                      const _EmptyNotifications(),

                    // ======================================
                    // Notifications
                    // ======================================

                    ...state.visibleNotifications
                        .map(
                      (notification) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: _NotificationCard(
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
// Header
// ==========================================================

class _NotificationsHeader
    extends StatelessWidget {
  final int unreadCount;

  const _NotificationsHeader({
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF002A55),
            Color(0xFF174A7E),
          ],
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,

            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(
                0.14,
              ),
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'مركز الإشعارات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  unreadCount == 0
                      ? 'لا توجد إشعارات جديدة حالياً'
                      : 'لديك $unreadCount إشعار غير مقروء',
                  style: const TextStyle(
                    color:
                        Color(0xFFDCE8F5),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          if (unreadCount > 0)
            Container(
              constraints:
                  const BoxConstraints(
                minWidth: 34,
                minHeight: 34,
              ),

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child: Center(
                child: Text(
                  unreadCount > 99
                      ? '99+'
                      : '$unreadCount',
                  style: const TextStyle(
                    color:
                        AppColors.primary,
                    fontWeight:
                        FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================================
// Filters
// ==========================================================

class _FiltersSection
    extends StatelessWidget {
  final NotificationsLoaded state;

  const _FiltersSection({
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
                size: 20,
              ),

              SizedBox(
                width: 7,
              ),

              Text(
                'تصفية الإشعارات',
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

          // ================================================
          // Status
          // ================================================

          const Text(
            'الحالة',
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _FilterChip(
                title: 'الكل',
                selected:
                    state.selectedStatus ==
                        NotificationFilterStatus
                            .all,
                onTap: () {
                  context
                      .read<NotificationsBloc>()
                      .add(
                        FilterNotificationsByStatusEvent(
                          status:
                              NotificationFilterStatus
                                  .all,
                        ),
                      );
                },
              ),

              _FilterChip(
                title: 'غير مقروء',
                selected:
                    state.selectedStatus ==
                        NotificationFilterStatus
                            .unread,
                onTap: () {
                  context
                      .read<NotificationsBloc>()
                      .add(
                        FilterNotificationsByStatusEvent(
                          status:
                              NotificationFilterStatus
                                  .unread,
                        ),
                      );
                },
              ),

              _FilterChip(
                title: 'مقروء',
                selected:
                    state.selectedStatus ==
                        NotificationFilterStatus
                            .read,
                onTap: () {
                  context
                      .read<NotificationsBloc>()
                      .add(
                        FilterNotificationsByStatusEvent(
                          status:
                              NotificationFilterStatus
                                  .read,
                        ),
                      );
                },
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          // ================================================
          // Type
          // ================================================

          const Text(
            'النوع',
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
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
                _TypeChip(
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
                      child: _TypeChip(
                        title:
                            _typeLabel(
                          type,
                        ),
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
            height: 15,
          ),

          // ================================================
          // Date
          // ================================================

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
                          DateTime(
                        2020,
                      ),

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

                    if (result == null) {
                      return;
                    }

                    if (!context.mounted) {
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
                          size: 19,
                          color:
                              AppColors.primary,
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Expanded(
                          child: Text(
                            _dateFilterText(
                              state,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              color: AppColors
                                  .textPrimary,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w600,
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
                ),
                color:
                    AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _dateFilterText(
    NotificationsLoaded state,
  ) {
    if (state.fromDate == null ||
        state.toDate == null) {
      return 'جميع التواريخ';
    }

    return 'من ${_formatDate(state.fromDate!)} إلى ${_formatDate(state.toDate!)}';
  }
}

// ==========================================================
// Filter Chip
// ==========================================================

class _FilterChip
    extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(
        30,
      ),
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.background,
          borderRadius:
              BorderRadius.circular(
            30,
          ),
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
            fontSize: 11.5,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Type Chip
// ==========================================================

class _TypeChip
    extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(
        30,
      ),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primarySoft
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            30,
          ),
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
                ? AppColors.primary
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
// Mark All Read
// ==========================================================

class _MarkAllReadButton
    extends StatelessWidget {
  final int unreadCount;

  const _MarkAllReadButton({
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          AppColors.primarySoft,
      borderRadius:
          BorderRadius.circular(
        14,
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        onTap: () async {
          final confirmed =
              await showDialog<bool>(
            context: context,
            builder:
                (dialogContext) {
              return AlertDialog(
                title: const Text(
                  'تحديد الكل كمقروء',
                ),
                content: Text(
                  'سيتم تحديد $unreadCount إشعار كمقروء. هل تريد المتابعة؟',
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
                        const Text(
                      'إلغاء',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                        true,
                      );
                    },
                    child:
                        const Text(
                      'تأكيد',
                    ),
                  ),
                ],
              );
            },
          );

          if (confirmed != true) {
            return;
          }

          if (!context.mounted) {
            return;
          }

          context
              .read<NotificationsBloc>()
              .add(
                MarkAllNotificationsAsReadEvent(),
              );
        },

        child: const Padding(
          padding:
              EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),

          child: Row(
            children: [
              Icon(
                Icons
                    .done_all_rounded,
                color:
                    AppColors.primary,
                size: 21,
              ),

              SizedBox(
                width: 9,
              ),

              Expanded(
                child: Text(
                  'تحديد جميع الإشعارات كمقروءة',
                  style: TextStyle(
                    color:
                        AppColors.primary,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              Icon(
                Icons
                    .arrow_back_ios_new_rounded,
                size: 14,
                color:
                    AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Notification Card
// ==========================================================

class _NotificationCard
    extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationCard({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        _typeColor(
      notification.type,
    );

    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(
        17,
      ),

      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          17,
        ),

        // حالياً نحدد الإشعار كمقروء.
        // بالخطوة التالية نفتح شاشة التفاصيل UC-249.
       onTap: () async {
  // UC-249
  // بمجرد فتح الإشعار يتحول إلى مقروء.

  if (!notification.isRead) {
    context.read<NotificationsBloc>().add(
          MarkNotificationAsReadEvent(
            notificationId: notification.id,
          ),
        );
  }

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) {
        return NotificationDetailsScreen(
          notification: notification.copyWith(
            isRead: true,
          ),
        );
      },
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
              17,
            ),

            border: Border.all(
              color:
                  notification.isRead
                      ? AppColors.border
                      : color.withOpacity(
                          0.35,
                        ),
              width:
                  notification.isRead
                      ? 1
                      : 1.3,
            ),

            color:
                notification.isRead
                    ? Colors.white
                    : color.withOpacity(
                        0.035,
                      ),
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ============================================
              // Icon
              // ============================================

              Container(
                width: 45,
                height: 45,

                decoration:
                    BoxDecoration(
                  color:
                      color.withOpacity(
                    0.11,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),

                child: Icon(
                  _typeIcon(
                    notification.type,
                  ),
                  color: color,
                  size: 23,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // ============================================
              // Content
              // ============================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification
                                .title,
                            style:
                                TextStyle(
                              color: AppColors
                                  .textPrimary,
                              fontSize: 14,
                              fontWeight:
                                  notification
                                          .isRead
                                      ? FontWeight
                                          .w700
                                      : FontWeight
                                          .w900,
                            ),
                          ),
                        ),

                        if (!notification
                            .isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin:
                                const EdgeInsets
                                    .only(
                              right: 7,
                            ),
                            decoration:
                                BoxDecoration(
                              color: color,
                              shape: BoxShape
                                  .circle,
                            ),
                          ),
                      ],
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
                      style: const TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(
                      height: 9,
                    ),

                    Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                color.withOpacity(
                              0.08,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              8,
                            ),
                          ),
                          child: Text(
                            notification
                                .typeLabel,
                            style:
                                TextStyle(
                              color: color,
                              fontSize: 10.5,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons
                              .access_time_rounded,
                          size: 13,
                          color: AppColors
                              .textSecondary,
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Text(
                          _formatDateTime(
                            notification
                                .dateTime,
                          ),
                          style:
                              const TextStyle(
                            color: AppColors
                                .textSecondary,
                            fontSize: 10.5,
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

// ==========================================================
// Empty
// ==========================================================

class _EmptyNotifications
    extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
        top: 20,
      ),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
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
      child: const Column(
        children: [
          Icon(
            Icons
                .notifications_off_outlined,
            size: 46,
            color:
                AppColors.textSecondary,
          ),

          SizedBox(
            height: 12,
          ),

          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              color:
                  AppColors.textPrimary,
              fontSize: 15,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height: 5,
          ),

          Text(
            'لا توجد إشعارات مطابقة للتصفية الحالية.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Error
// ==========================================================

class _ErrorView
    extends StatelessWidget {
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
            const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color:
                  AppColors.danger,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              message,
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textSecondary,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
              ),
              label:
                  const Text(
                'إعادة المحاولة',
              ),
            ),
          ],
        ),
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
      return Icons
          .shopping_bag_outlined;

    case NotificationType.collection:
      return Icons
          .payments_outlined;

    case NotificationType.workPlans:
      return Icons
          .assignment_outlined;

    case NotificationType.offers:
      return Icons
          .local_offer_outlined;

    case NotificationType.evaluation:
      return Icons
          .workspace_premium_outlined;

    case NotificationType.general:
      return Icons
          .campaign_outlined;
  }
}

Color _typeColor(
  NotificationType type,
) {
  switch (type) {
    case NotificationType.orders:
      return const Color(
        0xFF175CD3,
      );

    case NotificationType.collection:
      return const Color(
        0xFF159B64,
      );

    case NotificationType.workPlans:
      return const Color(
        0xFF6941C6,
      );

    case NotificationType.offers:
      return const Color(
        0xFFF79009,
      );

    case NotificationType.evaluation:
      return const Color(
        0xFFC11574,
      );

    case NotificationType.general:
      return const Color(
        0xFF475467,
      );
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
  final now = DateTime.now();

  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );

  final notificationDay =
      DateTime(
    date.year,
    date.month,
    date.day,
  );

  String dateText;

  if (notificationDay == today) {
    dateText = 'اليوم';
  } else if (notificationDay ==
      today.subtract(
        const Duration(
          days: 1,
        ),
      )) {
    dateText = 'أمس';
  } else {
    dateText =
        _formatDate(
      date,
    );
  }

  final hour12 =
      date.hour == 0
          ? 12
          : date.hour > 12
              ? date.hour - 12
              : date.hour;

  final minute =
      date.minute
          .toString()
          .padLeft(
            2,
            '0',
          );

  final period =
      date.hour >= 12
          ? 'م'
          : 'ص';

  return '$dateText • $hour12:$minute $period';
}