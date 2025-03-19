import 'package:equatable/equatable.dart';

class CartSummary extends Equatable {
  final double totalCarat;
  final double totalPrice;
  final double averagePrice;
  final double averageDiscount;
  final int itemCount;

  const CartSummary({
    this.totalCarat = 0.0,
    this.totalPrice = 0.0,
    this.averagePrice = 0.0,
    this.averageDiscount = 0.0,
    this.itemCount = 0,
  });

  @override
  List<Object?> get props => [
    totalCarat,
    totalPrice,
    averagePrice,
    averageDiscount,
    itemCount,
  ];
}