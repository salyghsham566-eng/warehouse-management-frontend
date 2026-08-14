enum CollectionPharmacyFilter {
  all,
  hasDebt,
  settled,
  pendingCollection,
}

extension CollectionPharmacyFilterExtension
    on CollectionPharmacyFilter {
  String get label {
    switch (this) {
      case CollectionPharmacyFilter.all:
        return 'الكل';

      case CollectionPharmacyFilter.hasDebt:
        return 'عليها ذمة';

      case CollectionPharmacyFilter.settled:
        return 'المسددة';

      case CollectionPharmacyFilter.pendingCollection:
        return 'دفعات معلقة';
    }
  }
}