import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/food_models.dart';

class CartItem {
  const CartItem({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(item: item, quantity: quantity ?? this.quantity);
  }
}

class CartState {
  const CartState({this.items = const <CartItem>[]});

  final List<CartItem> items;

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
  int get subtotal =>
      items.fold(0, (sum, i) => sum + (i.item.price * i.quantity));
  int get deliveryFee => items.isEmpty ? 0 : 9000;
  int get total => subtotal + deliveryFee;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(MenuItem item) {
    final idx = state.items.indexWhere((e) => e.item.id == item.id);
    if (idx == -1) {
      emit(
        state.copyWith(
          items: [
            ...state.items,
            CartItem(item: item, quantity: 1),
          ],
        ),
      );
      return;
    }

    final next = [...state.items];
    final current = next[idx];
    next[idx] = current.copyWith(quantity: current.quantity + 1);
    emit(state.copyWith(items: next));
  }

  void decrementItem(String itemId) {
    final idx = state.items.indexWhere((e) => e.item.id == itemId);
    if (idx == -1) return;

    final next = [...state.items];
    final current = next[idx];
    if (current.quantity <= 1) {
      next.removeAt(idx);
    } else {
      next[idx] = current.copyWith(quantity: current.quantity - 1);
    }
    emit(state.copyWith(items: next));
  }

  void removeItem(String itemId) {
    emit(
      state.copyWith(
        items: state.items.where((e) => e.item.id != itemId).toList(),
      ),
    );
  }

  void clear() {
    emit(const CartState());
  }
}
