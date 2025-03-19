import 'package:bloc/bloc.dart';
import 'package:diamonds/data/models/diamond.dart';
import 'package:diamonds/data/repositories/cart_repository.dart';
import 'package:equatable/equatable.dart';

import 'cart_summary.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<CartStarted>(_onCartStarted);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartCleared>(_onCartCleared);
  }

  void _onCartStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartItems = await cartRepository.getCartItems();
      final summary = _calculateSummary(cartItems);
      emit(CartLoaded(items: cartItems, summary: summary));
    } catch (e) {
      emit(CartError("Failed to load cart: ${e.toString()}"));
    }
  }

  void _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      try {
        final currentState = state as CartLoaded;
        final updatedItems = List<Diamond>.from(currentState.items);

        // Check if item already exists
        final existingIndex = updatedItems
            .indexWhere((item) => item.lotId == event.diamond.lotId);

        if (existingIndex == -1) {
          updatedItems.add(event.diamond);
          await cartRepository.addToCart(event.diamond);
          final summary = _calculateSummary(updatedItems);
          emit(CartLoaded(items: updatedItems, summary: summary));
        }
      } catch (e) {
        emit(CartError("Failed to add item to cart: ${e.toString()}"));
      }
    }
  }

  void _onCartItemRemoved(
      CartItemRemoved event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      try {
        final currentState = state as CartLoaded;
        final updatedItems = List<Diamond>.from(currentState.items)
          ..removeWhere((item) => item.lotId == event.lotId);
        await cartRepository.removeFromCart(event.lotId);
        final summary = _calculateSummary(updatedItems);
        emit(CartLoaded(items: updatedItems, summary: summary));
      } catch (e) {
        emit(CartError("Failed to remove item from cart: ${e.toString()}"));
      }
    }
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      await cartRepository.clearCart();
      emit(const CartLoaded(items: [], summary: CartSummary()));
    } catch (e) {
      emit(CartError("Failed to clear cart: ${e.toString()}"));
    }
  }

  CartSummary _calculateSummary(List<Diamond> cartItems) {
    if (cartItems.isEmpty) {
      return const CartSummary();
    }

    double totalCarat = 0.0;
    double totalPrice = 0.0;
    double totalDiscount = 0.0;

    for (var diamond in cartItems) {
      totalCarat += diamond.carat;
      totalPrice += diamond.finalAmount;
      totalDiscount += diamond.discount;
    }

    final itemCount = cartItems.length;
    final averagePrice = totalPrice / itemCount;
    final averageDiscount = totalDiscount / itemCount;

    return CartSummary(
      totalCarat: totalCarat,
      totalPrice: totalPrice,
      averagePrice: averagePrice,
      averageDiscount: averageDiscount,
      itemCount: itemCount,
    );
  }
}
