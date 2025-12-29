import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/cart_model.dart';
import '../../data/repo/cart_repo.dart';
import 'cart_state.dart';

//! CartCubit
class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;

  CartCubit(this.cartRepo) : super(CartInitial()) {
    fetchCart();
  }
  Cart? cart;
  Future<void> fetchCart() async {
    emit(GetCartLoading());
    final result = await cartRepo.getCartItems();
    result.fold(
      (error) => emit(GetCartError(error)),
      (cartItems) {
        cart = cartItems;
        emit(GetCartLoaded());
      },
    );
  }

  Future<void> removeFromCart(int id) async {
    emit(CartItemRemovedLoading());
    final result = await cartRepo.removeFromCart(id);
    result.fold(
      (error) => emit(CartItemRemovedError(error)),
      (cartItems) {

        emit(CartItemRemovedSuccess(cartItems));
      },
    );
  }

  Future<void> clearCart() async {
    emit(ClearCartLoading());
    final result = await cartRepo.clearCart();
    result.fold(
      (error) => emit(ClearCartError(error)),
      (cartItems) {

        emit(ClearCartSuccess(cartItems));
      },
    );
  }

  void updateCartItemQuantity(int itemId, int newQuantity) {
    if (cart == null) return;
    // Keep a snapshot to revert on failure
    final previousCart = cart!;

    // Optimistic update (UI reflects immediately)
    final items = List<CartItem>.from(previousCart.items);
    final index = items.indexWhere((e) => (e.id ?? -1) == itemId);
    if (index == -1) return;

    final oldItem = items[index];
    final updatedItem = CartItem(
      id: oldItem.id,
      product: oldItem.product,
      quantity: newQuantity,
      variationId: oldItem.variationId,
      variationName: oldItem.variationName,
    );
    items[index] = updatedItem;

    double subtotal = 0;
    for (final it in items) {
      final price = it.product?.price ?? 0;
      final qty = it.quantity ?? 1;
      subtotal += price * qty;
    }
    final shipping = previousCart.shipping ?? 0;
    final tax = previousCart.tax ?? 0;
    cart = Cart(
      items: items,
      shipping: shipping,
      tax: tax,
      total: subtotal + shipping + tax,
      cartTotal: subtotal,
      finalTotal: subtotal + shipping + tax,
      totalItems: items.fold<int>(0, (sum, it) => sum + (it.quantity ?? 0)),
    );
    emit(CartUpdated());

    // Persist; if failed, reset to previous snapshot
    cartRepo
        .updateCartItemQuantity(cartItemId: itemId, quantity: newQuantity)
        .then((result) {
      result.fold(
        (error) {
          cart = previousCart; // revert
          emit(CartItemQuantityUpdateError(error));
          emit(CartUpdated());
        },
        (msg) {
          emit(CartItemQuantityUpdated(msg));
        },
      );
    });
  }
}
