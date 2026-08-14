enum CollectionPaymentsHistoryFilter {
  all,
  pending,
  approved,
  rejected,
}

extension CollectionPaymentsHistoryFilterExtension
    on CollectionPaymentsHistoryFilter {
  String get label {
    switch (this) {
      case CollectionPaymentsHistoryFilter.all:
        return 'الكل';

      case CollectionPaymentsHistoryFilter.pending:
        return 'قيد الاعتماد';

      case CollectionPaymentsHistoryFilter.approved:
        return 'معتمدة';

      case CollectionPaymentsHistoryFilter.rejected:
        return 'مرفوضة';
    }
  }
}