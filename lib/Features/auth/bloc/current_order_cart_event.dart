abstract class CurrentOrderCartEvent {}

// إضافة أو تحديث صنف واحد
class AddOrUpdateCurrentOrderItemEvent
    extends CurrentOrderCartEvent {
  final Map<String, dynamic> item;

  AddOrUpdateCurrentOrderItemEvent({
    required this.item,
  });
}

// إضافة عدة أصناف - تستخدم للسلال
class AddCurrentOrderItemsEvent
    extends CurrentOrderCartEvent {
  final List<Map<String, dynamic>> items;

  AddCurrentOrderItemsEvent({
    required this.items,
  });
}

// استبدال أصناف الطلبية بعد الرجوع من المراجعة
class ReplaceCurrentOrderItemsEvent
    extends CurrentOrderCartEvent {
  final List<Map<String, dynamic>> items;

  ReplaceCurrentOrderItemsEvent({
    required this.items,
  });
}

// تعديل الكمية
class UpdateCurrentOrderItemQuantityEvent
    extends CurrentOrderCartEvent {
  final String cartKey;
  final int quantity;

  UpdateCurrentOrderItemQuantityEvent({
    required this.cartKey,
    required this.quantity,
  });
}

// حذف صنف
class RemoveCurrentOrderItemEvent
    extends CurrentOrderCartEvent {
  final String cartKey;

  RemoveCurrentOrderItemEvent({
    required this.cartKey,
  });
}

// اختيار الصيدلية
class SetCurrentOrderPharmacyEvent
    extends CurrentOrderCartEvent {
  final Map<String, dynamic> pharmacy;

  SetCurrentOrderPharmacyEvent({
    required this.pharmacy,
  });
}

// الملاحظة
class SetCurrentOrderNoteEvent
    extends CurrentOrderCartEvent {
  final String note;

  SetCurrentOrderNoteEvent({
    required this.note,
  });
}

// تفريغ الطلبية بعد الإرسال
class ClearCurrentOrderCartEvent
    extends CurrentOrderCartEvent {}