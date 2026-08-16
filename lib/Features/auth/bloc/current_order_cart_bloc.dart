import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_2/Features/auth/bloc/current_order_cart_event.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_state.dart';
import 'package:project_2/Features/auth/bloc/current_order_cart_utils.dart';

class CurrentOrderCartBloc
    extends Bloc<
        CurrentOrderCartEvent,
        CurrentOrderCartState> {
  CurrentOrderCartBloc()
      : super(
          const CurrentOrderCartState(),
        ) {
    on<AddOrUpdateCurrentOrderItemEvent>(
      _addOrUpdateItem,
    );

    on<AddCurrentOrderItemsEvent>(
      _addItems,
    );

    on<ReplaceCurrentOrderItemsEvent>(
      _replaceItems,
    );

    on<UpdateCurrentOrderItemQuantityEvent>(
      _updateQuantity,
    );

    on<RemoveCurrentOrderItemEvent>(
      _removeItem,
    );

    on<SetCurrentOrderPharmacyEvent>(
      _setPharmacy,
    );

    on<SetCurrentOrderNoteEvent>(
      _setNote,
    );

    on<ClearCurrentOrderCartEvent>(
      _clearCart,
    );
  }

  void _addOrUpdateItem(
    AddOrUpdateCurrentOrderItemEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    final normalizedItem =
        normalizeCurrentOrderCartItem(
      event.item,
    );

    final newItems =
        state.items
            .map(
              (item) =>
                  Map<String, dynamic>.from(
                item,
              ),
            )
            .toList();

    _upsertItem(
      newItems,
      normalizedItem,
    );

    emit(
      state.copyWith(
        items: newItems,
      ),
    );
  }

  void _addItems(
    AddCurrentOrderItemsEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    final newItems =
        state.items
            .map(
              (item) =>
                  Map<String, dynamic>.from(
                item,
              ),
            )
            .toList();

    for (final rawItem in event.items) {
      final normalizedItem =
          normalizeCurrentOrderCartItem(
        rawItem,
      );

      _upsertItem(
        newItems,
        normalizedItem,
      );
    }

    emit(
      state.copyWith(
        items: newItems,
      ),
    );
  }

  // =========================================================
  // ترجع من Review
  // =========================================================

  void _replaceItems(
    ReplaceCurrentOrderItemsEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    final normalizedItems =
        event.items
            .map(
              (item) =>
                  normalizeCurrentOrderCartItem(
                Map<String, dynamic>.from(
                  item,
                ),
              ),
            )
            .toList();

    emit(
      state.copyWith(
        items: normalizedItems,
      ),
    );
  }

  void _updateQuantity(
    UpdateCurrentOrderItemQuantityEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    if (event.quantity <= 0) {
      return;
    }

    final newItems =
        <Map<String, dynamic>>[];

    for (final item in state.items) {
      if (item['cartKey'] ==
          event.cartKey) {
        final updated =
            Map<String, dynamic>.from(
          item,
        );

        updated['quantity'] =
            event.quantity;

        newItems.add(
          normalizeCurrentOrderCartItem(
            updated,
          ),
        );
      } else {
        newItems.add(
          Map<String, dynamic>.from(
            item,
          ),
        );
      }
    }

    emit(
      state.copyWith(
        items: newItems,
      ),
    );
  }

  void _removeItem(
    RemoveCurrentOrderItemEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    final newItems =
        state.items
            .where(
              (item) =>
                  item['cartKey'] !=
                  event.cartKey,
            )
            .map(
              (item) =>
                  Map<String, dynamic>.from(
                item,
              ),
            )
            .toList();

    emit(
      state.copyWith(
        items: newItems,
      ),
    );
  }

  void _setPharmacy(
    SetCurrentOrderPharmacyEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    emit(
      state.copyWith(
        pharmacy:
            Map<String, dynamic>.from(
          event.pharmacy,
        ),
      ),
    );
  }

  void _setNote(
    SetCurrentOrderNoteEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    emit(
      state.copyWith(
        note: event.note,
      ),
    );
  }

  void _clearCart(
    ClearCurrentOrderCartEvent event,
    Emitter<CurrentOrderCartState> emit,
  ) {
    emit(
      const CurrentOrderCartState(),
    );
  }

  void _upsertItem(
    List<Map<String, dynamic>> items,
    Map<String, dynamic> newItem,
  ) {
    final String cartKey =
        newItem['cartKey']
                ?.toString() ??
            '';

    final int existingIndex =
        items.indexWhere(
      (item) =>
          item['cartKey'] ==
          cartKey,
    );

    if (existingIndex >= 0) {
      items[existingIndex] =
          newItem;
    } else {
      items.add(
        newItem,
      );
    }
  }
}