class CurrentOrderCartState {
  final List<Map<String, dynamic>> items;

  final Map<String, dynamic>? pharmacy;

  final String note;

  const CurrentOrderCartState({
    this.items = const [],
    this.pharmacy,
    this.note = '',
  });

  // =========================================================
  // عدد القطع
  // =========================================================

  int get totalItemsCount {
    return items.fold<int>(
      0,
      (sum, item) {
        final dynamic value =
            item['totalQuantity'] ??
                item['quantity'] ??
                0;

        if (value is num) {
          return sum +
              value.toInt();
        }

        return sum +
            (int.tryParse(
                  value
                      .toString(),
                ) ??
                0);
      },
    );
  }

  bool get isEmpty =>
      items.isEmpty;

  bool get isNotEmpty =>
      items.isNotEmpty;

  CurrentOrderCartState copyWith({
    List<Map<String, dynamic>>? items,
    Map<String, dynamic>? pharmacy,
    bool clearPharmacy = false,
    String? note,
  }) {
    return CurrentOrderCartState(
      items:
          items ?? this.items,

      pharmacy:
          clearPharmacy
              ? null
              : pharmacy ??
                  this.pharmacy,

      note:
          note ?? this.note,
    );
  }
}