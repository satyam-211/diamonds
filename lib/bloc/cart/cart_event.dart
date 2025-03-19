part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
}
class CartStarted extends CartEvent {
  @override
  List<Object?> get props => [];
}

class CartItemAdded extends CartEvent {
  final Diamond diamond;

  const CartItemAdded(this.diamond);

  @override
  List<Object?> get props => [diamond];
}

class CartItemRemoved extends CartEvent {
  final String lotId;

  const CartItemRemoved(this.lotId);

  @override
  List<Object?> get props => [lotId];
}

class CartCleared extends CartEvent {
  @override
  List<Object?> get props => [];
}