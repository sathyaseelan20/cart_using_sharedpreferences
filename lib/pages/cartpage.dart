import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/models/cart_model.dart';
import 'package:shopping_cart/models/product_model.dart';


class CartPage extends StatefulWidget {
  final Map<int, CartItem> cart;
  final Function(Product, int) onQuantityChanged;

  const CartPage({
    super.key,
    required this.cart,
    required this.onQuantityChanged,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const String cartKey = "cart_data";

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final list = widget.cart.values.map((c) => c.toMap()).toList();
    prefs.setString(cartKey, jsonEncode(list));
  }

  int get totalItems =>
      widget.cart.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      widget.cart.values.fold(0, (sum, item) => sum + item.quantity * item.product.price);

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Cart Items"),
        backgroundColor: const Color.fromARGB(255, 33, 243, 205),
      ),

      body: items.isEmpty
          ? Center(child: Text("Your cart is empty", style: TextStyle(fontSize: 18),))
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 100),
              itemCount: items.length,
              itemBuilder: (context, index) {
                CartItem item = items[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: EdgeInsets.all(10),
                  
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 33, 243, 205),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2)
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(item.product.image,
                          width: 60, height: 60, fit: BoxFit.cover),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.title,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                            SizedBox(height: 4),
                            Text("₹ ${item.product.price}",
                                style: TextStyle(fontSize: 14)
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              widget.onQuantityChanged(item.product, -1);
                              saveCart();
                              setState(() {});
                            },
                          ),

                          Text("${item.quantity}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),

                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              widget.onQuantityChanged(item.product, 1);
                              saveCart();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        height: 80,
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Items: $totalItems"),
                Text(
                  "Total: ₹ $totalPrice",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                widget.cart.clear();
                saveCart();
                Navigator.pop(context);
              },
              child: Text("Checkout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 87, 71),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
