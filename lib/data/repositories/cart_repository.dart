import 'dart:convert';
import 'package:diamonds/data/models/diamond.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  static const String cartKey = 'diamond_cart';

  // Get all diamonds in cart
  Future<List<Diamond>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(cartKey);

    if (cartJson == null || cartJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = jsonDecode(cartJson);
      return decodedList
          .map((item) => Diamond.fromJson(item))
          .toList();
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing cart data: $e');
      return [];
    }
  }

  // Add diamond to cart
  Future<bool> addToCart(Diamond diamond) async {
    try {
      final List<Diamond> currentCart = await getCartItems();

      // Check if diamond already exists in cart
      if (currentCart.any((item) => item.lotId == diamond.lotId)) {
        return false; // Already in cart
      }

      // Add diamond to cart
      currentCart.add(diamond);

      // Save updated cart
      return _saveCart(currentCart);
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  // Remove diamond from cart
  Future<bool> removeFromCart(String lotId) async {
    try {
      final List<Diamond> currentCart = await getCartItems();

      // Remove diamond with matching lotId
      currentCart.removeWhere((item) => item.lotId == lotId);

      // Save updated cart
      return _saveCart(currentCart);
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Clear entire cart
  Future<bool> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(cartKey);
  }

  // Calculate cart summary
  Future<Map<String, dynamic>> getCartSummary() async {
    final List<Diamond> cartItems = await getCartItems();

    if (cartItems.isEmpty) {
      return {
        'totalCarat': 0.0,
        'totalPrice': 0.0,
        'averagePrice': 0.0,
        'averageDiscount': 0.0,
      };
    }

    // Calculate summary values
    double totalCarat = 0;
    double totalPrice = 0;
    double totalDiscount = 0;

    for (var diamond in cartItems) {
      totalCarat += diamond.carat;
      totalPrice += diamond.finalAmount;
      totalDiscount += diamond.discount;
    }

    final int itemCount = cartItems.length;
    final double averagePrice = totalPrice / itemCount;
    final double averageDiscount = totalDiscount / itemCount;

    return {
      'totalCarat': totalCarat,
      'totalPrice': totalPrice,
      'averagePrice': averagePrice,
      'averageDiscount': averageDiscount,
    };
  }

  // Helper method to save cart to SharedPreferences
  Future<bool> _saveCart(List<Diamond> cart) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert cart items to JSON
    final List<Map<String, dynamic>> cartJson =
    cart.map((diamond) => diamond.toJson()).toList();

    // Save to SharedPreferences
    return prefs.setString(cartKey, jsonEncode(cartJson));
  }

  // Check if a diamond is in the cart
  Future<bool> isInCart(String lotId) async {
    final List<Diamond> cart = await getCartItems();
    return cart.any((diamond) => diamond.lotId == lotId);
  }
}